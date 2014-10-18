local Activity5 = {
    ui = nil,
}

function Activity5:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/activity5.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = (frameSize.height-960)/2}
    self.ui.Panel_3:getLayoutParameter():setMargin(tbl_act)    
    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
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
    
    for i=1, 3 do
        ui_add_click_listener(ui_(self.ui["img_gift"..i], "btn_buy"), function(sender,eventType)
            self:buyGift()
        end)
    end
    
    ui_add_click_listener(self.ui.btn_refresh, function(sender,eventType)
        self:refreshGift()
    end)
    
    ui_add_click_listener(self.ui.btn_reward1, function(sender,eventType)
        self:getReward(1)
    end)
    
    ui_add_click_listener(self.ui.btn_reward2, function(sender,eventType)
        self:getReward(2)
    end)

    self.ui.img_gift1:setTouchEnabled(true)
    self.ui.img_gift2:setTouchEnabled(true)
    self.ui.img_gift3:setTouchEnabled(true)
    self.ui.img_click1:setTouchEnabled(true)
    self.ui.img_click2:setTouchEnabled(true)
    self.ui.img_click3:setTouchEnabled(true)
end  

function Activity5:onShow()
    local function onGetGemActInfo(params)
        if(params[1]==1) then
            self.ui.lbl_time:setString(params[3])
            local gift = params[2]
            self:setGift(gift)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getGemActInfo", onGetGemActInfo)
end

function Activity5:setGift(gift)
    local pos = toint(gift['pos'])
    local item1 = toint(gift['item1'])
    local item2 = toint(gift['item2'])
    local price = math.floor(toint(gift['price'])/10)    
    local pricetype = "钻石"
    if toint(gift['price'])%10 == 1 then
        pricetype = "金币"
    end
    local reward1 = toint(gift['reward1'])
    local reward2 = toint(gift['reward2'])
    local n = toint(gift['n'])
    if n > User.vip + 3 then
        self.ui.lbl_cost:setString(string.format("本次刷新需50钻"))
    else
        self.ui.lbl_cost:setString(string.format("本次刷新免费"))
    end
    
    self.ui.lbl_left:setString(string.format("本日刷新次数:%s",n))
    
    if pos > 0 then
        self.ui.img_gift1:setTouchEnabled(false)
        self.ui.img_gift2:setTouchEnabled(false)
        self.ui.img_gift3:setTouchEnabled(false)
        self.ui.img_click1:setVisible(false)
        self.ui.img_click2:setVisible(false)
        self.ui.img_click3:setVisible(false)
        for i=1, 3 do
            if pos == i then
                self.ui["img_gift"..i]:loadTexture("res/ui/img_activity/images_07_04.png")
                local pnl = ui_(self.ui["img_gift"..pos],"pnl_item")
                pnl:setVisible(true)
                ui_(pnl,"lbl_price"):setString(string.format("售价:%s%s",price,pricetype))
                ui_(pnl,"lbl_name"):setString(string.format("宝石礼包"))
                local itemid = 0
                local count = 0
                if item1 > 0 then
                    itemid = math.floor(item1/100)
                    count = item1 % 100
                    ui_(pnl,"img_item1"):setVisible(true)
                    ui_(pnl,"lbl_count1"):setVisible(true)
                    ui_(pnl,"img_item1"):loadTexture("res/item/"..tonum(itemid)..".png" )
                    ui_(pnl,"lbl_count1"):setString("x"..count)
                    
                else
                    ui_(pnl,"img_item1"):setVisible(false)
                    ui_(pnl,"lbl_count1"):setVisible(false)
                end
                if item2 > 0 then
                    itemid = math.floor(item2/100)
                    count = item2 % 100
                    ui_(pnl,"img_item2"):setVisible(true)
                    ui_(pnl,"lbl_count2"):setVisible(true)
                    ui_(pnl,"img_item2"):loadTexture("res/item/"..tonum(itemid)..".png" )
                    ui_(pnl,"lbl_count2"):setString("x"..count)

                else
                    ui_(pnl,"img_item2"):setVisible(false)
                    ui_(pnl,"lbl_count2"):setVisible(false)
                end
            else
                self.ui["img_gift"..i]:loadTexture("res/ui/img_activity/images_07_02.png")
                local pnl = ui_(self.ui["img_gift"..i],"pnl_item")
                pnl:setVisible(false)
            end
        end
    else
        self.ui.img_gift1:setTouchEnabled(true)
        self.ui.img_gift2:setTouchEnabled(true)
        self.ui.img_gift3:setTouchEnabled(true)
        self.ui.img_click1:setVisible(true)
        self.ui.img_click2:setVisible(true)
        self.ui.img_click3:setVisible(true)

        for i=1, 3 do
            ui_(self.ui["img_gift"..i],"pnl_item"):setVisible(false)
        end
        
        self.ui.img_gift1:loadTexture("res/ui/img_activity/images_07_02.png")
        self.ui.img_gift2:loadTexture("res/ui/img_activity/images_07_02.png")
        self.ui.img_gift3:loadTexture("res/ui/img_activity/images_07_02.png")
    end
    
    if reward1 > 0 then
        self.ui.btn_reward1:loadTextureNormal("res/ui/img_activity/btn_07_02.png")
    else
        self.ui.btn_reward1:loadTextureNormal("res/ui/img_activity/btn_07_03.png")
    end
    if reward2 > 0 then
        self.ui.btn_reward2:loadTextureNormal("res/ui/img_activity/btn_07_02.png")
    else
        self.ui.btn_reward2:loadTextureNormal("res/ui/img_activity/btn_07_03.png")
    end
