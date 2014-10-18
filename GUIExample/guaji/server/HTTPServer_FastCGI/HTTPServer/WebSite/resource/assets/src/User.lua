User = {
    server = "",
    uidkey =nil
}

function User.init()
 User.uname = ""
 User.uid = 0
 User.ucoin = 0
 User.ulv = 0
 User.uexp = 0
 User.uptime = 0
 User.umid = 0
 User.ug = 0
 User.bag = 0
 User.ujob = 0
 User.usex = 0
 User.step = 0
 User.pvb = 0
 User.vip = 0
 User.vippay = 0
 User.buycoin = 0
 User.mail = 0
 User.s1 = 0
 User.uluck = 0 -- 宝石升级幸运值
  
 User.ulvExpMin = 0 -- 当前等级起始经验
 User.ulvExpMax = 0 -- 当前等级满级经验
  
 User.zhanli = 0  -- 战力
 User.partnerskill = 0 -- 佣兵技能随机次数
 
 User.paygift = 1 -- 首冲标志, 1为首冲过了 0为没首冲过
 User.uCheng = 0 -- 用户称号1-9,0是没有称号
 User.userItems  = {}      -- 所有道具
 User.userEquips = {}      -- 背包里的装备 [ eid: equip, ... ]，包括已经装备了的
 User.userEquip = {}       -- 装备列表 { 部位:eid, 部位:eid, ... }， 根据部位查找
  
 User.userPartnerEquip = {} -- 佣兵的装备列表
  
 User.userProps = {}       -- 玩家基础属性，未带装备加成
 User.userEquipProps = {}   -- 玩家装备加成属性
 User.userPvpList = {}      -- 玩家pvp列表
  
 User.userSkill = {}       -- 装备的技能 sid
 User.userPvpSkill = {}    -- 装备的pvp技能
 User.userCheng = {}       -- 用户称号集合child，type
 User.tiliUpdateScheduler = nil
 
 User.guide = {}
 
 -- 伤害增加
 User.dmgAddTable = {
    [1] = 1, -- 战士->力量
    [2] = 2, -- 猎人->敏捷
    [3] = 3  -- 法师->智力
  }
end

User.init()

-- 装备字符串
function User.equipToString(equip)
  local es = ""
  table.foreach(equip, function(k,v)
      es = es .. "," .. v.eid
  end)
  
  if(string.len(es)>0)then
    es = string.sub(es, 2)
  end
  
  return es
end

function User.starToColor(star)
  star = tonum(star)
  if(star == 0) then
    return cc.c3b(99, 99, 99)
  elseif(star == 1) then
    return cc.c3b(19, 255, 19)
  elseif(star == 2) then
    return cc.c3b(0, 153, 255)
  elseif(star == 3) then
    return cc.c3b(255, 51, 255)
  elseif(star == 4) then
    return cc.c3b(255, 204, 0)
  else
    return cc.c3b(255, 0, 0)
  end 
end

function User.getSubColor()
    return cc.c3b(255,0,0)
end

function User.getAddColor()
    return cc.c3b(0,255,0)
end

function User.getCoinColor()
    return cc.c3b(255,255,0)
end

function User.getUgColor()
    return cc.c3b(0,204,255)
end

function User.getTextColor()
    return cc.c3b(111,40,20)
end

function User.getRonglianValue(star)
  star = tonum(star)
  if(star == 0) then
    return 5
  elseif(star == 1) then
    return 10
  elseif(star == 2) then
    return 20
  elseif(star == 3) then
    return 50
  elseif(star == 4) then
    return 150
  else
    return 0
  end 
end

--取得称号
function User.getChengHao(chid)
    local item = ConfigData.cfg_chenghao[toint(chid)]
    local color = User.starToColor(toint(item.type))
    local imgUrl
    if toint(item.type) == 2 then
        imgUrl =  "res/ui/images/img_232.png" 
    elseif toint(item.type) == 3 then
        imgUrl = "res/ui/images/img_231.png" 
    end
 
    return item,color,imgUrl
end

function User.starToText(star)
  star = tonum(star)
  if(star == 0) then
    return "白色"
  elseif(star == 1) then
    return "绿色"
  elseif(star == 2) then
    return "蓝色"
  elseif(star == 3) then
    return "紫色"
  elseif(star == 4) then
    return "橙色"
  else
    return "未知颜色 " .. star
  end 
end

