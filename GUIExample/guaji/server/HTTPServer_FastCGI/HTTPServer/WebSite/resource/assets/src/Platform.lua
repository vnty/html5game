require ("src/TalkingData")
Platform = {
    platformType=nil,
    platform=nil,
    platform_itools="iTools";
    platform_appstore="jediios",
    platform_uc="uc",
    platform_jinshan="jinshan",
    platform_oppo="oppo",
    platform_qh360="qh360",
    platform_3kwan="3kwan",
    platform_kuaiyong="kuaiyong",
    platform_pp="pp",
    platform_tongbu="tongbu",
    platform_i4="i4",
    platform_anzhi="anzhi",
    platform_cmgame="cmgame",
    platform_lengjing="lengjing",
    platform_tianji="tianji",
    platform_cooguo="cooguo",
    platform_gangtai="gangtai",
    text_charge_success="支付成功，您的钻石将在30秒内到账!"
}

function Platform:getPlatform()
    local toLowStr=string.lower(self.platformType);
    local ls=toLowStr:gsub("(.)(.+)" ,function(x,y)
        return x:upper()..y
        end
    )
    local targetPlatformSrc="src/Platform/Platform"..ls;
    self.platform=require(targetPlatformSrc);
    return self.platform	
end 
function Platform:initSDK()
    self.platform:initSDK();
end
function Platform:doLogout() --@return typeOrObject
    Scheduler.performWithDelayGlobal( function() self.platform:doLogout() end,0);
end
function Platform:doLogin()
    Scheduler.performWithDelayGlobal( function() self.platform:doLogin() end,0);
end     

function Platform:pay(tradeCode,money,ug,productName)
    self.platform:pay(tradeCode,money,ug,productName)
end

-- type = 1 ??????
-- type = 2 ???????
-- type = 3 ?????
function Platform:buyItem(i, type)
    cclog("Charge:buyItem " .. i)
    local price = {0, 0}
    if type == 1 or type == 2 then
        if(Platform.platformType==Platform.platform_appstore)then
            price = ConfigData.cfg_ug_price_appstore[i]
        else
            price = ConfigData.cfg_ug_price[i]
        end
    elseif type == 3 then
        price = {toint(i), toint(i)*10}
    end
    
    if(Platform.platformType==Platform.platform_appstore)then
        Platform:pay(11,price[1],price[2],nil);
    else 
        local function onGetTradeCode(param)
            if tonum(param[1]) == 1 then
                local orderCode = param[2]
                cclog(orderCode)
                local productName=nil;
                if(toint(price[1])==30) then 
                    productName="月卡";
                 else
                   productName=price[2].."钻石";
                 end
                local orderId = string.format("%d_%d", orderCode, User.server.index)
                Platform:pay(orderId, price[1], price[2],productName)
                TalkingData:doChargeRequest(orderId,productName,price[1],price[2],Platform.platformType);
            else
                MessageManager:show(param[2])
            end
        end
        sendCommand("getTradeCodeNew", onGetTradeCode, {Platform.platformType, type, price[1], price[2]})
    end
end

function Platform:getClipText()
    if( cc.PLATFORM_OS_ANDROID == targetPlatform ) then
        return self:callNativeFunc("org/cocos2dx/lua/AppUtils","getClipText",nil,"()S");
    else
        return self:callNativeFunc("MyPlatform","getClipText",nil);
    end
end

function Platform:startNewVersionUpdate(url,force,callback)
    if( cc.PLATFORM_OS_ANDROID == targetPlatform)then
        self:callNativeFunc("org/cocos2dx/lua/AppUpdate","callUpdate",{url,force,callback},"(SII)V");
    elseif(Platform.platformType==Platform.platform_appstore)then
        Platform.platform:doShowUpdate(callback);
    end
end
function Platform:doExitGame() --@return typeOrObject
    local function onOK()
        --??????????????
        if( cc.PLATFORM_OS_ANDROID == targetPlatform) then
            self:callNativeFunc("org/cocos2dx/lua/PushNotification","showLocalNotification",{},"()V");
        end
        doExitApplication();  
    end
    if(self.platformType==Platform.platform_uc or 
        self.platformType==Platform.platform_jinshan or
        self.platformType==Platform.platform_cmgame or
        self.platformType==Platform.platform_lengjing or
        self.platform.isNeedCallExit)then
        Platform.platform:doExitGame();
    else
        AlertManager:yesno("提示", RTE("确定结束游戏吗？",25, cc.c3b(255,255,255)), onOK)  
    end
