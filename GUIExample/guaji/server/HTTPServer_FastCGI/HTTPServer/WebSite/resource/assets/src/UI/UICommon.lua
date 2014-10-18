--@module UICommon
UICommon = {
}

function UICommon.setEquipImg(img, equip, doNotShowTip)
    if doNotShowTip == nil then
        doNotShowTip = false
    end

    --cclog("setEquipImg %s", equip.ename)
    local label
    local ani
    local ani1
    local ani2
    local gem
  
    if(equip == nil)then
        -- 没有装备
        local gem = img:getChildByTag(9996)
        if(gem ~= nil)then
            gem:removeFromParent(true)
        end

        local label = img:getChildByTag(9997)
        if(label ~= nil)then
            label:removeFromParent(true)
        end
        label = img:getChildByTag(9998)
        if(label ~= nil)then
            label:removeFromParent(true)
        end
    
        ani = img:getChildByTag(9999)
        if(ani ~= nil)then
            ani:removeFromParent(true)
        end
        
        ani1 = img:getChildByTag(9995)
        if(ani1 ~= nil)then
            ani1:removeFromParent(true)
        end
        
        ani2 = img:getChildByTag(10000)
        if(ani2 ~= nil)then
            ani2:removeFromParent(true)
        end
    
        img:loadTexture( "res/ui/images/img_36.png")
        local i = ui_(img,"item")
        if not doNotShowTip then
            i:loadTexture("res/ui/icon/icon_18.png")
        else
            i:loadTexture("res/equip/0.png") 
        end
        return
    end
  
    local cfg = ConfigData.cfg_equip[toint(equip.ceid)]
    local star = 36 + tonum(equip.star)
    local picindex = tonum(cfg.picindex)
  
    img:loadTexture( string.format("res/ui/images/img_%d.png", star ) )
    ui_(img,"item"):loadTexture( string.format("res/equip/%s.png", picindex ) )
  
    -- 显示装备等级
    label = img:getChildByTag(9997)
    if(label == nil)then
        label = UICommon.createLabel( "Lv"..math.max(math.floor( tonum(cfg.lv) / 5 ) * 5, 1), 25)
        label:setColor(cc.c3b(255,255,255))
        label:setTag(9997)
        label:setAnchorPoint(0.5,0.5)
        label:setPosition(52,0)
        label:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        label:enableOutline(cc.c4b(0,0,0,255),2)     
        img:addChild(label)
    else
        label:setString("Lv"..math.max(math.floor( tonum(cfg.lv) / 5 ) * 5, 1))
    end  
    
    -- 双属性神器
    ani = img:getChildByTag(9999)
    ani1 = img:getChildByTag(9995)
    if User.isAdv2Equip(equip) then  --User.isAdvEquip(equip) and not User.isAdv2Equip(equip)
        if(ani == nil and ani1 == nil) then
            -- 设置神器特效
            ani = UICommon.createAnimation( "res/effects/main-equip3.plist", "res/effects/main-equip3.png", "adv3_%03d.png", 30, 12, cc.p(0.50,0.5),1.1 )
            ani1 = UICommon.createAnimation( "res/effects/main-equip.plist", "res/effects/main-equip.png", "_%03d.png", 25, 12, cc.p(0.50,0.5), 0.9 )
            ani:setTag(9999)
            img:addChild(ani)
            local s = img:getContentSize()
            ani:setPosition(s.width/2,s.height/2)
            ani1:setTag(9995)
            img:addChild(ani1)
            ani1:setPosition(s.width/2,s.height/2)
        end
    else
        if ani ~= nil then
            ani:removeFromParent()
        end
        if ani1 ~=nil then
            	ani1:removeFromParent()
        end
    end
    
    -- 普通神器
    ani2 = img:getChildByTag(10000)
    if User.isAdvEquip(equip) and not User.isAdv2Equip(equip) then
        if(ani2 == nil) then
            -- 设置神器特效
            ani2 = UICommon.createAnimation( "res/effects/main-equip.plist", "res/effects/main-equip.png", "_%03d.png", 25, 12, cc.p(0.50,0.5), 0.9 )
            ani2:setTag(10000)
            img:addChild(ani2)
            local s = img:getContentSize()
            ani2:setPosition(s.width/2,s.height/2)
        end
    else
        if(ani2 ~= nil)then
            ani2:removeFromParent()
        end
    end
  
    -- 显示强化+x
    label = img:getChildByTag(9998)
    if(label == nil)then
        if(tonum(equip.uplv) > 0)then
            label = UICommon.createLabel("+"..equip.uplv, 25)
          label:setColor(cc.c3b(255,255,255))
          label:setTag(9998)      
          label:setAnchorPoint(1,1)
          label:setPosition(95,95)
          label:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
          label:enableOutline(cc.c4b(0,0,0,255),2)      
          img:addChild(label)      
        end
    else
        label:setString("+"..equip.uplv)
    end
    
    -- 显示宝石镶嵌
    gem = img:getChildByTag(9996)
    local socks = tonum(equip.sock)
    if socks > 0 then
        local gems = string.split( equip.gemstr, "," )
        
        if gem == nil then
            gem = cc.Sprite:create()
            gem:setTag(9996)
            gem:setPosition(cc.p(53,20))
            gem:setAnchorPoint(cc.p(0.5,0.5))
            img:addChild(gem)
        end
        gem:removeAllChildren()
        local offset = (-socks + 1) * 18 / 2
        for i = 1, socks do
            local g = tonum(gems[i])
            -- 凹槽
            local s = cc.Sprite:create("res/ui/icon/icon_28.png")
            s:setPosition(cc.p(offset,0))
            s:setAnchorPoint(cc.p(0.5,0.5))
            gem:addChild(s)
            if g ~= 0 then
                --得到宝石的颜色
                local color = math.floor(g % 1000 / 100)
                local s = cc.Sprite:create( string.format("res/ui/icon/icon_%d.png", color + 28) )
                s:setPosition(cc.p(offset,0))
                s:setAnchorPoint(cc.p(0.5,0.5))
                gem:addChild(s)
            end
            offset = offset + 18
        end
    else
        if gem ~= nil then
            gem:removeFromParent()
        end
    end
    
