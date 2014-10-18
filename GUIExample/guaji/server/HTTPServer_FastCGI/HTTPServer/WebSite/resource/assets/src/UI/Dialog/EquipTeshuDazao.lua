-- 多人团战
local EquipTeshuDazao = {
    ui = nil,
    item_module = nil,
    equips = {},
    parent = nil,
    ulv = 0,
}

function EquipTeshuDazao:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/honor-dazao.json"))

    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/honor-dazao-item.json")
    self.item_module:retain()

    self.ui.list_equip:setDirection(ccui.ScrollViewDir.vertical)
    self.ui.list_equip:setItemsMargin(3)
    
    ui_add_click_listener(self.ui.btn_close, function()
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_cancel, function()
        self:close()
    end)
    
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpTeShuDaZao())
    end)
    self.ulv = 0
    self.ui.lbl_forge:setString("打造神器消耗熔炼值和声望")
    return self.ui
end

function EquipTeshuDazao:onShow(parent)
    self.parent = parent
    self.ui.lbl_mycredit:setString("我的声望: "..toint(User.userItems[8]))
    if self.ulv ~= User.ulv then
        self:getEquips()
        self:setEquipsList()
        self.ulv = User.ulv
    end
end

function EquipTeshuDazao:getEquips()
    local equips = {}
    local templist=ConfigData.cfg_equip
    table.foreach(templist, function(k,v)
        if toint(v.lv) <= User.ulv then
            if (equips[toint(v.etype)] == nil or toint(equips[toint(v.etype)].lv) < toint(v.lv)) and (toint(v.ejob) == 0 or toint(v.ejob) == toint(User.ujob)) then
                equips[toint(v.etype)] = v
            end
        end
    end)
    
    self.equips = {}
    table.foreach(equips, function(k, v)
        v['credit'] = self:getCredit(toint(v.etype))
        table.insert(self.equips, v)
    end)
    
    table.sort(self.equips,function(a, b)
        return tonum(a.credit) < tonum(b.credit)
    end)
end

function EquipTeshuDazao:setEquipsList()
    local itemlist = self.ui.list_equip
    
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)
    
    table.foreach(self.equips, function(k,v)
        if v ~= nil then
            itemlist:pushBackDefaultItem()
            local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
            local d = ui_delegate(custom_item)
            self:setItemInfo(d,v)
        end
    end)
    
    table.foreach(self.equips, function(k,v)
        if v ~= nil then
            itemlist:pushBackDefaultItem()
            local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
            local d = ui_delegate(custom_item)
            self:setItemInfo2(d,v)
        end
    end)
    
    itemlist:refreshView()
    itemlist:jumpToTop()
end

function EquipTeshuDazao:getAdvPros(etype)
   local advp = 0
   local advparr = {
        [1] = 14,
        [2] = 35,
        [3] = 33,
        [5] = 48,
        [6] = 37,
        [7] = 46,
        [8] = 36,
        [10] = 38,
        [12] = 34,
        [14] = 47
   }
   if advparr[etype] ~= nil then
        advp = advparr[etype] 
   end
   return advp
end

function EquipTeshuDazao:getAdvPros2(etype)
    local advp = 0
    local advparr = {
        [1] = 17014,
        [2] = 49035,
        [3] = 25033,
        [5] = 21048,
        [6] = 39037,
        [7] = 24046,
        [8] = 28036,
        [10] = 13038,
        [12] = 30034,
        [14] = 29047
    }
    if advparr[etype] ~= nil then
        advp = advparr[etype] 
    end
    return advp
end

function EquipTeshuDazao:getCredit(etype)
    local c = 0
    local carr = {
        [1] = 2000,
        [2] = 2000,
        [3] = 2000,
        [5] = 2000,
        [6] = 2000,
        [7] = 2000,
        [8] = 2000,
        [10] = 2000,
        [12] = 2000,
        [14] = 2000
    }
    if carr[etype] ~= 0 then
        c = carr[etype]
    end
    return c
end

function EquipTeshuDazao:getCredit2(etype)
    local c = 0
    local carr = {
        [1] = 20000,
        [2] = 20000,
        [3] = 20000,
        [5] = 20000,
        [6] = 20000,
        [7] = 20000,
        [8] = 20000,
        [10] = 20000,
        [12] = 20000,
        [14] = 20000
    }
    if carr[etype] ~= 0 then
        c = carr[etype]
    end
    return c
end

