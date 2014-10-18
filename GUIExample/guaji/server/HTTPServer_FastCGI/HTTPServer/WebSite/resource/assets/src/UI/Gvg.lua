GvgUI = {
    ui = nil,
    myTeam = nil,
    myMembers = nil,
    ret = 0,
    time = 0
}

function GvgUI:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/gvg.json")
    local frameSize = cc.Director:getInstance():getWinSize()
    
    self.ui = ui_delegate(nativeUI)

    self.ui.Image_14:setContentSize(640,230+(frameSize.height-960)/2)
    self.ui.Panel_5_0_0_1:setContentSize(640,720+(frameSize.height-960)/2)
    self.ui.Image_17:setPosition(cc.p(320,200+(frameSize.height-960)/6))
    self.ui.Image_16:setPosition(cc.p(358,84+(frameSize.height-960)/6))
    self.ui.Image_15:setPosition(cc.p(84,71+(frameSize.height-960)/3))
    self.ui.Image_20:setPosition(cc.p(320,453+(frameSize.height-960)/2))
    --self.ui.Image_19:setPosition(cc.p(320,100))
    
    self.ui.Panel_nojoinin:setVisible(false)
    self.ui.Panel_players:setVisible(false)
    self.ui.Panel_joinin:setVisible(false)
    self.ui.Panel_cancel:setVisible(false)
    self.ui.Panel_leader:setVisible(false)
    
    ui_add_click_listener(self.ui.btn_joinin, function()
        if self.time <= 0 then
            MessageManager:show("正在比赛中,请稍后...")
            return
        end
        if(self.ret == 0) then
            return 
        end
        GvgUI:joinGvg()
    end)
    
    ui_add_click_listener(self.ui.btn_cancel, function()
        if self.time <= 0 then
            MessageManager:show("正在比赛中,请稍后...")
            return
        end
        if(self.ret == 0) then
            return 
        end
        GvgUI:cancelJoinGvg()
    end)
    
    ui_add_click_listener(self.ui.btn_build, function()
        if self.time <= 0 then
            MessageManager:show("正在比赛中,请稍后...")
            return
        end
        if(self.ret == 0) then
            return 
        end
        local onOK = function()
            GvgUI:createGvgTeam()
        end
        AlertManager:yesno("创建队伍",RTE("创建队伍需要50钻,是否继续?",25,cc.c3b(255,255,255)),onOK)
    end)
    
    ui_add_click_listener(self.ui.btn_manage, function()
        if self.time <= 0 then
            MessageManager:show("正在比赛中,请稍后...")
            return
        end
        if(self.ret == 0) then
            return 
        end
        GvgUI:viewMyTeam()
    end)
    
    ui_add_click_listener(self.ui.btn_check, function()
        if self.time <= 0 then
            MessageManager:show("正在比赛中,请稍后...")
            return
        end
        if(self.ret == 0) then
            return 
        end
        GvgUI:viewMyTeam()
    end)
    
    ui_add_click_listener(self.ui.btn_help, function()
        DialogManager:showDialog("HelpDialog", HelpText:helpGvg())
    end)
--    ui_add_click_listener(self.ui.btn_close, function()
--        self:close()
--    end)
    
    self.ui.Label_29:setString("队长奖励: 宝石袋, 海量金币")
    self.ui.Label_30:setString("队员奖励: 大量金币")
    
--    local time = UICommon.timeFormatNumber( toint(self.time) )
--    self.ui.txt_time:setString(time)
    
    Scheduler.scheduleNode(self.ui.nativeUI, function()
        local time = UICommon.timeFormatNumber( toint(self.time) )
        self.ui.txt_time:setString(time)
        if(self.time >= 0) then
            self.time = self.time - 1
        end
    end ,1)
    
    return self.ui
end

function GvgUI:onShow()
    self:getMyTeam()
end

function GvgUI:joinGvg()
    if toint(User.zhanli) < 1500 then
        MessageManager:show("战力1500以上可以加入队伍")
        return
    end
    local callback = function(params)
        if(params[1] == 1) then
            self.ret = 2
            self:refreshUI()
            MessageManager:show("加入成功")
        else
            MessageManager:show(params[2])
        end
    end
    
    sendCommand("joinGvg",callback)
end

function GvgUI:cancelJoinGvg()
    local callback = function(params)
        if(params[1] == 1) then
            self.ret = 3
            self.myMembers = nil
            self.myTeam = nil
            self:refreshUI()
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("cancelGvg", callback)
end

function GvgUI:createGvgTeam()
    if toint(User.zhanli) < 1500 then
        MessageManager:show("战力1500以上可以创建队伍")
        return
    end
    local callback = function(params)
        if(params[1] == 1) then
            self.ret = 1
            self.myMembers = params[2] 
            self.myTeam =params[3]
            self:refreshUI()
            User.ug = User.ug - 50
            MainUI:refreshUinfoDisplay()
        else
            self.ret = 0
            MessageManager:show(params[2])
        end 
    end
    
    sendCommand("createGvg",callback)
end


function GvgUI:getMyTeam(type)
    local callback = function(params)
        self.ret = tonum(params[1])
        if(params[1] == 0) then
            MessageManager:show(params[2])
            self.ui.lbl_gameNum:setVisible(true)
            self.ui.txt_time:setVisible(false)
            self.ui.lbl_gameNum:setString(params[2])
            self.ui.lbl_time:setString("正在团战中")
        elseif(params[1] == 1 or params[1] == 4) then
            self.ui.lbl_gameNum:setVisible(false)
            self.ui.txt_time:setVisible(true)
            self.ui.lbl_time:setString("即将进行下一场战斗")
            self.myMembers = params[2] 
            self.myTeam =params[3]
            self.time = tonum(params[4])
        else
            self.ui.lbl_gameNum:setVisible(false)
            self.ui.txt_time:setVisible(true)
            self.ui.lbl_time:setString("即将进行下一场战斗")
            self.myMembers = nil
            self.myTeam = nil
            self.time = tonum(params[2])
        end
        if tonum(params[3]) > 2 then
            local c1 = ConfigData.cfg_item[tonum(params[3])]
            local c2 = ConfigData.cfg_item[tonum(params[3])-2]
            if c1 ~= nil and c2 ~= nil then
                self.ui.Label_29:setString(string.format("队长奖励: 宝石袋, 海量金币     冠军队长:%s",c1.name))
                self.ui.Label_30:setString(string.format("队员奖励: 大量金币             冠军队员:%s",c2.name))
            end
        end
        if(type == nil or type ~= tonum(params[1])) then
            self:refreshUI()
        end
    end
    
    sendCommand("getMygvg", callback)
end

function GvgUI:viewMyTeam()
    GameUI:switchTo("gvgDetail")
end

--function GvgUI:manageTeam()
--    GameUI:switchTo("gvgDetail")
--end

function GvgUI:refreshUI()
    self.ui.Panel_nojoinin:setVisible(false)
    self.ui.Panel_players:setVisible(false)
    self.ui.Panel_joinin:setVisible(false)
    self.ui.Panel_cancel:setVisible(false)
    self.ui.Panel_leader:setVisible(false)
    if(self.ret == 1) then
        -- 队长
        self.ui.Panel_leader:setVisible(true)
    elseif(self.ret == 2) then
        -- 池子中,非队员
        self.ui.Panel_cancel:setVisible(true)
    elseif(self.ret == 3) then
        -- 未报名
        self.ui.Panel_joinin:setVisible(true)
    elseif(self.ret == 4) then
        -- 别人的队员
        self.ui.Panel_players:setVisible(true)
    end
end

return GvgUI
