local LoginAccount = {
    ui = nil
    
}

function LoginAccount:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/login-account.json"))
  
  ui_add_click_listener( self.ui.btn_close,function()
    DialogManager:closeDialog(self)
  end)
  
  ui_add_click_listener( self.ui.btn_login,function()
            self:doLogin()
  end)
  
    local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then
        --self.uiLoginName:setString("")
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
        elseif eventType == ccui.TextFiledEventType.insert_text then
        elseif eventType == ccui.TextFiledEventType.delete_backward then
        --self.uiLoginName:setString("")
        end
    end

    --self.ui.login_name:addEventListenerTextField(textFieldEvent) 
    
    local ln = cc.UserDefault:getInstance():getStringForKey("login_name")
    if(ln ~= nil) then
        self.ui.txt_username:setText(ln)
    end
    local password = cc.UserDefault:getInstance():getStringForKey("login_password")
    if(password ~= nil) then
        self.ui.txt_password:setText(password)
    end
    if(ln and password and Platform.platform.login_id==nil)then
        self:doLogin()
    end
  return self.ui
end
function LoginAccount:doLogin()
    local ln = self.ui.txt_username:getStringValue()
    local pw = self.ui.txt_password:getStringValue()
    local phoneNumber=self.ui.txt_phone:getStringValue()
    
    if(Platform.platformType==Platform.platform_appstore)then
        Platform.platform:doLoginAccount(self,ln,pw,phoneNumber);
    else
        if(ln ~= "" and pw ~= "")then
            local function onLoginAccount(param)
                if(param[1] == 1)then
                    MessageManager:show("登录成功")
                    cc.UserDefault:getInstance():setStringForKey("login_name", ln)
                    cc.UserDefault:getInstance():setStringForKey("login_password", pw)
                    Platform.platform.login_id=ln;
                    Platform.platform.login_session=pw;
                    loginUI.ui.lbl_loginname:setString(ln)
                    loginUI.loginUid = param[2]
                    User.uidkey=param[3]
                    --cc.UserDefault:getInstance():setStringForKey("login_uid", param[2])
                    DialogManager:closeDialog(self)
                else
                    MessageManager:show(param[2])
            	end
            end
            sendCommandG("loginAccount", onLoginAccount, {Platform.platformType, ln, pw} )
        else
            MessageManager:show("请输入用户名和密码")
        end   
    end 
end


return LoginAccount