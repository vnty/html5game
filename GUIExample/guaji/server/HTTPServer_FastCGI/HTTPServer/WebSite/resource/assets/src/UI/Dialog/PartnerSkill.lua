local ParnertSkill = {
    ui = nil,
    skilllist = nil,
    boxlist = {},
    skillNum = 0,
    skills = nil,
    parent = nil,
    num_refresh = 0;
}

function ParnertSkill:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_partner.json"))
    self.ui.nativeUI:setTouchEnabled(true)
    
    self.skilllist = self.ui.list_skill
    self.skilllist:setItemsMargin(5)
    self.skilllist:setTouchEnabled(true)
    self.skilllist:setBounceEnabled(true)
      
    ui_add_click_listener( self.ui.btn_close,function()
        self:close()
    end)
        
    ui_add_click_listener( self.ui.btn_refresh,function()
        self:refreshPartnerSkill()
    end)
    
    ui_add_click_listener( self.ui.btn_help,function()
        DialogManager:showDialog("HelpDialog", HelpText:helpPartnerSkill())
    end)
    
    self.lock = {0,0,0,0}
    return self.ui
end
--
function ParnertSkill:setItemInfo(d, v, i)
    --使checkbox只能选中一个
    local function setSelectBox(box)
        self.skillNum = self.skillNum + 1
        self:setPartnerSkillCost()
        table.foreach(self.boxlist,function(k,v)
            if(box == v) then
                v:setSelectedState(true)
            end
        end)
    end

    --d.btn_order:removeFromParent()
    d.txt_mp:setString( string.format("消耗MP：%d", v.mp) )
    d.txt_mp:setColor(cc.c3b(00,204,255))
    d.img_skill:loadTexture( string.format("res/skill/%s.png",v.sid))
    d.lbm_order:setString(v.slv)
    d.txt_name:setString(v.sname)
    d.txt_info:setString(v.tips)
    d.img_lock:setVisible(false)
    
    local function selectedEvent(sender,eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            setSelectBox(sender)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            self.skillNum = self.skillNum - 1
            self:setPartnerSkillCost()
            --self:checkboxEnable()
        end
    end 

    d.checkbox:addEventListenerCheckBox(selectedEvent)
    table.insert(self.boxlist,d.checkbox)
    if self.lock[i] > 0 then
        self.skillNum = self.skillNum + 1
        table.foreach(self.boxlist,function(k,v)
            if(d.checkbox == v) then
                v:setSelectedState(true)
            end
        end)
    end
end

function ParnertSkill:refreshPartnerSkill()
    local function onGetPartnerskill(params)
        if params[1] == 1 then
            PartnerUI.curPartner.skill = params[2]
            MessageManager:showMessageNode(self.ui.btn_refresh, string.format("钻石-%d", math.floor(math.sqrt(User.partnerskill-3))* 10 *(1+self.skillNum)), cc.c3b(255,255,0))
            User.partnerskill = User.partnerskill + 1
            GameUI:loadUinfo()
            self:onShow()
        else
            MessageManager:show(params[2])
        end
    end
    self:getLockSkill()
    sendCommand("getPartnerskill",onGetPartnerskill,{PartnerUI.curPartner.partnerid, self.lock})
end

function ParnertSkill:getLockSkill()
    self.lock = {0,0,0,0}
    local n = self:getSkillNum()
    local sn = table.getn(self.skills)
    for i=1, math.min(4, n, sn) do
        local custom_item = self.skilllist:getItem(i-1)
        local d = ui_delegate(custom_item)
        if(d.checkbox:getSelectedState() == true) then
            self.lock[i] = toint(self.skills[i])
        else
            self.lock[i] = 0
        end       
    end
end

--
function ParnertSkill:checkboxEnable()
    table.foreach(self.boxlist, function(k,v)
        --v:setEnabled(true)     
        v:setTouchEnabled(true)
        v:setBright(true) 
    end)
end

--
function ParnertSkill:checkboxDisable()
    table.foreach(self.boxlist, function(k,v)
        if(v:getSelectedState() == false) then
            --v:setEnabled(false)            
            v:setTouchEnabled(false)
            v:setBright(false) 
        end
    end)
end


function ParnertSkill:onShow()
    self:initParnterSkillView()
    self:setPartnerSkillCost()
end

--初始化佣兵技能界面
function ParnertSkill:initParnterSkillView()
    self.skills = string.split(PartnerUI.curPartner.skill, ",")
    self.skilllist:removeAllItems()
    self.boxlist = {}
    self.skillNum = 0
    local n = self:getSkillNum()

    for i=1, n do
        if(self.skills[i] ~= nil and self.skills[i] ~= "") then
            local skill_item = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item_partner.json"))
            self.skilllist:pushBackCustomItem(skill_item.nativeUI)
            local data = ConfigData.cfg_skill[toint(self.skills[i])]
            self:setItemInfo(skill_item, data, i)
        else
            local skill_item_empty = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item_empty.json"))
            self.skilllist:pushBackCustomItem(skill_item_empty.nativeUI)
            skill_item_empty.img_lock:setVisible(false)
            skill_item_empty.txt_info:setString("已开启,可刷新技能获得新技能")
        end
    end

    if(n < 4)then
        for i = n+1, 4 do
            local skill_item_empty = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item_empty.json"))
            self.skilllist:pushBackCustomItem(skill_item_empty.nativeUI)
            local lvt = {
                [1] = 5,
                [2] = 15,
                [3] = 25,
                [4] = 35
            }
            skill_item_empty.txt_info:setString( string.format("人物等级%d级开启", lvt[i]) )
            skill_item_empty.txt_info:setColor( cc.c3b(69,183,212) )
        end
    end
end

function ParnertSkill:setPartnerSkillCost()
    if User.partnerskill > 3 then
        self.ui.lbl_number:setString(string.format("本次刷新技能消耗：%s钻石",math.floor(math.sqrt(User.partnerskill-3))*10*(1+self.skillNum)))
    else
        self.ui.lbl_number:setString(string.format("本次刷新技能消耗：免费"))
    end
end

--相应人物等级的技能个数
function ParnertSkill:getSkillNum()
    local n = 0
    if(User.ulv>=35) then
        n = 4
    elseif User.ulv>=25 then
        n = 3
    elseif User.ulv>=15 then
        n = 2
    elseif User.ulv>=5 then
        n = 1
    end
    return n
end

function ParnertSkill:close()
    PartnerUI:refreshView()
    DialogManager:closeDialog(self)
end

return ParnertSkill