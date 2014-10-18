require("src/UI/UICommon")

AlertManager = {
    curAlert = nil
}

-- yes/no 对话框
function AlertManager:yesno(...)
    local arg = {...}
    return AlertManager:alert("YesNoOK", arg[1], arg[2], "yesno", arg[3],arg[4],arg[5])
end

-- ok对话框
function AlertManager:ok(...)
    local arg = {...}
    return AlertManager:alert("YesNoOK", arg[1], arg[2], "ok", arg[3],arg[4])
end

-- 消息框
function AlertManager:message(...)
    local arg = {...}
    return AlertManager:alert("Message", arg[1], arg[2] )
end

-- loading
function AlertManager:loading(...)
    local arg = {...}
    return AlertManager:alert("Loading",arg[1])	
end

function AlertManager:alert(alert, ...)
  local arg = {...}
  local ed = nil

  if(self[alert] == nil)then
    ed = require("src/UI/Alert/"..alert)    
    ed:create()
    ed.ui.nativeUI:retain()
    self[alert] = ed
    
    -- 居中
    local size = cc.Director:getInstance():getWinSize()
    local s2 = ed.ui.nativeUI:getContentSize()
    ed.ui.nativeUI:setPosition(cc.p( (size.width-s2.width) /2 , (size.height - s2.height) / 2 ))
  else
    ed = self[alert]
  end
  
  -- 关闭当前对话框
  if(self.curAlert ~= nil)then
    self.curAlert.ui.nativeUI:removeFromParent()
  end

  self.curAlert = ed

  local scene = cc.Director:getInstance():getRunningScene()
  scene:addChild(ed.ui.nativeUI,50,50) -- Alert的zOrder 为 50
  
  if(ed.onShow ~= nil)then
    ed:onShow(unpack(arg))
  end
  
  return ed
end

-- 关闭界面
function AlertManager:closeAlert()
  if(self.curAlert ~= nil)then
    self.curAlert.ui.nativeUI:removeFromParent()
    self.curAlert = nil
  end
end

return AlertManager