end

function Activity5:viewGift(pos)
    self.ui.img_gift1:setTouchEnabled(false)
    self.ui.img_gift2:setTouchEnabled(false)
    self.ui.img_gift3:setTouchEnabled(false)
    local function onViewGemActGift(params)
        if(params[1]==1) then
            local delay = cc.DelayTime:create(0.3)
            local scale2 = cc.ScaleTo:create(0.3,1,1)
            local sequence2 = cc.Sequence:create(delay, scale2 )
            local function callback()
                self:setGift(params[2])
            end
            local scale = cc.ScaleTo:create(0.3,0.01,1)
            local sequence = cc.Sequence:create( scale, cc.CallFunc:create(callback))
            self.ui["img_gift"..pos]:runAction(sequence)
            self.ui["img_gift"..pos]:runAction(sequence2)
        else
            MessageManager:show(params[2])
            self.ui.img_gift1:setTouchEnabled(true)
            self.ui.img_gift2:setTouchEnabled(true)
            self.ui.img_gift3:setTouchEnabled(true)
        end
    end
    sendCommand("viewGemActGift", onViewGemActGift, {pos})
end

function Activity5:refreshGift()
    local function onResetGemAct(params)
        if params[1] == 1 then
            self:setGift(params[2])
            local price = toint(params[2]['price'])
            if price > 0 then
                MessageManager:show(string.format("钻石 -%d", price))
            end   
            GameUI:loadUinfo()
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("resetGemAct", onResetGemAct)
end

function Activity5:buyGift()
    local function onBuyGemAct(params)
        if(params[1]==1) then
            table.foreach(params[2], function(k,v)
                local c = ConfigData.cfg_item[tonum(v["itemid"])]
                MessageManager:show(string.format("获得%s*%s",c.name,v["count"]))
                BagUI:addItem(v["itemid"], v["count"])
                BagUI:setNeedRefresh()
            end)
            GameUI:loadUinfo()
            self:setGift(params[3])
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("buyGemAct", onBuyGemAct)
end

function Activity5:getReward(type)
    local function onGetGemActReward(params)
    	if params[1] == 1 then
            table.foreach(params[2], function(k,v)
                local c = ConfigData.cfg_item[tonum(v["itemid"])]
                MessageManager:show(string.format("获得%s*%s",c.name,v["count"]))
                BagUI:addItem(v["itemid"], v["count"])
                BagUI:setNeedRefresh()
            end)
            self:setGift(params[3])
    	else
    	   MessageManager:show(params[2])
    	end
    end
    sendCommand("getGemActReward", onGetGemActReward,{type})
end

return Activity5