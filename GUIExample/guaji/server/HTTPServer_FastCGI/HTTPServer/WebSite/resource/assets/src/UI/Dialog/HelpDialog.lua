local HelpDialog = {
  ui = nil,
}

function HelpDialog:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/help-main.json"))

    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
    self.ui.Panel_3_0_0:getLayoutParameter():setMargin(tbl_act)

  
  ui_add_click_listener( self.ui.btn_close,function()
        DialogManager:closeDialog(self)
  end)
  
  return self.ui
end

function HelpDialog:onShow(text)
    
    self.ui.scv_help:removeAllChildren()
    
    local size = self.ui.scv_help:getContentSize()
    self.report = ccui.RichText:create()
    
    self.ui.scv_help:addChild(self.report)  
    self.report:setAnchorPoint(cc.p(0,1))
    self.report:ignoreContentAdaptWithSize(false)
    self.report:setContentSize(size)
    self.report:setLocalZOrder(10)

    for _,v in pairs(text) do
        self.report:pushBackElement(v)
    end

    self.report:formatText()
    local rs = self.report:getRealSize()

    self.ui.scv_help:setInnerContainerSize(rs)
    self.report:setPosition(cc.p(0, math.max(rs.height, size.height)) )
end

return HelpDialog