local SkillPvp = {
    ui = nil,
    skilllist = nil,
    currentId = 0,
    lastUlv = 0,
    maxIndex=0,
    pvpskill = {}
}

function SkillPvp:create()
    local frameSize = cc.Director:getInstance():getWinSize()
    self.ui = ui_delegate(ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/skill_pvp.json"))

    self.skilllist = self.ui.list_skill
    self.skilllist:setItemsMargin(8)
    self.skilllist:setTouchEnabled(true)
    self.skilllist:setBounceEnabled(true)

    local function pvpListEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.onsSelectedItem then
            local i = sender:getCurSelectedIndex()
            self.currentId = i+1;
            if(i>=self.maxIndex and i<self:getSkillNum()) then
                DialogManager:showSubDialog(self,"SkillSelect","pvp",self)
            end
        end
    end

    self.skilllist:addEventListener(pvpListEvent)

    ui_add_click_listener( self.ui.btn_change,function()
        DialogManager:showSubDialog(self,"SkillSelect","pvp",self)
    end)

    ui_add_click_listener( self.ui.btn_close,function()
        self:close()
    end)
    
    ui_add_click_listener( self.ui.btn_default,function()
        local function callback(params)
            if params[1] == 1 then
                User.userPvpSkill = {}
                MessageManager:show("设置成功!")
                self:initCurrentSkillView()
            else
                MessageManager:show(params[2])
            end
        end
        sendCommand("setPvpSkill",callback,{'0'})
    end)
    
    return self.ui
end

function SkillPvp:onShow()
    self:initCurrentSkillView()
end

function SkillPvp:initCurrentSkillView()
    self.skilllist:removeAllItems()
    local n = self:getSkillNum()
    if tonum(User.userPvpSkill[1]) == 0 then
        -- object 记得要clone
        self.pvpskill = clone(User.userSkill)
    else
        self.pvpskill = clone(User.userPvpSkill)
    end
    for i=1,n do
        if self.pvpskill[i] ~= nil then
            local skill_item = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item.json"))
            self.skilllist:pushBackCustomItem(skill_item.nativeUI)
            local data = ConfigData.cfg_skill[toint(self.pvpskill[i])]
            self:setItemInfo(skill_item,data,i)
            self.maxIndex=i
        else
            local skill_item_empty = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item_empty.json"))
            self.skilllist:pushBackCustomItem(skill_item_empty.nativeUI)
            skill_item_empty.img_lock:setVisible(false)
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

function SkillPvp:setItemInfo(d,v,i)
    local x = d.checkbox:getPositionX()
    local y = d.checkbox:getPositionY()
    d.checkbox:removeFromParent()

    if v ~= nil then
        d.txt_name:setString(v.sname)
        d.txt_info:setString(v.tips)
    else
        d.txt_name:setString("没有装备技能");
        d.txt_info:setString("无")
        return
    end

    d.txt_mp:setString( string.format("消耗MP：%d", v.mp) )
    d.lbm_order:setString(i)
    d.img_skill:loadTexture( string.format("res/skill/%d.png", v.sid))
    d.img_lock:setVisible(false)

    if i ~= 1 then
        d.btn_order:loadTextureNormal("res/ui/button/btn_117.png")
        ui_add_click_listener( d.btn_order,function()
            -- 这里要延后执行，因为switchSkill中会把item清掉导致事件返回时出现问题
            Scheduler.performWithDelayGlobal(function()
                self:switchSkill(v.sid,-1)
            end,0.1)
        end)
    end   
end

function SkillPvp:switchSkill(sid,direction)-- [-1 up] [1 down]
    local position = self:getSkillPosition(sid)
    if(position == nil) then
        return
    end

    local newPosition = position + direction
    local newSid = User.userPvpSkill[newPosition]
    if(newSid ~= nil) then
        User.userPvpSkill[position] = newSid
        User.userPvpSkill[newPosition] = sid
        self:initCurrentSkillView()
        self:sendEquipSkill()
    end
end

function SkillPvp:getSkillPosition(sid)
    local result = nil
    table.foreach(User.userPvpSkill,function(k,v)
        if(toint(v) == toint(sid)) then
            result = toint(k)
        end
    end)
    return result
end

function SkillPvp:sendEquipSkill()
    local function onSetSkill(params)
        if params[1] == 1 then
            local skill = string.split(params[2],",");
            local n = 1
            User.userPvpSkill={}
            table.foreach(skill,function(k,v)
                if(tonum(v) > 0) then
                    User.userPvpSkill[toint(n)] = toint(v);
                    n = n + 1
                end
            end)
        else
            User.userPvpSkill={}
            SkillPvp:initCurrentSkillView()
            MessageManager:show(params[2])
        end
    end

    --发送装备技能的请求

    self.maxIndex=0
    local str_skill = "";
    table.foreach(User.userPvpSkill,function(k,v)
        cclog(k.."  "..v)
        str_skill = str_skill..v..","
        self.maxIndex=k
    end)
    str_skill = string.sub(str_skill, 1, -2)

    sendCommand("setPvpSkill", onSetSkill,{str_skill})
end

function SkillPvp:getSkillNum()
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

function SkillPvp:close()
    DialogManager:closeDialog(self)
end

return SkillPvp