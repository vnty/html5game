
local ChooseJobUI = class()


function ChooseJobUI:ctor()
  self.ui = nil
  self.job = 1
  self.sex = 1
  self.last_img = nil
  self.rt = nil
end

function ChooseJobUI:setDescText(job)
    local size = self.ui.pnl_desc:getContentSize()
  
  if(self.rt ~= nil)then
    self.rt:removeFromParent()
  end
  
  self.rt = ccui.RichText:create()
  
  self.ui.pnl_desc:addChild(self.rt)
  
  self.rt:setAnchorPoint(cc.p(0,1))
  self.rt:ignoreContentAdaptWithSize(false)
    self.rt:setContentSize(size)
  self.rt:setLocalZOrder(10)

  if(job == 1)then
    self.rt:pushBackElement(RTE("战士将力量、防御以及领导才能结合在一起，以在光荣的战斗中一展身手。强大的战士利用盾牌以及战斗技巧来保护自己，在持久战中光荣胜出。",20))
    self.rt:pushBackElement(RTE("关键：力量，防御，坦克",25,cc.c3b(0,0,255))) 
  elseif(job == 2)then
    self.rt:pushBackElement(RTE("无情的原始世界吸引了无数冒险者的到来，坚持下来的就成为了猎人。猎人是射击专家，通过普通射击时大量的致命的暴击终结敌人。",20))
    self.rt:pushBackElement(RTE("关键：敏捷，普通攻击，暴击",25,cc.c3b(0,0,255))) 
  elseif(job == 3)then
    self.rt:pushBackElement(RTE("法师既强大又危险,只有最智慧并严于律己的学徒才能够走上法师之路。法师使用强力的技能来杀伤敌人，充足的魔法值保证他们的技能源源不断。",20))
    self.rt:pushBackElement(RTE("关键：智力，技能，魔法值",25,cc.c3b(0,0,255))) 
  end
  
  self.rt:setPosition(cc.p(0, size.height))
end

function ChooseJobUI:choose(j)
  if(j == 1)then
    self.job = 1
    self.sex = 1
  elseif(j == 2)then
    self.job = 2
    self.sex = 1
  elseif(j == 3)then
    self.job = 3
    self.sex = 1
  elseif(j == 4)then
    self.job = 1
    self.sex = 2
  elseif(j == 5)then
    self.job = 2
    self.sex = 2
  elseif(j == 6)then
    self.job = 3
    self.sex = 2
  end
    self.last_img:loadTexture( "res/ui/images/img_148.png")
  local new = self.ui[string.format("img_%d",j)]
    new:loadTexture( "res/ui/images/img_153.png")
  self.last_img = new
  self:setDescText(self.job)
end 
 
function ChooseJobUI:init()
    local frameSize = cc.Director:getInstance():getWinSize()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/choose-job.json"))
    where1 = {left = 30,top = 0,right = 30, bottom = 0  }
    where1.top = 110+(frameSize.height-960)/3
    self.ui.img_1:getLayoutParameter():setMargin(where1)
    self.ui.img_2:getLayoutParameter():setMargin(where1)
    self.ui.img_3:getLayoutParameter():setMargin(where1)
    where1.top = 340+2*(frameSize.height-960)/3
    self.ui.img_4:getLayoutParameter():setMargin(where1)
    self.ui.img_5:getLayoutParameter():setMargin(where1)
    self.ui.img_6:getLayoutParameter():setMargin(where1)
    
    
    -- top
    local back = cc.Scale9Sprite:create("res/ui/images/img_110.png", cc.rect(14, 14, 8, 8))
    local EditName = cc.EditBox:create(cc.size(350,50), back)
    EditName:setPosition(cc.p(175, 25))
    EditName:setFontSize(25)
    EditName:setFontColor(cc.c3b(255,255,255))
    EditName:setPlaceHolder("请输入您的大名")
    EditName:setPlaceholderFontColor(cc.c3b(255,255,255))
    EditName:setMaxLength(6)
    EditName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    --Handler
    --EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    self.ui.pnl_username:addChild(EditName)
    
    ui_add_click_listener(self.ui.btn_start, function()
      local uname = EditName:getText()
      if(uname == "")then
        MessageManager:show("请输入您的大名")
        return
      end
      sendCommand("setUinfo", function(param)
        if(tonum(param) == 1)then
          User.ujob = self.job
          User.usex = self.sex
          User.uname = uname
          -- 切换至主界面
          self.ui.nativeUI:removeFromParent()
          GameUI:doEnterGame()
        else
            EditName:setText("");
            MessageManager:show("非法的用户名!");
        end
      end, {self.job,uname,self.sex})
    end )
    
    self.last_img = self.ui.img_1
    self:setDescText(1)
    
    for i = 1, 6 do
        ui_add_click_listener(self.ui["btn_0"..i], function()
            self:choose(i)
        end )
    end
    
    return self.ui.nativeUI
end

return ChooseJobUI