-- 优先搜索更新过的目录
local realPath = createDownloadDir()
addSearchPath(realPath,true)

require "Cocos2d"
require "Cocos2dConstants"
require "CocoStudio"
require "src/Global"
require "src/Config"
require "src/quick-x/scheduler"
require "src/quick-x/functions"
require "src/quick-x/debug"

-- cclog
cclog = function(...)
    print(string.format(...))
end

cclog("realpath: " .. realPath)

-- for CCLuaEngine traceback
local errorReported = {}
function __G__TRACKBACK__(msg, doCrash)
    if(doCrash == nil)then
        doCrash = Config.isTest
    end
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    local traceback = debug.traceback() 
    cclog(traceback)
    cclog("----------------------------------------")

    local function onLogReport(param)
        if tonum(param[1]) == 2 or tonum(param[1]) == 3 then
            local function onOK()
                if tonum(param[1]) == 3 then
                    doExitApplication()
                end
            end
            AlertManager:ok("错误提示", RTE( param[2],25, cc.c3b(255,255,255)), onOK)
        end
    end
    local errorMsg = Config.getCurVersion() .." " .. tostring(msg) .. "\n" .. traceback
    
    -- 是否已经发送过了
    for _,v in pairs(errorReported) do
        if v == errorMsg then
            -- 同样的错误只汇报一遍
            --cclog("same errorMsg " .. errorMsg)
            return
        end
    end
    
    table.insert(errorReported,errorMsg)
    
    -- 发送到服务器端
    sendCommand("logreport", onLogReport, { errorMsg }, function() end )

    if(doCrash)then
        -- 严重错误，强制崩溃
        local crashui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/game-crash.json"))
        crashui.nativeUI:setPosition(globalOrigin)
        cc.Director:getInstance():getRunningScene():addChild(crashui.nativeUI,10000,10000)
        crashui.lbl_error:setString( errorMsg )
        ui_add_click_listener(crashui.btn_restart,function()
            -- crashui.nativeUI:removeFromParent()        
            doExitApplication()      
        end)
    end
end

local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    targetPlatform = cc.Application:getInstance():getTargetPlatform()
  
    local frameSize = cc.Director:getInstance():getWinSize()
    local p=frameSize.height/frameSize.width;
    if(p<1.5)then    --ipad
        cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(640,frameSize.height,cc.ResolutionPolicy.SHOW_ALL)      
        globalOrigin = cc.p(0,0)
    else--iphone
        --local targetHeight=frameSize.width*p;
        --local offset=(targetHeight-960)/2;
        globalOrigin = cc.p(0,0)
    end
    
    Config.gameVersion="2.2.0";
    -- 如果当前版本跟安装版本不一样，则清除原来的更新资源
    local installedVersion = cc.UserDefault:getInstance():getStringForKey("installedVersion")
    cclog("installedVersion " .. installedVersion)
    if(installedVersion == "" or installedVersion ~= Config.gameVersion) then
        cclog("reseting version to " .. Config.gameVersion)
        cc.UserDefault:getInstance():setStringForKey("installedVersion", Config.gameVersion)
        local pathToSave = createDownloadDir()
        deleteDownloadDir2(pathToSave)
        createDownloadDir()
    end
    
    require "src/Platform"
    -- run
    local loginScene = cc.Scene:create()
    if cc.Director:getInstance():getRunningScene() == nil then
        -- 第一次启动
        cc.Director:getInstance():runWithScene(loginScene)
    else
        -- 有可能是自动更新后重新进入游戏，这时loginScene是存在的，所以要replace
        cc.Director:getInstance():replaceScene(loginScene)
    end

    -- 延后至下一个执行周期，以便于scene初始化完成，否则AlertManager可能会出错
    Scheduler.performWithDelayGlobal(
        function()
            --获取平台
            if(cc.PLATFORM_OS_ANDROID == targetPlatform)then
                Platform.platformType=Platform:callNativeFunc("org/cocos2dx/lua/AppActivity","getAnrdoidPlatform",{},"()S");
                Config.isTest=false;
            elseif(cc.PLATFORM_OS_IPHONE==targetPlatform or cc.PLATFORM_OS_IPAD==targetPlatform )then
                Platform.platformType=Platform:callNativeFunc("MyPlatform","getPlatformName",nil);
                Config.isTest=false;
            else
                Platform.platformType="local"
            end
            Platform:getPlatform()
            Platform:initSDK();
            
            -- 切换服务器列表
            Config.switchServerList(Config.isTest)
            doStartAutoUpdate()
        end, 0)
end

function doStartAutoUpdate()
    -- 检查是否有更新
    local autoupdate = require("src/UI/AutoUpdate"):init()
    cc.Director:getInstance():getRunningScene():addChild(autoupdate,5,5)
    autoupdate:setPosition(globalOrigin)

    AutoUpdate:doGetServerInfo()
end

-- 在C++里面的AppDelegate::applicationWillEnterForeground()被调用
function applicationOnActive()
    AlertManager:closeAlert();
    if(GameUI ~= nil and GameUI.onActive ~= nil)then
        GameUI.onActive()
    end
end

-- 在C++里面的AppDelegate::applicationDidEnterBackground()
function applicationOnDeactive()
    if(GameUI ~= nil and GameUI.onDeactive ~= nil)then
        GameUI:onDeactive()
    end
end

function playGameMusic(musicName) --@return typeOrObject
    if GameUI ~= nil and GameUI.configure["music"] ~= nil and GameUI.configure["music"] == 1 then
        local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("res/sound/"..musicName..".mp3");
        cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true);
    end
end

function stopAllGameMusic()
    cc.SimpleAudioEngine:getInstance():stopMusic(true);
end
-- 在C++里面的AppDelegate::keyEventCallback()
function escapeKeyPressed()
    if(User ~= nil and User.uid ~= 0 and MainUI ~= nil )then
        MainUI:exitGame()
    else
        Platform:doExitGame();
    end
end
xpcall(main, __G__TRACKBACK__)