function EquipTeshuDazao:setItemInfo(d, v)
    local advp = self:getAdvPros(toint(v.etype))
    d.lbl_shenqi:setString(User.getPropStr(advp,ConfigData.cfg_equip_prop[advp][4]))
    
    local propstr = ""
    if(toint(v.p1) == 10 and toint(v.p2) == 11) then -- 武器的主属性
        propstr = string.format( "伤害 %d - %d", v.p1min, v.p2min ) 
    else
        propstr = User.getPropStr(toint(v.p1), v.p1min)
    end

    d.lbl_subpros:setString(propstr)
    d.lbl_name:setString("Lv."..math.max(math.floor( tonum(v.lv) / 5 ) * 5, 1).." "..v.ename)
      
    ui_add_click_listener(d.btn_dazao, function()
        local function callback(params)
            if params[1] == 1 then
                local equip = params[2]
                self.parent.forgeInfo.forgepoint = self.parent.forgeInfo.forgepoint - tonum(params[3])
                MessageManager:show("获得新装备：".. User.getEquipName(equip), cc.c3b(255,0,0) )
                BagUI:setNeedRefresh()
                BagUI:addEquipToBag(equip,true)
                User.updateEquipInfo(equip)
                self:close()
                self.parent:close()
                DialogManager:showDialog( "EquipDetail", equip);
            else
                MessageManager:show(params[2])
            end
        end
        AlertManager:yesno("打造新属性神器", RTE( string.format("打造新属性神器需要消耗%s声望和%s熔炼值",self:getCredit(toint(v.etype)),20000),25, cc.c3b(255,255,255)), function()
            sendCommand("dazaoAdvEquip", callback, {v.eid})
        end,"打造")
    end)
    d.img_type:loadTexture( string.format("res/ui/icon/title_%02d.png", toint(v.etype)) )
    d.item:loadTexture(string.format("res/equip/%s.png", toint(v.picindex)))
    -- 设置神器特效
    local ani = UICommon.createAnimation("res/effects/main-equip.plist", "res/effects/main-equip.png", "_%03d.png", 25, 12, cc.p(0.50,0.48), 0.9 )
    ani:setTag(9999)
    d.item:addChild(ani)
    local s = d.item:getContentSize()
    ani:setPosition(s.width/2,s.height/2)
end


function EquipTeshuDazao:setItemInfo2(d, v)
    local advp = self:getAdvPros2(toint(v.etype))
    local advp1 = advp % 1000
    local advp2 = math.floor(advp / 1000)
    d.lbl_shenqi:setString(User.getPropStr(advp1,ConfigData.cfg_equip_prop[advp1][4]).."\n"..User.getPropStr(advp2,ConfigData.cfg_equip_prop[advp2][4]))
    d.lbl_shenqi:setPosition(cc.p(10,25))
    d.lbl_subpros:setPosition(cc.p(10,60))
    local propstr = ""
    if(toint(v.p1) == 10 and toint(v.p2) == 11) then -- 武器的主属性
        propstr = string.format( "伤害 %d - %d", v.p1min, v.p2min ) 
    else
        propstr = User.getPropStr(toint(v.p1), v.p1min)
    end

    d.lbl_subpros:setString(propstr)
    d.lbl_name:setString("Lv."..math.max(math.floor( tonum(v.lv) / 5 ) * 5, 1).." "..v.ename)

    ui_add_click_listener(d.btn_dazao, function()
        local function callback(params)
            if params[1] == 1 then
                local equip = params[2]
                self.parent.forgeInfo.forgepoint = self.parent.forgeInfo.forgepoint - tonum(params[3])
                MessageManager:show("获得新装备：".. User.getEquipName(equip), cc.c3b(255,0,0) )
                BagUI:setNeedRefresh()
                BagUI:addEquipToBag(equip,true)
                User.updateEquipInfo(equip)
                self:close()
                self.parent:close()
                DialogManager:showDialog( "EquipDetail", equip);
            else
                MessageManager:show(params[2])
            end
        end
        AlertManager:yesno("打造双属性神器", RTE( string.format("打造双属性神器需要消耗%s声望和%s熔炼值",self:getCredit2(toint(v.etype)),20000),25, cc.c3b(255,255,255)), function()
            sendCommand("dazaoAdv2Equip", callback, {v.eid})
        end,"打造")
    end)
    d.img_type:loadTexture( string.format("res/ui/icon/title_%02d.png", toint(v.etype)) )
    d.item:loadTexture(string.format("res/equip/%s.png", toint(v.picindex)))
    -- 设置神器特效
    local ani = d.item:getChildByTag(9999)
    local ani1 = d.item:getChildByTag(9995)
    if(ani == nil and ani1 == nil) then
        -- 设置神器特效
        ani = UICommon.createAnimation( "res/effects/main-equip3.plist", "res/effects/main-equip3.png", "adv3_%03d.png", 30, 12, cc.p(0.50,0.5),1.1 )
        ani1 = UICommon.createAnimation( "res/effects/main-equip.plist", "res/effects/main-equip.png", "_%03d.png", 25, 12, cc.p(0.50,0.5), 0.9 )
        ani:setTag(9999)
        d.item:addChild(ani)
        local s = d.item:getContentSize()
        ani:setPosition(s.width/2,s.height/2)
        ani1:setTag(9995)
        d.item:addChild(ani1)
        ani1:setPosition(s.width/2,s.height/2)
    end
end


function EquipTeshuDazao:close()
    DialogManager:closeDialog(self)
    self.parent:refreshFrogePoint()
end


return EquipTeshuDazao