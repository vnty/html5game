require("src/Config")
require("src/quick-x/debug")
require("src/ConfigData")
require("src/quick-x/scheduler")
require("src/UI/UICommon")
require("src/UI/MessageManager")
require("src/UI/AlertManager")
require("src/UI/DialogManager")
require("src/UMeng")
require("src/Platform")

local sign_L = 0
-- @module
loginUI = {
    ui = nil,
    serverList = {},
    lastSelected = nil,
    
    loginUid = "",
    loginSession = "",
    serverListItemModel = nil
}

loginUI.serverListItemModel = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/login-serverlist_item.json")
loginUI.serverListItemModel:retain()

local function setServerText(lbl,v)
    local state = tonumber(v.state)
    if( state == 1) then
        lbl:setColor(cc.c3b(0, 255, 0))
        lbl:setString(v.name .. "(正常)")
    elseif(state == 2) then
        lbl:setColor(cc.c3b(255, 255, 0))
        lbl:setString(v.name .. "(拥挤)")
    elseif(state == 3) then
        lbl:setColor(cc.c3b(255, 0, 0))
        lbl:setString(v.name .. "(爆满)")
    elseif(state == 4) then
        lbl:setColor(cc.c3b(0, 0, 255))
        lbl:setString(v.name .. "(排队)")
    elseif(state == 5) then
        lbl:setColor(cc.c3b(255, 255, 0))
        lbl:setString(v.name .. "(新服)")
    else
        lbl:setColor(cc.c3b(255, 0, 0))
        lbl:setString(v.name .. "(维护)")
    end
end

-- 切换最近服务器和选择服务器
local function switchUI(to)
  cclog("switching to " .. to)
  local f = true
  local posY=400;
  local h=204;
  local m=111;
  local n=175;
  if(to == "recent")then
    f = false
    sign_L = 0
  elseif(to == "select")then
    f = true
    sign_L = 1
    posY=690;
    h=130;
    m=42;
    n=106;
  end
  
  --cclog("switchUI %s %s",to,f)
  
  loginUI.ui.img_select:setVisible(f)
  loginUI.ui.server_list:setTouchEnabled(f)
  
  loginUI.ui.img_cur:setVisible(true)
  loginUI.ui.img_cur:setTouchEnabled(true)
  loginUI.ui.img_cur:setPositionY(posY)
  loginUI.ui.img_cur:setSize(482,h);
  local k=ui_delegate(loginUI.ui.img_cur);
  k.btn_choose:setVisible(not f);
  --local t=k.Label_10:getPositionY();
  --dump("Label PositionY:"..t);
   k.Label_10:setPositionY(n);
   -- dump("Image_5 PositionY:"..t);
  k.Image_5:setPositionY(m);
  loginUI.ui.login_button:setVisible(not f);
end 

function loginUI:create()
--    playGameMusic("bg1")

    local ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/login.json"))
    self.ui = ui
    ui.login_button:setTouchEnabled(true)
    ui.login_button:setPressedActionEnabled(true)
    ui_add_click_listener(ui.login_button, function(sender,eventType)
        self:doLogin()
    end)
    
    ui_add_click_listener(ui.btn_change_account,function()
        if(User.server == nil or User.server.url == "")then
            MessageManager:show("请选择服务器")
        else
            Platform:doLogout();
        end
    end)
    
    ui.lbl_ver:setTouchEnabled(true)
    ui_add_click_listener(ui.lbl_ver, function()
        local function onYes()
            Config.isTest=true;
            self.ui.nativeUI:removeFromParent()
            Config.switchServerList(true)
            doStartAutoUpdate()
        end
    	AlertManager:yesno("调试", RTE("是否切换至测试服列表？",25,cc.c3b(255,255,255)), onYes )
    end)
        
    ui.server_list:setDirection(ccui.ScrollViewDir.vertical)
    ui.server_list:setItemsMargin(8)
    ui.server_list:setBounceEnabled(true)
    
    ui.img_cur:setTouchEnabled(false)
    ui.server_list:setTouchEnabled(false)
    ui.img_cur:setVisible(false)
    ui.img_select:setVisible(false)
    ui_add_click_listener(loginUI.ui.img_cur, function ()
    if(sign_L == 0)then
        switchUI("select")
        else
        switchUI("recent")
        end
    end)
    
    
    local ln = cc.UserDefault:getInstance():getStringForKey("login_name")
    if(ln ~= nil) then
        self.ui.lbl_loginname:setString(ln)
    end

    return self.ui.nativeUI
end

