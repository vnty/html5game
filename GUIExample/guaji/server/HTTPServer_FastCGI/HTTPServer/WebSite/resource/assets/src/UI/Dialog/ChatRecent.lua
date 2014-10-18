local ChatRecent = {
    ui = nil,
    item_model = nil
}

function ChatRecent:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/chat-recent.json"))
    
    if self.item_model == nil then
        self.item_model = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/chat-recent-item.json")
        self.item_model:retain()
    end
  
    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)
    
    ui_add_click_listener(self.ui.nativeUI, function(sender,eventType)
        -- 点击任意位置关闭
        self:close()
    end)
    
    return self.ui
end

function ChatRecent:onShow(uids)
    local function onGetChatRecent(p)
        dump(p)
        if tonum(p[1]) == 1 then
            self.ui.pnl_list:removeAllChildren()
            local size = self.ui.pnl_list:getContentSize()
            local x = 0
            local y = 0
            for _,v in pairs(p[2]) do
                local item = self.item_model:clone()
                item:setAnchorPoint(cc.p(0,1))
                item:setPosition(cc.p(x * 120, size.height - y * 120))
                self.ui.pnl_list:addChild(item)
                
                UICommon.setUserItemImg( ui_(item,"item_img"),v)
                
                item:setTouchEnabled(true)
                ui_add_click_listener(item,function()
                    DialogManager:showSubDialog(self, "PvpDetail",v.uid)
                end)
                
                x = x + 1
                if x >= 4 then
                    x = 0
                    y = y + 1
                end
            end
        else
            MessageManager:show(p[2])
        end
    end
    local ustr = table.concat(uids, ",") -- 10001,10002,10003
    cclog("ustr" .. ustr)
    sendCommand("getChatRecent", onGetChatRecent, { ustr })
end

function ChatRecent:close()
    DialogManager:closeDialog(self)
end

return ChatRecent