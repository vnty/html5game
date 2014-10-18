-- 神器吞噬

local EquipTunshi = {
    ui = nil,
    equip = nil,
    equips = nil,
    cando = false, -- 条件是否满足
}

function EquipTunshi:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/equip-tunshi.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        self:close()
        BagSelect:refreshSelectedListE()
    end)
  
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpTunshi())
    end)  
    

  self.ui.item_img_main:setTouchEnabled(true)
  ui_add_click_listener( self.ui.item_img_main, function()

  end)

    for i = 1,6 do
        local item = self.ui["item_img_"..i]
        item:setTouchEnabled(true)
        ui_add_click_listener(item,function()
            
            self:close()
            
            -- 选择装备
            BagSelect:doOpenTunshi(self.equip)
        end)
    end

  ui_add_click_listener( self.ui.btn_do, function()
    self:doTunshi()
  end)
  
  ui_add_click_listener(self.ui.btn_auto_select,function()
    BagSelect:doOpenTunshi( self.equip,function(equips)
        EquipTunshi:onShow(self.equip,equips)
    end)
  end)
end

function EquipTunshi:close()
	DialogManager:closeDialog(self)
end

function EquipTunshi:onShow(equip, equips)
    self.equip = equip
    self.equips = equips
  
    -- 装备icon和部位
    UICommon.setEquipImg(self.ui.item_img_main, equip)
    if(equips == nil)then
        equips = {}
        self.ui.lbl_coin:setVisible(false)
    else
        self.expGain = 0
        for _,v in pairs(equips)do
            self.expGain = self.expGain + v.advexp + 1
        end
        local cf = ConfigData.cfg_equip[tonum(equip.ceid)]
        local slv = math.max(toint(cf.lv) - toint(cf.lv) % 5, 1)
        self.coinCost = self.expGain * 100 * toint(slv) * toint(slv)
        self.ui.lbl_coin:setString( string.format("需要金币：%d (当前拥有 %d)", self.coinCost , User.ucoin ) )
        if(User.ucoin > self.coinCost)then
            self.ui.lbl_coin:setColor( cc.c3b(0,255,0) )   
        else
            self.ui.lbl_coin:setColor( cc.c3b(255,0,0) )
        end
        self.ui.lbl_coin:setVisible(true)
    end
    
    for i = 1, 6 do 
        UICommon.setEquipImg(self.ui["item_img_"..i], equips[i])
    end  
  
    self.ui.lbl_lv:setString( string.format( "神器等级：Lv %d", equip.advlv) )

    local expmin = math.pow(tonum(equip.advlv) - 1, 2)
    local expmax = math.pow(tonum(equip.advlv), 2)
    
    local advp1 = toint(equip.advp) % 1000
    local advp2 = math.floor(toint(equip.advp) / 1000)
    local appendstr = ""
    if advp2 > 0 then
        expmin = math.floor(expmin * 1.4)
        expmax = math.floor(expmax * 1.4)
        local propstr2 = User.getPropStr(toint(advp2), ConfigData.cfg_equip_prop[advp2][4] * tonum(equip.advlv) )
        appendstr = "\n"..propstr2
    end
    
    local exp = tonum(equip.advexp)
    self.ui.lbl_exp:setString( string.format( "经验：%d/%d", exp - expmin, expmax - expmin) )
    self.ui.expbar:setPercent( (exp - expmin) / (expmax - expmin) * 100.0 )
    
    local advp1 = toint(equip.advp) % 1000
    local advp2 = math.floor(toint(equip.advp) / 1000)
    local appendstr = ""
    if advp2 > 0 then
        local propstr2 = User.getPropStr(toint(advp2), ConfigData.cfg_equip_prop[advp2][4] * tonum(equip.advlv) )
        appendstr = "\n"..propstr2
    end
    local prostr = User.getPropStr( advp1, ConfigData.cfg_equip_prop[advp1][4] * tonum(equip.advlv))
    self.ui.lbl_adv:setString( string.format("%s%s", prostr, appendstr ) )
end

function EquipTunshi:doTunshi()
    if(self.equips == nil)then
        MessageManager:show("请选择要吞噬的神器")
        return
    end

    local function onUpAdvp(param)
        dump(param)
        if(tonum(param[1]) == 1)then
            -- 成功
            if tonum(param[4]) > 0 then
                MessageManager:show("吞噬成功！获得强化精华*"..param[4])
            end
            -- 删除旧装备
            for _,v in pairs(self.equips)do
                BagUI:removeEquipFromBag(v.eid)
            end

            self.equip = param[2]
            BagUI:updateEquip(self.equip, false)
            BagUI:refreshUI()
            -- 更新金币和强化精华
--            GameUI:loadUinfo()
            GameUI:addUserJinghua(param[4])
            GameUI:addUserCoin(-param[3])
            -- 更新装备
            self:onShow(self.equip, nil)
        else
            MessageManager:show("吞噬失败： " .. param[2])
        end
    end  
    sendCommand( "upAdvp", onUpAdvp , {self.equip.eid, User.equipToString(self.equips) })
end

return EquipTunshi