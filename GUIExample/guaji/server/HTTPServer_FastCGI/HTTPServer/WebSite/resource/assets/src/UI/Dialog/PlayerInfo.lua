local cmd = require("src/Command")

local PlayerInfo = {
  ui = nil,
}

function PlayerInfo:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/player-info.json"))
  
    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        DialogManager:closeDialog(self)
    end)
  
    ui_add_click_listener(self.ui.btn_vip, function(sender,eventType)
        DialogManager:showDialog("Vip")
    end)  
    
    ui_add_click_listener(self.ui.btn_changesig, function(sender,eventType)
        self:close()
        DialogManager:showDialog("PlayerInfoChangeSig")
    end)
    
    ui_add_click_listener(self.ui.btn_changeChen, function(sender,eventType)
        self:close()
        DialogManager:showDialog("ChengHaoManage")
    end)
    -- 返回到登陆界面
    ui_add_click_listener( self.ui.btn_logout, function(sender,eventType)
        MainUI:exitGame()
    end)  
    if(Platform:needShowPlatform()==true)then
        ui_add_click_listener(self.ui.btn_user,function(sender,eventType)
            Platform:showPlatform(); 
        end);
    else
        self.ui.btn_user:setVisible(false);
    end
    
    ui_add_click_listener( self.ui.btn_sound, function(sender,eventType)
        if (GameUI.configure["music"] == 1) then
            GameUI.configure["music"] = 0
            self.ui.btn_sound:setTitleColor(cc.c3b(35,101,147))
            self.ui.btn_sound:setTitleText("开启声音")
            self.ui.btn_sound:loadTextureNormal("res/ui/button/btn_104.png")
            stopAllGameMusic()
        else
            GameUI.configure["music"] = 1
            self.ui.btn_sound:setTitleColor(cc.c3b(128,14,16))
            self.ui.btn_sound:setTitleText("关闭声音")
            self.ui.btn_sound:loadTextureNormal("res/ui/button/btn_102.png")
            playGameMusic("bg2")
        end
        cc.UserDefault:getInstance():setStringForKey("music", GameUI.configure["music"])
    end)
    
    return self.ui
end

function PlayerInfo:onShow(sig)
    -- 显示个人信息
    UICommon.loadExternalTexture(self.ui.img_icon, User.getUserHeadImg(User.ujob, User.usex))
    
    self.ui.lbl_name:setString(User.uname)
    self.ui.lbl_id:setString( string.format("我的ID： %d", User.uid) )
    self.ui.lbl_exp:setString( string.format("经验：%s/%s", User.uexp - User.ulvExpMin, User.ulvExpMax - User.ulvExpMin ) )
    self.ui.lbl_lv:setString( string.format("等级： %d 级", User.ulv) )
    self.ui.lbl_job:setString( string.format("职业： %s", User.getJobName(User.ujob) ))
    self.ui.lbl_vip:setString( string.format("VIP等级： VIP%d", User.vip) )
    self.ui.bmf_vip:setString( string.format("V%d", User.vip))
    if User.uCheng>0 and User.uCheng <10 then
        local item,color = User.getChengHao(User.uCheng)
        self.ui.lbl_chengname:setString(item.name)
        self.ui.lbl_chengname:setColor(color)
    else
        self.ui.lbl_chengname:setString("无")
        self.ui.lbl_chengname:setColor(cc.c3b(250,200,3))
    end
    self.ui.lbl_popularity:setString( string.format("声望： %d ", tonum(User.userItems[8])))
    if(sig ~= nil) then
        self.ui.lbl_sig:setString(sig)
    else
        sendCommand("getUserSig", function (param)
            if(param[1] == 1)then
                if(param[2] == "")then
                    self.ui.lbl_sig:setString("还未设置签名")
                else
                    self.ui.lbl_sig:setString(param[2])
                end
            else
                MessageManager:show(param[2])
            end
        end,{})
    end
    if (GameUI.configure["music"] == 1) then
        self.ui.btn_sound:setTitleColor(cc.c3b(128,14,16))
        self.ui.btn_sound:setTitleText("关闭声音")
        self.ui.btn_sound:loadTextureNormal("res/ui/button/btn_102.png")
    else
        self.ui.btn_sound:setTitleColor(cc.c3b(35,101,147))
        self.ui.btn_sound:setTitleText("开启声音")
        self.ui.btn_sound:loadTextureNormal("res/ui/button/btn_104.png")
    end
end

function PlayerInfo:close()
    DialogManager:closeDialog(self)
end

return PlayerInfo