local Guide = {
    ui = nil,
}

function Guide:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/guide.json"))
  
  -- 确定按钮
  ui_add_click_listener(self.ui.btn_close,function()
    DialogManager:closeDialog(self)
  end)
  
  self.ui.btn_cancel:setVisible(false)
  self.ui.btn_yes:setVisible(false)
  
  return self.ui
    
end

function Guide:onShow(type)
    local title = self:getGuideTitleByType(type)
    self.ui.lbl_title:setString(title)

    local size = self.ui.pnl_message:getContentSize()

    if(self.rt ~= nil)then
        self.rt:removeFromParent()
    end

    self.rt = ccui.RichText:create()

    self.ui.pnl_message:addChild(self.rt)

    self.rt:setAnchorPoint(cc.p(0,1))
    self.rt:ignoreContentAdaptWithSize(false)
    self.rt:setContentSize(size)
    self.rt:setLocalZOrder(10)
    
    local msg = self:getGuideTextByType(type)
    
    for _,v in pairs(msg)do
        self.rt:pushBackElement(v)    
    end

    self.rt:formatText()
    
    -- 调整大小
    local rs = self.rt:getRealSize()
    local psize = self.ui.Panel_5:getSize()
    local p3size = self.ui.Panel_3_0:getSize()
    
    self.ui.Panel_5:setSize(cc.size(psize.width, rs.height + 26))
    self.ui.pnl_message:setContentSize(cc.size(size.width, rs.height + 10))
    self.rt:setPosition(cc.p(0, rs.height + 5))
    self.ui.Panel_3_0:setSize(cc.size(p3size.width, rs.height + 205))
    self.ui.Image_4:setPosition(cc.p(p3size.width / 2, rs.height + 200))
end

function Guide:getGuideTextByType(type)
    if type == "boss" then
        return Guide:GuideBoss()
    elseif type == "battle" then
        return Guide:GuideBattle()
    elseif type == "map" then
        return Guide:GuideMap()
    elseif type == "skill" then
        return Guide:GuideSkill()
    elseif type == "partner" then
        return Guide:GuidePartner()
    elseif type == "delequipnew" then
        return Guide:GuideDelEquipNew()
    else
        return {
            RTE("更多内容可点击主页上的帮助按钮查看",30,cc.c3b(255,255,255)),
        }
    end
end

function Guide:getGuideTitleByType(type)
    if type == "boss" then
        return "您被BOSS击败了"
    elseif type == "battle" then
        return "挂机介绍"
    elseif type == "map" then
        return "切换地图介绍"
    elseif type == "skill" then
        return "技能介绍"
    elseif type == "partner" then
        return "佣兵介绍"
    elseif type == "delequipnew" then
        return "熔炉介绍"
    else
        return "更多帮助"
    end
end

