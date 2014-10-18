local Activity4 = {
    ui = nil,
    step = nil, 
    gift = nil, 
    allreward = nil,
}

function Activity4:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/activity4.json"))
    
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = (frameSize.height-960)/2}
    self.ui.Panel_3:getLayoutParameter():setMargin(tbl_act)

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        DialogManager:closeDialog(self)
    end)

    ui_add_click_listener(self.ui.btn_close2, function(sender,eventType)
        DialogManager:closeDialog(self)
    end)
    
    self.ui.Image_71:setTouchEnabled(true)
    
    ui_add_click_listener(self.ui.Image_71, function(sender,eventType)
        DialogManager:closeDialog(self)
        DialogManager:showDialog("Charge")
    end)
    
    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/activity4-item.json")
    self.item_module:retain()
    
    self.item_item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/activity4-item-item.json")
    self.item_item_module:retain()
    
    self.step = nil
    self.gift = nil
    self.allreward = nil
    
    return self.ui
end  

function Activity4:onShow()
    local needRewardInfo = 1
    if self.allreward ~= nil then
        needRewardInfo = 0
    end
    local function onGetStartChargeActInfo(params)
    	if params[1] == 1 then
            if self.step ~= tonum(params[2]) or self.gift ~= tonum(params[3]) then
                local time = UICommon.timeFormatMin(params[2])
                self.ui.lbl_time:setString(time)
                self.gift = tonum(params[3])
                self.step = tonum(params[4])
                -- 0 是true...
                if needRewardInfo == 1 then
                    self.allreward = params[5]
                end
                self:refreshReward()
            end
            self.ui.lbl_day:setString(string.format("%d天",self.gift))
    	else
            MessageManager:show(params[2])
    	end
    end
    sendCommand("getStartChargeActInfo", onGetStartChargeActInfo, {needRewardInfo})
end

function Activity4:getAllReward()
    local function onGetStartChargeActAllRewardInfo(params)
        if params[1] == 1 then
            self.allreward = params[2]
        else
            MessageManager:show(params[2]) 
        end
    end
    sendCommand("getStartChargeActAllRewardInfo", onGetStartChargeActAllRewardInfo)
end

function Activity4:refreshReward()
    local itemlist = self.ui.list_reward
    -- 清空列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)
    for i = self.step+1, table.getn(self.allreward) do
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        self:setItemInfo(d, self.allreward[i], i)
    end

    itemlist:refreshView()
    itemlist:jumpToTop()    
end

function Activity4:setItemInfo(d, reward, i)
    if i == self.step+1 then
        if i-1 < self.gift then
            d.btn_getreward:setVisible(true)
            d.lbl_noreward:setVisible(false)
        end
        ui_add_click_listener(d.btn_getreward, function(sender,eventType)
            local function onGetStartChargeActReward(params)
                if params[1] == 1 then
                    MessageManager:show("领取成功!")
                    table.foreach(params[2],function(k, v)
                        BagUI:addItem(v.itemid, v.count)
                        BagUI:setNeedRefresh()
                        if tonum(v.itemid) ~= 6 then
                            local c = ConfigData.cfg_item[toint(v.itemid)]
                            MessageManager:show(string.format("获得%s*%s",c.name,v.count))
                        else
                            local lv = toint(v.count.lv) - toint(v.count.lv) % 5
                            local color = User.starToText(v.count.star)
                            local etype = ConfigData.cfg_equip_etype2[toint(v.count.etype)]
                            MessageManager:show(string.format("获得%s级%s%s",lv,color,etype))
                        end
                    end)
                    self.gift = tonum(params[3][3])
                    self.step = tonum(params[3][4])
                    self:refreshReward()
                else
                    MessageManager:show(params[2]) 
                end
            end
            sendCommand("getStartChargeActReward", onGetStartChargeActReward, {0})
        end)
    else
        if i-1 < self.gift then
            d.lbl_noreward:setString("已达成")
            d.lbl_noreward:setColor(cc.c3b(0,255,0))
        else
            d.lbl_noreward:setString("未达成")
        end
    end
    d.lbl_day:setString(string.format("累计充值%d天, 可领取: ", i))
    
    local itemlist = d.list_item
    -- 清空列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_item_module)
    itemlist:setItemsMargin(18)
    
    table.foreach(reward, function(k,v)
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d2 = ui_delegate(custom_item)
        
        if tonum(v.itemid) ~= 6 then
            local c = ConfigData.cfg_item[toint(v.itemid)]
            d2.img_item:loadTexture( "res/item/"..v.itemid..".png")
            d2.lbl_name:setString(string.format("%s*%s",c.name,v.count))
        else
            local c = ConfigData.cfg_equip[toint(v.count['eid'])]
            d2.img_item:loadTexture( "res/equip/"..c.picindex..".png")
            local lv = toint(c.lv) - toint(c.lv) % 5
            local color = User.starToText(v.count['pcount'])
            local etype = ConfigData.cfg_equip_etype2[toint(c.etype)]
            d2.lbl_name:setString(string.format("%s级%s%s",lv,color,etype))
        end
    end)

    itemlist:refreshView()
    itemlist:jumpToTop()  
end

return Activity4