end

-- 设置道具item img
function UICommon.setItemImg(item_img, itemid, count, showName,star)
    item_img:loadTexture( "res/ui/images/img_36.png")
    local starNum=36
    if(star~=nil)then
         starNum=36+star
    end
    item_img:loadTexture( string.format("res/ui/images/img_%d.png",starNum ) )
    local item = ui_(item_img,"item")
    
    local labelName  = item_img:getChildByTag(101)
    local labelCount = item_img:getChildByTag(100)
    if tonum(itemid) == 0 then
        if labelName ~= nil then
            labelName:removeFromParent()
        end

        if labelCount ~= nil then
            labelCount:removeFromParent()
        end
        
        UICommon.loadExternalTexture(item, "res/equip/0.png" )
        return
    end
    
        UICommon.loadExternalTexture(item, "res/item/"..tonum(itemid)..".png" )

    -- 数量和名字
    local s = ""
    if count > 0 then
        s = "x" .. count
        if labelCount == nil then
            labelCount = UICommon.createLabel( s, 25)
            labelCount:setColor(cc.c3b(255,255,255))
            labelCount:setAnchorPoint(1,0)
            labelCount:setPosition(90,10)
            labelCount:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
            labelCount:enableOutline(cc.c4b(0,0,0,255),2)
            labelCount:setTag(100)     
            item_img:addChild(labelCount)
        else
            labelCount:setString(s)
        end
    end
    
    local s = ConfigData.cfg_item[tonum(itemid)]["name"]
    if labelName == nil then
        labelName = UICommon.createLabel( s, 25)
        labelName:setColor(cc.c3b(255,255,255))
        labelName:setAnchorPoint(0.5,0.5)
        labelName:setPosition(52,-20)
        labelName:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
        labelName:setTag(101)
        labelName:enableOutline(cc.c4b(0,0,0,255),2)
        if(showName == nil or showName) then
            item_img:addChild(labelName)
        end    
    else
        labelName:setString(s)
    end
       
