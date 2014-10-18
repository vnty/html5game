-- 每日奖励

local DailyGift = {
  ui = nil,
  onClose = nil
}

function DailyGift:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/dialog-gift.json"))
  
  ui_add_click_listener( self.ui.btn_close,function()
    DialogManager:closeDialog(self)
    if(self.onClose ~= nil)then
        self.onClose()
    end
  end)

  ui_add_click_listener( self.ui.btn_getgift,function()
    local function onGetGift(param)
        if(param[1] == 1)then
            local info = param[2]
            MessageManager:show( string.format("获得金币 *%d 钻石 *%d", info.coin, info.g))
            
            if(info.equip[1] ~= 0)then
                -- 额外获得装备
                local v = info.equip[2]
                MessageManager:show( "意外获得新装备：".. User.getEquipName(v), User.starToColor(v.star) )
                BagUI:addEquipToBag(v,true)
            end
            
            GameUI:loadUinfo()            
        else
            MessageManager:show(param[2])
        end
    end
    sendCommand("getGift", onGetGift, {})
  end)
        
  return self.ui
end

function DailyGift:onShow(onClose)
  self.onClose = onClose
  
  local function onGetGiftInfo(param)
    if(param[1] == 1)then
        local info = param[2]
        self.ui.lbl_logindays:setString( string.format("累计登录游戏满7天奖励（已登录%d天）：", info.day) )
        self.ui.lbl_coin:setString(string.format("金币 *%d", info.coin))
        self.ui.lbl_zuanshi:setString( string.format("钻石 *%d", info.g) )
    
        if(info.equip[1] ~= 0)then
        local v = info.equip[2]
            v.ename = ConfigData.cfg_equip[tonum(v.ceid)].ename
            self.ui.lbl_equip_name:setString(User.getEquipName(v))
            self.ui.lbl_equip_name:setColor(User.starToColor(v.star))
            UICommon.setEquipImg(self.ui.item_img,v)
        end
    else
        MessageManager:show(param[2])
    end  
  end
  --sendCommand("getGiftInfo", onGetGiftInfo, {} )
  
end

return DailyGift