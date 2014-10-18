-- 神器传承

local EquipChuancheng = {
    ui = nil,
    equip = nil,
    equip2 = nil,
    cando = false, -- 条件是否满足
}

function EquipChuancheng:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/equip-chuancheng.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        self:close()
        BagSelect:refreshSelectedListE()
    end)
  
    self.ui.item_img_main:setTouchEnabled(true)
        ui_add_click_listener( self.ui.item_img_main, function()
            self:close()
            -- 选择装备
            BagSelect:doOpenChuanchengEquip(self.equip)
    end)

    ui_add_click_listener( self.ui.btn_do, function()
        self:doChuancheng()
    end)
  
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpChuancheng())
    end)
end

function EquipChuancheng:close()
    DialogManager:closeDialog(self)
end

function EquipChuancheng:onShow(equip, equip2)
  self.equip = equip
  self.equip2 = equip2
  
  -- 装备icon和部位
  UICommon.setEquipImg(self.ui.item_img_0,equip)  
  UICommon.setEquipImg(self.ui.item_img_main, equip2) 
  
  if(tonum(equip.advp) ~= 0)then
    local advp1 = toint(equip.advp) % 1000
    local advp2 = math.floor(toint(equip.advp) / 1000)
    local appendstr = ""
    if advp2 > 0 then
        local propstr2 = User.getPropStr(toint(advp2), ConfigData.cfg_equip_prop[advp2][4] * tonum(equip.advlv) )
        appendstr = "\n"..propstr2
    end
    local prostr = User.getPropStr( advp1, ConfigData.cfg_equip_prop[advp1][4] * tonum(equip.advlv))
    self.ui.lbl_adv:setString( string.format("传承属性：%s%s", prostr, appendstr ) )
  end
  
  -- 所需金币和数量
  if(equip2 == nil)then
    self.ui.lbl_coin:setString( "需要金币：--" )
    self.ui.img_light:setVisible(false)
    self.ui.img_light:stopAllActions()
  else
    local cf1lv = tonum(ConfigData.cfg_equip[tonum(equip.ceid)].lv)
    local cf2lv = tonum(ConfigData.cfg_equip[tonum(equip2.ceid)].lv)
    local scf1lv = math.max(cf1lv - cf1lv % 5, 1)
    local scf2lv = math.max(cf2lv - cf2lv % 5, 1)
    if User.isAdv2Equip(equip) then
        if scf2lv <= scf1lv then
            self.coinCost = 80000
        else    
            self.coinCost = 80000 + 140 * ( scf2lv * scf2lv - scf1lv * scf1lv )* tonum(self.equip.advlv) * tonum(self.equip.advlv)
        end
    else
        if scf2lv <= scf1lv then
            self.coinCost = 10000
        else    
            self.coinCost = 10000 + 100 * ( scf2lv * scf2lv - scf1lv * scf1lv )* tonum(self.equip.advlv) * tonum(self.equip.advlv)
        end
    end
    self.ui.lbl_coin:setString( string.format("需要金币：%d (当前拥有 %d)", self.coinCost , User.ucoin ) )
    self.ui.img_light:setVisible(true)
    
    self.ui.img_light:stopAllActions()
    local sequence = cc.Sequence:create( cc.FadeOut:create(1),cc.FadeIn:create(1) )
    self.ui.img_light:runAction(cc.RepeatForever:create(sequence))
  end
end

function EquipChuancheng:doChuancheng()
    if(self.equip2 == nil)then
        MessageManager:show("请选择要传承到哪件装备")
        return
    end

    local function onTransEquip(param)
        if(tonum(param[1]) == 1)then
            -- 成功
            MessageManager:show("传承成功！")
    
            self.equip = param[2] 
            self.equip2 = param[3]
            BagUI:updateEquip(self.equip, false)          
            BagUI:updateEquip(self.equip2, false)
            
            BagUI:refreshUI()
            
            -- 更新金币和强化精华
            GameUI:addUserCoin(-self.coinCost)
            GameUI:loadUinfo()
    
            -- 更新装备
--            self:onShow(self.equip,self.equip2)
        else
            MessageManager:show("传承失败： " .. param[2])
        end
        self:close()
    end  
    sendCommand( "transAdvp", onTransEquip , {self.equip.eid, self.equip2.eid})
end

return EquipChuancheng