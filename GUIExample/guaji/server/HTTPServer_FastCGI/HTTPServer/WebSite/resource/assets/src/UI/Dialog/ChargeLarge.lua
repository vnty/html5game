local cmd = require("src/Command")

local ChargeLarge = {
    ui = nil,
}

function ChargeLarge:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/vip-charge-large.json"))

    ui_add_click_listener(self.ui.btn_cancel, function(sender,eventType)
        self:close()
    end)

    -- top
    local size = self.ui.pnl_input:getContentSize()
    local back = cc.Scale9Sprite:create("res/ui/images/img_110.png", cc.rect(14, 14, 8, 8))
    local EditName = cc.EditBox:create(cc.size(350,50), back)
    EditName:setPosition(cc.p(size.width/2, size.height/2))
    EditName:setFontSize(25)
    EditName:setFontColor(cc.c3b(255,255,255))
    EditName:setPlaceHolder("请输入充值数额")
    EditName:setPlaceholderFontColor(cc.c3b(0,255,0))
    EditName:setMaxLength(8)
    EditName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    --Handler
    --EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    self.ui.pnl_input:addChild(EditName)

    ui_add_click_listener(self.ui.btn_yes, function(sender,eventType)
        local num = toint(EditName:getText())
        if num >= 2000 then
            Platform:buyItem(num, 3)
        else
            MessageManager:show("请输入正确的数值")
        end
    end)

    return self.ui
end

function ChargeLarge:onShow()
end

function ChargeLarge:close()
    DialogManager:closeDialog(self)
end

return ChargeLarge