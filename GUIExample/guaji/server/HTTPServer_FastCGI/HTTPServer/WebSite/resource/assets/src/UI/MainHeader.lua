--@module MainHeader
-- 主界面头部
local frameSize = cc.Director:getInstance():getWinSize()
local MainHeader = {
  ui = nil,
}

function MainHeader:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/main-header.json"))
  
  ui_add_click_listener(self.ui.nativeUI,function()
        DialogManager:showDialog("PlayerInfo")
  end)
  
    self.ui.nativeUI:setPosition(cc.p(0,frameSize.height-90))
  
  self:refreshUinfoDisplay()
  
  return self.ui.nativeUI
end

function MainHeader:refreshUinfoDisplay()  
    -- 设置主界面的参数
    self.ui.lbm_coin:setString(string.format("%d",User.ucoin))
    self.ui.lbm_ug:setString(string.format("%d",User.ug))
    self.ui.lbm_lv:setString(string.format("等级：%d级",User.ulv))
    self.ui.bmf_vip:setString( string.format("V%d", User.vip))
end

function MainHeader:setVisible(f)
    UICommon.setVisible(self.ui.nativeUI,f)
end

return MainHeader