end
function Platform:doSubmitGameInfo()
	if(self.platformType==Platform.platform_uc or 
	   self.platformType==Platform.platform_oppo or
	   self.platformType==Platform.platform_lengjing or
	   self.platformType==Platform.platform_cooguo or
        self.platform.isNeedSubmitUserInfo)then
       
	   self.platform:doSubmitUserInfo();
	end
    TalkingData:setLevel(User.ulv);
	TalkingData:setGameServer(User.server.name);
end
function switchAccount(param) --@return typeOrObject
     if(User ~= nil and User.uid ~= 0 and MainUI ~= nil )then
        GameUI:doExitGame();
    end
    Platform.platform.login_id=nil;
    Platform.platform.login_session=nil;
    loginUI.ui.lbl_loginname:setString("");
end

--һЩ��ƽ̨��Ҫע���Ժ���Ҫ���µ�¼��
function Platform:needGameLogin()
    local ret=false;
    if( self.platformType==Platform.platform_qh360 or 
        self.platformType==Platform.platform_uc or
        self.platformType==Platform.platform_pp or
        self.platformType==Platform.platform_i4 or
        self.platform.isNeedGameLogin) then 
        ret=true
    end
    return ret;
end
function Platform:getChannel() --@return typeOrObject
    if(self.platformType==Platform.platform_3kwan or 
        self.platformType==Platform.platform_lengjing or
        self.platformType==Platform.platform_tianji or
        self.platform.isNeedGetChannel)then
        return self.platform:getChannel();
	end
	return "0";
end
function Platform:showPlatform()
	if(self:needShowPlatform()==true)then
	   self.platform:showPlatform();
	end
end
function Platform:needShowPlatform()
   if(self.platformType==Platform.platform_itools or
        self.platformType==Platform.platform_kuaiyong or 
        self.platformType==Platform.platform_pp or 
        self.platformType==Platform.platform_tongbu or 
        self.platformType==Platform.platform_i4 or
        self.platform.isNeedShowPlatform)then
    return true;
   end
   return false;
end

--����java��C++���÷���
function Platform:callNativeFunc(nativeClassName,nativeFuncName,nativeFuncParam,nativeFuncType)
    nativeFuncType=self:createParamType(nativeFuncType);
    if( cc.PLATFORM_OS_ANDROID == targetPlatform ) then
        local luaj = require "luaj"
        local ok,ret  = luaj.callStaticMethod(nativeClassName,nativeFuncName,nativeFuncParam,nativeFuncType)
        if not ok then
            error(string.format("native call error:%s:%s:%s:%s", nativeClassName,nativeFuncName,self:tableSerialize(nativeFuncParam),nativeFuncType),ret);
        end
        return ret
    else
        local luaoc = require "luaoc";
        local ok,ret=luaoc.callStaticMethod(nativeClassName,nativeFuncName,nativeFuncParam);
        if not ok then
            error(string.format("native call error:%s:%s:%s", nativeClassName,nativeFuncName,self:tableSerialize(nativeFuncParam)),ret);
        end
        return ret
    end
    return nil;
end
function Platform:tableSerialize(myTable)
    do return "aaa"; end
    if(myTable==nil) then
     return "nil"
     end
    local ss="{";
    for k,v in pairs(myTable) do
        if(type(k)=="number")then
            ss=ss..v..",";
        else
            ss=ss..k.."="..v..",";
        end
    end
    ss=ss.."}";
    ss=string.gsub(ss,",}","}");
    return ss;
end
--�滻
function Platform:createParamType(paramTypes)
    if(paramTypes==nil)then return nil end;
    local typesString=string.gsub(paramTypes,"S","Ljava/lang/String;");
    return typesString;
end
-------------------------------------------------------------------------------------------------------------
function Platform:onLoginSuccess(loginId) --@return typeOrObject
        Scheduler.performWithDelayGlobal(function()
        if(loginId)then
            loginUI.ui.lbl_loginname:setString(loginId)
        end
            MessageManager:show("平台登录成功，点击进入游戏");
        end,0)
end
function Platform:doChargeRequest()
    
end
--doLog Ϊtrue���ͷ�����log for umeng
function Platform:onChargeSuccess(msg,orderId,money,doLog)
    if(msg)then
        Scheduler.performWithDelayGlobal(function()
            MessageManager:show(msg);
        end,0)
    end
    Scheduler.performWithDelayGlobal(function() 
        GameUI:loadUinfo()
        User.paygift = 1 -- �׳��־
    end, 5)
    if(doLog==true) then
        UMeng:pay( tonum(money), tonum(money*10), 50)
      --TalkingData:onChargeSuccess(orderId);
    end
end
return Platform
