-- 离线战斗报告

-- 离线战斗报告对话框实际上跟InfoDialog结构一模一样，由于是唯一一个可能异步弹出（非用户操作就会弹出）
-- 所以要独立做一个，否则直接用InfoDialog可能在弹出时直接覆盖现有的InfoDialog

local InfoDialogBattleOffline = {
  ui = nil,
  report = nil,
  callback = nil
}

function InfoDialogBattleOffline:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/dialog-info.json"))
  
  ui_add_click_listener( self.ui.btn_close,function()
    DialogManager:closeDialog(self)
    if(self.callback ~= nil)then
        self.callback()
    end
  end)
        
  return self.ui
end

function InfoDialogBattleOffline:onShow(title, content, callback)
  self.callback = callback
  self.ui.lbl_title:setString(title)
    local size = self.ui.sv_report:getContentSize()
  
  --if(self.report ~= nil)then
    --self.report:removeFromParent()
  --end
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
  else
    self.ui.sv_report:setInnerContainerSize(self.ui.sv_report:getSize())
  end
    
  self.report:setPosition(cc.p(0, math.max(rs.height,size.height)))
  self.ui.sv_report:jumpToTop()
end

return InfoDialogBattleOffline