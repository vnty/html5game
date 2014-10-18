local cmd = require("src/Command")
local User = require("src/User")
local frameSize = cc.Director:getInstance():getWinSize()
local first_hp = 0
local pos = nil
local sname = ""
BattleUI = {}

function BattleUI.init()

    BattleUI.ui = nil
    BattleUI.nativeUI = nil

    BattleUI.battleState = ""   -- 当前战斗状态， ""表示未开始战斗 rest req playing

    BattleUI.BattleData = nil
    BattleUI.BattleLog = {}
    BattleUI.turnCount = 0
    BattleUI.battleMaxTime = 0 -- 本次战斗最长时间 
    BattleUI.mpCostTurn = {0,0}    -- 玩家释放技能耗蓝回合
    BattleUI.playCount = 0

    BattleUI.roleListNew = {}

    BattleUI.richtext = nil
    BattleUI.richtextlist = {}

    BattleUI.ui_player = nil
    BattleUI.ui_hire = nil
    BattleUI.ui_enemy1 = nil
    BattleUI.ui_enemy2 = nil
    BattleUI.ui_enemy3 = nil

    BattleUI.nextBattle = nil
    BattleUI.nextBattleCount = 0

    BattleUI.nextUserBattle = nil  -- 正在等待的战斗

    BattleUI.battleStatisticsUI = nil
    BattleUI.battleStatisticsData = nil

    -- 定时器
    BattleUI.battleTimer = nil
    BattleUI.waitCount = 0
    BattleUI.waitRichText = nil

    -- 是否滚屏
    BattleUI.adjustRichTextFlag = true

    -- 是否聊天模式
    BattleUI.inChatMode = false
    BattleUI.chatUI = nil

    -- 点击显示战斗提示
    BattleUI.onShowBattleTips = nil
end

BattleUI.init()

function BattleUI:create()

    self.nativeUI = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/battle.json")
    cclog("battle...")
    self.ui = ui_delegate(self.nativeUI)
    self.ui.Image_16:setContentSize(640,frameSize.height -370)
    self.ui.lbl_map:setPosition(cc.p(frameSize.width/2,frameSize.height-400))
    self.ui.chat_log:setContentSize(580,frameSize.height-605)
    self.ui.battle_log:setContentSize(580,frameSize.height-540)
    self.ui.club_chat_log:setContentSize(580,frameSize.height-605)
    self.ui.pnl_chat:setContentSize(580,frameSize.height-605)

    self.ui_player = ui_delegate(self.ui.pnl_player)
    self.ui_hire   = ui_delegate(self.ui.pnl_hire)
    self.ui_enemy1 = ui_delegate(self.ui.pnl_enemy1)
    self.ui_enemy2 = ui_delegate(self.ui.pnl_enemy2)
    self.ui_enemy3 = ui_delegate(self.ui.pnl_enemy3)

    self.ui_player.nativeUI:setVisible(false)
    self.ui_hire.nativeUI:setVisible(false)
    self.ui_enemy1.nativeUI:setVisible(false)
    self.ui_enemy2.nativeUI:setVisible(false)
    self.ui_enemy3.nativeUI:setVisible(false)
    self.ui.img_new_chat:setVisible(false)

    self.ui.lbl_time:setVisible(false)
    self.ui.img_type:setVisible(false)
    self.ui.img_VS:setVisible(true)

    --    self.ui.Image_20:loadTexture("res/ui/images/img_131.png")
    --    self.ui.Image_20:setVisible(false)

    self.ui.btn_tips:setVisible(false)
    self.ui.img_stat:loadTexture("res/ui/images/img_193.png")
    ui_add_click_listener(self.ui.btn_tips, function()
        self.onShowBattleTips()
    end)

    -- 初始化聊天
    local chatUIClass = require("src/UI/Chat")
    self.chatUI = chatUIClass.new()
    self.chatUI:init()

    self:switchChatMode(self.inChatMode)

    -- 战斗设置
    ui_add_click_listener(self.ui.button_battleSet, function()
        DialogManager:showDialog("BattleSet")
    end)

    -- 聊天设置
    ui_add_click_listener(self.ui.button_chat_setup, function()
        DialogManager:showDialog("BattleSet")
    end)


    -- 世界地图
    ui_add_click_listener(self.ui.button_changemap, function()
        GameUI:switchTo("mapUI")
        local type = "map"
        if BattleUI:checkGuideIcon(type) then
            BattleUI:removeGuideIcon(type)
            User.showGuide(type)
        end
    end)

    -- 快速战斗
    ui_add_click_listener(self.ui.button_quick_battle, function()
        local type = "quickbattle"
        if BattleUI:checkGuideIcon(type) then
            BattleUI:removeGuideIcon(type)
        end
        BattleUI:quickBattle()
    end)

    ui_add_click_listener(self.ui.btn_chat, function()
        self.inChatMode = not self.inChatMode
        self:switchChatMode(self.inChatMode)
    end)  

    -- 按住日志，暂停滚屏
    self.ui.battle_log:addTouchEventListener(
        function(sender,eventType)
            if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
                self.adjustRichTextFlag = true
            elseif eventType == ccui.TouchEventType.began then
                self.adjustRichTextFlag = false      
            end
        end
    )

    ui_add_click_listener(self.ui.btn_battle_statistics, function()
        if(self.battleStatisticsUI == nil )then
            local bs = require("src/UI/BattleStatistics")
            self.battleStatisticsUI = bs:create()
            self.ui.nativeUI:addChild(self.battleStatisticsUI.ui.nativeUI)
            -- 第一次打开设置一次
            if(self.battleStatisticsData ~= nil)then
                self.battleStatisticsUI:setBattleStaticData(self.battleStatisticsData)
            end
            return
        else
            local v = self.battleStatisticsUI.ui.nativeUI:isVisible()
            self.battleStatisticsUI.ui.nativeUI:setVisible(not v)
            self.battleStatisticsUI.ui.nativeUI:setTouchEnabled(not v)
        end
    end)

    self.ui.lbl_state:setVisible(false)
    self.ui.lbl_state:enableOutline(cc.c4b(0,0,0,255),2)  

    -- 启动战斗
    self.battleState = ""

    -- 在登陆奖励关闭以后启动战斗请求
    -- self:startNextBattle()

    -- 战斗定时器，每秒一次，用于播放战斗或战斗倒计时
    self.battleTimer = Scheduler.scheduleGlobal(function()
        xpcall( function()
            self:onBattleTimer()            
        end, function(msg)
            __G__TRACKBACK__(msg,false)
            self:doRestAndFight(30, "战斗发生了一些错误， 休息一下继续..." )    
        end )
    end ,1)

    return self.ui
end

function BattleUI:switchChatMode(isChatMode)
    if not isChatMode then
        -- 切换到战斗模式
        self.ui.battle_log:setVisible(true)

        UICommon.setVisible(self.ui.button_quick_battle,true)
        UICommon.setVisible(self.ui.button_changemap,true)
        UICommon.setVisible(self.ui.button_battleSet,true)

        self.ui.btn_chat:setTitleText("聊天频道")

        self.chatUI:exitChat()

        self:changeMap(Map.mapid)
    else
        -- 切换到聊天模式
        self.ui.battle_log:setVisible(false)
        self.ui.img_new_chat:setVisible(false)

        UICommon.setVisible(self.ui.button_quick_battle, false)
        UICommon.setVisible(self.ui.button_changemap,false)
        UICommon.setVisible(self.ui.button_battleSet,false)            

        self.ui.btn_chat:setTitleText("战斗日志")

        self.chatUI:enterChat()
    end
