local Activity1 = {
  ui = nil,
  count=0,
}
function Activity1:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/activity.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = 5+(frameSize.height-960)/2}
    self.ui.Panel_3_0_0_0:getLayoutParameter():setMargin(tbl_act)
     ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
      DialogManager:closeDialog(self)
     end)
     
    ui_add_click_listener(self.ui.btn_charge, function(sender,eventType)
         DialogManager:showDialog("Charge")
         DialogManager:closeDialog(self)
    end)
    
    ui_add_click_listener(self.ui.btn_ug, function(sender,eventType)
        local function onDoSearchGem(param)
            if(param[1]==1) then
                self:getGift(param)
            else
                MessageManager:show(param[2])
            end
        end
        sendCommand("doSearchGem", onDoSearchGem)
    end)
    
    ui_add_click_listener(self.ui.btn_coin, function(sender,eventType)
        local function onDoSearchCoin(param)
            dump(param)
            if(param[1]==1) then
               self:getGift(param)
            else
                MessageManager:show(param[2])
            end
        end
        sendCommand("doSearchCoin", onDoSearchCoin)
    end)
    
    
end  
function Activity1:getGift(param) 
    local itemname = ConfigData.cfg_item[param[2].itemid].name
    MessageManager:show("恭喜获得"..itemname.."*"..param[2].count)
    BagUI:addItem(param[2].itemid, param[2].count)
    BagUI:setNeedRefresh()
    self.count=self.count-1
    self.ui.lbl_left:setString(string.format("我的可探索次数：%d",self.count))
end
function Activity1:onShow()

    local function onGetSearchTimes(param)
    dump(param)
        if(param[1]==1) then
            self.count= toint(param[2])
            self.ui.lbl_left:setString(string.format("我的可探索次数：%d",self.count))
            if param[3] ~= nil then
                self.ui.lbl_time:setString(param[3])
            end 
        else
            MessageManager:show(param[2])
        end
    end
    sendCommand("getSearchTimes", onGetSearchTimes)
end
return Activity1