-- 计算玩家属性系统
function User.getBaseProps(job,lv)
    --人物初始属性：
    --伤害：5-10
    --战士：力量11 敏捷9 智力9 耐力 11
    --猎人：力量9 敏捷 12 智力9 耐力 10
    --法师：力量9 敏捷 9 智力 12 耐力 10
    --升级增加属性：
    --战士每升一级加3点力量，2点耐力，1点敏捷，1点智力
    --猎人每升一级加3点敏捷，2点耐力，1点力量，1点智力
    --法师每升一级加3点智力，2点耐力，1点敏捷，1点力量
    -- 每点力量增加战士0.5点最小伤害，1点最大伤害
    -- 每点敏捷增加猎人0.5点最小伤害，1点最大伤害
    -- 每点智力增加法师0.5点最小伤害，1点最大伤害
  
    --缩写 力量str 敏捷agi 智力int 耐力vit 伤害dmg，最大最小伤害 dmgmin dmgmax
    --护甲def 魔抗mdef 命中dex 暴击cri 闪避ev 韧性res
    -- HP hpmax MP mpmax 物抗pdef
    -- 属性id参见ConfigData.cfg_equip_prop
  
    -- 先计算一级属性
    local init = {
        [1] = { 11, 9, 9, 11 }, -- 战士
        [2] = { 9, 12, 9, 10 }, -- 猎人
        [3] = { 9, 9, 12, 10 } } -- 法师

    local add = {
        [1] = { 3, 1, 1, 2 }, -- 战士
        [2] = { 1, 3, 1, 2 }, -- 猎人
        [3] = { 1, 1, 3, 2 } }-- 法师
    
    local baseProps = {}
    
    baseProps[1] = init[job][1] + add[job][1] * lv -- 力量
    baseProps[2] = init[job][2] + add[job][2] * lv -- 敏
    baseProps[3] = init[job][3] + add[job][3] * lv -- 智力
    baseProps[4] = init[job][4] + add[job][4] * lv -- 耐力
  
    baseProps[10] = 5
    baseProps[11] = 10
    
    return baseProps
end

function User.onEquipProps(eps)
   User.userEquipProps = {}
   User.equipPropsToTable(User.userEquipProps,eps)
   User.updateSecondProps(User.userEquipProps,User.ujob, 0)
end

function User.equipPropsToTable(t, eps, job)
  local ep = string.split(eps,",")
  table.foreach(ep, function(k,v)
    local p = string.split(v,"|")
    t[tonum(p[1])] = tonum(t[tonum(p[1])]) + tonum(p[2])  
  end)
end

-- 计算二级属性
-- TODO: 计算MP放到一级属性里面去
function User.updateSecondProps(t, job, ulv)
    ulv = tonum(ulv)
    t[26] = tonum(t[26]) + tonum(t[4]) * 10                   -- HP
    t[27] = tonum(t[27]) + ulv * 20                           -- MP
    t[31] = tonum(t[31]) + tonum(t[1]) * 1.0  -- 物抗
    t[7]  = toint(tonum(t[7]) + tonum(t[1]) * 0.6 + 0.6 * ulv * ulv)   -- 命中
    t[8]  = tonum(t[8]) + tonum(t[2]) * 0.2   -- 闪避
    t[12] = tonum(t[12]) + tonum(t[2]) * 1.0  -- 暴击
    t[6]  = tonum(t[6]) + tonum(t[3]) * 1.0   -- 魔抗
    t[9]  = tonum(t[9]) + tonum(t[4]) * 1.0   -- 韧性
    t[5]  = tonum(t[5])                       -- 护甲  
    
    t[10] = tonum(t[10]) + tonum(t[User.dmgAddTable[tonum(job)]]) * 0.5       -- 最小伤害
    t[11] = tonum(t[11]) + tonum(t[User.dmgAddTable[tonum(job)]]) * 1.0       -- 最大伤害

    -- 物理/魔法穿透属性
    t[46] = tonum(t[46])      -- 无视物抗
    t[47] = tonum(t[47])      -- 无视魔抗
end

-- 百分比属性
function User.updateThirdPros(t)
    t[26] = toint(tonum(t[26]) * (1 + User.userEquipProps[39] / 10000))  -- HP
    t[31] = tonum(t[31]) * (1 + User.userEquipProps[33] / 10000)  -- 物抗
    t[7]  = tonum(t[7]) * (1 + User.userEquipProps[35] / 10000)   -- 命中
    t[8]  = tonum(t[8]) * (1 + User.userEquipProps[36] / 10000)   -- 闪避
    t[12] = tonum(t[12]) * (1 + User.userEquipProps[38] / 10000)  -- 暴击
    t[6]  = tonum(t[6]) * (1 + User.userEquipProps[34] / 10000)   -- 魔抗
    t[9]  = tonum(t[9]) * (1 + User.userEquipProps[37] / 10000)   -- 韧性
    t[5]  = tonum(t[5]) * (1 + User.userEquipProps[48] / 10000)                      -- 护甲  

    t[10] = tonum(t[10]) + tonum(t[14])      -- 最小伤害
    t[11] = tonum(t[11]) + tonum(t[14])      -- 最大伤害