end

function BattleUI:showNewChatMessage()
    if(not self.inChatMode)then
        self.ui.img_new_chat:setVisible(true)
    end
end

-- 飘一下减少的血量
function BattleUI:showDamageTips(hpbar, damage, type)
    local tip
    --local tip = cc.LabelTTF:create("-"..damage, Config.font, 30)

    if(type == 2)then
        -- 暴击
        tip = cc.LabelBMFont:create("-" .. damage, "res/ui/bmtfont.proj/battleyellow.fnt")        
    elseif(type==4) then
        -- 恢复生命
        tip = cc.LabelBMFont:create("+" .. damage, "res/ui/bmtfont.proj/battlegreen.fnt")
    elseif(type==7) then
        -- 恢复魔法
        tip = cc.LabelBMFont:create("+" .. damage, "res/ui/bmtfont.proj/battleblue.fnt")
    elseif(type==17) then
        -- 恢复魔法
        tip = cc.LabelBMFont:create("-" .. damage, "res/ui/bmtfont.proj/battleblue.fnt")
    elseif(type == 3) then
        -- MISS
        tip=cc.LabelBMFont:create("MISS", "res/ui/bmtfont.proj/battlered.fnt")        
    else
        -- 普通伤害
        if tonum(damage) > 0 then
            tip = cc.LabelBMFont:create("-" .. damage, "res/ui/bmtfont.proj/battlered.fnt")
        end
    end

    if tip ~= nil then
        hpbar:addChild(tip,10,10)

        local actionBy = cc.MoveBy:create(1, cc.p(0, 50))
        --
        local delay = cc.DelayTime:create(0.5)
        --
        local sequence = cc.Sequence:create(actionBy, delay,cc.FadeOut:create(0.5), cc.CallFunc:create(function()
            tip:removeFromParent()
        end))
        --local action = cc.RepeatForever:create(sequence)
        tip:runAction(sequence)
    end
end

-- 更新人物的HP/MP的显示
function BattleUI:updateRoleUI(role)
    -- 血条进度条动画

    local p = 100.0 * role.hp[2] / role.hp[1]
    --local before_hp = 100.0 * first_hp / role.hp[1]
    --dump(p)

--    local pt = cc.ProgressTo:create(0.7, p)
    --role.Bar_before_hp:setPercent(before_hp)
    role.Bar_before_hp:setVisible(true)
    role.bar_hp:setPercent(p)
    first_hp = p


    local delay = cc.DelayTime:create(0.1)
    local fade = cc.FadeOut:create(0.5)
    local sequence = cc.Sequence:create(delay,fade,cc.CallFunc:create(function()
        role.Bar_before_hp:setVisible(false)
        role.Bar_before_hp:setOpacity(255)
        role.Bar_before_hp:setPercent(p) 
    end))
    role.Bar_before_hp:runAction(sequence)
    role.text_hp:setString(string.format("%d/%d",role.hp[2],role.hp[1]))

    if(role.hp[2]<=0) then
        role.img_dead:setVisible(true)
    else
        role.img_dead:setVisible(false)
    end

    if role.bar_mp ~= nil then
        role.bar_mp:setPercent(100.0*role.mp[2]/role.mp[1])
    end    
end

function BattleUI:onShow()
    self:changeMap(Map.mapid)
end

function BattleUI:startNextBattle()
    cclog("startNextBattle")

    if(self.battleState ~= "")then
        return
    end

    local function onCommandError()
        self:doRestAndFight(30, "网络错误..")
    end

    local bs = require("src/UI/Dialog/BattleSet")

    -- 是否有挑战pvp或者boss
    if(self.nextUserBattle ~= nil)then
        if(self.nextUserBattle.type == "pvp")then
            self.ui.img_VS:loadTexture("res/ui/images/img_131_03.png")
            local c = sendCommand("pvp", function(param) 
                BattleUI:BattleHandler(param)
            end,
            {self.nextUserBattle.uid}, onCommandError, true )

        elseif(self.nextUserBattle.type == "pvb")then
            self.ui.img_VS:loadTexture("res/ui/images/img_131_02.png")
            local c = sendCommand("pvb", function(param)
                BattleUI:BattleHandler(param)
            end,
            { tonum(self.nextUserBattle.mapid),bs.star,bs.job}, onCommandError, true )

        end
        self.nextUserBattle = nil

    else
        local c = sendCommand("pve", function(param)
            BattleUI:BattleHandler(param)
        end,{Map.mapid,bs.star,bs.job}, onCommandError, true );

        self.ui.img_VS:loadTexture("res/ui/images/img_131_01.png")
    end
    self.ui.lbl_state:setVisible(false)
    self.battleState = "req"
end

function BattleUI:onBattleTimer()
    if self.battleState == "req" then
    elseif self.battleState == "rest" then
        BattleUI:onRestAndFightTimer(self.waitCount)
        BattleUI:showFightTime(self.waitCount)
        self.waitCount = self.waitCount - 1
    elseif self.battleState == "playing" then
        BattleUI:onBattleTurnTimer()
    end
end

function BattleUI:doAttack(atkInfo) --@return typeOrObject
    local ret=tonum(atkInfo[1]);
    local defid = tonum(atkInfo[4])
    if(ret==1) then--扣血攻击
        local defender = BattleUI.roleListNew[toint(defid/10)][toint(defid%10)+1]
        local faceImg =defender.img_face
        local ani = faceImg:getChildByTag(9999)
        if(ani == nil) then
            -- 设置神器特效
            local scale=BattleUI:getRoleUIScale(defid)
            ani = UICommon.createAnimation("res/effects/p102.plist", "res/effects/p102.png", "p102_%d.png", 3, 18, cc.p(0.50,0.48), scale,1 )
            ani:setTag(9999)
            faceImg:addChild(ani)
            local s = faceImg:getContentSize()
            ani:setPosition(s.width/2,s.height/2)
        else
            ani:removeFromParent()

        end
    end
end
function BattleUI:getRoleUIByRoleAttid(attid) 
    if(attid==10) then return BattleUI.ui_player
    elseif(attid==11) then return BattleUI.ui_hire
    elseif(attid==20) then return BattleUI.ui_enemy1
    elseif(attid==21) then return BattleUI.ui_enemy2
    elseif(attid==22) then return BattleUI.ui_enemy3 
    else return nil
    end
end
function BattleUI:getRoleUIScale(attid) --@return typeOrObject
    local player_ui=BattleUI:getRoleUIByRoleAttid(attid)
    if(player_ui) then
        return player_ui.nativeUI:getScale()
    end
    return 1;
end
function BattleUI:changeMap(mapid)
    if(self.ui.lbl_map ~= nil)then
        local mname = ConfigData.cfg_map[tonum(mapid)].mname
        self.ui.lbl_map:setString(mname)
    end
end

-- 休息N秒后再战
function BattleUI:doRestAndFight(time, message)

    self.battleState = "rest"
    self.waitCount = time

    self:addRichText()
    local curRichText = self.richtext
    self.waitRichText = curRichText
    curRichText:pushBackElement( RTE(message))
    curRichText:pushBackElement( RTE("("..time..")", 25, cc.c3b(255,128,0)))
    curRichText:formatText() -- 这里必须formatText,否则下一个timer到期的时候removeElement(1)可能出错
    BattleUI:adjustRichText()
