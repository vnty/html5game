--@module BattleOffline
-- 离线时回来以后计算这个过程中的战斗结果

require("src/UI/Battle")

local BattleOffline = {
  quickpve = false
}

function BattleOffline:show(quickpve, info, boxs)
    self.quickpve = quickpve
    local title = ""
    
    if(quickpve)then
        title = "快速战斗报告"
    else
        title = "离线战斗报告"
    end

    local contents = {}
    table.insert( contents, RTE("正在计算战斗结果...\n", 25, cc.c3b(255,255,255)) )

    -- info 格式 参数mapid ;返回 array(offlinetime -> 离线时间, battletime -> 战斗次数, mapid-> 地图id，oldlv -> 旧等级，newlv -> 升级后的等级 logs -> 战斗logs) 每个log格式array(输赢,怪物信息,经验值,金币,装备)
    local ots = tonum(info.offlinetime)
    local count = tonum(info.battletime)
    local mapid = tonum(info.mapid)
    local oldlv = tonum(info.oldlv)
    local newlv = tonum(info.newlv)
    local exp = tonum(info.addexp)
    local gold = tonum(info.addcoin)
    local s1 = tonum(info.adds1)
    local equipCount = {}
    local win = tonum(info.win)
    local sellequipCount = {}
    local equips = info.equips--放到背包里面的真实装备
    local sellequip = info.sellequip --被卖掉的装备统计
    local dropequip = info.dropequip --总掉落的装备统计
    --放到背包里面的真实装备创建下

    if(table.getn(equips) ~= 0)then
        for i=1,table.getn(equips) do
            BagUI:addEquipToBag(equips[i],true)
        end
    end
    --local log = info.logs
    --for k,v in pairs(log) do
