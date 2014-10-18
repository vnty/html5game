-- 带YES/NO/OK的消息框

local YesNoOK = {
  ui = nil,
  rt = nil,
  onCallback = nil -- yes或者确定时候的回调
}

function YesNoOK:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/alert-yesnook.json"))
  
  -- 确定按钮
  ui_add_click_listener(self.ui.btn_close,function()
    AlertManager:closeAlert()
    if(self.onCallback ~= nil)then
        self.onCallback()
        self.onCallback=nil        
    end    
  end)
  
  -- no按钮
  ui_add_click_listener(self.ui.btn_cancel,function()
    AlertManager:closeAlert() 
  end)
  
  -- yes按钮
  ui_add_click_listener(self.ui.btn_yes,function()
    AlertManager:closeAlert()  
    if(self.onCallback ~= nil)then
        self.onCallback()
        self.onCallback=nil
    end
  end)  
  
  return self.ui
end

-- callback在yes和黄色确定时都会被调用
function YesNoOK:onShow(title, msg, t, callback,rightText,leftText )
  self.onCallback = callback
  self.ui.lbl_title:setString(title)
    
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
  
  if(t == "ok")then
    -- 只显示黄色确定按钮
    UICommon.setVisible(self.ui.btn_cancel,false)
    UICommon.setVisible(self.ui.btn_yes,false)
    UICommon.setVisible(self.ui.btn_close,true)
  elseif(t == "yesno")then
    -- 显示确定取消
    UICommon.setVisible(self.ui.btn_cancel,true)
    UICommon.setVisible(self.ui.btn_yes,true)
    UICommon.setVisible(self.ui.btn_close,false)
  end
  if(rightText) then
            self.ui.btn_yes:setTitleText(rightText)
        else
            self.ui.btn_yes:setTitleText("确定")
  end
  if(leftText) then
        self.ui.btn_cancel:setTitleText(rightText)
    else
        self.ui.btn_cancel:setTitleText("取消")
  end
  
end

return YesNoOK