require("src/quick-x/functions")

local User = require("src/User")
local cjson = require("cjson")

cjson.encode_empty_table_as_object(true) -- cjson默认会将空对象解析成{}而不是[]，与json不一致 https://groups.google.com/forum/#!msg/OpenResty/pJ9hEcMtrGA/FPANxwi49_AJ

local Command = class("Command", nil)

-- TODO: 把网络请求的loading 消息框独立出来，不要用Alert

function Command:ctor()
    self.xhr = nil
    self.callback = nil
end

function Command:doSend( url, data,noShowLoading )

    self.xhr = cc.XMLHttpRequest:new()
    -- self.xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    self.xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    self.xhr:open("POST", url )
    local to = self.xhr.timeout
    local alert = nil
    local alertTimer = nil
    --dump(to)
    --xhr:retain() -- retain，防止被自动释放
  
    local function onReadyStateChange(event)
        if(alert ~= nil)then
            AlertManager:closeAlert()
        else
            if alertTimer ~= nil then
                Scheduler.unscheduleGlobal(alertTimer)
            end
        end
  
        if(event == "error")then -- 修改了lua_xml_http_request.cpp 修改增加网络错误通知
            -- 网络错误
            if(self.onError ~= nil)then
                self.onError("onNetError")
            else
                -- 网络错误
                AlertManager:ok("网络错误", RTE("网络错误，请在流畅的网络环境进行游戏",25, cc.c3b(255,255,255)))      
            end
            return
        end
      
        xpcall(
            function()      
                --cclog("Http Status Code:".. self.xhr.statusText)
                self.onData(self.xhr.response)
            end,
            function (msg)
                if(self.onError ~= nil)then
                    self.onError("onDataError", "Command send " .. self.cmd .. " error " .. msg )
                else
                    __G__TRACKBACK__("Command send " .. self.cmd .. " error " .. msg)
                end            	
            end)
    end
  
    self.xhr:registerScriptHandler(onReadyStateChange)
    --dump(data)
    self.xhr:send(data)
  if(not noShowLoading) then
    -- 超过2秒显示网络请求对话框， doNotShowLoading专门用户BattleUI的pve\pvb\pvp
        alertTimer = Scheduler.performWithDelayGlobal( function()
        --alert = AlertManager:message(false, RTE("正在请求网络，请稍后...", 25, cc.c3b(255,255,255)))
        alert = AlertManager:loading();
    end, 2 )
    end
end

function Command:doSendUserCommand(data,noShowLoading)
  local function onData(response)
    --safe_print("HTTP Response " .. response)    
    local ret = cjson.decode(response)
    if ret == nil then
        safe_print("HTTP Response " .. response)
        return;
    end
    --cclog("dump from doSendUserCommand %s", self.cmd)
    --safe_print(vardump(ret))              
    if(ret[1] == 0) then -- 失败
        cclog("request failed")
        -- 服务器错误
        AlertManager:ok("服务器错误", RTE("服务器错误:"..ret[2],25, cc.c3b(255,255,255)))           
    elseif(ret[1] == 1) then -- 成功
        self.callback(ret[2])
    elseif(ret[1] == 2) then -- 版本过老
        local function onOK()
            doExitApplication()
        end
        AlertManager:ok("游戏更新", RTE( ret[2],25, cc.c3b(255,255,255)), onOK)
    elseif(ret[1] == 3) then -- 版本过老且自动跳转至更新页面
        local function onOK()
            Platform:openUrl(ret[3])
        end
        AlertManager:yesno("游戏更新", RTE( ret[2],25, cc.c3b(255,255,255)), onOK)
    end
  end
  self.onData = onData;
  self:doSend(User.server.url,data,noShowLoading);
end

function sendCommand( func, callback, param, onError,noShowLoading )
    local c = Command.new()
    c.cmd = func
    c.callback = callback
    c.onError = onError
    if(param == nil) then
        param = {}
    end
    local ss=string.format("cmd=c&ver=%s&func=%s&uid=%d&uidkey=%s&platform=%s&param=%s", Config.getCurVersion(), func, User.uid,User.uidkey,Platform.platformType,cjson.encode(param) );
    c:doSendUserCommand(ss,noShowLoading)
    return c 
end

function sendCommandG( func, callback, param, onError )
    local c = Command.new()
    c.cmd = func
    c.callback = callback
    c.onError = onError
    if(param == nil) then
        param = {}
    end
    c:doSendUserCommand(string.format("cmd=g&ver=%s&func=%s&platform=%s&param=%s", Config.getCurVersion(), func, Platform.platformType, cjson.encode(param) ) )
    return c
end

return Command