--      local r = tonum(v[1])
--      if(r == 0)then
--        -- 输了       
--      else
--        -- 赢
--        exp = exp + tonum(v[3])
--        gold = gold + tonum(v[4])
--        if(v[5][1] == 1)then
--          local equip = v[5][2]
--          equipCount[tonum(equip.star)] = tonum(equipCount[tonum(equip.star)]) + 1
--          BagUI:addEquipToBag(equip,true)
--        elseif(v[5][1] == 2) then
--           sellequipCount[tonum(v[5][2])] = tonum(sellequipCount[tonum(v[5][2])]) + 1
--        end
--      end
--    end

    local WHITE = cc.c3b(255,255,255)
    
    if(self.quickpve == true)then
        table.insert( contents, RTE("在 ", 25, WHITE ))
    else
        table.insert( contents, RTE("在您离线的 ", 25, WHITE ))
    end
    
    table.insert( contents, RTE( UICommon.timeFormat(ots), 25, cc.c3b(51,255,102) ))
    table.insert( contents, RTE(" 内\n", 25, WHITE ))
    
    table.insert( contents, RTE("您在地图 ", 25, WHITE ))
    table.insert( contents, RTE( ConfigData.cfg_map[mapid].mname, 25, cc.c3b(51,255,102)  ))
    table.insert( contents, RTE("战斗了 ", 25, WHITE ))
    table.insert( contents, RTE(count, 25, cc.c3b(51,255,102) ))
    table.insert( contents, RTE(" 次\n", 25, WHITE))

    table.insert( contents, RTE("战胜：",25, WHITE))
    table.insert( contents, RTE(win .. "\n", 25, cc.c3b(51,255,102)  ))
        
    table.insert( contents, RTE("战败：",25, WHITE))
    table.insert( contents, RTE( count-win .. "\n", 25, cc.c3b(51,255,102)  ))
    
    table.insert( contents, RTE("获得经验：",25, WHITE ) )
    table.insert( contents, RTE( exp, 25, cc.c3b(51,255,102) ))
    if(newlv>oldlv)then
      table.insert( contents, RTE(" 人物等级从 ",25, cc.c3b(234,133,234) ) )
      table.insert( contents, RTE( oldlv, 25, cc.c3b(51,255,102) ))
      table.insert( contents, RTE(" 升级至 ", 25, cc.c3b(234,133,234) ) )
      table.insert( contents, RTE( newlv, 25, cc.c3b(51,255,102) ))
      GameUI:loadUinfo()
    else
      GameUI:addUserExp(exp)      
    end
    table.insert( contents, RTE("\n"))

    table.insert( contents, RTE("获得金币：",25, WHITE) )
    table.insert( contents, RTE( gold .. "\n", 25, cc.c3b(51,255,102) ))
    GameUI:addUserCoin(gold)
    
    if(s1 ~= nil and s1 ~= 0) then
        table.insert( contents, RTE("获得精华：" ,25, WHITE))
        table.insert( contents, RTE( s1 .."\n", 25, cc.c3b(51,255,102) ))
        GameUI:addUserJinghua(s1)
    end
    
    local hasEquip = false   
    for i = 1, 5 do
      if(tonum(dropequip[i]) > 0)then
        table.insert( contents, RTE( "掉落：", 25, WHITE))
        if(tonum(sellequip[i]) > 0)then
            table.insert( contents, RTE(User.starToText(i-1) .. "装备*" .. dropequip[i] .. " [自动卖出*" ..sellequip[i].."]\n", 25, User.starToColor(i-1) ))
        else
            table.insert( contents, RTE(User.starToText(i-1) .. "装备*" .. dropequip[i] .. "\n", 25, User.starToColor(i-1) ))
        end
        hasEquip = true
      end
    end
    
    local emptybox = {
            [31] = 0,
            [32] = 0,
            [33] = 0}
            
    if boxs == nil then       -- 掉落的宝箱
        boxs = {}
    end
    local box = 0
    local boxitem = 0
    local boxcount = 0
    for i=1,table.getn(boxs) do
        box = tonum(boxs[i]["box"])
        boxitem = tonum(boxs[i]["boxitem"])
        boxcount = tonum(boxs[i]["boxcount"])

        if(box ~= 0) then
            if(boxitem ~= 0 and boxcount ~= 0) then
                table.insert( contents, RTE("发现: ",25,cc.c3b(255,255,255)))
                table.insert( contents, RTE(ConfigData.cfg_item[box].name,25,User.starToColor(box%10+1)))
                table.insert( contents, RTE(" 使用",25,cc.c3b(255,255,255)))
                table.insert( contents, RTE(ConfigData.cfg_item[box-10].name,25,User.starToColor(box%10+1)))
                table.insert( contents, RTE(" 获得",25,cc.c3b(255,255,255)))
                table.insert( contents, RTE(ConfigData.cfg_item[boxitem].name.."*"..boxcount,25,User.starToColor(1)))
                table.insert( contents, RTE("\n"))
                -- 物品刷新
                BagUI:reduceItem(box-10, 1)
                BagUI:addItem(boxitem, boxcount)
            else
--                table.insert( contents, RTE(" 没有",25,cc.c3b(255,255,255)))
--                table.insert( contents, RTE(ConfigData.cfg_item[box-10].name,25,User.starToColor(box%10+1)))
--                table.insert( contents, RTE(" 遗憾地离开了",25,cc.c3b(255,255,255)))
--                table.insert( contents, RTE("\n"))
                emptybox[box] = emptybox[box] + 1
            end
        end
    end
    
    for i =33, 31, -1 do
        if emptybox[i] ~= 0 then
            table.insert( contents, RTE("发现: ",25,cc.c3b(255,255,255)))
            table.insert( contents, RTE(ConfigData.cfg_item[i].name.."*"..emptybox[i],25,User.starToColor(i%10+1)))
            table.insert( contents, RTE(" 没有",25,cc.c3b(255,255,255)))
            table.insert( contents, RTE(ConfigData.cfg_item[i-10].name,25,User.starToColor(i%10+1)))
            table.insert( contents, RTE(" 遗憾地离开了",25,cc.c3b(255,255,255)))
            table.insert( contents, RTE("\n"))
        end
    end
    
    BagUI:setNeedRefresh()
    BagUI:refreshUI()

    if(hasEquip == false)then
      table.insert( contents, RTE( "点背不能怪社会，命苦不能怨政府。 一件装备都没打到！ \n",25, WHITE))
    end
    DialogManager:showDialog("InfoDialogBattleOffline", title, contents)
end

return BattleOffline