-- 自动更新
require("src/UI/AlertManager")
AutoUpdate = {
    ui = nil,
    serverInfo = nil
}

function AutoUpdate:init()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/autoupdate.json"))
    return self.ui.nativeUI
end

function AutoUpdate:doGetServerInfo()
    self.ui.lbl_msg:setString("正在获取服务器信息...")
    local function onError()
        local function onOK()
            self:doGetServerInfo(Config.getServerUrl())
        end
        -- 网络错误
        AlertManager:ok("网络连接失败", RTE("获取服务器列表失败，请在流畅的网络环境进行游戏。",25, cc.c3b(255,255,255)), onOK)
    end
    local function onData(res)
        local cjson = require("cjson")
        self.serverInfo = cjson.decode(res)
        if self.serverInfo == nil then
            onError()
        end
        Platform.platform.payurl=self.serverInfo.payurl;

        local contiuneCallback=function()
            self:doUpdate( self.serverInfo.updateVersion, self.serverInfo.updateZip)
        end
        -- 是否有大版本更新
        local newVersion=self.serverInfo.newVersion;
        if (newVersion~= nil and newVersion.url ~= nil) then
            local new_version=newVersion.new_version;
            local force=newVersion.force;

            Platform:startNewVersionUpdate(newVersion.url,force,contiuneCallback);
            if(toint(force)>0)then --强制更新
                return;
            end
        else
            contiuneCallback();
        end 
    end

    local cmd = require("src.Command").new()
    cmd.onData = onData
    cmd.onError = onError
    cmd:doSend( string.format( "%s?func=serverlist&platform=%s&channel=%s&ver=%s&installedVersion=%s",
        Config.getServerUrl(), Platform.platformType,Platform:getChannel(),Config.getCurVersion(), Config.gameVersion ))
end

function AutoUpdate:doUpdate(updateVersion,updateZip)
    self.ui.lbl_msg:setString("正在检查资源更新...")

    local assetsManager       = nil
    local pathToSave          = createDownloadDir();

    pathToSave = createDownloadDir()
    local function reset()
        cclog("reseting autoUpdater")
        deleteDownloadDir2(pathToSave)
        assetsManager:deleteVersion()
        createDownloadDir()
    end

    local function doEnterLogin()
        self.ui.nativeUI:removeFromParent()
        local loginUI = require("src/UI/Login")
        local login = loginUI:create()
        cc.Director:getInstance():getRunningScene():addChild(login,4,4)
        login:setPosition(globalOrigin)
        loginUI:doEnterLogin(self.serverInfo)
    end

    local function onError(errorCode)
        local function onOK()
            doExitApplication()
        end
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            cclog("newest version")
            doEnterLogin()
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            -- 网络错误
            AlertManager:ok("更新错误", RTE( string.format("发生网络错误，请在流畅的网络环境重新再试(%d)", errorCode),25, cc.c3b(255,255,255)), onOK)
        else
            AlertManager:ok("更新错误", RTE( string.format("发生错误 %d ，请换个网络重新再试试！或者联系GM的QQ"..Config.gmQQ.. " (在 QQ添加好友/找服务 里面可以搜到)", errorCode),25, cc.c3b(255,255,255)), onOK)
            local log = assetsManager:getAssetsManagerLog()
            --cclog(log)
            -- 向服务器发送错误报告
            local cmd = require("src.Command").new()
            local cjson = require("cjson")
            cmd:doSend( string.format( "%s?func=errorLog&platform=%s&ver=%s&installedVersion=%s",
                Config.getServerUrl(), Platform.platformType,Config.getCurVersion(), Config.gameVersion)
            , "msg=" .. cjson.encode(log))
            reset()

            -- 允许它在更新错误的情况下登陆...
            doEnterLogin()
        end
        assetsManager:release()
        assetsManager=nil;
    end

    local function onProgress( percent )
        local progress = string.format("下载中，已完成 %d%%",percent)
        self.ui.lbl_msg:setString(progress)
        self.ui.bar_process:setPercent(percent)
    end

    local function onSuccess()
        self.ui.lbl_msg:setString("下载成功，正在启动游戏")
        cclog("downloading ok")

        assetsManager:release()
        assetsManager = nil
        
        local function onOK()
            -- 清除所有已经加载了的 src/ 和 src. 下面的lua模块
            for _,v in pairs(package.loaded) do
                local m = _:sub(1,4) 
                if m == "src/" or m == "src." then
                    cclog(_)
                    package.loaded[_] = nil
                end
            end
            
            -- 清理缓存
            cc.SpriteFrameCache:getInstance():removeSpriteFrames()
            cc.TextureCache:getInstance():removeAllTextures()
            
            -- 重新进入
            require("src.main")
        end

        AlertManager:ok("更新成功", RTE("更新成功，请您点击确定进入游戏。",25, cc.c3b(255,255,255)), onOK)
    end
    assetsManager = cc.AssetsManager:new( updateZip, updateVersion, pathToSave)
    assetsManager:retain()
    assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
    assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
    assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
    assetsManager:setConnectionTimeout(3)

    Config.downloadedVersion= cc.UserDefault:getInstance():getStringForKey(assetsManager:keyOfVersion())
    if(Config.downloadedVersion==nil or Config.downloadedVersion=="")then
        cc.UserDefault:getInstance():setStringForKey(assetsManager:keyOfVersion(), Config.gameVersion)
        Config.downloadedVersion=Config.gameVersion
    end 
    assetsManager:update()
end
return AutoUpdate