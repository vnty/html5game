local PlatformUc = {
    platformPrefix="uc",
    platformClassName='org/cocos2dx/lua/PlatformUc',
    login_id=nil,
    login_session=nil
}
function PlatformUc:initSDK()

end
function PlatformUc:doGameLogin(callback) --@return typeOrObject
    if(self.login_session)then
        local function onLoginAccount(param)
            if(param[1] == 1)then
                loginUI.loginUid    = param[2];
                User.uidkey         = param[3];
                self.login_id       = param[4];
                TalkingData:setAccount(self.platformPrefix..self.login_id);
                callback();
            else
                MessageManager:show(param[2]);
                self:doLogin();
            end
        end
        sendCommandG("loginAccount", onLoginAccount, 
        {Platform.platformType,self.platformPrefix,self.login_session});
    else
        PlatformUc:doLogin(nil);
    end
end
function PlatformUc:doLogout()
    self.login_session=nil;
    self:doLogin();
end
function PlatformUc:doLogin()
    local function onLoginCallback(p)
        AlertManager:closeAlert()
        local r = string.split(p, "|");
        if(r[1]=="success")then
            self.login_session=r[2];
            Platform:onLoginSuccess(nil);
        else
           self:doLogin();
        end
    end
    AlertManager:loading()
    Platform:callNativeFunc(self.platformClassName,"UcLogin",{onLoginCallback},"(I)V")
end

function PlatformUc:pay(orderId,money,ug,productName)
    local function onPayCallback(p)
        local r = string.split(p, "|");
        if(r[1]=="success")then
            Platform:onChargeSuccess(nil,orderId,money,false);
        end
    end
    Platform:callNativeFunc(self.platformClassName,"UcPay",{
        onPayCallback,
        orderId,
        money,
        User.uid,
        User.uname,
        User.ulv
    },"(ISISSS)V")
end
function PlatformUc:doExitGame()
    local function exitGame()
         doExitApplication();  
    end
    Platform:callNativeFunc(self.platformClassName,"UcExitGame",{exitGame},"(I)V")
end
function PlatformUc:doSubmitUserInfo()
    Platform:callNativeFunc(self.platformClassName,"UcSubmitUserLoginInfo",{
        User.uid,
        User.uname,
        User.ulv,
        User.server.index,
        User.server.name
    },"(ISIIS)V")
end
return PlatformUc