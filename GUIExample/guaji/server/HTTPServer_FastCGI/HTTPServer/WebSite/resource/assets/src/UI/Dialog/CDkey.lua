local CDkey = {
    ui=nil
}

function CDkey:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/cdkey.json"))
  
    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)
    
    -- top
    local back = cc.Scale9Sprite:create("res/ui/images/img_110.png", cc.rect(20, 20, 1, 1))
    back:setContentSize(cc.size(0,0))
    local EditName = cc.EditBox:create(cc.size(350,50), back)
--    local EditName = cc.EditBox:create(cc.size(350,50), self.ui.info_back)
    EditName:setPosition(cc.p(250, 60))
    EditName:setFontSize(24)
    EditName:setFontColor(cc.c3b(255,255,255))
    EditName:setPlaceHolder("请输入CdKey兑换码")
    EditName:setPlaceholderFontColor(cc.c3b(137,138,138))
    EditName:setMaxLength(20)
    EditName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    --Handler
    --EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    self.ui.pnl_message:addChild(EditName)
  
    ui_add_click_listener(self.ui.btn_yes, function(sender,eventType)

        local cdkey = EditName:getText()
    
        local function onGetCdKeyGift(p)
            if(p[1] == 1)then
                self:close()
                local reward = "领取成功!"
                if(tonum(p[2].coin) ~= 0 or tonum(p[2].ug) ~= 0 or tonum(p[2].s1) ~= 0) then
                    reward = "获得"
                    if(tonum(p[2].coin) ~= 0) then
                        reward = reward.." 金币"..p[2].coin
                    end
                    if(tonum(p[2].ug) ~= 0) then
                        reward = reward.." 钻石"..p[2].ug
                    end
                    if(tonum(p[2].s1) ~= 0) then
                        reward = reward.." 精华"..p[2].s1
                        BagUI:setNeedRefresh()
                    end
                end
                if(tonum(p[2].count)~=0 and tonum(p[2].itemid)>0) then
                    local s = ConfigData.cfg_item[tonum(tonum(p[2].itemid))]["name"]
                    reward=reward..s..p[2].count
                    BagUI:addItem(tonum(p[2].itemid),tonum(p[2].count))
                    BagUI:setNeedRefresh()
                end
                MessageManager:show(reward)
                GameUI:loadUinfo()
            else
                MessageManager:show(p[2])
            end
        end
        
        sendCommand("getCdKeyGift", onGetCdKeyGift,{Platform.platformType,cdkey})
    end)
    
    ui_add_click_listener(self.ui.btn_paste, function(sender,eventType)
        EditName:setText(Platform:getClipText())
    end)
    
    return self.ui
end

function CDkey:onShow()
end

function CDkey:close()
    DialogManager:closeDialog(self)
end

return CDkey