local ClubSetGongGao = {
    ui = nil, 
    cid = 0
}

function ClubSetGongGao:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-setGongGao.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)
    
 
    local function textFieldEvent(sender, eventType)
        dump(sender.data)
        local num=self.ui.TextField_29:getStringValue()
       
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            cclog("attach_with_ime")
            self.ui.TextField_29:setColor(cc.c3b(0,255,51))
            self.ui.lbl_putin:setVisible(true)
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            cclog("detach_with_ime")
            self.ui.TextField_29:setColor(cc.c3b(255,255,255))
            self.ui.lbl_putin:setVisible(false)
        elseif eventType == ccui.TextFiledEventType.insert_text then
            cclog("insert_text")
            self.ui.TextField_29:setColor(cc.c3b(0,255,51))
            self.ui.lbl_putin:setVisible(true)
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            cclog("delete_backward")
            self.ui.TextField_29:setColor(cc.c3b(0,255,51))
            self.ui.lbl_putin:setVisible(true)
        end
    end
    self.ui.TextField_29:addEventListenerTextField(textFieldEvent)
    ui_add_click_listener(self.ui.btn_setnote, function(sender,eventType)
        local name = self.ui.TextField_29:getStringValue()
        if name == nil then
            name = ""
        elseif string.len(name)> 120 then 
            MessageManager:show("您输入的字太长了")
            return
        end
        local function callback(p)
            if(p[1] == 1)then
                MessageManager:show("修改成功")
                self:close()
                ClubMember:reloadInfo(function()
                    ClubMember:refreshUI()
                end)
            else
                MessageManager:show(p[2])
            end
        end
        if self.cid ~= 0 then
            sendCommand("setClubNote",callback, {name, self.cid})
        end
    end)

    return self.ui
end


function ClubSetGongGao:onShow(type, default, cid)

    -- TODO 刷新公会
    --self.EditName:setText("")
    --self.EditName:setPlaceHolder(default)
    type = tonum(type)
    self.cid = tonum(cid)
    self.ui.TextField_29:setMaxLengthEnabled(true);
    self.ui.TextField_29:setMaxLength(40)
    self.ui.pnl_setnote:setVisible(true)
    self.ui.TextField_29:setText(default)
    self.ui.lbl_putin:setVisible(false)
  
end

function ClubSetGongGao:close()
    DialogManager:closeDialog(self)
end

return ClubSetGongGao