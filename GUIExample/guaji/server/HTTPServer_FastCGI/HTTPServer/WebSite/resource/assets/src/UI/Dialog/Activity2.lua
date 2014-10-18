local Activity2 = {
    ui = nil,
    count=0,
}

function Activity2:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/activity2.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
    self.ui.Panel_3_0_0_0_0:getLayoutParameter():setMargin(tbl_act)    

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        DialogManager:closeDialog(self)
    end)

    ui_add_click_listener(self.ui.btn_shop, function(sender,eventType)
        DialogManager:closeDialog(self)
        GameUI:switchTo("shopUI")
    end)

    ui_add_click_listener(self.ui.btn_change1, function(sender,eventType)
        self:changeItems(41)
    end)
    
    ui_add_click_listener(self.ui.btn_change2, function(sender,eventType)
        self:changeItems(42)
    end)
    
    ui_add_click_listener(self.ui.btn_change3, function(sender,eventType)
        self:changeItems(13)
    end)
    
    ui_add_click_listener(self.ui.btn_change4, function(sender,eventType)
        self:changeItems(6)
    end)

end  

function Activity2:onShow()
    local function onGetGoblinNum(param)
        if(param[1]==1) then
            self.ui.lbl_left:setString("我的地精之泪数量 :"..param[2])
            if param[3] ~= nil then
                self.ui.lbl_time:setString(param[3])
            end 
        else
            MessageManager:show(param[2])
        end
    end
    sendCommand("getGoblinNum", onGetGoblinNum)
end

function Activity2:changeItems(itemid)
    local function onGetActItem(param)
        if(param[1] == 1) then
            local item = param[2]
            if item['itemid'] ~= 6 then
                local c = ConfigData.cfg_item[toint(item['itemid'])]
                BagUI:addItem(item['itemid'], item['count'])
                BagUI:setNeedRefresh()
                MessageManager:show("获得"..c.name.."*"..item['count'])
            else
                local equip = item['count']
                MessageManager:show("获得新装备：".. User.getEquipName(equip), cc.c3b(255,0,0) )
                BagUI:setNeedRefresh()
                BagUI:addEquipToBag(equip,true)
                User.updateEquipInfo(equip)
                DialogManager:closeDialog(self)
                DialogManager:showDialog( "EquipDetail", equip);
            end
            self.ui.lbl_left:setString("我的地精之泪数量 :"..param[3])
        else
            MessageManager:show(param[2])
        end
    end
    sendCommand("getGoblinItem",onGetActItem,{itemid})
end


return Activity2