function Guide:GuideBoss()
    if User.guide['boss']==0 then
        return {
            RTE("点击",30,cc.c3b(255,255,255)),
            RTE("快速战斗",30,cc.c3b(255,0,0)),
            RTE("按钮可以使您立即获得2小时的战斗收益来快速提升自己的实力！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==1 then
        return {
            RTE("主页",30,cc.c3b(255,0,0)),
            RTE("的",30,cc.c3b(255,255,255)),
            RTE("商城",30,cc.c3b(255,0,0)),
            RTE("里有大量比你现在的装备",30,cc.c3b(255,255,255)),
            RTE("更好的装备",30,cc.c3b(255,0,0)),
            RTE("，赶紧去看看吧！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==2 then
        return {
            RTE("点击你",30,cc.c3b(255,255,255)),
            RTE("身上的任意装备",30,cc.c3b(255,0,0)),
            RTE("，里面的",30,cc.c3b(255,255,255)),
            RTE("强化",30,cc.c3b(255,0,0)),
            RTE("按钮可以提高您装备的主要属性，",30,cc.c3b(255,255,255)),
            RTE("强化精华",30,cc.c3b(255,0,0)),
            RTE("可以通过",30,cc.c3b(255,255,255)),
            RTE("挑战BOSS",30,cc.c3b(255,0,0)),
            RTE("获取并在卖出或熔炼时",30,cc.c3b(255,255,255)),
            RTE("原数返还",30,cc.c3b(255,0,0)),
            RTE("，赶紧试试吧！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==3 then
        return {
            RTE("点击你",30,cc.c3b(255,255,255)),
            RTE("身上的任意装备",30,cc.c3b(255,0,0)),
            RTE("，里面的",30,cc.c3b(255,255,255)),
            RTE("洗练",30,cc.c3b(255,0,0)),
            RTE("按钮可以重置装备的力敏智耐，赶紧把装备的属性点都",30,cc.c3b(255,255,255)),
            RTE("洗到主属性",30,cc.c3b(255,0,0)),
            RTE("上吧！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==4 then
        return {
            RTE("培养",30,cc.c3b(255,0,0)),
            RTE("你的",30,cc.c3b(255,255,255)),
            RTE("佣兵",30,cc.c3b(255,0,0)),
            RTE("吧！培养可以让你的佣兵有更高的属性，伤害和防御！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==5 then
        return {
            RTE("神器",30,cc.c3b(255,0,0)),
            RTE("可以",30,cc.c3b(255,255,255)),
            RTE("吞噬",30,cc.c3b(255,0,0)),
            RTE("其他的神器来",30,cc.c3b(255,255,255)),
            RTE("提高",30,cc.c3b(255,0,0)),
            RTE("自己的",30,cc.c3b(255,255,255)),
            RTE("神器属性",30,cc.c3b(255,0,0)),
            RTE("，点开任意一件神器你就能很快的找到",30,cc.c3b(255,255,255)),
            RTE("神器吞噬",30,cc.c3b(255,0,0)),
            RTE("的按钮！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==6 then
        return {
            RTE("点击你",30,cc.c3b(255,255,255)),
            RTE("身上的任意装备",30,cc.c3b(255,0,0)),
            RTE("，里面的",30,cc.c3b(255,255,255)),
            RTE("宝石镶嵌",30,cc.c3b(255,0,0)),
            RTE("按钮可以让您给装备镶嵌宝石，装备没有孔也没关系，",30,cc.c3b(255,255,255)),
            RTE("熔炉",30,cc.c3b(255,0,0)),
            RTE("里",30,cc.c3b(255,255,255)),
            RTE("打造",30,cc.c3b(255,0,0)),
            RTE("几个",30,cc.c3b(255,255,255)),
            RTE("小锤子",30,cc.c3b(255,0,0)),
            RTE("开孔就行了！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==7 then
        return {
            RTE("低等级神器",30,cc.c3b(255,0,0)),
            RTE("可以将自己的神器属性原样",30,cc.c3b(255,255,255)),
            RTE("传承",30,cc.c3b(255,0,0)),
            RTE("给",30,cc.c3b(255,255,255)),
            RTE("高等级普通装备",30,cc.c3b(255,0,0)),
            RTE("，点开任意一件神器你就能很快的找到",30,cc.c3b(255,255,255)),
            RTE("神器传承",30,cc.c3b(255,0,0)),
            RTE("的按钮！",30,cc.c3b(255,255,255)),
        }
    elseif User.guide['boss']==8 then
        return {
            RTE("到",30,cc.c3b(255,255,255)),
            RTE("背包",30,cc.c3b(255,0,0)),
            RTE("里的",30,cc.c3b(255,255,255)),
            RTE("物品栏",30,cc.c3b(255,0,0)),
            RTE("里找到你拥有的宝石吧，点击",30,cc.c3b(255,255,255)),
            RTE("任意一个宝石",30,cc.c3b(255,0,0)),
            RTE("就能给",30,cc.c3b(255,255,255)),
            RTE("宝石升级",30,cc.c3b(255,0,0)),
            RTE("提升宝石的属性！",30,cc.c3b(255,255,255)),
        }
    else
        return {
            RTE("更多内容可点击主页上的帮助按钮查看",30,cc.c3b(255,255,255)),
        }
    end
end

function Guide:GuideBattle()
    return {
        RTE("从您进入游戏后就已经在自动战斗了，即使",30,cc.c3b(255,255,255)),
        RTE("退出游戏",30,cc.c3b(255,0,0)),
        RTE("甚至",30,cc.c3b(255,255,255)),
        RTE("关闭手机",30,cc.c3b(255,0,0)),
        RTE("都",30,cc.c3b(255,255,255)),
        RTE("不会停",30,cc.c3b(255,0,0)),
        RTE("（不消耗流量），只要您随时再回到游戏时就能收获一堆的经验金币和装备！",30,cc.c3b(255,255,255)),
    }
end

function Guide:GuideMap()
    return {
        RTE("点击",30,cc.c3b(255,255,255)),
        RTE("挑战BOSS",30,cc.c3b(255,0,0)),
        RTE("按钮战胜当前地图的BOSS就能开启下一级地图，开启后点击新地图就能到该地图挂机获得更多经验金币！",30,cc.c3b(255,255,255)),
    }
end

function Guide:GuideSkill()
    return {
        RTE("点击",30,cc.c3b(255,255,255)),
        RTE("更换技能",30,cc.c3b(255,0,0)),
        RTE("就能装备已学会的技能，技能按顺序施放，施放完后进行两次普通攻击，之后再次施放技能直到魔法值用完！",30,cc.c3b(255,255,255)),
    }
end

function Guide:GuidePartner()
    return {
        RTE("点击",30,cc.c3b(255,255,255)),
        RTE("休息中",30,cc.c3b(255,0,0)),
        RTE("按钮就能让佣兵为您",30,cc.c3b(255,255,255)),
        RTE("出战",30,cc.c3b(255,0,0)),
        RTE("！佣兵只能装备4件装备，他的等级将跟您保持一致。",30,cc.c3b(255,255,255)),
    }
end

function Guide:GuideDelEquipNew()
    return {
        RTE("熔炉可以将您",30,cc.c3b(255,255,255)),
        RTE("不要的装备",30,cc.c3b(255,0,0)),
        RTE("熔炼成",30,cc.c3b(255,255,255)),
        RTE("更高品质的装备",30,cc.c3b(255,0,0)),
        RTE("或",30,cc.c3b(255,255,255)),
        RTE("熔炼值",30,cc.c3b(255,0,0)),
        RTE("，熔炼值可以通过",30,cc.c3b(255,255,255)),
        RTE("普通打造",30,cc.c3b(255,0,0)),
        RTE("按钮打造高品质装备甚至神器！",30,cc.c3b(255,255,255)),
    }
end

return Guide