end

-- 装备附加属性字符串转换成合并后的属性表，并对装备评分
-- 还有装备的宝石镶嵌信息
User.updateEquipInfo = function(e)

    -- 装备属性字符串 -> 属性table
    local pstr = e.pstr
    local props = string.split(pstr,',')
    local props_combine = {}
    table.foreach(props, function(k,v)
            local p = string.split(v,"|")
            local pi = tonum(p[1])
            if(pi > 0)then
                if(props_combine[pi] == nil) then
                props_combine[pi] = tonum(p[2]) 
            else
                props_combine[pi] = props_combine[pi] + tonum(p[2])
            end
        end
    end)

    e.ptable = props_combine
  
    -- 装备主属性+装备跟主属性相同的副属性+力量*2+敏捷*2+智力*2+体力*2
    local score = 0
    if(tonum(e.p1) == 26 or tonum(e.p1) == 27)then
        score = score + tonum(User.getRealPvalue(e.p1value,e.star,e.uplv)) / 10 -- HP和MP要打折
    else
        score = score + tonum(User.getRealPvalue(e.p1value,e.star,e.uplv))
    end
    if(tonum(e.p2) > 0)then
        score = score + tonum(User.getRealPvalue(e.p2value,e.star,e.uplv))
    end
    
    score = score + tonum(props_combine[1]) * 2
    score = score + tonum(props_combine[2]) * 2
    score = score + tonum(props_combine[3]) * 2
    score = score + tonum(props_combine[4]) * 2
    
    e.score = score
end

-- 装备属性表转换成属性可读字符串
User.itemPropTableToText = function(t)
    local propstr = ""
    local i = 0
    table.foreach(t, function(k,v)
      propstr = propstr .. User.getPropStr(k, v)
      i = i + 1 
      if(i % 2 == 0)then
        propstr = propstr .. "\n"
      else  
        propstr = propstr .. "    "
      end
    end)
    
    return propstr
end

-- 装备属性表转换成属性可读字符串
User.itemPropTableToText2 = function(t)
    local propstr = ""
    table.foreach(t, function(k,v)
      propstr = propstr .. User.getPropStr(k, v) .. "\n"
    end)
    
    return propstr
end

function User.isEquiped(e)
  return tonum(e.euser) ~= 0 
end

-- 装备是否装备在雇佣兵上
function User.isEquipedByPartner(e)
  return tonum(e.euser) ~= 0 and tonum(e.euser) ~= 1
end

-- 是否为神器
function User.isAdvEquip(e)
  return tonum(e.advp) ~= 0
end

-- 是否为双属性神器
function User.isAdv2Equip(e)
    return tonum(e.advp) >= 1000
end

function User.isUpLv(e)
    return tonum(e.uplv) ~= 0
end

function User.isGemEquip(e)
    return e.gemstr ~= nil and e.gemstr ~= ""
end

-- 装备是否符合职业
function User.isJobFit(e,job)
  local ejob = tonum(e.ejob) 
  return ejob == 0 or ejob == tonum(job)
end

-- 根据装备属性得到名字
function User.getEquipName(v)  
  local cf = ConfigData.cfg_equip[tonum(v.ceid)]
  if(cf ~= nil)then
    local str = "Lv".. math.max(math.floor( tonum(cf.lv) / 5 ) * 5, 1) .. " " .. v.ename
  
    if(tonum(v.uplv) > 0)then
      str = str .. "+" .. v.uplv .. ""
    end
    return str
  else  
    return "错误装备 " .. v.ename
  end
end

-- 装备比较
function User.equipCompare(a,b)
  
  -- 先按评分来
  if( tonum(a.score) ~= tonum(b.score) ) then
    return tonum(a.score) > tonum(b.score)
  end

  -- 再按是否是神器来
  local isMainA = User.isAdvEquip(a)
  local isMainB = User.isAdvEquip(b)
  if(isMainA ~= isMainB)then
    return isMainA
  end
    
  return tonum(ConfigData.cfg_equip[tonum(a.ceid)].lv) > tonum(ConfigData.cfg_equip[tonum(b.ceid)].lv)
end

function User.getJobName(job)
  return ConfigData.cfg_jobs[tonum(job)]
end