end

-- 设置玩家头像item img
function UICommon.setUserItemImg(item_img, v)
    local item = ui_(item_img,"item")

    local labelName = item_img:getChildByTag(100)
    local labelLv = item_img:getChildByTag(101)

    UICommon.loadExternalTexture( item, User.getUserHeadImg(v.ujob, v.sex) )

    -- 数量和名字
    if labelName == nil then
        labelName = UICommon.createLabel( v.uname, 25)
        labelName:setColor(cc.c3b(255,255,255))
        labelName:setAnchorPoint(0.5,0.5)
        labelName:setPosition(52,-20)
        labelName:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
        labelName:setTag(100)
        labelName:enableOutline(cc.c4b(0,0,0,255),2)
        item_img:addChild(labelName)
    else
        labelName:setString(v.uname)
    end

    if labelLv == nil then
        labelLv = UICommon.createLabel("Lv.".. v.ulv, 25)
        labelLv:setColor(cc.c3b(255,255,255))
        labelLv:setAnchorPoint( cc.p(0.5,0.5) )
        labelLv:setPosition(52,10)
        labelLv:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
        labelLv:enableOutline(cc.c4b(0,0,0,255),2)      
        item_img:addChild(labelLv)
    end  
end

-- flag 是否显示神器套装效果
function UICommon.showEquipDetails(parent, equip, minUpLv, showGems, GemSeparate)
    if showGems == nil then
        showGems = false
    end
    
    if GemSeparate == nil then
        GemSeparate = false
    end
    local size = parent:getContentSize()
  
    local rt = parent:getChildByTag(9999)
    if(rt ~= nil)then
        rt:removeFromParent(true)
    end
    local gemSprite = parent:getChildByTag(9998)
    if(gemSprite ~= nil)then
        gemSprite:removeFromParent(true)
    end
    
    rt = ccui.RichText:create()
  
    parent:addChild(rt)
  
    rt:setAnchorPoint(cc.p(0,1))
    rt:setTouchEnabled(false)
    rt:ignoreContentAdaptWithSize(false)
    rt:setContentSize(size)
    rt:setLocalZOrder(10)
    rt:setPosition(cc.p(0,size.height))
    rt:setTag(9999)
   
    -- 装备名字
    rt:pushBackElement( RTE(User.getEquipName(equip).."\n",30,User.starToColor(toint(equip.star))) )

    -- 职业限制
    if(tonum(equip.ejob) ~= 0)then
        rt:pushBackElement( RTE( string.format("只有 %s 可以装备\n", ConfigData.cfg_jobs[tonum(equip.ejob)] ),20, cc.c3b(255,255,0)) )    
    end
 
    -- 装备评分
    rt:pushBackElement( RTE( string.format("装备评分 %d\n", equip.score),20, cc.c3b(255,0,255)) )
    
    -- 装备主属性
    local propstr = ""
    if(toint(equip.p1) == 10 and toint(equip.p2) == 11) then -- 武器的主属性
        propstr = string.format( "伤害 %d - %d", User.getRealPvalue(equip.p1value, equip.star, equip.uplv), User.getRealPvalue(equip.p2value, equip.star, equip.uplv) ) 
    else
        propstr = User.getPropStr(toint(equip.p1), User.getRealPvalue(equip.p1value, equip.star, equip.uplv)  )
    end

    rt:pushBackElement( RTE(propstr.."\n",25,cc.c3b(255,255,255) ))
    
    local socks = tonum(equip.sock)
    local gemAdd = {}
    if GemSeparate and socks > 0 then
        local gems = string.split( equip.gemstr, "," )
        for i = 1, socks do
            local g = tonum(gems[i])
            if g ~= 0 then
                local cg = ConfigData.cfg_gem[g]
                gemAdd[toint(cg.type)] = {[1] = cg.name, [2] = tonum(cg.value)}
            end
        end
    end
    
    -- 装备副属性
    if(equip.pstr ~= "") then
        local pt = equip.ptable
        if GemSeparate then
            for i=1,4 do
                local propstr2 = ""
                if gemAdd[i] ~= nil then
                    local cf = ConfigData.cfg_equip_prop[i] 
                    if(cf[2] == 1)then
                        propstr2 =  string.format( cf[1] .. " " .. cf[3], pt[i] - toint(gemAdd[i][2]))
                    elseif(cf[2] == 2)then
                        propstr2 =  string.format( cf[1] .. " " .. cf[3], (pt[i] - toint(gemAdd[i][2])) * 0.01)
                    end
                    propstr2 = propstr2 .. " [" .. gemAdd[i][1] .. " +" .. gemAdd[i][2] .. "]\n"
                else
                    if pt[i] ~= nil then
                        propstr2 = User.getPropStr(i, pt[i]) .. "\n"
                    end
                end
                rt:pushBackElement( RTE(propstr2,20,User.starToColor(toint(equip.star))))
            end
        else
            propstr = User.itemPropTableToText2(pt)
            rt:pushBackElement( RTE(propstr,20,User.starToColor(toint(equip.star))))
        end
    end
  
    -- 神器属性
    if(User.isAdvEquip(equip))then
        rt:pushBackElement( RTE( string.format("%d星神器：\n", equip.advlv),20, cc.c3b(255,0,0)))
       
        local advp = toint(equip.advp)
        local advp1 = advp
        local advp2 = 0
        if User.isAdv2Equip(equip) then
            advp1 = advp % 1000
            advp2 = math.floor(advp / 1000)
        end
        
        propstr = User.getPropStr(toint(advp1), ConfigData.cfg_equip_prop[advp1][4] * tonum(equip.advlv) )
        rt:pushBackElement( RTE( propstr .. "\n",20, cc.c3b(255,0,0) ))
        
        if User.isAdv2Equip(equip) then
            propstr = User.getPropStr(toint(advp2), ConfigData.cfg_equip_prop[advp2][4] * tonum(equip.advlv) )
            rt:pushBackElement( RTE( propstr .. "\n",20, cc.c3b(255,0,0) ))
        end
                
        local expmin = math.pow(tonum(equip.advlv) - 1, 2)
        local expmax = math.pow(tonum(equip.advlv), 2)
        local exp = tonum(equip.advexp)
        --rt:pushBackElement( RTE( string.format( "神器经验： %d/%d\n", exp, expmax - expmin) ,20, cc.c3b(255,0,0)  ))
    
        --10件+1装备额外攻击吸血+2%
        --10件+2装备额外攻击吸血+4%
        local all_elv = 1
        local advlv = tonum(equip.advlv)
        local realadd = all_elv
        if(all_elv >= advlv + 2)then
            realadd = advlv + 2
        end
    
        -- 神器套装属性
        if minUpLv ~= nil then
            local p1 = ConfigData.cfg_equip_prop[advp1][4]
            local p2 = 0
            if User.isAdv2Equip(equip) then
                p2 = ConfigData.cfg_equip_prop[advp2][4]
            end
            
            if minUpLv > 0 then
                local up = math.min(minUpLv, advlv)
                rt:pushBackElement( RTE( string.format("%s [全身强化+%d激活 已激活]\n", User.getPropStr(advp1, p1 * up), math.min(minUpLv,advlv)), 20, cc.c3b(0,255,0) ))
            end

            if(minUpLv < advlv)then
                rt:pushBackElement ( RTE( string.format("%s [全身强化+%d激活 未激活]\n", User.getPropStr(advp1, p1 * (minUpLv + 1)), minUpLv + 1), 20, cc.c3b(128,128,128) ))
            end
            
            if User.isAdv2Equip(equip) then
                if minUpLv > 0 then
                    local up = math.min(minUpLv, advlv)
                    rt:pushBackElement( RTE( string.format("%s [全身强化+%d激活 已激活]\n", User.getPropStr(advp2, p2 * up), math.min(minUpLv,advlv)), 20, cc.c3b(0,255,0) ))
                end

                if(minUpLv < advlv)then
                    rt:pushBackElement( RTE( string.format("%s [全身强化+%d激活 未激活]\n", User.getPropStr(advp2, p2 * (minUpLv + 1)), minUpLv + 1), 20, cc.c3b(128,128,128) ))
                end
            end
            
            if(minUpLv >= advlv) then
                rt:pushBackElement ( RTE( string.format("当前星级最大值\n"), 20, cc.c3b(128,128,128) ))
            end
        end
    end

    local realSize = nil
    
    -- 镶嵌了的宝石详情
    local socks = tonum(equip.sock)
    if showGems and socks > 0 then
        local gems = string.split( equip.gemstr, "," )
                
        for i = 1, socks do
            local g = tonum(gems[i])
            if g ~= 0 then
                local cg = ConfigData.cfg_gem[g]
                rt:pushBackElement ( RTE( string.format("%s %s\n", cg.name, User.getPropStr(toint(cg.type), tonum(cg.value))), 20, cc.c3b(245,3,247) ))
            end
        end
        
        rt:formatText()
        realSize = rt:getRealSize()
                
        gemSprite = cc.Sprite:create()
        gemSprite:setTag(9998)
        gemSprite:setPosition(cc.p(0, size.height - realSize.height - 13))
        gemSprite:setAnchorPoint(cc.p(0,1))
        parent:addChild(gemSprite)
        
        local offset = 0
        for i = 1, socks do
            local g = tonum(gems[i])
            -- 凹槽
            local back = nil
            if g == 0 then
                back = cc.Sprite:create("res/ui/images/img_36.png")
            else
                back = cc.Sprite:create("res/ui/images/img_39.png")
                local s = cc.Sprite:create( string.format("res/item/%d.png", g) )
                s:setPosition(cc.p(53,53))
                s:setAnchorPoint(cc.p(0.5,0.5))
                back:addChild(s)
            end
            back:setPosition(cc.p(offset,0))
            back:setAnchorPoint(cc.p(0,1))
            back:setScale(0.5,0.5)
            gemSprite:addChild(back)
            offset = offset + 73
        end
        
        realSize.height = realSize.height + 54 + 13
    else
        rt:formatText()
        realSize = rt:getRealSize()
    end

    return realSize
