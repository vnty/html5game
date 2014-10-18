local Vip = {
    ui = nil,
    curVip = 0
}

function Vip:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/vip.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        DialogManager:closeDialog(self)
    end)
    
    ui_add_click_listener(self.ui.btn_charge, function(sender,eventType)
        DialogManager:closeDialog(self)
        DialogManager:showDialog("Charge")
    end)      
    
    ui_add_click_listener(self.ui.btn_next, function(sender,eventType)
        self:changeVipPage(1)
    end)
    ui_add_click_listener(self.ui.btn_prev, function(sender,eventType)
        self:changeVipPage(-1)
    end)
    
    return self.ui
end

function Vip:onShow()
    local size = self.ui.pnl_info1:getContentSize()  
    self.ui.pnl_info1:removeAllChildren()
    
    local info1 = ccui.RichText:create()
    
    if(User.vip < ConfigData.cfg_vip_max)then
        local vip0 = ConfigData.cfg_vip[User.vip]
        local vip1 = ConfigData.cfg_vip[User.vip + 1]
        info1:pushBackElement( RTE("再充值",20, cc.c3b(255,255,255) ) )
        info1:pushBackElement( RTE( (tonum(vip1.pay) - User.vippay) .. "钻石",20, cc.c3b(255,204,0) ))
        info1:pushBackElement( RTE("即可成为",20, cc.c3b(255,255,255) ))
        info1:pushBackElement( RTE("VIP"..User.vip + 1,20, cc.c3b(0,255,0) ))
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
        
    self.curVip = User.vip
    
    self:changeVipPage(0)
end

function Vip:changeVipPage(p)
    self.curVip = self.curVip + p
    self.curVip = math.max(self.curVip,0)
    self.curVip = math.min(self.curVip,15)
  
    self.ui.lbl_vip:setString( string.format("VIP%d等级特权", self.curVip) )

    local size = self.ui.pnl_info2:getContentSize()  
    self.ui.pnl_info2:removeAllChildren()
    local info = ccui.RichText:create()
    
    local vip = ConfigData.cfg_vip[self.curVip]
    
    info:setAnchorPoint(cc.p(0,1))
    info:ignoreContentAdaptWithSize(false)
    info:setContentSize(size)
    
    info:pushBackElement( RTE("累计充值",20, cc.c3b(255,255,255) ) )
    info:pushBackElement( RTE( vip.pay.."钻石",20, cc.c3b(255,204,0) ))
    info:pushBackElement( RTE("即可成享受该特权\n",20, cc.c3b(255,255,255) ))
    
    info:pushBackElement( RTE("每天可以购买快速战斗次数 ",20, cc.c3b(255,255,255) ))
    info:pushBackElement( RTE( vip.quickpve .. "\n",20, cc.c3b(0,255,0) ))

    info:pushBackElement( RTE("每天可以购买挑战BOSS次数 ",20, cc.c3b(255,255,255) ))
    info:pushBackElement( RTE( vip.buypvb .. "\n",20, cc.c3b(0,255,0) ))

    info:pushBackElement( RTE("每天可以购买金币次数 ",20, cc.c3b(255,255,255) ))
    info:pushBackElement( RTE( vip.buycoin .. "\n",20, cc.c3b(0,255,0) ))  

    info:pushBackElement( RTE("商城额外高级商品栏 ",20, cc.c3b(255,255,255) ))
    info:pushBackElement( RTE( vip.shopstar .. "\n",20, cc.c3b(0,255,0) )) 
    
    info:pushBackElement( RTE("击败BOSS可额外发现 ",20, cc.c3b(255,255,255) ))
    local box="无"
    if(toint(vip.boxid)~=0) then
         box=ConfigData.cfg_item[tonum(vip.boxid)]["name"]
    end
    info:pushBackElement( RTE( box.. "\n",20, cc.c3b(0,255,0) )) 
    
    info:pushBackElement( RTE("最高佣兵培养 ",20, cc.c3b(255,255,255) ))
    
   
    local plv = "普通培养"
    if(tonum(vip.plv) == 2)then
        plv = "高级培养"
    elseif(tonum(vip.plv) == 3)then
        plv = "白金培养"
    elseif(tonum(vip.plv) == 4)then
        plv = "至尊培养"
    end
    info:pushBackElement( RTE( plv.. "\n",20, cc.c3b(0,255,0) )) 

    info:formatText()
    info:setPosition(cc.p(0,size.height))
    self.ui.pnl_info2:addChild(info)
end

return Vip