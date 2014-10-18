local PlatformLocal = {
    platformPrefix="local",
    login_id=nil,
    login_session=nil
}
function PlatformLocal:initSDK()
end
function PlatformLocal:doGameLogin(callback) --@return typeOrObject    
 --   dump(self.login_id);
  --  dump(self.login_session);
    if(self.login_id and self.login_session)then
        local function onLoginAccount(param)
            AlertManager:closeAlert()
            if(param[1] == 1)then
                loginUI.loginUid    = param[2];
                User.uidkey         = param[3];
                callback();
                TalkingData:setAccount(self.platformPrefix..loginUI.loginUid)
            else
                MessageManager:show(param[2]);
            end
        end
        sendCommandG("loginAccount", onLoginAccount, {Platform.platformType,self.login_id,self.login_session});
    else
        self:doLogin(nil);
    end
end
function PlatformLocal:doLogout() --@return typeOrObject
    self:doLogin();
end
function PlatformLocal:doLogin() --@return typeOrObject
    DialogManager:showDialog("LoginAccount")
end

function PlatformLocal:pay(tradeCode,money,ug)
    MessageManager:show("local 类型的服务器无法支付")
end

return PlatformLocal