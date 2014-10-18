--@module PlayerDetail

PlayerDetail = {
  ui = nil,
}

function PlayerDetail:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/player-detail.json"))
  
  ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
    DialogManager:closeDialog(self)
  end)
  
  return self.ui
end

-- 显示玩家属性
local function getUserPropStr(pi)
  local str = ""
  str = User.getPropStr3(pi,tonum(User.userProps[pi]) + tonum(User.userEquipProps[pi]))
  local basearr={
    [26] = 39,
    [31] = 33,
    [7] = 35,
    [8] = 36,
    [12] = 38,
    [6] = 34,
    [9] = 37,
    [5] = 48,
    [10] = 14,
    [11] = 14
  }
  if basearr[pi] ~= nil then
    str = toint(tonum(str) * (1 + tonum(User.userEquipProps[tonum(basearr[pi])])/ 10000))  --百分比属性 TODO 加全身强化
  end
  return str
end

local function getUserPropValue(pi)
  local str = tonum(User.userProps[pi]) + tonum(User.userEquipProps[pi])
  local basearr={
    [26] = 39,
    [31] = 33,
    [7] = 35,
    [8] = 36,
    [12] = 38,
    [6] = 34,
    [9] = 37,
    [5] = 48,
    [10] = 14,
    [11] = 14
  }
  if basearr[pi] ~= nil then
    str = toint(tonum(str) * (1 + tonum(User.userEquipProps[tonum(basearr[pi])])/ 10000))  --百分比属性 TODO 加全身强化
  end
  return str
end

local GREEN = cc.c3b(0,255,0)
local PURPLE = cc.c3b(173,142,185)
local WHITE = cc.c3b(255,255,255)

