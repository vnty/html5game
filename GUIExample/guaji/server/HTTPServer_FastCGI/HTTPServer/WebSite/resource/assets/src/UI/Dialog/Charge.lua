local Charge = {
    ui = nil,
}

function Charge:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/vip-charge.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)

    ui_add_click_listener(self.ui.btn_vip, function(sender,eventType)
        self:close()
        DialogManager:showDialog("Vip")
    end)    
    
    ui_add_click_listener(self.ui.btn_chargelarge, function()
        DialogManager:showDialog("ChargeLarge")
    end)
    
    for i = 1,6 do
        local pnl = self.ui["pnl_buy_"..i]
        local btn = ui_(pnl, "btn_buy")
        local p
        if(Platform.platformType==Platform.platform_appstore)then
            p = ConfigData.cfg_ug_price_appstore[i]
        else
            p = ConfigData.cfg_ug_price[i]
        end
        
        ui_(pnl,"lbl_price"):setString("￥" .. p[1])
        if i ~= 1 then
            -- 月卡
            ui_(pnl,"lbl_ug"):setString(p[2])
        else
--            ui_(pnl, "Image_23"):setVisible(false)
            ui_(pnl,"lbl_ug"):setString("月卡")
            if(Platform.platformType==Platform.platform_appstore)then
                pnl:setVisible(false);
            end
        end
        if(Platform.platformType==Platform.platform_appstore)then
            if i==6 then
                pnl:setPosition(cc.p(5,235));
                  
            end
        end
        ui_add_click_listener(btn, function(sender,eventType)
            if i ~= 1 then
                Platform:buyItem(i,1)
                self:onShow()
            else
                Platform:buyItem(i,2)
                self:onShow()
            end
        end)
    end
  
     if(Platform.platformType==Platform.platform_appstore)then
        self.ui.Image_250:setVisible(false);
       ui_add_click_listener(self.ui.btn_back, function(sender,eventType)
            local luaoc = require "luaoc";
            luaoc.callStaticMethod("MyPlatform","restoreTransaction",nil);
        end)
    else
        self.ui.btn_back:setVisible(false);    
    end
    
    return self.ui
end

function Charge:close()
	DialogManager:closeDialog(self)
end

function Charge:onShow()
    local size = self.ui.pnl_info1:getContentSize()  
    self.ui.pnl_info1:removeAllChildren()
    
    local info1 = ccui.RichText:create()
    
    if(User.vip < ConfigData.cfg_vip_max)then
        local vip0 = ConfigData.cfg_vip[User.vip]
        local vip1 = ConfigData.cfg_vip[User.vip + 1]
        info1:pushBackElement( RTE("再充值",20, cc.c3b(255,255,255) ) )
        info1:pushBackElement( RTE( (tonum(vip1.pay) - User.vippay) .. "钻石",20, cc.c3b(255,204,0) ))
        info1:pushBackElement( RTE("即可成为",20, cc.c3b(255,255,255) ))
        info1:pushBackElement( RTE( "VIP"..User.vip+1,20, cc.c3b(0,255,0) ))
        self.ui.expbar:setPercent( (User.vippay - tonum(vip0.pay)) * 100.0 / (tonum(vip1.pay) - tonum(vip0.pay)) )
        self.ui.bmf_vip_now:setString("V"..User.vip)
        self.ui.bmf_vip_next:setString("V"..User.vip + 1)
    else
        info1:pushBackElement( RTE("您已经是最高等级VIP了",20, cc.c3b(255,255,255) ) )
        self.ui.expbar:setPercent(100)        
        self.ui.bmf_vip_now:setString("V"..User.vip)
        self.ui.bmf_vip_next:setString("V"..User.vip)        
    end

    info1:formatText()
    local s = info1:getContentSize()
    info1:setAnchorPoint(cc.p(0.5,0.5))
    info1:setPosition(cc.p(size.width/2,size.height/2))
    self.ui.pnl_info1:addChild(info1)
    if(Platform.platformType~=Platform.platform_appstore)then
        self.ui.btn_chargelarge:setVisible(User.vip >= 7)
    else
        self.ui.btn_chargelarge:setVisible(false)
    end
    -- 刷新首冲图标
    for i = 1,6 do
        local pnl = self.ui["pnl_buy_"..i]
        ui_(pnl,"Image_25"):setVisible(User.paygift == 0 and i ~= 1)
    end
end

return Charge