end

-- 在Penal里面创建一个左上角对齐的RichText，尺寸与Panel一样大
function UICommon.createRichText(pnl, rtes)
    local s = pnl:getContentSize()
    local info = ccui.RichText:create()
    info:setPosition(0,s.height)
    info:setAnchorPoint( cc.p(0,1) )
    info:ignoreContentAdaptWithSize(false)
    info:setContentSize(s)
    --info:setLocalZOrder(10)
    pnl:addChild(info)

    for _,v in pairs(rtes) do
        info:pushBackElement(v)
    end
    
    return info
end

function UICommon.createLabel(text, size)
    --return cc.Label:createWithTTF( text, Config.font, size)
    return cc.Label:createWithSystemFont( text, "", size)
end

function UICommon.timeFormatNumber(ts)
    local str = ""
    if(ts < 0)then
        str = "-"
        ts = -ts
    end

    local h = math.floor(ts / 3600)
    if(h >= 10)then
        str = str .. h .. ":"
    else
        str = str.."0"..h..":"
    end
    ts = ts % 3600
    
    local min = math.floor(ts / 60)
    if(min >= 10)then
        str = str .. min .. ":"
    else
        str = str.."0"..min..":"
    end
    ts = ts % 60
    
    local sec = math.floor(ts % 60)
    if(sec >= 10)then
        str = str .. sec
    else
        str = str.."0"..sec
    end
    
    return str
    
