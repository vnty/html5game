local Activity3 = {
    ui = nil,
}

function Activity3:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/activity3.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = (frameSize.height-960)/2}
    self.ui.Panel_3:getLayoutParameter():setMargin(tbl_act)    
    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        DialogManager:closeDialog(self)
    end)

    ui_add_click_listener(self.ui.btn_close2, function(sender,eventType)
        DialogManager:closeDialog(self)
    end)

    ui_add_click_listener(self.ui.img_gift1, function(sender,eventType)
        self:viewGift(1)
    end)
    
    ui_add_click_listener(self.ui.img_gift2, function(sender,eventType)
        self:viewGift(2)
    end)
    
    ui_add_click_listener(self.ui.img_gift3, function(sender,eventType)
        self:viewGift(3)
    end)
    
    ui_add_click_listener(self.ui.img_click1, function(sender,eventType)
        self:viewGift(1)
    end)

    ui_add_click_listener(self.ui.img_click2, function(sender,eventType)
        self:viewGift(2)
    end)

    ui_add_click_listener(self.ui.img_click3, function(sender,eventType)
        self:viewGift(3)
    end)
    
    ui_add_click_listener(self.ui.btn_buy, function(sender,eventType)
        self:buyGift()
    end)
    
    ui_add_click_listener(self.ui.btn_refresh, function(sender,eventType)
        self:refreshGift()
    end)
    
    self.ui.img_click1:setTouchEnabled(true)
    self.ui.img_click2:setTouchEnabled(true)
    self.ui.img_click3:setTouchEnabled(true)
end  

function Activity3:onShow()
    local function onGetMidAutumnInfo(params)
        if(params[1]==1) then
            self.ui.lbl_time:setString(params[3])
            self.ui.lbl_left:setString("本日抽牌次数: "..params[2]["midnum"].."/"..(3+User.vip))
            local gift = tonum(params[2]["midgift"])
            self:setGift(gift)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getMidAutumnInfo", onGetMidAutumnInfo)
end

function Activity3:setGift(gift)
    if gift > 0 then
        self.ui.img_gift1:setTouchEnabled(false)
        self.ui.img_gift2:setTouchEnabled(false)
        self.ui.img_gift3:setTouchEnabled(false)
        self.ui.img_click1:setVisible(false)
        self.ui.img_click2:setVisible(false)
        self.ui.img_click3:setVisible(false)
        self.ui.pnl_nogift:setVisible(false)
        self.ui.pnl_gift:setVisible(true)
        local itemid = math.floor(gift/10000000)
        gift=gift%10000000
        local price = math.floor(gift/1000)
        gift=gift%1000
        local num = math.floor(gift/10)
        local pos=gift%10
        for i=1,3 do
            local ani = self.ui["img_item"..i]:getChildByTag(9999)
            if pos == i then
                self.ui["img_item"..i]:setVisible(true)
                self.ui["img_gift"..i]:loadTexture("res/ui/img_activity/images_05_03.png")
                self.ui["lbl_price"..i]:setString("售价:"..price.."钻石")
                if itemid < 1000 then
                    local c = ConfigData.cfg_item[itemid]
                    self.ui["lbl_name"..i]:setString(c.name.."*"..num)
                    self.ui["lbl_count"..i]:setString("x"..num)
                    self.ui["lbl_count"..i]:setVisible(true)
                    self.ui["img_item"..i]:loadTexture("res/item/"..tonum(itemid)..".png" )
                    if(ani ~= nil)then
                        ani:removeFromParent()
                    end
                else
                    if num ~= 8 then
                        self.ui["lbl_name"..i]:setString("神器"..ConfigData.cfg_equip_etype[num])
                    else
                        self.ui["lbl_name"..i]:setString("神器鞋子")
                    end
                    self.ui["lbl_count"..i]:setVisible(false)
                    local cfg = ConfigData.cfg_equip[itemid]
                    local picindex = tonum(cfg.picindex)

                    self.ui["img_item"..i]:loadTexture( string.format("res/equip/%s.png", picindex ) )
                    
                    if(ani == nil) then
                        ani = UICommon.createAnimation( "res/effects/main-equip.plist", "res/effects/main-equip.png", "_%03d.png", 25, 12, cc.p(0.50,0.48), 0.9 )
                        ani:setTag(9999)
                        self.ui["img_item"..i]:addChild(ani)
                        local s = self.ui["img_item"..i]:getContentSize()
                        ani:setPosition(s.width/2,s.height/2)
                    end
                end
            else
                self.ui["img_gift"..i]:loadTexture("res/ui/img_activity/images_05_02.png")
                self.ui["img_item"..i]:setVisible(false)
            end
        end
    else
        self.ui.img_gift1:setTouchEnabled(true)
        self.ui.img_gift2:setTouchEnabled(true)
        self.ui.img_gift3:setTouchEnabled(true)
        self.ui.img_click1:setVisible(true)
        self.ui.img_click2:setVisible(true)
        self.ui.img_click3:setVisible(true)
        self.ui.img_item1:setTouchEnabled(false)
        self.ui.img_item2:setTouchEnabled(false)
        self.ui.img_item3:setTouchEnabled(false)
        self.ui.img_item1:setVisible(false)
        self.ui.img_item2:setVisible(false)
        self.ui.img_item3:setVisible(false)
        self.ui.pnl_nogift:setVisible(true)
        self.ui.pnl_gift:setVisible(false)
        self.ui.img_gift1:loadTexture("res/ui/img_activity/images_05_02.png")
        self.ui.img_gift2:loadTexture("res/ui/img_activity/images_05_02.png")
        self.ui.img_gift3:loadTexture("res/ui/img_activity/images_05_02.png")
    end
end

function Activity3:viewGift(pos)
    local function onViewMidAutumnGift(params)
        if(params[1]==1) then
            self.ui.lbl_left:setString("本日抽牌次数: "..params[2]["midnum"].."/"..(3+User.vip))
            
            self.ui.img_gift1:setTouchEnabled(false)
            self.ui.img_gift2:setTouchEnabled(false)
            self.ui.img_gift3:setTouchEnabled(false)
            
            local gift = tonum(params[2]["midgift"])
            local delay = cc.DelayTime:create(0.3)
            local scale2 = cc.ScaleTo:create(0.3,1,1)
            local sequence2 = cc.Sequence:create(delay, scale2 )
            local function callback()
                self:setGift(gift)
            end
            local scale = cc.ScaleTo:create(0.3,0.01,1)
            local sequence = cc.Sequence:create( scale, cc.CallFunc:create(callback))
            self.ui["img_gift"..pos]:runAction(sequence)
            self.ui["img_gift"..pos]:runAction(sequence2)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("viewMidAutumnGift", onViewMidAutumnGift, {pos})
end

function Activity3:refreshGift()
    local function onResetMidAutumnGift(params)
        if(params[1]==1) then
            local gift = 0
            self:setGift(gift)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("resetMidAutumnGift", onResetMidAutumnGift)
end

function Activity3:buyGift()
    local function onBuyMidAutumnGift(params)
        if(params[1]==1) then
            BagUI:addItem(params[2]["itemid"], params[2]["count"])
            BagUI:setNeedRefresh()
            if tonum(params[2]["itemid"]) ~= 6 then
                local c = ConfigData.cfg_item[tonum(params[2]["itemid"])]
                MessageManager:show("获得"..c.name.."*"..params[2]["count"])
            else
                MessageManager:show("获得神器："..User.getEquipName(params[2]["count"]),cc.c3b(255,0,0))
            end
            self:setGift(0)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("buyMidAutumnGift", onBuyMidAutumnGift)
end

return Activity3