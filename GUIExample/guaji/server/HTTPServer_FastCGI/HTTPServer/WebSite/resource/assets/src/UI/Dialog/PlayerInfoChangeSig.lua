local cmd = require("src/Command")

local PlayerInfoChangeSig = {
  ui = nil,
}

function PlayerInfoChangeSig:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/player-info-change-sig.json"))
  
    ui_add_click_listener(self.ui.btn_cancel, function(sender,eventType)
        self:close()
    end)
    
    -- top
    local size = self.ui.pnl_sig:getContentSize()
    local back = cc.Scale9Sprite:create("res/ui/images/img_110.png", cc.rect(14, 14, 8, 8))
    local EditName = cc.EditBox:create(cc.size(550,50), back)
    EditName:setPosition(cc.p(size.width/2, size.height/2))
    EditName:setFontSize(25)
    EditName:setFontColor(cc.c3b(255,255,255))
    EditName:setPlaceHolder("请输入您的签名")
    EditName:setPlaceholderFontColor(cc.c3b(0,255,0))
    EditName:setMaxLength(20)
    EditName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    --Handler
    --EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    self.ui.pnl_sig:addChild(EditName)
  
    ui_add_click_listener(self.ui.btn_yes, function(sender,eventType)
        self:close()

        local sig = EditName:getText()
        
        local function onSetUserSig(p)
            if(p[1] == 1)then
                MessageManager:show("设置成功")
                DialogManager:showDialog("PlayerInfo",sig)
            else
                MessageManager:show(p[2])
            end
        end
        
        sendCommand("setUserSig", onSetUserSig,{sig})
    end)
  
    return self.ui
end

function PlayerInfoChangeSig:onShow()
end

function PlayerInfoChangeSig:close()
    DialogManager:closeDialog(self)
end

return PlayerInfoChangeSig