end

-- 以秒为单位
function UICommon.timeFormat(ts)
  local str = ""
  if(ts < 0)then
    str = "-"
    ts = -ts
  end
  
  local h = math.floor(ts / 3600)
  if(h > 0)then
    str = str .. h .. "小时"
    ts = ts % 3600
  end
  
  local min = math.floor(ts / 60)
  if(min > 0)then
    str = str .. min .. "分钟"
  end
  
  return str .. (ts % 60) .. "秒"
  
end

-- 以分为单位
function UICommon.timeFormatMin(ts)
  local str = ""
  if(ts < 0)then
    str = "-"
    ts = -ts
  end
  
  local d = math.floor(ts / 24 / 3600)
  if(d > 0)then
    str = str .. d .. "天"
    ts = ts % (3600 * 24)
  end
  
  local h = math.floor(ts / 3600)
  if(h > 0)then
    str = str .. h .. "小时"
    ts = ts % 3600
  end
  
  local min = math.floor(ts / 60)
  if(min > 0)then
    str = str .. min .. "分钟"
  end
  
  return str
end

-- 距离当前时间多少
function UICommon.timeAgoStr(ts)
    if ts < 60 then
        return ts .. "秒前"
    else
        local min = math.floor(ts / 60)
        if min < 60 then
            return min.."分钟前"
        elseif min < 24 * 60 then
            local hour = math.floor(ts / 3600)
            return hour.."小时前"
        else
            local day = math.floor(ts / 86400)
            if day < 5 then
                return day.."天前"
            else
                return "5天前"
            end
        end
    end