-- 获得装备强化信息，返回 所需精华, 强化比例
function User.getEquipUpInfo(star, uplv, elv, type)
    star = tonum(star)
    uplv = tonum(uplv)
    elv = tonum(elv)
    type = tonum(type)
    
    local sa = { [0] = 0.2, [1] = 0.4, [2] = 0.6, [3] = 0.8, [4] = 1.0 }
    local sd = {[1]=2, [2]=1, [3]=0.5, [5]=0.5, [6]=1, [7]=0.5, [8]=1, [10]=1, [12]=0.5, [14]=1}
    
    local c = 0
    local add = 0
    local per = math.floor(uplv / 5) * 0.05 + 0.1
    c = per * sa[star]
    add = per * sa[star]
    return math.floor( (0.1* (uplv + 1) * (uplv + 1) + 5 * (uplv + 1) + 5 )*(0.5 * elv + 4.5)*c*sd[type] ), math.floor(100 * add)
end

function User.getRealPvalue(base, star, uplv)
    base = tonum(base)
    star = tonum(star)
    uplv = tonum(uplv)
    local sa = { [0] = 0.2, [1] = 0.4, [2] = 0.6, [3] = 0.8, [4] = 1.0 }
    if(uplv > 10)then
        return (1 + sa[star] * uplv * 0.2 - sa[star] * 0.75) * base
    elseif(uplv > 5)then
        return (1 + sa[star] * uplv * 0.15 - sa[star] * 0.25) * base
    else
        return (1 + sa[star] * uplv * 0.1) * base
    end
end

function User.getUserImg(job,sex)
    job = tonum(job)
    sex = tonum(sex)
    if(sex == 1)then
        if(job == 1)then
            return "res/hero/imghero_005.jpg"
        elseif(job == 2)then
            return "res/hero/imghero_001.jpg"
        elseif(job == 3)then
            return "res/hero/imghero_003.jpg"
        end
    else
        if(job == 1)then
            return "res/hero/imghero_006.jpg"
        elseif(job == 2)then
            return "res/hero/imghero_002.jpg"
        elseif(job == 3)then
            return "res/hero/imghero_004.jpg"
        end  
  end
end

function User.getUserJobIcon(job)
    if job == 1 then
        return "res/ui/images/img_08.png"
    elseif job == 2 then
        return "res/ui/images/img_07.png"
    elseif job == 3 then
        return "res/ui/images/img_09.png"
    end
end

function User.getUserHeadImg(job,sex)
    job = tonum(job)
    sex = tonum(sex)
    if(sex == 1)then
        if(job == 1)then
            return "res/hero/hero_005.png"
        elseif(job == 2)then
            return "res/hero/hero_001.png"
        elseif(job == 3)then
            return "res/hero/hero_003.png"
        end
    else
        if(job == 1)then
            return "res/hero/hero_006.png"
        elseif(job == 2)then
            return "res/hero/hero_002.png"
        elseif(job == 3)then
            return "res/hero/hero_004.png"
        end  
    end
end

function User.getPartnerHead(p)
    return "res/hero/p_" .. p.picindex .. ".png"
end

-- 格式： 力量 +10  暴击伤害 +1.0%
function User.getPropStr(p, v)
    local cf = ConfigData.cfg_equip_prop[tonum(p)] 
    if(cf[2] == 1)then
        return string.format( cf[1] .. " " .. cf[3], v)
    elseif(cf[2] == 2)then
        return string.format( cf[1] .. " " .. cf[3], v * 0.01)
    end
end

-- 格式： +10  +1.0%
function User.getPropStr2(p, v)
    local cf = ConfigData.cfg_equip_prop[p] 
    if(cf[2] == 1)then
        return string.format( cf[3], v)
    elseif(cf[2] == 2)then
        return string.format( cf[3], v * 0.01)
    end
end

-- 格式： 10  1.0
function User.getPropStr3(p, v)
    local cf = ConfigData.cfg_equip_prop[p] 
    if(cf[2] == 1)then
        return string.format( "%d", v)
    elseif(cf[2] == 2)then
        return string.format( "%.1f%%", v * 0.01)
    end
end

-- 得到全身装备里面强化等级最低的
function User.getEquipMinUpLv()
    local up = 99999
    for k,_ in pairs(ConfigData.cfg_equip_etype) do
        local eid = tonum(User.userEquip[k])
        if eid == 0 then
            return 0
        end
        
        up = math.min(up, tonum(User.userEquips[eid].uplv) )
    end

    return up
end

function User.getEquipMinUpLvPvp(pvpEquips)
    local up = 99999
    for k,_ in pairs(ConfigData.cfg_equip_etype) do
        local v = pvpEquips[k]
        if v == nil then
            return 0
        end

        up = math.min(up, tonum(v.uplv) )
    end

    return up
