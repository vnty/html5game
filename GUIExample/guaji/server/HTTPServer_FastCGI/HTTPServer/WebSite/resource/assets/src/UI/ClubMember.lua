ClubMember = {
    myclub = nil,
    sysclub = nil, 
    time = 0,
    temphp = 0
}

function ClubMember:create()
    local frameSize = cc.Director:getInstance():getWinSize()
    self.ui = ui_delegate(ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/club-member.json"))
    --自适应界面
    self.ui.Image_12:setContentSize(640,215+(frameSize.height-960)/2)
    self.ui.Image_44:setPosition(cc.p(frameSize.width/2,(frameSize.height-960)/2+140))
    self.ui.pnl_note:setContentSize(555,80+(frameSize.height-960)/3)
    self.ui.pnl_note:setPosition(cc.p(43,(frameSize.height-960)/8+22))
    self.ui.lbl_note:setContentSize(535,70+(frameSize.height-960)/3)
    self.ui.lbl_note:setPosition(cc.p(10,(frameSize.height-960)/8+30))
    self.ui.Image_12_0:setContentSize(640,655+(frameSize.height-960)/2)
    self.ui.Panel_28:setPosition(cc.p(30,(frameSize.height-960)/4+170))
--    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-item.json")
--    self.item_module:retain()
--
--    self.ui.item_list:setDirection(ccui.ScrollViewDir.vertical)

    ui_add_click_listener(self.ui.btn_openboss, function()
--        if tonum(self.myclub.state) < 100 then
--            MessageManager:show("请等待会长或副会长开启魔兽入侵战")
--            return
--        end
        local message = ""
        if tonum(self.sysclub.freeboss) > 0 then
            message = "免费"
        else
            message = "需要"..(tonum(self.sysclub.buyboss + 1)*tonum(self.sysclub.buyboss)*50 + 100).."钻石"
        end
        AlertManager:yesno("开启BOSS", RTE("每周有两次免费开启魔兽入侵的机会,本次开启魔兽入侵"..message..",是否开启?(剩余免费次数"..self.sysclub.freeboss.."次)", 25, cc.c3b(255,255,255)), function()
            self:openBoss()
        end)
    end)

    ui_add_click_listener(self.ui.btn_joinboss, function()
        self:joinBoss()
    end)
    
    ui_add_click_listener(self.ui.btn_view,function()
        self:viewBoss()
    end)
    
    -- 下面的按钮
    ui_add_click_listener(self.ui.btn_member, function()
        self:viewMember()
    end)

--    ui_add_click_listener(self.ui.btn_manage, function()
--        self:manageClub()
--    end)

    ui_add_click_listener(self.ui.btn_bossin,function()
        self:viewBoss()
    end)
    
    ui_add_click_listener(self.ui.btn_shop,function()
        self:clubShop()
    end)
    
    ui_add_click_listener(self.ui.btn_help,function()
        DialogManager:showDialog("HelpDialog", HelpText:helpClub())
    end)
    
    ui_add_click_listener(self.ui.btn_sign,function()
        local function callback(params)
            if params[1] == 1 then
                local message={}
                table.insert(message, {message="签到成功!", color=cc.c3b(0,255,0)})
                table.insert(message, {message="你获得: 公会贡献*"..params[2], color=cc.c3b(0,255,0)})
                table.insert(message, {message="你获得: 金币*"..params[4], color=cc.c3b(0,255,0)})
                table.insert(message, {message=" ", color=cc.c3b(0,255,0)})
                if tonum(params[3]) > 0 then
                    table.insert(message, {message="公会获得: 经验*"..params[3], color=cc.c3b(0,255,0)})
                end
                MessageManager:showMessageDelay(message, 0.1)
                self:reloadInfo(function()
                    GameUI:addUserCoin(tonum(params[2]))
                    self:refreshUI()
                end)
            else
                MessageManager:show(params[2])
            end
        end
        sendCommand("checkinClub",callback,{self.sysclub.cid})
    end)
    
    ui_add_click_listener(self.ui.btn_rank,function()
        local function callback(params)
            if params[1] == 1 then
                DialogManager:showDialog("ClubRank", params[2])
            else
                MessageManager:show(params[2])
            end
        end
        sendCommand("getClubRank",callback,{self.sysclub.cid})
    end)
    
    ui_add_click_listener(self.ui.btn_addatk,function()
        if tonum(self.myclub.buff) >= 10 then
            MessageManager:show("鼓舞次数达到上限")
            
            return
        end
        local function onOK()
            local function callback(params)
                if params[1] == 1 then
                    self.myclub.buff = tonum(params[2])
                    GameUI:addUserUg(-tonum(params[3]))
                    self:refreshUI()
                else
                    MessageManager:show(params[2])
                end
            end
            sendCommand("encourageAtk",callback, {self.sysclub.cid})
        end
        AlertManager:yesno("鼓舞",RTE("鼓舞一次需消耗20钻,是否继续?", 25, cc.c3b(255,255,255)), onOK)
    end)
    
    -- 公会战相关
    ui_add_click_listener(self.ui.btn_cvc,function()
        local function callback(params)
--            dump(params)
            if params[1] == 0 or params[1] == 1 then
                MessageManager:show(params[2])
            end
                DialogManager:showDialog("ClubView",params[1],params[2],params[3])
        end
        sendCommand("getCvcInfo",callback,{self.sysclub.cid})
    end)

    -- 公会战相关
    ui_add_click_listener(self.ui.btn_cvc2,function()
        local function callback(params)
            --            dump(params)
            if params[1] == 0 or params[1] == 1 then
                MessageManager:show(params[2])
            end
            DialogManager:showDialog("ClubView",params[1],params[2],params[3])
        end
        sendCommand("getCvcInfo",callback,{self.sysclub.cid})
    end)
    
--    ui_add_click_listener(self.ui.btn_cvclist,function()
--        local function callback(params)
--            if params[1] == 1 then
--                DialogManager:showDialog("ClubView",params[2],1)
--            else
--                MessageManager:show(params[2])
--            end
--        end
--        sendCommand("getCvcList",callback, {self.sysclub.cid})
--    end)
--    
--    ui_add_click_listener(self.ui.btn_cvcmy,function()
--        local function callback(params)
--            if params[1] == 1 then
--                DialogManager:showDialog("ClubView",params[2],2)
--            else
--                MessageManager:show(params[2])
--            end
--        end
--        sendCommand("getClubCvc",callback, {self.sysclub.cid})
--    end)
    
    Scheduler.scheduleNode(self.ui.nativeUI, function()
        local time = UICommon.timeFormatNumber( toint(self.time) )
        self.ui.text_time:setString(time)
        if(self.time > 0) then
            self.time = self.time - 1
            if (self.time+10)%300 == 0 or self.time <= 0 then
                self:reloadInfo(function()
                    self:refreshUI()
                end)
            end
        end
    end ,1)
    
    return self.ui
end

function ClubMember:onShow()
    self:refreshUI()
end

function ClubMember:viewBoss()
--    if tonum(self.sysclub.bosshp) == 0 then
--        MessageManager:show("请等待会或副会长长开启魔兽入侵战")
--        return
--    end
    local callback = function(params)
        if params[1] == 1 then
            DialogManager:showDialog("ClubBoss", params[2])
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getClubMember", callback, {self.sysclub.cid})
end

function ClubMember:manageClub()
    DialogManager:showDialog("ClubManage")
end

function ClubMember:clubShop()
    local numbers = {}
    local function callback(params)
        if params[1] == 1 then
            self.myclub = params[2]
            self.sysclub = params[3]
            for i=1, 6 do
                table.insert(numbers,tonum(self.sysclub["itemleft"..i]))
            end
    
            DialogManager:showDialog("ClubShop", self.myclub.cid, self.myclub.score, numbers)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getMyClub", callback, {User.zhanli})

end

function ClubMember:viewMember()
    local callback = function(params)
        if params[1] == 1 then
            DialogManager:showDialog("ClubMemberView", params[2], 1)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getClubMember", callback, {self.sysclub.cid})
end

function ClubMember:openBoss()
    -- 开启BOSS战
    local function callback(params)
        if params[1] == 1 then
            self.sysclub = params[2]
            GameUI:addUserUg(-tonum(self.sysclub.buyboss)*tonum(self.sysclub.buyboss)*50 + 50)
            self:refreshUI()
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("openBoss", callback, {self.sysclub.cid})
end

function ClubMember:joinBoss()
    -- 打BOSS
    local function callback(params)
        if params[1] == 1 then
            self.myclub = params[2]
            self.sysclub.bosstemphp = tonum(self.sysclub.bosstemphp) - tonum(self.myclub.tempscore)
            self:reloadInfo(function()
                self:refreshUI()
            end)
        else
            --            MessageManager:show(params[2])
            MessageManager:show(params[2])
        end
    end
    sendCommand("joinBoss", callback, {self.sysclub.cid})
end

function ClubMember:refreshUI()
    -- 刷新公会信息
    self.ui.pnl_openboss:setVisible(false)
    self.ui.pnl_joinboss:setVisible(false)
    self.ui.pnl_view:setVisible(false)
    self.ui.img_unsign:setVisible(toint(self.myclub.signleft) < 0)
    if self.sysclub ~= nil then
        self.ui.lbl_name:setString(self.sysclub.cname)
        self.ui.lbl_id:setString("公会ID:"..self.sysclub.cid)
--        local x = self.ui.lbl_name:getPositionX() + self.ui.lbl_name:getRealSize().width
--        local y = self.ui.lbl_name:getPositionY()
--        self.ui.lbl_id:setPosition(cc.p(x,y))
        self.ui.lbl_lv:setString("Lv."..self.sysclub.clv)
        self.ui.lbl_count:setString("人数 : "..self.sysclub.count.."/"..self.sysclub.maxcount)
        self.ui.lbl_score:setString("经验 : "..self.sysclub.exp.."/"..ConfigData.cfg_club_lv[toint(self.sysclub.clv)])
        self.ui.lbl_note:setString("公告: "..self.sysclub.note)
        self.ui.lbl_boss:setString("Lv."..self.sysclub.bosslv.." 魔兽")
        self.ui.lbl_bossexp:setString("魔兽经验(贡献): "..(math.floor(toint(self.sysclub.bosslv)*toint(self.sysclub.bosslv)*0.004+4)*100))
        -- 公会经验条
        if toint(self.sysclub.clv)<10 then
            self.ui.expbar:setPercent(tonum(100*tonum(self.sysclub.exp)/ConfigData.cfg_club_lv[toint(self.sysclub.clv)]))
        else
            self.ui.expbar:setPercent(100)
        end
        -- boss 时间 刷新boss血条
--        self.ui.lbl_hp:setString("血量: "..self.sysclub.bosstemphp.."/"..self.sysclub.bosshp)
        self.ui.bar_bosshp:setPercent(toint(self.sysclub.bosstemphp*100/self.sysclub.bosshp))
        self.time = tonum(self.sysclub.bossleft)
        local damage = 0
        if self.temphp == 0 then
            self.temphp = tonum(self.sysclub.bosstemphp)
        else
            damage = self.temphp - tonum(self.sysclub.bosstemphp)
            self.temphp = tonum(self.sysclub.bosstemphp)
        end
        if tonum(self.sysclub.bosshp) == 0 then
            -- 未开启BOSS
            self.ui.text_time:setVisible(false)
            self.ui.pnl_openboss:setVisible(true)
        elseif tonum(self.myclub.bossts) == 0 then
            -- 开启BOSS, 未加入
            self.ui.text_time:setVisible(true)
            self.ui.pnl_joinboss:setVisible(true)
        else
            -- 开启BOSS,已加入
            self.ui.text_time:setVisible(true)
            self.ui.pnl_view:setVisible(true)
            -- 飘一下boss血量减少的字
            if damage > 0 then
                ClubMember:showDamageTips(self.ui.bar_bosshp, damage)
            end
            -- 下面鼓舞的字
            local rtes = {}
            table.insert(rtes, RTE("本次鼓舞+20%,消耗20钻\n",20,cc.c3b(0,204,255)) )
            table.insert(rtes, RTE("我的鼓舞加成:",20, cc.c3b(255,255,255)) )
            table.insert(rtes, RTE("攻击+"..(20*self.myclub.buff).."%\n",20, cc.c3b(255,0,255)) )
            self.ui.pnl_addatk:removeAllChildren()
            UICommon.createRichText(self.ui.pnl_addatk, rtes )
        end
    end
end

function ClubMember:reloadInfo(callback)
    local callback = function(params)
        if params[1] == 1 then
            -- 有公会
            ClubMember.myclub = params[2]
            ClubMember.sysclub = params[3]
            if callback ~= nil then
                callback()
            end
        elseif params[1] == 2 then
            -- 没公会
            ClubUI.clubs = params[2]
            ClubMember.myclub = nil
            ClubMember.sysclub = nil
            GameUI:switchTo("clubUI")
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getMyClub", callback, {User.zhanli})
end

-- 飘一下减少的血量
function ClubMember:showDamageTips(hpbar, damage)
    local tip
    tip = cc.LabelBMFont:create("-" .. damage, "res/ui/bmtfont.proj/battlered.fnt")        

    if tip ~= nil then
        hpbar:addChild(tip,10,10)
        tip:setAnchorPoint(1,0)
        tip:setPosition(480,40)
        
        local actionBy = cc.MoveBy:create(1, cc.p(0, 50))
        local delay = cc.DelayTime:create(0.5)
        local sequence = cc.Sequence:create(actionBy, delay,cc.FadeOut:create(0.5), cc.CallFunc:create(function()
            tip:removeFromParent()
        end))
        tip:runAction(sequence)
    end
end

return ClubMember