end

function BattleUI:onRestAndFightTimer(i)
    -- 这里有个bug尚未找到，就是RemoveElement的时候curRichText已经是无效了
    self.waitRichText:removeElement(1)
    self.waitRichText:pushBackElement( RTE("(".. i ..")", 25, cc.c3b(255,128,0)))
    self.waitRichText:formatText()                    

    if(i > 0) then
        self.ui.img_stat:setVisible(false)
        --        self.ui.img_stat:loadTexture("res/ui/images/img_193.png")
        BattleUI:showNextBattleWith()
    end
    if( i <= 0 )then -- 启动下一场战斗
        self.battleState = ""
        self:startNextBattle()
    end
end

function BattleUI:showFightTime(i)
    if(i > 0) then
        self.ui.lbl_time:setVisible(true)
        self.ui.lbl_time:setString(i)
    else 
        self.ui.lbl_time:setVisible(false)
        local battleStart = cc.Sprite:create("res/ui/images/img_204.png")
        battleStart:setAnchorPoint(cc.p(0.5,0.5))
        battleStart:setPosition(cc.p(35, -80))
        self.ui.img_VS:addChild(battleStart)
        battleStart:setScale(0.2,0.2)
        local scaleOut=cc.ScaleTo:create(0.6,1) 
        local easeBackOut=cc.EaseBackOut:create(scaleOut)
        local sequence = cc.Sequence:create(easeBackOut,cc.CallFunc:create(function()
            battleStart:removeFromParent()
        end))
        battleStart:runAction(sequence);
    end
end

function BattleUI:showNextBattleWith()
    if(self.nextUserBattle ~= nil)then
        if(self.nextUserBattle.type == "pvp")then
            if(self.waitCount == 1) then
                self.nextBattle:setVisible(false)
                self.nextBattle:removeFromParent()
                self.nextBattleCount = 0
            else
                if(self.nextBattleCount == 0) then 
                    self.nextBattle = cc.Sprite:create("res/ui/images/img_202.png")
                    self.nextBattle:setAnchorPoint(cc.p(0,0))
                    self.nextBattle:setPosition(cc.p(-80, -180))
                    self.nextBattle:setVisible(true)
                    self.ui.img_VS:addChild(self.nextBattle)
                    self.nextBattleCount = 1
                end
            end
        elseif(self.nextUserBattle.type == "pvb")then
            if(self.waitCount == 1) then
                self.nextBattle:setVisible(false)
                self.nextBattle:removeFromParent()
                self.nextBattleCount = 0
            else
                if(self.nextBattleCount == 0) then 
                    self.nextBattle = cc.Sprite:create("res/ui/images/img_194.png")
                    self.nextBattle:setAnchorPoint(cc.p(0,0))
                    self.nextBattle:setPosition(cc.p(-80, -180))
                    self.nextBattle:setVisible(true)
                    self.ui.img_VS:addChild(self.nextBattle)
                    self.nextBattleCount = 1
                end
            end
        end
    else
        if(self.waitCount == 1) then
            self.nextBattle:setVisible(false)
            self.nextBattle:removeFromParent()
            self.nextBattleCount = 0
        else
            if(self.nextBattleCount == 0) then 
                self.nextBattle = cc.Sprite:create("res/ui/images/img_193.png")
                self.nextBattle:setAnchorPoint(cc.p(0,0))
                self.nextBattle:setPosition(cc.p(-80, -180))
                self.nextBattle:setVisible(true)
                self.ui.img_VS:addChild(self.nextBattle)
                self.nextBattleCount = 1
            end
        end
    end
end

function BattleUI:BattleHandler(arr)
    xpcall(
        function()
            self:_BattleHandler(arr)
        end,

        function(msg)
            -- 处理战斗出错，休息一下再来
            MessageManager:show("战斗错误")

            self:doRestAndFight(30, "战斗发生了一些错误， 休息一下继续..." )

            __G__TRACKBACK__(msg)
        end )
end

function BattleUI:_BattleHandler(arr)
    BattleUI.BattleData = arr

    if(arr[1]==0) then
        local msg = ""
        if(arr[2] ~= nil)then
            msg = arr[2]
        end

        -- 发生错误， 30 秒后再试
        self:doRestAndFight(10, msg .. "， 休息一下..." )
        return
    elseif(arr[1] == 1)then
        local r = arr[2]
        if(r.type == "rework")then         -- 离线后的战斗日志
            local bo = require("src/UI/BattleOffline")
            bo:show(false, r.log, r.boxs)
            self:doRestAndFight(5, "准备下一次战斗..." )
        elseif(r.type == "pvequick")then -- 快速战斗
            local bo = require("src/UI/BattleOffline")
            bo:show(true, r.log, r.boxs)
        else -- 普通战斗
            self.battleMaxTime = tonum(r.battletime)
            BattleUI:analyseBattleData(r.log)
        end

        -- 更新战斗统计
        if(r.stat ~= nil and r.stat ~= "")then
            self.battleStatisticsData = r.stat
            -- 更新战斗统计
            MainUI:setBattleRate(self.battleStatisticsData[1])
            if(self.battleStatisticsUI ~= nil and self.battleStatisticsData ~= nil)then
                self.battleStatisticsUI:setBattleStaticData(self.battleStatisticsData)
            end
            if( tonum(self.battleStatisticsData[1]) >= 95)then
                self:showBattleTips(true)
                self.onShowBattleTips = function()
                    self:showBattleTips(false)
                    AlertManager:yesno("提示", { 
                        RTE("当前地图战斗胜率已超过",25,cc.c3b(255,255,255)),
                        RTE("95%",25,cc.c3b(0,255,0)),
                        RTE("，击败本地图", 25,cc.c3b(255,255,255)),
                        RTE("BOSS",25,cc.c3b(234,133,234)),
                        RTE("开启更高级地图\n",25,cc.c3b(255,255,255) ) },
                    function()
                        GameUI:switchTo("mapUI",1)
                    end)
                end
            end
        end
    end
end

-- 显示战斗提示
function BattleUI:showBattleTips(flag)
    UICommon.setVisible(self.ui.btn_tips,flag)
    if(flag == false)then
        self.ui.btn_tips:stopAllActions()
    else
        local s1 = cc.ScaleTo:create(0.6, 1.3)
        local s2 = cc.ScaleTo:create(0.6, 1)
        local sq = cc.Sequence:create(s1,s2)

        self.ui.img_mark:runAction(cc.RepeatForever:create(sq))
    end
end

-- 准备Pvp战斗
function BattleUI:addPvpBattle(v)
    self.nextUserBattle = {
        type = "pvp",
        uid = v.uid,
        username = v.uname
    }

    self.ui.lbl_state:setString("接下来将挑战 ".. v.uname .. " ...")
    self.ui.lbl_state:setVisible(true)
    --local obj={name=v.uname,hp=0,mp=0,lv=v.ulv}
    --obj.icon_path = User.getUserHeadImg(v.ujob, v.usex )
    --BattleUI.roleListNew = { [1] = { [1] = {}, [2] = {} }, [2] = {} } 
    --local scale= self.ui_enemy1.nativeUI:getScale()
    --  local x, y = self.ui_enemy1.nativeUI:getPosition()
    -- cclog("scale is" .. scale .. " x:" .. x .. " y:" .. y)
    --self.ui_enemy1.nativeUI:setScale(1,1)
    --self.ui_enemy1.nativeUI:setPosition(336,723)
    --BattleUI:setRole(2,1,self.ui_enemy1,obj)