end

function User.loadGuide()
    local function callback(params)
        if params[1] == 1 then
            table.foreach(params[2],function(k,v)
                User.guide[k] = toint(v)
                if k == "skill" or k == "map" or k == "battle" or k == "partner" then
                    if toint(v) == 0 then
                        User.setGuide(k)
                    end
                end
            end)
        end
    end
    sendCommand("getGuideInfo",callback)
end

function User.showGuide(type)
    if User.guide[type] == nil then
        -- 未初始化,先直接不显示吧
        return
    end
    if type == "boss" then
        if User.guide['boss'] >= 9 then
            return
        end
    elseif type == "battle" then
        if User.guide['battle'] >= 1 then
            return
        end
    elseif type == "map" then
        if User.guide['map'] >= 1 then
            return
        end
    elseif type == "skill" then
        if User.ulv < 5 then
            return 
        end
        if User.guide['skill'] >= 1 then
            return
        end
    elseif type == "partner" then
        if User.ulv < 15 then
            return 
        end
        if User.guide['partner'] >= 1 then
            return
        end
    elseif type == "delequipnew" then
        if User.guide['delequipnew'] >= 1 then
            return
        end
    else
        return
    end
    sendCommand("viewGuide",function(params)
        --通知服务器端
        if params[1] == 1 then
            if type == "boss" then
                User.guide[type] = math.min(User.guide[type] + 1, 9)
            else
                User.guide[type] = 1
            end
        end
    end,{type})
    DialogManager:showDialog("Guide",type)
end

function User.setGuide(type)
    if User.guide[type] == nil then
        -- 未初始化,先直接不显示吧
        return
    end
    if type == "boss" then
        if User.guide['boss'] >= 9 then
            return
        elseif User.guide['boss'] == 0 then
            User.setGuideIcon("quickbattle")
        elseif User.guide['boss'] == 1 then
            User.setGuideIcon("main")
            User.setGuideIcon("shop")
        elseif User.guide['boss'] == 2 then
        elseif User.guide['boss'] == 3 then
            if User.ulv < 10 then
                return 
            end
        elseif User.guide['boss'] == 4 then
            if User.ulv < 15 then
                return 
            end
            User.setGuideIcon("partner")
            User.setGuideIcon("uppartner")
        elseif User.guide['boss'] == 5 then
            if User.ulv < 15 then
                return 
            end
        elseif User.guide['boss'] == 6 then
            if User.ulv < 20 then
                return 
            end
        elseif User.guide['boss'] == 7 then
            if User.ulv < 20 then
                return 
            end
        elseif User.guide['boss'] == 8 then
            if User.ulv < 20 then
                return 
            end
            User.setGuideIcon("item")
        end
        User.showGuide(type)
    elseif type == "battle" then
        if User.guide['battle'] >= 1 then
            return
        else
            User.setGuideIcon("battle")
        end
    elseif type == "map" then
        if User.guide['map'] >= 1 then
            return
        else
            User.setGuideIcon("map")
        end
    elseif type == "skill" then
        if User.ulv < 5 then
            return 
        end
        if User.guide['skill'] >= 1 then
            return
        end
        User.setGuideIcon("skill")
    elseif type == "partner" then
        if User.ulv < 15 then
            return 
        end
        if User.guide['partner'] >= 1 then
            return
        end
        User.setGuideIcon("partner")
    elseif type == "delequipnew" then
        if User.guide['delequipnew'] >= 1 then
            return
        end
        User.setGuideIcon("delequipnew")
    else
        return
    end
end

function User.setGuideIcon(type)
    if type == "skill" or type == "battle" or type == "partner" or type == "main" then
        MainBtn:setGuideIcon(type)
    elseif type == "shop" or type == "delequipnew" then
        MainUI:setGuideIcon(type)
    elseif type == "map" or type == "quickbattle" then
        BattleUI:setGuideIcon(type)
    elseif type == "uppartner" then
        PartnerUI:setGuideIcon(type)
    elseif type == "item" then
        BagUI:setGuideIcon(type)
    end  
end

function User.removeGuideIcon(type)
    if type == "skill" or type == "battle" or type == "partner" then
        MainBtn:removeGuideIcon(type)
    elseif type == "shop" or type == "delequipnew" then
        MainUI:removeGuideIcon(type)
    elseif type == "map" or type == "quickbattle" then
        BattleUI:removeGuideIcon(type)
    elseif type == "uppartner" then
        PartnerUI:removeGuideIcon(type)
    elseif type == "item" then
        BagUI:removeGuideIcon(type)
    end
end

return User