function loginUI:doEnterLogin(serverInfo)

    self.ui.lbl_ver:setString("Ver. " .. Config.getCurVersion())
    self.ui.server_list:removeAllItems()
    -- 显示公告
    if serverInfo.news ~= "" and serverInfo.news ~= nil then
        local con = loadstring( "return ".. serverInfo.news )()
        DialogManager:showDialog("InfoDialog","公告", con)
    end
    loginUI.serverList = serverInfo.serverlist
    dump(loginUI.serverList)
    if(loginUI.serverList == nil)then
        error("invalid server list " .. Config.serverList)
        return
    end
    local sid = cc.UserDefault:getInstance():getStringForKey("server_id")
    --switchUI("select")      
    local lastestServer=nil;
    local loginRecent=false;
    
    table.foreach(loginUI.serverList,
        function(i, v)
            if(not lastestServer)then
                lastestServer=v;
            end
            local custom_item = loginUI.serverListItemModel:clone()
            local server_name = ui_(custom_item,"server_name")
            setServerText(server_name,v)           
            custom_item:setTouchEnabled(true)
            loginUI.ui.img_cur:setTouchEnabled(true)
            ui_add_click_listener(custom_item, function()
                cclog("server url = %s", v.url) -- lua table 下标从1开始！

                if User.server == nil or tonum(v.index) ~= tonum(User.server.index) then
                    User.server = v
                    -- 重新登录一下
                    loginUI.loginUid = ""
                    --cc.UserDefault:getInstance():setStringForKey("login_uid","")
                end

                --if(self.lastSelected ~= nil) then
                    --self.lastSelected:setBackGroundImage("res/ui/images/img_156.png")            
                --end
                self.lastSelected = self.ui.server_list:getItem(i-1)
                --self.lastSelected:setBackGroundImage("res/ui/images/img_157.png")   
                setServerText(self.ui.lbl_lastserver, v)

                switchUI("recent")
            end)
        
            -- 有最近登录的服务器
            if v.index == sid then
                loginRecent=true;
                --custom_item:setBackGroundImage("res/ui/images/img_157.png")
                setServerText(self.ui.lbl_lastserver,v)
                switchUI("recent")
                self.lastSelected = custom_item    
                User.server = v 
            end
            self.ui.server_list:pushBackCustomItem(custom_item)  
      end)  
      --没有最近登录的服务器，给选择默认第一个服
    if not loginRecent and lastestServer ~= nil then
        setServerText(self.ui.lbl_lastserver,lastestServer)
        switchUI("recent")
        User.server = lastestServer
      end
     if(not Platform.platform.login_session)then
        Platform:doLogin();
     else
        loginUI.ui.lbl_loginname:setString(Platform.platform.login_id);
     end
end

function loginUI:loadCfgData()
    if ConfigData.cfgInited == false then
        local cjson = require("cjson")
        local json = cc.FileUtils:getInstance():getStringFromFile("src/cfg/cfg.json") -- 这个文件由php的/tools/cfg_export.php导出
        local cfgs = cjson.decode(json)

        table.foreach( cfgs["cfg_equip"], function(k,v)
            ConfigData.cfg_equip[toint(v.eid)] = v 
        end)
    
        table.foreach( cfgs["cfg_skill"], function(k,v)
          ConfigData.cfg_skill[toint(v.sid)] = v 
        end)
      
        table.foreach( cfgs["cfg_map"], function(k,v)
          ConfigData.cfg_map[toint(v.mid)] = v 
        end)
      
        for k,v in pairs(cfgs["cfg_exp"])do
            ConfigData.cfg_userlv[toint(v.lv)] = v 
        end
      
        for k,v in pairs(cfgs["cfg_vip"])do
            ConfigData.cfg_vip[toint(v.vip)] = v
            ConfigData.cfg_vip_max = math.max( ConfigData.cfg_vip_max, tonum(v.vip) )
        end
        
        for k,v in pairs(cfgs["cfg_chenghao"])do
            ConfigData.cfg_chenghao[toint(v.chid)] = v
        end
        
        ConfigData.cfg_buy_coin = cfgs["cfg_buy_coin"]
        
        for k,v in pairs(cfgs["cfg_item"]) do
            ConfigData.cfg_item[toint(v.itemid)] = v
        end
        
        for k,v in pairs(cfgs["cfg_gem"]) do
            ConfigData.cfg_gem[toint(v.itemid)] = v
        end
        
        local f = "def"
        for k,v in pairs(cfgs["cfg_propname"])do
            if tonum(v.ntype) == 1 then
                f = "%+d"
            elseif tonum(v.ntype) == 2 then
                f = "%+.1f%%"
            end
            ConfigData.cfg_equip_prop[toint(v.nid)] = {
            [1] = v.name,          -- 属性名
            [2] = tonum(v.ntype),  -- 类型
            [3] = f,               -- 格式化  
            [4] = tonum(v.nvalue)  -- 神器初始值
            }
        end
        
        ConfigData.cfgInited = true
    end
 end
 

function loginUI:doExitGame()
    MessageManager:purgeMessages()
    cc.Director:getInstance():popScene()
    --self.ui.login_button:setEnabled(true)
    
    -- 切换场景以后要delay执行
    Scheduler.performWithDelayGlobal(function()
            self.ui.nativeUI:removeFromParent()
            doStartAutoUpdate()
        end
        ,0)
end
 
function loginUI:doLogin()
    if User.server == nil or User.server == "" then
        MessageManager:show("请选择服务器")
        return
    end
    -- 服务器Sid
    cc.UserDefault:getInstance():setStringForKey("server_id", User.server.index)
    --local loginUid = cc.UserDefault:getInstance():getStringForKey("login_uid")
    if not Platform.platform.login_session then
        Platform:doLogin();
        return
    end
    
    -- 先禁用，2秒后启用，防止误按
    self.ui.login_button:setEnabled(false)
    Scheduler.performWithDelayGlobal(function()
        self.ui.login_button:setEnabled(true)
    end,2)
    local callback=function ()
        local function onLoginOK(param)
            local User = require("src/User")
            local gameUI = require("src/UI/GameUI")
            
            local u = param[3]
            gameUI:onLoadUinfo(u)
            -- 当前地图
            local mapUI = require("src/UI/Map")
            mapUI.mapid = tonum(u.nowmid)

            if( User.ujob == 0)then
                local function onCloseNewGuide()
                    -- 选择角色
                    local chooseJobUI = require("src/UI/ChooseJob").new()
                    self.ui.nativeUI:addChild(chooseJobUI:init())
                end
                -- 显示新手引导
                local newGuide = require("src/UI/NewGuide")
                newGuide:show(onCloseNewGuide)

                UMeng:startLevel("map1")
            else
                gameUI:doEnterGame()
            end
        end
        User.uid = toint(self.loginUid)
        sendCommand("login", onLoginOK, {} )
    end
    Platform.platform:doGameLogin(callback);
   
    self:loadCfgData()
end

return loginUI
 