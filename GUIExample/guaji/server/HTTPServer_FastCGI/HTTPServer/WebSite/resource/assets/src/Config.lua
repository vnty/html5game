
Config = {
    -- gameVersion的前两个数字，表示一个发布基础包，跨大版本号的包不一样，必须重新下载，小版本号更新可以在线补丁
    isTest = true,
    gameVersion = "2.2.0",
  
    downloadedVersion = nil,

    font = "微软雅黑",
    --font =""
    --font = "res/ui/ttf/font.ttf"
   -- serverUrl_dev  ="http://192.168.0.222/p11server/serverconfig.php",   -- 测试服列表
    serverUrl_dev  ="http://www.jedi-games.com/p11/serverconfig_dev.php",  -- 测试服列表
    --serverUrl_dev  ="http://192.168.0.107/p11/serverconfig_dev.php",     -- 测试服列表
    serverUrl_rel  ="http://www.jedi-games.com/p11/serverconfig.php",      -- 运营服列表
        
    serverUrl = "", -- 当前URL
    
    gmQQ = "800063656"
}

function Config.getServerUrl()
    dump(Config.serverUrl)
    return Config.serverUrl
end

function Config.switchServerList(isDev)
    if isDev then
        Config.serverUrl = Config.serverUrl_dev
    else 
        Config.serverUrl = Config.serverUrl_rel
    end
end

function Config.getCurVersion()
    if Config.downloadedVersion ~= nil and Config.downloadedVersion ~= "" then
        return Config.downloadedVersion
    end
    
    return Config.gameVersion
end

-- 获得版本号前两个
function Config.getBaseVersion(ver)
	local v = string.split(ver,".")
	return v[1] .. "." .. v[2]
end