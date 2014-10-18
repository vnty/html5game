
local BattleStatistics = {
  ui = nil,
  curStatData = nil,
  
  uiId = {
    [1] = {"lbl_battle_win_rate", "%d%%" }, -- 胜率
    [2] = {"lbl_battle_time", "%d/小时" }, -- 战斗次数
    [3] = {"lbl_battle_coin", "%d/小时"}, -- 金币
    [4] = {"lbl_battle_exp", "%d/小时" }, -- 经验
    [5] = {"lbl_battle_equip_drop", "每只怪%d" }, -- 装备数量
  }
}

function BattleStatistics:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/battle-statistics.json"))
  
  self.ui.nativeUI:setTouchEnabled(true)
  
  ui_add_click_listener( self.ui.nativeUI,function()
    self.ui.nativeUI:setVisible(false)
    self.ui.nativeUI:setTouchEnabled(false)
  end)

  self.ui.nativeUI:setPosition(cc.p(0,670))

  return self
end

function BattleStatistics:setBattleStaticData(param)
    local color = nil
    
    for k,v in ipairs(self.uiId)do
        self.ui[v[1]]:setString(string.format(v[2], param[k]))
        color = cc.c3b(255,255,255)
        if(self.curStatData ~= nil)then
            if(tonum(self.curStatData[k]) > tonum(param[k]))then
                color = cc.c3b(255,0,0)
            elseif(tonum(self.curStatData[k]) < tonum(param[k]))then
                color = cc.c3b(0,255,0)
            end
        end
        if k==5 then
        
            local rate = ConfigData.cfg_map[tonum(Map.mapid)].rate/100
            self.ui[v[1]]:setString("每只怪"..rate.."%")
            
        end
        self.ui[v[1]]:setColor(color)
    end
    
    color = cc.c3b(255,255,255)
    if(self.curStatData ~= nil)then
        if(tonum(self.curStatData[2]) > tonum(param[2]))then
            color = cc.c3b(255,0,0)
        elseif(tonum(self.curStatData[2]) < tonum(param[2]))then
            color = cc.c3b(0,255,0)
        end
    end

    self.ui.lbl_battle_avg_time:setString(UICommon.timeFormat(math.floor(3600/tonum(param[2]))) .."/场")
    self.ui.lbl_battle_avg_time:setColor(color)

    local timeleft = "升级时间遥遥无期"
    if(tonum(param[4])>0)then
        timeleft = "约需要 " .. UICommon.timeFormatMin((User.ulvExpMax - User.uexp) * 3600 / tonum(param[4]) )
    end
    if(User.ulv >= 100) then
        self.ui.lbl_lvup:setString("已满级") 
    else
        self.ui.lbl_lvup:setString( string.format("人物升级至 Lv %d 还需经验 %s，%s", 
            User.ulv + 1, User.ulvExpMax - User.uexp, timeleft ) )
    end
    self.curStatData = param
end

function BattleStatistics:setInitData()
    self.ui.lbl_battle_win_rate:setString("---")
    self.ui.lbl_battle_avg_time:setString("---")
    self.ui.lbl_battle_exp:setString("---")
    self.ui.lbl_battle_coin:setString("---")
    self.ui.lbl_battle_time:setString("---")
    self.ui.lbl_battle_equip_drop:setString("---")
    self.ui.lbl_lvup:setString("--")
    self.curStatData = nil
end

return BattleStatistics