function PlayerDetail:onShow()
    local size = self.ui.scv_attr:getContentSize()
  
    if(self.report ~= nil)then
        self.report:removeFromParent()
    end
  
    self.report = ccui.RichText:create()
  
    self.ui.scv_attr:addChild(self.report)
  
    self.report:setAnchorPoint(cc.p(0,1))
    self.report:ignoreContentAdaptWithSize(false)
    self.report:setContentSize(size)
    self.report:setLocalZOrder(10)

    self.report:pushBackElement(RTE( string.format("Lv.%d %s [%s]\n",User.ulv,User.uname, User.getJobName(User.ujob)), 25, cc.c3b(0,204,255)))
    self.report:pushBackElement(RTE( string.format( "战力：%d\n", User.zhanli) , 25, cc.c3b(255,153,0)))
    self.report:pushBackElement(RTE( "属性：总属性值 [效果]\n", 25, PURPLE))

    local d = self.ui
  
    self.report:pushBackElement(RTE(" \n"))
    self.report:pushBackElement(RTE("基础属性:\n",30,WHITE))
  
    -- 基础属性
    self.report:pushBackElement(RTE( "力量：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(1), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 物抗", 20, PURPLE ))
    self.report:pushBackElement(RTE( User.getPropStr2(1,getUserPropValue(1)), 20, GREEN ))
    self.report:pushBackElement(RTE( " 命中", 20, PURPLE ))
    self.report:pushBackElement(RTE( 0.6*tonum(User.getPropStr2(1,getUserPropValue(1))), 20, GREEN ))
    if(User.ujob == 1)then
        self.report:pushBackElement(RTE( " 最小伤害", 20, PURPLE ))
        self.report:pushBackElement(RTE( User.getPropStr2(1,getUserPropValue(1) * 0.5), 20, GREEN ))
        self.report:pushBackElement(RTE( " 最大伤害", 20, PURPLE ))
        self.report:pushBackElement(RTE( User.getPropStr2(1,getUserPropValue(1) ), 20, GREEN ))
    end
    self.report:pushBackElement(RTE( " ]\n", 20, PURPLE ))
    
    self.report:pushBackElement(RTE( "敏捷：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(2), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 暴击", 20, PURPLE ))
    self.report:pushBackElement(RTE( User.getPropStr2(2,getUserPropValue(2)), 20, GREEN ))
    self.report:pushBackElement(RTE( " 闪避", 20, PURPLE ))
    self.report:pushBackElement(RTE( User.getPropStr2(2,getUserPropValue(2) * 0.2), 20, GREEN ))
    if(User.ujob == 2)then
        self.report:pushBackElement(RTE( " 最小伤害", 20, PURPLE ))
        self.report:pushBackElement(RTE( User.getPropStr2(2,getUserPropValue(2) * 0.5), 20, GREEN ))
        self.report:pushBackElement(RTE( " 最大伤害", 20, PURPLE ))
        self.report:pushBackElement(RTE( User.getPropStr2(2,getUserPropValue(2) ), 20, GREEN ))

    end
    self.report:pushBackElement(RTE( " ]\n", 20, PURPLE ))    
    
    self.report:pushBackElement(RTE( "智力：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(3), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 魔抗", 20, PURPLE ))
    self.report:pushBackElement(RTE( User.getPropStr2(3,getUserPropValue(3)), 20, GREEN ))
    self.report:pushBackElement(RTE( " 每回合回复", 20, PURPLE ))
    self.report:pushBackElement(RTE( User.getPropStr2(3, math.sqrt(getUserPropValue(3))), 20, GREEN ))
    self.report:pushBackElement(RTE( "MP", 20, PURPLE ))
    if(User.ujob == 3)then
        self.report:pushBackElement(RTE( " 最小伤害", 20, PURPLE ))
        self.report:pushBackElement(RTE( User.getPropStr2(3,getUserPropValue(3) * 0.5), 20, GREEN ))
        self.report:pushBackElement(RTE( " 最大伤害", 20, PURPLE ))
        self.report:pushBackElement(RTE( User.getPropStr2(3,getUserPropValue(3) ), 20, GREEN ))

    end
    self.report:pushBackElement(RTE( " ]\n", 20, PURPLE ))
    
    self.report:pushBackElement(RTE( "耐力：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(4), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ HP", 20, PURPLE ))
    self.report:pushBackElement(RTE( User.getPropStr2(4,getUserPropValue(4) * 10), 20, GREEN ))
    self.report:pushBackElement(RTE( " 韧性", 20, PURPLE ))
    self.report:pushBackElement(RTE( User.getPropStr2(4,getUserPropValue(4)), 20, GREEN ))
    self.report:pushBackElement(RTE( " ]\n", 20, PURPLE ))         
  
    local eps = { 26,27 }
    for _,v in pairs(eps) do
        self.report:pushBackElement(RTE( ConfigData.cfg_equip_prop[v][1] .."：", 25, PURPLE))
        self.report:pushBackElement(RTE( getUserPropStr(v) .. "\n", 25, GREEN ))
    end

    -- 战斗属性
    self.report:pushBackElement(RTE(" \n"))
    self.report:pushBackElement(RTE("战斗属性:",30,WHITE))
    self.report:pushBackElement(RTE( "[ 对", 20, PURPLE))
    self.report:pushBackElement(RTE( User.ulv, 20, GREEN))
    self.report:pushBackElement(RTE( "级敌人的效果 ]\n", 20, PURPLE))

    eps = { 10,11 }
    for _,v in pairs(eps) do
        self.report:pushBackElement(RTE( ConfigData.cfg_equip_prop[v][1] .."：", 25, PURPLE))
        self.report:pushBackElement(RTE( getUserPropStr(v) .."\n", 25, GREEN ))
    end

    self.report:pushBackElement(RTE( "护甲：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(5), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 减少", 20, PURPLE ))
    local v = getUserPropValue(5) / (User.ulv * (User.ulv + 1) * 3 + getUserPropValue(5) + 50)
    self.report:pushBackElement(RTE( string.format( "%0.1f%%", v * 100), 20, GREEN ))
    self.report:pushBackElement(RTE( "受到的伤害", 20, PURPLE ))
    self.report:pushBackElement(RTE( " ]\n", 20, PURPLE ))
    
    self.report:pushBackElement(RTE( "物抗：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(31), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 减少", 20, PURPLE ))
    local v = getUserPropValue(31) / ((User.ulv + 1) * 50 + getUserPropValue(31))
    self.report:pushBackElement(RTE( string.format( "%0.1f%%", v * 100), 20, GREEN ))
    self.report:pushBackElement(RTE( "受到的物理伤害", 20, PURPLE ))
    self.report:pushBackElement(RTE( " ]\n", 20, PURPLE ))
    
    self.report:pushBackElement(RTE( "魔抗：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(6), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 减少", 20, PURPLE ))
    local v = getUserPropValue(6) / ((User.ulv + 1) * 50 + getUserPropValue(6))
    self.report:pushBackElement(RTE( string.format( "%0.1f%%", v * 100), 20, GREEN ))
    self.report:pushBackElement(RTE( "受到的魔法伤害", 20, PURPLE ))
    self.report:pushBackElement(RTE( " ]\n", 20, PURPLE ))
  
    self.report:pushBackElement(RTE( "暴击：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(12), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 普通攻击", 20, PURPLE ))
    local v = getUserPropValue(12) / ((User.ulv + 1) * User.ulv * 3 + getUserPropValue(12) + 50)
    self.report:pushBackElement(RTE( string.format( "%0.1f%%", v * 100), 20, GREEN ))
    self.report:pushBackElement(RTE( "概率造成", 20, PURPLE ))
    self.report:pushBackElement(RTE( string.format( "%0.1f%%", 180 + getUserPropValue(13) * 0.01), 20, GREEN ))    
    self.report:pushBackElement(RTE( "伤害 ]\n", 20, PURPLE ))
    
    self.report:pushBackElement(RTE( "命中：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(7), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 提升攻击命中率 ]\n", 20, PURPLE ))

    self.report:pushBackElement(RTE( "闪避：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(8), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 提升被普通攻击躲闪率 ]\n", 20, PURPLE ))

    self.report:pushBackElement(RTE( "韧性：", 25, PURPLE))
    self.report:pushBackElement(RTE( getUserPropStr(9), 25, GREEN ))
    self.report:pushBackElement(RTE( " [ 降低被暴击概率 ]\n", 20, PURPLE ))
  
    self.report:pushBackElement(RTE(" \n"))
    self.report:pushBackElement(RTE("神器属性:\n",30,WHITE))
    -- 神器属性
    eps = { 13,14,16,17,21,24,25,28,29,30,33,34,35,36,37,38,39,46,47,48,49 }
    for _,v in pairs(eps) do
        if(tonum(User.userProps[v]) + tonum(User.userEquipProps[v]) > 0)then
            self.report:pushBackElement(RTE( ConfigData.cfg_equip_prop[v][1] .."：", 25, cc.c3b(255,38,38)))
            self.report:pushBackElement(RTE( getUserPropStr(v), 25, cc.c3b(108,180,120) ))
            if v == 46 then
                local ign = tonum(getUserPropStr(v))/(tonum(getUserPropStr(v))+100)
                self.report:pushBackElement(RTE( "(无视", 25, PURPLE ))
                self.report:pushBackElement(RTE( string.format( "%0.1f%%", ign * 100), 25, GREEN ))
                self.report:pushBackElement(RTE( "物抗)", 25, PURPLE ))
            end
            if v == 47 then
                local ign = tonum(getUserPropStr(v))/(tonum(getUserPropStr(v))+100)
                self.report:pushBackElement(RTE( "(无视", 25, PURPLE ))
                self.report:pushBackElement(RTE( string.format( "%0.1f%%", ign * 100), 25, GREEN ))
                self.report:pushBackElement(RTE( "魔抗)", 25, PURPLE ))
            end
            if v == 49 then
                local ign = tonum(getUserPropStr(v))/(tonum(getUserPropStr(v))+100)
                self.report:pushBackElement(RTE( "(无视", 25, PURPLE ))
                self.report:pushBackElement(RTE( string.format( "%0.1f%%", ign * 100), 25, GREEN ))
                self.report:pushBackElement(RTE( "护甲)", 25, PURPLE ))
            end
            self.report:pushBackElement(RTE( "\n", 25, cc.c3b(108,180,120) )) 
        end
    end
  
  
  self.report:formatText()
  local rs = self.report:getRealSize()
  
  if(rs.height > size.height)then
      self.ui.scv_attr:setInnerContainerSize(rs)
  end
  self.report:setPosition(cc.p(0, math.max(rs.height,size.height)))
  self.ui.scv_attr:jumpToTop()
end


return PlayerDetail