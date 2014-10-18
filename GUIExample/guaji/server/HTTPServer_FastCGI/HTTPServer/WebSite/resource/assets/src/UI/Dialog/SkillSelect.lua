-- @module SkillSelect

local SkillSelect = {
  ui = nil,
  skilllist = nil,
  boxlist = {},
--  selectbox = {},
  skillNum = 0,
  skills = nil,
  parent = nil 
}

function SkillSelect:create()
   self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_select.json"))
   self.ui.nativeUI:setTouchEnabled(true)
   
   self.skilllist = self.ui.list_skill
   self.skilllist:setItemsMargin(5)
   self.skilllist:setTouchEnabled(true)
   self.skilllist:setBounceEnabled(true)
  
   local skill_item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item.json")
   ui_delegate(skill_item).Image_72:setVisible(false)
   self.skilllist:setItemModel(skill_item)
     
   ui_add_click_listener( self.ui.nativeUI,function()
      self:close()
   end)
   
   ui_add_click_listener( self.ui.btn_return,function()
      self:close()
   end)
   
   ui_add_click_listener( self.ui.btn_save,function()
      self:save()
   end)
   
   return self.ui
end

function SkillSelect:setItemInfo(d,v)
    
    --使checkbox只能选中一个
    local function setSelectBox(box)
        self.skillNum = self.skillNum + 1
        table.foreach(self.boxlist,function(k,v)
          if(box == v) then
            v:setSelectedState(true)
          end
        end)
        
        if(self.skillNum>= SkillUI.getSkillNum()) then
          self:checkboxDisable()
        end
    end
    
    d.btn_order:removeFromParent()
    d.txt_mp:setString( string.format("消耗MP：%d", v.mp) )
    d.img_skill:loadTexture( string.format("res/skill/%d.png", v.sid))
    d.lbm_order:setString(v.slv)
    d.txt_name:setString(v.sname)
    d.txt_info:setString(v.tips)
        
    if toint(v.slv)<=toint(User.ulv) then
        -- 技能已开启
        d.img_lock:setVisible(false)

        local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                setSelectBox(sender)
            elseif eventType == ccui.CheckBoxEventType.unselected then
                self.skillNum = self.skillNum - 1
                self:checkboxEnable()
            end
        end 

        d.checkbox:addEventListenerCheckBox(selectedEvent)
                
        table.insert(self.boxlist,d.checkbox)
        if(SkillUI:getSkillPosition(v.sid) ~= nil) then
            setSelectBox(d.checkbox)  --如为当前装备技能则显示选中
        end
        d.txt_mp:setColor(cc.c3b(00,204,255))
    else
        --        local size = d.nativeUI:getContentSize()
        --        local tip = UICommon.createLabel( string.format( "人物等级Lv.%d开启该技能", toint(v.slv)), 30)
--        tip:setColor(cc.c3b(255,30,0))
--        --tip:setTag(10002)      
--        tip:setPosition(cc.p(size.width/2,size.height/2))
--        tip:enableOutline(cc.c4b(0,0,0,255),5)      
--        d.nativeUI:addChild(tip)      
--        tip:runAction(cc.RepeatForever:create(cc.Sequence:create( cc.FadeIn:create(1), cc.FadeOut:create(1))))
--        tip:setPosition(cc.p(size.width/2,size.height/2))
        
        d.txt_mp:setString( string.format("人物等级%d级开启", toint(v.slv)) )
        d.txt_mp:setColor(cc.c3b(255,0,0))
        
        d.checkbox:setEnabled(false)
        d.checkbox:setVisible(false)
    end
end

function SkillSelect:checkboxEnable()
    table.foreach(self.boxlist, function(k,v)
        --v:setEnabled(true)     
        v:setTouchEnabled(true)
        v:setBright(true) 
    end)
end

function SkillSelect:checkboxDisable()
    table.foreach(self.boxlist, function(k,v)
        if(v:getSelectedState() == false) then
            --v:setEnabled(false)            
            v:setTouchEnabled(false)
            v:setBright(false) 
        end
    end)
end

--从cfg中获取技能
function SkillSelect:getSkillList()
  local optionSkill = {}
  local n = 1;
  table.foreach(ConfigData.cfg_skill,function(k,v)
    if toint(v.sjob) == toint(User.ujob) then
      optionSkill[n] = v;
      n = n+1;
    end
  end)
  
  table.sort( optionSkill, function(a,b)
  	return toint(a.slv) < toint(b.slv)
  end )
  return optionSkill
end

--初始化选择技能界面
function SkillSelect:initSelectSkillView()
    self.skills = self:getSkillList()

    self.ui.lbl_tips:setString(string.format("人物等级Lv. %d 可以装备 %d 个技能", User.ulv, SkillUI:getSkillNum() ))
  
    self.skilllist:removeAllItems()
    self.boxlist = {}
    self.skillNum = 0
    table.foreach(self.skills,function(k,v)
        self.skilllist:pushBackDefaultItem()
        local custom_item = self.skilllist:getItem(self.skilllist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
    
        self:setItemInfo(d,v)
    end)
    if(self.skillNum>= SkillUI.getSkillNum()) then
        self:checkboxDisable()
    end
end

function SkillSelect:onShow(type, parent)
   self:initSelectSkillView()
   self.parent = parent
   self.type = type
end

function SkillSelect:close()
   DialogManager:closeDialog(self)
   if self.type ~= nil and self.type == "pvp" then
    if self.parent ~=nil then
    end
   end
end

--保存技能
function SkillSelect:save()
    local n = self.skilllist:getChildrenCount() -1
    local position = 1
    for i=0,n do
      local custom_item = self.skilllist:getItem(i)
      local d = ui_delegate(custom_item)
      if(d.checkbox:getSelectedState() == true) then
        self:equipSkill(self.skills[i+1].sid, position)
        position = position+1
      end       
    end
  
  if(position<= SkillUI:getSkillNum()) then
    for i = position, SkillUI:getSkillNum() do
      if self.type ~= nil and self.type == "pvp" then
        User.userPvpSkill[i] = nil
      else
        User.userSkill[i] = nil
      end
    end
  end
  
  if self.type == nil or self.type == "pve" then
    SkillUI:initCurrentSkillView()
    SkillUI:sendEquipSkill()
  elseif self.type == "pvp" then
    if self.parent ~=nil then
        self.parent:initCurrentSkillView()
        self.parent:sendEquipSkill()
      end
  end
  self:close()
end

--本地装备到玩家的技能上，并同步服务端
function SkillSelect:equipSkill(sid,position)
    if self.type ~= nil and self.type == "pvp" then
        User.userPvpSkill[position] = sid
    else
        User.userSkill[position] = sid
    end
end

return SkillSelect