end

function BattleUI:addPkBoss(v)
    cclog("addPkBoss " ..v)
    self.nextUserBattle = {
        type = "pvb",
        mapid = v
    }

    self.ui.lbl_state:setString("接下来将挑战 ".. ConfigData.cfg_map[v].mname .. " 守关BOSS...")
    self.ui.lbl_state:setVisible(true)  
end

-- 快速战斗
function BattleUI:quickBattle()

    local function doQuickBattle()
        local function onQuickBattle(param)
            if(param[1] == 1)then
                BattleUI:_BattleHandler(param)
                GameUI:loadUinfo()
            else
                local errType=param[2]
                if errType==1 then
                    local vip = ConfigData.cfg_vip[User.vip]
                    local text1={ 
                        RTE("您当前 ",25, cc.c3b(255,255,255)),
                        RTE("VIP"..User.vip,25, cc.c3b(209,201,1)),
                        RTE("，可进行快速战斗", 25, cc.c3b(255,255,255)),
                        RTE(vip.quickpve,25,cc.c3b(0,255,0)),
                        RTE("次", 25, cc.c3b(255,255,255)),
                        RTE("(已用完)\n" ,25, cc.c3b(255,0,0))
                    }
                    if(User.vip<15) then
                        vip =ConfigData.cfg_vip[User.vip+1]
                        table.insert(text1,#text1+1,RTE("下一级 ",25, cc.c3b(255,255,255)))
                        table.insert(text1,#text1+1,RTE("VIP"..(User.vip+1),25, cc.c3b(209,201,1)))
                        table.insert(text1,#text1+1, RTE("，可进行快速战斗", 25, cc.c3b(255,255,255)))
                        table.insert(text1,#text1+1,RTE(vip.quickpve,25,cc.c3b(0,255,0)))
                        table.insert(text1,#text1+1,RTE("次 ",25, cc.c3b(255,255,255)))
                    end
                    if(User.vip<15) then
                        AlertManager:yesno("快速战斗次数不足", 
                            text1,
                            function() DialogManager:showDialog("Charge") end,"充值" )
                    else
                        AlertManager:ok("快速战斗次数上限", 
                            text1,
                            nil)
                    end
                elseif errType==2 then
                    AlertManager:yesno("钻石不足", 
                        {RTE("快速战斗所需钻石不足，赶紧去充值吧! ",25, cc.c3b(255,255,255))},
                        function() DialogManager:showDialog("Charge") end,"充值" )
                end

                --MessageManager:show(param[2])
            end
        end
        sendCommand("pvequick", onQuickBattle, {Map.mapid})     
    end

    local function getPrice(t)
        t = tonum(t)
        if(t < 1)then
            return 30
        elseif(t<3)then
            return 50
        elseif(t<6)then
            return 90
        elseif(t<10)then
            return 150
        elseif(t<15)then
            return 250
        else
            return 400
        end
    end
    local vip = ConfigData.cfg_vip[User.vip]
    AlertManager:yesno("快速战斗", 
        { RTE("进行快速战斗2小时，将消耗 ",25, cc.c3b(255,255,255)),
            RTE(getPrice(User.pvequick), 25, cc.c3b(255,0,255)),
            RTE(" 钻石，确定继续？", 25, cc.c3b(255,255,255)),
            RTE( string.format("(您是VIP%d，今天还剩余%d次)", User.vip, vip.quickpve - User.pvequick),20, cc.c3b(152,84,162))
        },
        doQuickBattle )
end

-- 游戏进程被重新激活，停止当前战斗播放，立即调用下一次战斗
--从后台返回游戏的时候，新增弹出窗口的图片在android不加载(纹理变黑)的解决办法：
-- http://blog.csdn.net/wk3368/article/details/17560137
function BattleUI:onDeviceActive()
    Scheduler.performWithDelayGlobal(function()    
        cclog("BattleUI:onDeviceActive " .. self.battleState)
        if(self.battleState == "playing")then
            BattleUI:BattleFinish()
        elseif(self.battleState == "rest")then
        end 

        self:appendText( RTE("欢迎回来...") )
        self.battleState = ""

        -- 马上进行下一次战斗
        self:startNextBattle()
    end, 0.1 )
end

function BattleUI:analyseBattleData(arr)
    BattleUI.BattleLog = arr
    BattleUI.roleListNew = { [1] = { [1] = {}, [2] = {} }, [2] = {} } -- 1 己方， 2 敌方

    self.ui_player.nativeUI:setVisible(false)
    self.ui_hire.nativeUI:setVisible(false)
    self.ui_enemy1.nativeUI:setVisible(false)
    self.ui_enemy2.nativeUI:setVisible(false)
    self.ui_enemy3.nativeUI:setVisible(false)

    -- 我方信息
    local myinfo = arr[2][1]
    if(table.getn(myinfo)>=1) then
        local m = myinfo[1]
        m.name = User.uname    -- 自己
        m.icon_path = User.getUserHeadImg(User.ujob, User.usex)
        BattleUI:setRole(1, 1, self.ui_player, m)
    end

    if(table.getn(myinfo)>=2) then
        local h = myinfo[2]
        h.icon_path = User.getPartnerHead(h)
        BattleUI:setRole(1, 2, self.ui_hire, h)
    end

    -- 敌方信息
    local enemyInfo = arr[2][2]
    local texts = {}
    local enemyNum = table.getn(enemyInfo)
    for i = 1, enemyNum do
        BattleUI:showEnemy(enemyInfo[i],i,texts)
    end
    BattleUI:appendText(unpack(texts))

    -- 开始播放日志
    self.turnCount = 1 -- 当前回合
    self.roleCount = 1 -- 当前出手人物
    self.actCount  = 1 -- 当前行动
    self.mpCostTurn = {0,0} -- 玩家释放技能耗蓝回合
    self.playCount = 0 -- 播放秒数，用于计算下次战斗cd时间

    BattleUI.turnCountTotal = table.getn(BattleUI.BattleLog[3])

    -- 开始进入播放状态
    self.battleState = "playing"
end

function BattleUI:onBattleTurnTimer()
    while true do

        local turn = BattleUI.BattleLog[3][BattleUI.turnCount]
        local role = turn[BattleUI.roleCount]
        local arr = string.split(role.log[BattleUI.actCount],",")
        --cclog("turn %d/%d, role %d/%d, act %d/%d",  self.turnCount, self.turnCountTotal, self.roleCount, table.getn(turn), self.actCount,table.getn(role.log))

        BattleUI:onPlayAction(role, arr)

        local nextBuff = false        
        if BattleUI.actCount >= table.getn(role.log) then
            BattleUI.actCount = 1
            BattleUI.roleCount = BattleUI.roleCount + 1

            if BattleUI.roleCount > table.getn(turn) then
                BattleUI.roleCount = 1
                BattleUI.turnCount = BattleUI.turnCount + 1
            end
        else
            BattleUI.actCount = BattleUI.actCount + 1

            -- 看下一条是不是BUFF状态更新，如果是，则直接显示
            if self.actCount <= table.getn(role.log) then
                local arr = string.split(role.log[self.actCount],",")
                if tonum(arr[1]) == 1001 then
                    --cclog("next buff")
                    nextBuff = true
                end
            end
        end

        if(BattleUI.turnCount > BattleUI.turnCountTotal) then
            BattleUI:BattleFinish() 

            -- 休息进行下一次战斗
            -- cclog("battleMaxTime %d playCount %d", self.battleMaxTime, self.playCount)
            local waittime = math.max(self.battleMaxTime - self.playCount + 1, 3)
            if(self.nextUserBattle ~= nil) then 
                if(self.nextUserBattle.type == "pvp") then
                    self:doRestAndFight(waittime, "正在恢复休息中， 并搜寻竞技场..." )
                elseif(self.nextUserBattle.type == "pvb") then
                    self:doRestAndFight(waittime, "正在恢复休息中， 并搜寻Boss..." )
                end
            else
                self:doRestAndFight(waittime, "正在恢复休息中， 并搜寻敌人..." )
            end
            break
        end

        if not nextBuff then
            self.playCount = self.playCount + 1  -- 播放秒数 
            break
        end
    end
end

function BattleUI:showEnemy(obj,i,texts)
    table.insert(texts, RTE("你遇到了 ".."Lv."..obj["lv"].." "))
    local name = obj["name"]
    if(obj["isboss"]) then
        name = name .. "[BOSS]"
    end
    table.insert(texts, RTE( name ,25,cc.c3b(0,102,255)))
    table.insert(texts, RTE(" (HP:"..obj["hp"]..")") )
    table.insert(texts, RTE("\n") )
    local pnl = self["ui_enemy"..i]

    --local x, y = self.ui_enemy1.nativeUI:getPosition()
    --if(obj)
    local r = BattleUI.BattleData[2]
    if r.type=="pvp" then
        obj.icon_path = User.getUserHeadImg(obj.job, obj.sex )
        self.ui_enemy1.img_back:loadTexture("res/ui/images/img_127.png")
        self.ui_enemy1.nativeUI:setScale(1,1)
        self.ui_enemy1.nativeUI:setPosition(350,135)
        self.ui_enemy1.bar_mp:setVisible(true)
    elseif r.type=="pvb" then
        obj.icon_path = string.format("res/monster/%d.png", obj.picindex)
        self.ui_enemy1.img_back:loadTexture("res/ui/images/img_128.png")
        self.ui_enemy1.nativeUI:setScale(1,1)
        self.ui_enemy1.nativeUI:setPosition(350,135)
        self.ui_enemy1.bar_mp:setVisible(false)
    else 
        obj.icon_path = string.format("res/monster/%d.png", obj.picindex)
        self.ui_enemy1.img_back:loadTexture("res/ui/images/img_128.png")
        self.ui_enemy1.nativeUI:setScale(0.75,0.75)
        self.ui_enemy1.nativeUI:setPosition(420,180)
        self.ui_enemy1.bar_mp:setVisible(false)
    end

    --[[ if(obj.picindex~=0) then
    self.ui_enemy1.nativeUI:setScale(0.75,0.75)
    self.ui_enemy1.nativeUI:setPosition(418,745)
    end--]]

    BattleUI:setRole(2,i,pnl,obj)
end

function BattleUI:setRole(side, id, roleUI, obj)
    BattleUI.roleListNew[side][id] = {}
    BattleUI.roleListNew[side][id].name = obj.name
    BattleUI.roleListNew[side][id].hp   = { tonum(obj['hp']), tonum(obj['hp']) }
    BattleUI.roleListNew[side][id].mp   = { tonum(obj['mp']), tonum(obj['mp']) }
    BattleUI.roleListNew[side][id].buff = {}

    roleUI.nativeUI:setVisible(true)
    if side == 1 then
        roleUI.lbl_name:setString(string.format("%s Lv.%d", obj.name, obj.lv))
    elseif side == 2 then
        roleUI.lbl_name:setString(string.format("Lv.%d %s", obj.lv, obj.name))
    end
    UICommon.loadExternalTexture(roleUI.img_icon, obj.icon_path )
    roleUI.bar_hp:setPercent(100)
    roleUI.Bar_before_hp:setPercent(100)
    roleUI.text_hp:setString( string.format("%d/%d", obj['hp'], obj['hp']) )
    roleUI.img_dead:setVisible(false)
    self.ui.img_stat:setVisible(false)

    if roleUI.img_boss ~= nil then 
        if(tonum(obj.isboss) == 1) then
            roleUI.img_boss:setVisible(true)
            BattleUI.roleListNew[side][id].name = obj.name.."[BOSS]"
        else
            roleUI.img_boss:setVisible(false)
        end
    end

    if(roleUI.bar_mp ~= nil) then    
        roleUI.bar_mp:setPercent(100)
    end

    roleUI.pnl_buff:removeAllChildren()

    BattleUI.roleListNew[side][id].bar_hp = roleUI.bar_hp
    BattleUI.roleListNew[side][id].text_hp = roleUI.text_hp
    BattleUI.roleListNew[side][id].pnl_buff = roleUI.pnl_buff
    BattleUI.roleListNew[side][id].bar_mp = roleUI.bar_mp
    BattleUI.roleListNew[side][id].img_dead=roleUI.img_dead
    BattleUI.roleListNew[side][id].img_face=roleUI.img_icon
    BattleUI.roleListNew[side][id].Bar_before_hp = roleUI.Bar_before_hp
end

-- 更新buff状态
function BattleUI:updateBuff(role, side, buffid, leftturn)
    buffid = toint(buffid)
    if tonum(leftturn) == 0 then
        role.buff[buffid] = nil
    else
        role.buff[buffid] = toint(leftturn)
    end

    -- 更新BUFF列表文字
    role.pnl_buff:removeAllChildren()
    local size = role.pnl_buff:getContentSize()  
    local rt = ccui.RichText:create()

    local doHaveBuff = false
    rt:pushBackElement( RTE("[",20, cc.c3b(255,255,255)) )
    local s = ""
    for k,v in pairs(role.buff) do
        local buff = ConfigData.cfg_buff[k]
        if(buff[2] == 1)then
            rt:pushBackElement( RTE( s .. buff[1] .. v,20,cc.c3b(255,0,0) ))
        elseif(buff[2] == 2)then
            rt:pushBackElement( RTE( s .. buff[1] .. v,20, cc.c3b(0,255,0) ))
        end
        s = " "
        doHaveBuff = true
    end

    if doHaveBuff then
        rt:pushBackElement( RTE("]",20, cc.c3b(255,255,255)) )
        rt:formatText()
        rt:setAnchorPoint( cc.p(0.5,0.5) )
        local rtsize = rt:getContentSize()

        if side == 1 then
            rt:setPosition(cc.p(rtsize.width / 2, size.height / 2))
        elseif side == 2 then
            rt:setPosition(cc.p(size.width - rtsize.width / 2 , size.height / 2))        
        end
        role.pnl_buff:addChild(rt)
    end
end

-- BattleLog格式
-- BattleLog[回合][出手人物][行为]
function BattleUI:onPlayAction(role, arr)
    --dump(arr)
    local ret = tonum(arr[1])
    local color = cc.c3b(255,0,0)
    local colora = cc.c3b(0,102,255)
    local colore = cc.c3b(153,102,204)
    local colornormal = cc.c3b(0,0,0)
    local attid = tonum(arr[2])
    if(toint(attid/10)==1) then
        colora = cc.c3b(153,102,204)
        colore = cc.c3b(0,102,255)
    end
    BattleUI:doAttack(arr);

    local attacter = BattleUI.roleListNew[toint(attid/10)][toint(attid%10)+1]
    local name_t = RTE(attacter.name,25,colora)

    if(ret==1001) then
        -- 更新BUFF
        BattleUI:updateBuff(attacter, toint(attid/10),arr[3], arr[4])
    else
        local skilid = tonum(arr[3])
        local defid = tonum(arr[4])
        local dtype = tonum(arr[5])
        local damage = tonum(arr[6])
        local mpcost = 0
        local roundText = RTE("["..BattleUI.turnCount.."]",25,cc.c3b(255,128,0))
        local skill_t = nil
        local use_t = RTE("使用")

        if(ret==1) then
            sname = ""
            if(skilid == 1 or skilid == 11 or skilid == 12)then
                skill_t = RTE(" 普通攻击 ")
            else
                --local sname = " "
                if(ConfigData.cfg_skill[toint(skilid)]~= nil)then
                    sname = sname .. ConfigData.cfg_skill[toint(skilid)].sname.." "
                    mpcost = toint(ConfigData.cfg_skill[toint(skilid)].mp)

                else
                    sname = "未知技能" .. skilid
                end
                skill_t = RTE(sname,25,cc.c3b(85,104,74)) 
            end
            --
        elseif (ret==203) then
        else -- BUFF 效果
            use_t=RTE("由于")
            local sname="buff "
            --    if(toint(skilid)==6) then
            --      sname=sname.."狂怒回复"
            --    elseif(toint(skilid)==10) then
            --      sname=sname.."中毒"
            --    elseif(toint(skilid)==1) then
            if(toint(skilid)==1) then
                use_t=RTE("处于")
                sname="晕眩中" .. "跳过战斗"
            elseif(toint(skilid)==2) then
                use_t=RTE("处于")
                sname="冻结中" .. "跳过战斗"
                --    elseif(toint(skilid)==13) then
                --      sname=sname.."灼烧"
            else
                use_t=""
                sname=""
            end
            skill_t = RTE(sname,25,cc.c3b(85,104,74))
        end

        local to_t = RTE("对")
        local defender = BattleUI.roleListNew[toint(defid/10)][toint(defid%10)+1]
        local aim_t = RTE(defender.name,25,colore) 

        local pos = nil

        if defid==attid then
            aim_t = RTE("自己",25,colore)
        end
        --
        if ret == 1 then
            local move_object
            local move_distance
            if toint(attid/10) == 1 and toint(attid%10) == 0 then
                move_object = self.ui.pnl_player
                move_distance = 15
            elseif toint(attid/10) == 1 and toint(attid%10) == 1 then
                move_object = self.ui.pnl_hire
                move_distance = 15
            elseif toint(attid/10) == 2 and toint(attid%10) == 0 then
                move_object = self.ui.pnl_enemy1
                move_distance = -15
            elseif toint(attid/10) == 2 and toint(attid%10) == 1 then
                move_object = self.ui.pnl_enemy2
                move_distance = -15
            elseif toint(attid/10) == 2 and toint(attid%10) == 2 then
                move_object = self.ui.pnl_enemy3
                move_distance = -15        
            end
            --
            local function createSimpleMoveBy()  
                return cc.MoveBy:create(0.2, cc.p(move_distance, 0))  
            end
            local function createSimpleDelayTime()  
                return cc.DelayTime:create(0.1)  
            end 
            local move_ease_in = cc.EaseIn:create(createSimpleMoveBy(), 1)
            local move_ease_in_back = move_ease_in:reverse()
            local seq = cc.Sequence:create(move_ease_in,createSimpleDelayTime(),move_ease_in_back,createSimpleDelayTime()) 
            move_object:runAction(seq)
        end
        if defid ~= attid then
            local pLable = cc.Label:createWithSystemFont(sname,"", 15)
            local move_X_begian =  0
            local move_Y_begian =  0
            local move_word_distance = 0
            if toint(attid/10) == 1 and toint(attid%10) ~= 1 then
                move_Y_begian = 254-100
                move_X_begian = 200
                move_word_distance = 400
                pLable:setPosition(cc.p(200,254-110)) 
            elseif toint(attid/10) == 1 and toint(attid%10) == 1 then  
                move_Y_begian = 254-190
                move_X_begian = 200
                move_word_distance = 400
                pLable:setPosition(cc.p(200,254-190))
            elseif toint(attid/10) ~= 1 then
                move_X_begian = 440
                move_Y_begian = 254-130
                move_word_distance = -400
                pLable:setPosition(cc.p(440,254-130))
            end

            pLable:setColor(cc.c3b(255,255,255))
            pLable:enableOutline(cc.c4b(0,0,0,255),3)
            self.ui.Image_17:addChild(pLable,100,100)
            local function callback()
                pLable:removeFromParent()
            end
            
            local scaleTo = cc.ScaleTo:create(0.1,1,1)
            local delay = cc.DelayTime:create(0.5)
            local fade = cc.FadeIn:create(0.5)
            local sequence = cc.Sequence:create(delay, fade, cc.CallFunc:create(callback))
            pLable:runAction(sequence)

            local ac = cc.MoveBy:create(0.5, cc.p(50 ,0 ) )
            local delay = cc.DelayTime:create(0.5)
            local fade = cc.FadeOut:create(0.5)
            local sequence = cc.Sequence:create(delay, ac,fade, cc.CallFunc:create(callback))
            pLable:runAction(sequence)

            local move_object
            local move_distance
            if toint(defid/10) == 1 and toint(defid%10) == 0 then
                move_object = self.ui.pnl_player
                move_distance = -5
            elseif toint(defid/10) == 1 and toint(defid%10) == 1 then
                move_object = self.ui.pnl_hire
                move_distance = -5
            elseif toint(defid/10) == 2 and toint(defid%10) == 0 then
                move_object = self.ui.pnl_enemy1
                move_distance = 5
            elseif toint(defid/10) == 2 and toint(defid%10) == 1 then
                move_object = self.ui.pnl_enemy2
                move_distance = 5
            elseif toint(defid/10) == 2 and toint(defid%10) == 2 then
                move_object = self.ui.pnl_enemy3
                move_distance = 5        
            end
            local function createSimpleMoveBy()  
                return cc.MoveBy:create(0.2, cc.p(move_distance, 0))  
            end
            local function createSimpleDelayTime()  
                return cc.DelayTime:create(0.1)  
            end
            local move_ease_in = cc.EaseIn:create(createSimpleMoveBy(), 1)
            local move_ease_in_back = move_ease_in:reverse()
            local seq = cc.Sequence:create(move_ease_in,createSimpleDelayTime(),move_ease_in_back,createSimpleDelayTime()) 
            move_object:runAction(seq)
        end
        --

        local cause_t = RTE("造成")
        local damage_t = RTE(damage,25,color)
        local end_t = RTE("点伤害")
        if(toint(dtype)==2) then
            end_t = RTE("点伤害(暴击)")
        elseif(toint(dtype)==3) then
            end_t = RTE("点伤害(闪避)")
        elseif(toint(dtype)==4) then
            cause_t=RTE("恢复")
            to_t = RTE("为")
            --    aim_t = RTE("")
            end_t = RTE("点生命值")
        elseif(toint(dtype)==5)then
            cause_t=RTE("受到")
            to_t = RTE("")
            aim_t = RTE("")
        elseif(toint(dtype)==7) then
            cause_t=RTE("回复")
            to_t = RTE("")
            aim_t = RTE("")
            end_t = RTE("点魔法值")
        elseif(toint(dtype)==17) then
            cause_t=RTE("减少")
            to_t = RTE("")
            aim_t = RTE("")
            end_t = RTE("点魔法值")
        elseif(toint(dtype)==8) then
            cause_t=RTE("魔法盾吸收")
            to_t = RTE("")
            aim_t = RTE("")
            end_t = RTE("点伤害")
        elseif(toint(dtype)==6) then
            cause_t = RTE("")
            damage_t = RTE("")
            end_t = RTE("")
            if(toint(ret)==2) then
                to_t = RTE("")
                aim_t = RTE("")
            end
        end


        if ret==203 then
            cause_t=RTE("吸取到")
            end_t = RTE("点生命值")
            BattleUI:appendText(roundText,name_t,cause_t,damage_t,end_t)
        elseif(ret~=0) then
            if(ret~=2) then
                if(toint(dtype)==6) then
                    BattleUI:appendText(roundText,name_t,to_t,aim_t,use_t,skill_t)
                else
                    BattleUI:appendText(roundText,name_t,use_t,skill_t,to_t,aim_t,cause_t,damage_t,end_t)
                end
            else
                if(toint(skilid)==1 or toint(skilid)==2) then
                    BattleUI:appendText(roundText,name_t,use_t,skill_t)
                end
            end
        end

        -- 更新血量/蓝量显示
        if(toint(attid/10) == 1 and toint(attid%10) == 0) then
            if(BattleUI.mpCostTurn[1] < BattleUI.turnCount and ret==1) then
                BattleUI.mpCostTurn[1] = BattleUI.turnCount
                attacter.mp[2] = math.max(attacter.mp[2]-mpcost,0)
                BattleUI:updateRoleUI(attacter)
            end
        end
        if BattleUI.BattleData[2]['type']=="pvp" then
            if(toint(attid/10) == 2 and toint(attid%10) == 0) then
                if(BattleUI.mpCostTurn[2] < BattleUI.turnCount and ret==1) then
                    BattleUI.mpCostTurn[2] = BattleUI.turnCount
                    attacter.mp[2] = math.max(attacter.mp[2]-mpcost,0)
                    BattleUI:updateRoleUI(attacter)
                end
            end
        end
        if(toint(dtype)==4) then
            defender.hp[2] = math.min(defender.hp[1],defender.hp[2] + damage)
        elseif(toint(dtype)==7) then
            attacter.mp[2] = math.min(attacter.mp[2] + damage,attacter.mp[1])
        elseif(toint(dtype)==17) then
            attacter.mp[2] = math.max(attacter.mp[2] - damage,0)
        elseif(toint(dtype)~=6) then
            defender.hp[2] = math.max(0,defender.hp[2] - damage)
            if(defender.hp[2]<=0) then
            --                BattleUI.roleListNew
            end
        end

        -- 更新血条
        local bar = defender.bar_hp
        BattleUI:updateRoleUI(defender)
        BattleUI:showDamageTips(bar, damage, toint(dtype))

    end


end

function BattleUI:BattleFinish()

    local texts = {}  
    if BattleUI.BattleLog[1] == 1 then
        table.insert( texts, RTE("战斗胜利\n"))
        self.ui.img_stat:setVisible(true)
        self.ui.img_stat:loadTexture("res/ui/images/img_191.png")
        self.ui.img_stat:setScale(0.2,0.2)
        local scaleOut=cc.ScaleTo:create(0.6,1) 
        local easeBackOut=cc.EaseBackOut:create(scaleOut)
        self.ui.img_stat:runAction(easeBackOut);

        table.insert( texts, RTE("获得经验"..BattleUI.BattleLog[4] .."\n",25,cc.c3b(255,0,255)))

        GameUI:addUserExp(BattleUI.BattleLog[4])

        table.insert( texts, RTE("获得金钱"..BattleUI.BattleLog[5] .."\n",25,cc.c3b(153,0,255)))

        GameUI:addUserCoin(BattleUI.BattleLog[5])

        GameUI:addUserJinghua(BattleUI.BattleLog[7])
        MainUI:battleFinish(BattleUI.BattleLog[5],BattleUI.BattleLog[4])
        if(BattleUI.BattleLog[7]~=0) then
            table.insert( texts, RTE("获得精华"..BattleUI.BattleLog[7] .."\n",25,cc.c3b(0,102,255)))
        end
        User.ug = User.ug + BattleUI.BattleLog[8];
        if(BattleUI.BattleLog[8]~=0) then
            table.insert( texts, RTE("获得钻石"..BattleUI.BattleLog[8] .."\n",25,cc.c3b(0,102,255)))
        end

        --获得装备
        local equipDataArr = BattleUI.BattleLog[6]--这是一个equips的array    
        --cclog(vardump(equipDataArr))
        -- local effectPath = cc.FileUtils:getInstance():fullPathForFilename("res/sound/s_err.mp3")
        -- cc.SimpleAudioEngine:getInstance():playEffect(effectPath,false,0 ,0,0)
        if(table.getn(equipDataArr) ~= 0)then
            for i=1,table.getn(equipDataArr) do
                local equipData=equipDataArr[i]
                if equipData[1] ==1 then

                    local e=equipData[2]
                    table.insert( texts, RTE("获得装备 "))
                    table.insert( texts, RTE("[".. User.getEquipName(e) .. "]",25,User.starToColor(e.star)) )
                    table.insert( texts, RTE("\n"))
                    BagUI:addEquipToBag(e,true)
                elseif equipData[1] == 2 then   
                    table.insert( texts,  RTE("卖出"))         
                    --table.insert( texts, RTE("\n"))
                    table.insert( texts,  RTE( User.starToText(equipData[2]) .. "装备", 25, User.starToColor(equipData[2]) ))
                    table.insert( texts, RTE("\n"))
                    table.insert( texts,  RTE("获得金钱"..equipData[3],25,cc.c3b(153,0,255)))
                    table.insert( texts, RTE("\n"))
                    if(equipData[4]~=0) then
                        table.insert( texts, RTE("获得精华"..equipData[4],25,cc.c3b(0,102,255)))
                        table.insert( texts, RTE("\n"))                        
                    end
                end
            end
        end
        --dump(BattleUI.BattleLog)
        local box = tonum(BattleUI.BattleData[2]["box"])
        local boxitem = tonum(BattleUI.BattleData[2]["boxitem"])
        local boxcount = tonum(BattleUI.BattleData[2]["boxcount"])

        if(box ~= 0) then
            table.insert( texts, RTE("发现",25,cc.c3b(0,0,0)))
            table.insert( texts, RTE(ConfigData.cfg_item[box].name,25,User.starToColor(box%10+1)))
            if(boxitem ~= 0 and boxcount ~= 0) then
                table.insert( texts, RTE(" 使用",25,cc.c3b(0,0,0)))
                table.insert( texts, RTE(ConfigData.cfg_item[box-10].name,25,User.starToColor(box%10+1)))
                table.insert( texts, RTE(" 获得",25,cc.c3b(0,0,0)))
                table.insert( texts, RTE(ConfigData.cfg_item[boxitem].name.."*"..boxcount,25,cc.c3b(0,0,0)))
                table.insert( texts, RTE("\n"))
                -- 物品刷新
                BagUI:reduceItem(box-10, 1)
                BagUI:addItem(boxitem, boxcount)
                BagUI:setNeedRefresh()
                BagUI:refreshUI()
            else
                table.insert( texts, RTE(" 没有",25,cc.c3b(0,0,0)))
                table.insert( texts, RTE(ConfigData.cfg_item[box-10].name,25,User.starToColor(box%10+1)))
                table.insert( texts, RTE(" 遗憾地离开了",25,cc.c3b(0,0,0)))
                table.insert( texts, RTE("\n"))
            end
        end


    elseif BattleUI.BattleLog[1]==0 then
        table.insert( texts, RTE("敌人获胜\n"))
        self.ui.img_stat:setVisible(true)
        self.ui.img_stat:loadTexture("res/ui/images/img_192.png")
        self.ui.img_stat:setScale(0.2,0.2)
        local scaleOut=cc.ScaleTo:create(0.6,1) 
        local easeBackOut=cc.EaseBackOut:create(scaleOut)
        self.ui.img_stat:runAction(easeBackOut);
    else
        table.insert( texts, RTE("敌人逃跑\n"))
    end

    BattleUI:appendText(unpack(texts))

    -- 根据战斗情况不一样，重新读取数据
    -- PVB，重新读取uinfo，有挑战boss的次数
    -- PVP，重新读取Pvp数据

    local r = BattleUI.BattleData[2]

    if r.type == "pvp" then
        -- 更新一下pvp
        User.pvp = User.pvp - 1
        PvpUI:getPvp()
    end

    -- 成功挑战BOSS
    if(r.type == "pvb" and BattleUI.BattleLog[1] == 1) then
        -- 提示进入下一张地图
        self:showBattleTips(true)
        self.onShowBattleTips = function()
            self:showBattleTips(false)
            AlertManager:yesno("提示", { 
                RTE("您已经成功战胜当前地图",25,cc.c3b(255,255,255)),
                RTE("BOSS",25,cc.c3b(234,133,234)),
                RTE("，可前往更高级的地图！\n",25,cc.c3b(255,255,255) ) },
            function()
                GameUI:switchTo("mapUI", 2)
            end)
        end
    elseif r.type == "pvb" then
        User.setGuide("boss")
    end

    -- 更新地图id
    if(r.nowmid ~= nil)then
        --dump("new umid " .. r["nowmid"])
        if(tonum(r.nowmid) > User.umid )then
            UMeng:finishLevel( string.format("map%d", User.umid) )
            User.umid = tonum(r.nowmid)
            UMeng:startLevel( string.format("map%d", User.umid) )
        end
    end

    GameUI:loadUinfo()
end


function BattleUI:appendText(...)
    --cclog("appendText")
    --cclog(debug.traceback())
    -- 每句话一个RichText
    self:addRichText()

    local arg = {...}
    for i=1, table.getn(arg) do
        BattleUI.richtext:pushBackElement(arg[i])
    end
    BattleUI.richtext:pushBackElement(RTE("\n"))  

    BattleUI.richtext:formatText() -- 强制渲染，这样richText:getRealSize()得到的值才正确
    BattleUI:adjustRichText() -- 调整文字
    --cclog("appendText end")
end

function BattleUI:addRichText()
    BattleUI.richtext = ccui.RichText:create()
    local s = self.ui.battle_log:getContentSize()
    local n = table.getn(BattleUI.richtextlist)
    BattleUI.richtextlist[n+1] = BattleUI.richtext

    BattleUI.richtext:setPositionX(0)
    BattleUI.richtext:setPositionY(s.height)
    BattleUI.richtext:setAnchorPoint(cc.p(0,1))
    BattleUI.richtext:ignoreContentAdaptWithSize(false)
    BattleUI.richtext:setContentSize(s)
    BattleUI.richtext:setLocalZOrder(10)
    self.ui.battle_log:addChild(self.richtext)

    if(n>=1) then
        local y = BattleUI.richtextlist[n]:getPositionY()-BattleUI.richtextlist[n]:getRealSize().height
        BattleUI.richtext:setPositionY(y)
    end
end

function BattleUI:adjustRichText()
    --cclog("adjustRichText Y = " .. BattleUI.richtext:getPositionY())
    --cclog("adjustRichText H = " ..BattleUI.richtext:getRealSize().height)
    if(BattleUI.richtext == nil or self.adjustRichTextFlag == false)then
        return
    end

    local y = BattleUI.richtext:getPositionY() - BattleUI.richtext:getRealSize().height
    if(y<0) then -- 滚屏
        local gap = -y
        local newRichTextList = {}
        for i=1, table.getn(BattleUI.richtextlist) do
            local y1 = BattleUI.richtextlist[i]:getPositionY()
            local h1 = BattleUI.richtextlist[i]:getRealSize().height

            if(y1 - h1 >= frameSize.height - 400 )then
                -- 超出边界了，删！
                BattleUI.richtextlist[i]:removeFromParent()
            else
                BattleUI.richtextlist[i]:setPositionY(y1 + gap) -- 普通向上滚屏
                table.insert(newRichTextList,BattleUI.richtextlist[i])
            end
        end

        BattleUI.richtextlist = newRichTextList
    end
end

-- 退出当前游戏
function BattleUI:stopAndExit()
    self.richtextlist = {}

    if(self.battleTimer ~= nil)then
        Scheduler.unscheduleGlobal(self.battleTimer)
        self.battleTimer = nil
    end

    if(self.chatUI ~= nil)then
        self.chatUI:close()
    end

    BattleUI.init()
end

function BattleUI:setGuideIcon(type)
    local btnname = ""
    if type == "map" then
        btnname = "changemap"
    elseif type == "battle" then
        btnname = "quick_battle"
    end
    
    if self.ui["button_"..btnname] == nil then
        return 
    end
    local img = self.ui["button_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end

    local img_guide = ccui.ImageView:create("res/ui/icon/icon_26.png")
    img_guide:setTag(7777)
    img_guide:setPosition(cc.p(125,40))
    self.ui["button_"..btnname]:addChild(img_guide)
    local ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.50,0.50))
    local s = img_guide:getContentSize()        
    ani:setPosition(s.width/2+3,s.height/2+5)
    img_guide:addChild(ani)
end

function BattleUI:removeGuideIcon(type)
    local btnname = ""
    if type == "map" then
        btnname = "changemap"
    elseif type == "battle" then
        btnname = "quick_battle"
    end
    
    if self.ui["button_"..btnname] == nil then
        return false
    end
    local img = self.ui["button_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end
end

function BattleUI:checkGuideIcon(type)
    local btnname = ""
    if type == "map" then
        btnname = "changemap"
    elseif type == "quickbattle" then
        btnname = "quick_battle"
    end

    if self.ui["button_"..btnname] == nil then
        return false
    end

    local img = self.ui["button_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        return true
    end
    return false
end

return BattleUI