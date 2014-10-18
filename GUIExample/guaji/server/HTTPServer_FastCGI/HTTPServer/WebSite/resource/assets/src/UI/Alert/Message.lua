-- 不带按钮的浮动消息框

local Message = {
  ui = nil,
  rt = nil,
  closeable = false
}

function Message:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/alert-message.json"))
  ui_add_click_listener(self.ui.pnl_back,function()
    if(self.closeable)then
        AlertManager:closeAlert()
    end
  end)
  return self.ui
end

function Message:onShow(closeable, msg)
  self.closeable = closeable
  
  local size = self.ui.pnl_message:getContentSize()
  
  if(self.rt ~= nil)then
    self.rt:removeFromParent()
  end
  
  self.rt = ccui.RichText:create()
  
  self.ui.pnl_message:addChild(self.rt)
  
  self.rt:setAnchorPoint(cc.p(0,1))
  self.rt:ignoreContentAdaptWithSize(false)
  self.rt:setContentSize(size)
  self.rt:setLocalZOrder(10)
  self.rt:setTouchEnabled(false)
  if(type(msg) == "table")then
    for _,v in pairs(msg)do
      self.rt:pushBackElement(v)    
    end
  else
    self.rt:pushBackElement(msg)
  end
  self.rt:formatText()
  
  local rs = self.rt:getRealSize()
  
  -- 居中
  self.rt:setPosition(cc.p(0, (size.height + rs.height) / 2))

end

return Message