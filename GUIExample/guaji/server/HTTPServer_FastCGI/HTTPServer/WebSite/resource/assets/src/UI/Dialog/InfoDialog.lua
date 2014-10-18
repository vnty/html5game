-- 标准的信息报告框

local InfoDialog = {
  ui = nil,
  callback = nil
}

function InfoDialog:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/dialog-info.json"))
  
  ui_add_click_listener( self.ui.btn_close,function()
    DialogManager:closeDialog(self)
    if(self.callback ~= nil)then
        self.callback()
    end
  end)
        
  return self.ui
end

function InfoDialog:onShow(title, content, callback)
  self.callback = callback
  self.ui.lbl_title:setString(title)
    local size = self.ui.sv_report:getContentSize()
  
  self.ui.sv_report:removeAllChildren()
  
  self.report = ccui.RichText:create()
  
  self.ui.sv_report:addChild(self.report)
  
  self.report:setAnchorPoint(cc.p(0,1))
  self.report:ignoreContentAdaptWithSize(false)
    self.report:setContentSize(size)
  self.report:setLocalZOrder(10)

  for _,v in pairs(content) do
    self.report:pushBackElement(v)
  end
  
  self.report:formatText()
  
  local rs = self.report:getRealSize()
  
  if(rs.height > size.height)then
    self.ui.sv_report:setInnerContainerSize(rs)
  end
  
  self.report:setPosition(cc.p(0, math.max(rs.height,size.height)))
  self.ui.sv_report:jumpToTop()
end

return InfoDialog