end

-- ImageView加载外部图片
function UICommon.loadExternalTexture(img,filename)
    if( not cc.FileUtils:getInstance():isFileExist(filename) )then
      cclog("Texture file " .. filename .. " does not exist")
      return
    end
    
    img:loadTexture(filename)
end

-- Button加载外部图片
function UICommon.loadExternalTextureNormal(img,filename)
    if( not cc.FileUtils:getInstance():isFileExist(filename) )then
        cclog("Texture file " .. filename .. " does not exist")
        return
    end

    img:loadTextureNormal(filename)
end

function UICommon.setVisible(o,f)
    o:setVisible(f)
    o:setTouchEnabled(f)
end

function UICommon.createAnimation(plist, png, format, totalFrames, fps, anchorPoint, scale,dorepeat)
  local cache = cc.SpriteFrameCache:getInstance()
  cache:addSpriteFrames(plist, png)

  local sprite = cc.Sprite:createWithSpriteFrameName( string.format(format, 1) )
  --local spriteBatch = cc.SpriteBatchNode:create(png)
  --cclog("spriteBatch = " .. tostring(tolua.isnull(spriteBatch)))
  --cclog("sprite = " .. tostring(tolua.isnull(sprite)))
  if(anchorPoint ~= nil)then
    sprite:setAnchorPoint(anchorPoint)
  end
  if(scale ~= nil)then
    sprite:setScale(scale)    
  end
  --spriteBatch:addChild(sprite)
  sprite:setPosition(cc.p(0, 0))

  local animFrames = {}
  for i =1,totalFrames do
      local frame = cache:getSpriteFrame(string.format(format, i))
      animFrames[i] = frame
  end

  local animation = cc.Animation:createWithSpriteFrames(animFrames, 1 / fps)
    --local action=cc.RepeatForever:create(cc.Animate:create(animation))
    local action
  if(not dorepeat or dorepeat==0) then
        action=cc.RepeatForever:create(cc.Animate:create(animation))
  else
        local crepeat=cc.Repeat:create(cc.Animate:create(animation),dorepeat)
        action=cc.Sequence:create(crepeat,cc.CallFunc:create(function() sprite:removeFromParent() end))
  end
  sprite:runAction(action)
  sprite:setBlendFunc(gl.DST_ALPHA, gl.ONE)
  
  return sprite
end
