local BattleSet = {
    tempstar = 0,
    tempjob = 0,
    tempchat = 0
}

function BattleSet:create()
    self.tempstar = 0
    self.tempjob = 0
    self.tempchat = 0

    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/battle_set.json"))
    self.ui.nativeUI:setTouchEnabled(true)
   
    -- 按颜色卖出
    for i=1, 4 do
        self.ui["row_equip"..i]:setTouchEnabled(true)
        ui_add_click_listener( self.ui["row_equip"..i],function()
            self:selectStar(i)
        end)
     
        local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                self:starSelect(i)
            elseif eventType == ccui.CheckBoxEventType.unselected then
                self:starDisselect(i)
            end
        end 
     
        local d = ui_delegate(self.ui["row_equip"..i])
        d.checkbox:addEventListener(selectedEvent)
    end
   
    -- 按职业卖出
    local function selectedEvent(sender,eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self.tempjob = 1
        elseif eventType == ccui.CheckBoxEventType.unselected then
            self.tempjob = 0
        end
    end 
   
    self.ui["row_job1"]:setTouchEnabled(true)
    ui_add_click_listener( self.ui["row_job1"],function()
        local d = ui_delegate(self.ui["row_job1"])
        if(d.checkbox:getSelectedState()==true)then
            d.checkbox:setSelectedState(false)
            self.tempjob = 0
        else
            d.checkbox:setSelectedState(true)
            self.tempjob = 1
        end
    end)
    local d = ui_delegate(self.ui["row_job1"])
    d.checkbox:addEventListenerCheckBox(selectedEvent)
    
    -- 关闭聊天
    local function selectedEvent(sender,eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self.tempchat = 0
        elseif eventType == ccui.CheckBoxEventType.unselected then
            self.tempchat = 1
        end
    end 

    self.ui["row_chat"]:setTouchEnabled(true)
    ui_add_click_listener( self.ui["row_chat"],function()
        local d = ui_delegate(self.ui["row_chat"])
        if(d.checkbox:getSelectedState()==true)then
            d.checkbox:setSelectedState(false)
            self.tempchat = 1
        else
            d.checkbox:setSelectedState(true)
            self.tempchat = 0
        end
    end)
    local d = ui_delegate(self.ui["row_chat"])
    d.checkbox:addEventListener(selectedEvent)
        
    ----------------------
    ui_add_click_listener( self.ui.btn_cancel,function()
        self:close()
    end)
   
    ui_add_click_listener( self.ui.btn_save,function()
        self:save()
    end)
   
    return self.ui
end

--判断选择的颜色
function BattleSet:selectStar(id)
  local d = ui_delegate(self.ui["row_equip"..id])
  if(d.checkbox:getSelectedState() == true) then
    self:starDisselect(id)
  else
    self:starSelect(id)
  end
end

--选中未选中的
function BattleSet:starSelect(id)
  self.tempstar = id
  for i=1,id do
    local d = ui_delegate(self.ui["row_equip"..i])
    d.checkbox:setSelectedState(true)
  end
  for i=id+1,4 do
    local d = ui_delegate(self.ui["row_equip"..i])
    d.checkbox:setSelectedState(false)
  end
end

--选中选中的
function BattleSet:starDisselect(id)
  self.tempstar = id -1
  for i=1,id-1 do
    local d = ui_delegate(self.ui["row_equip"..i])
    d.checkbox:setSelectedState(true)
  end
  for i=id,4 do
    local d = ui_delegate(self.ui["row_equip"..i])
    d.checkbox:setSelectedState(false)
  end
end

function BattleSet:onShow()
    self.tempjob = User.selljob
    if(self.tempjob == 1) then
        local d = ui_delegate(self.ui["row_job1"])
        d.checkbox:setSelectedState(true)
    end
    
    self.tempstar = User.sellstar
    self:starSelect(self.tempstar)  

    -- 聊天设置
    self.tempchat = tonum(cc.UserDefault:getInstance():getStringForKey("disableChat"))
    local d = ui_delegate(self.ui["row_chat"])
    d.checkbox:setSelectedState( self.tempchat == 0 )
end

function BattleSet:close()
   DialogManager:closeDialog(self)
end

function BattleSet:save()
    if User.selljob ~= self.tempjob or User.sellstar ~= self.tempstar then 
        sendCommand("setAutoSell", function (param)
            if(param[1] == 1)then
                User.selljob = self.tempjob
                User.sellstar = self.tempstar
                MessageManager:show("设置成功")
            end
        end,{self.tempstar})
    end
    
    -- 保存聊天设置
    local dc = tonum(cc.UserDefault:getInstance():getStringForKey("disableChat"))
    if dc ~= self.tempchat then
        cc.UserDefault:getInstance():setStringForKey("disableChat", self.tempchat)
        
        -- 关闭或者开启聊天
        BattleUI.chatUI:chatSetup(self.tempchat)
    end

    self:close()
end


return BattleSet