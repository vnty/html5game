-- @module EquipDetail

local EquipDetail = {
    ui = nil,
    equip = nil,
    doSetEquipCallback = nil,
    rt = nil
}

function EquipDetail:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/equip_detail.json"))
  
    self.ui.nativeUI:setTouchEnabled(true)
  
    ui_add_click_listener( self.ui.nativeUI,function()
        self:close()
    end)
  
    ui_add_click_listener( self.ui.btn_close,function()
        self:close()
    end)
  
    -- 更换装备按钮
    ui_add_click_listener( self.ui.btn_change,function()
        self:close()
        self.doSetEquipCallback(self.equip)
    end)
  
    -- 卖掉/卸下
    ui_add_click_listener(self.ui.btn_sell, function()
        self:close()
        if(User.isEquiped(self.equip))then
            -- 卸下
            if(User.isEquipedByPartner(self.equip))then
                PartnerUI.doEquip({eid=0, etype=self.equip.etype},true)
            else
                EquipUI.doEquip( {eid=0, etype=self.equip.etype},true)
            end
        else
            -- 卖出
            if(tonum(self.equip.star) >= 4)then
                local function onOK()
                    BagUI:doSellEquip(self.equip)    	
                end
                AlertManager:yesno("卖出装备", RTE("确定卖出橙装吗？",25, cc.c3b(255,255,255)), onOK)
            else
                BagUI:doSellEquip(self.equip)       
            end
        end
    end)

    -- 强化
    ui_add_click_listener( self.ui.btn_up,function()
        self:close()
        DialogManager:showDialog( "EquipQianghua", self.equip )
    end)
  
    -- 洗炼
    ui_add_click_listener( self.ui.btn_xilian,function()
        self:close()
        DialogManager:showDialog( "EquipXilian", self.equip )
    end)
    
    -- 宝石镶嵌
    ui_add_click_listener( self.ui.btn_gem,function()
        self:close()
        DialogManager:showDialog( "GemEmbed", self.equip )
    end)
  
    -- 神器融合
    ui_add_click_listener( self.ui.btn_sq_up,function()
        if(User.isAdvEquip(self.equip))then
            self:close()
            DialogManager:showDialog( "EquipTunshi", self.equip )
        else
            MessageManager:show("只有神器才能吞噬其他神器!")
        end         
    end)
  
    -- 神器传承
    ui_add_click_listener( self.ui.btn_sq_pass,function()
        if(User.isAdvEquip(self.equip))then
            self:close()
            DialogManager:showDialog( "EquipChuancheng", self.equip )
        else
            MessageManager:show("只有神器才能传承!")
        end       
    end)
  
    return self.ui
end

-- 设置装备
function EquipDetail:onShow(v, pvpEquipTable)
    dump(v)
    self.equip = v
    local isAdv = User.isAdvEquip(v) 
    local d = self.ui
    local propSize = nil
  
    -- 是否为别人的装备
    if pvpEquipTable == nil then
    
        -- 装备按钮
        UICommon.setVisible(self.ui.btn_change,User.isEquiped(v))
    
        -- 神器的话显示进阶按钮  
        UICommon.setVisible(self.ui.btn_sq_up, isAdv)
        UICommon.setVisible(self.ui.btn_sq_pass, isAdv)

        -- 宝石镶嵌按钮
--        local c = ConfigData.cfg_equip[tonum(v.ceid)]
        UICommon.setVisible(self.ui.btn_gem, tonum(v.lv) >= 10)
      
        -- 卖出/卸下按钮
        UICommon.setVisible(self.ui.btn_sell, true)
        if(User.isEquiped(v))then
            self.ui.btn_sell:setTitleText("卸 下")
        else
            self.ui.btn_sell:setTitleText("卖 出")
        end
      
        -- 洗炼按钮，10级+蓝装以上才有洗炼
        UICommon.setVisible(self.ui.btn_xilian, tonum(v.star) >= 2 and tonum(v.lv) >= 10)
        UICommon.setVisible(self.ui.btn_up, true)
        
        local minUpLv = nil
        if User.isEquiped(v) and not User.isEquipedByPartner(v) then  
             minUpLv = User.getEquipMinUpLv()
        end
        propSize = UICommon.showEquipDetails(self.ui.pnl_equip_props, v, minUpLv, true)
    else
        -- 别人的装备
        UICommon.setVisible(self.ui.btn_gem, false)
        UICommon.setVisible(self.ui.btn_change,false)
        UICommon.setVisible(self.ui.btn_sq_up, false)
        UICommon.setVisible(self.ui.btn_sq_pass, false)
        UICommon.setVisible(self.ui.btn_up, false)
        UICommon.setVisible(self.ui.btn_sell, false)
        UICommon.setVisible(self.ui.btn_xilian, false)
        
        local minUpLv = User.getEquipMinUpLvPvp(pvpEquipTable)
        propSize = UICommon.showEquipDetails(self.ui.pnl_equip_props, v, minUpLv, true)
    end

    -- 装备icon和部位
    UICommon.setEquipImg(d.item_img,v)  
    d.img_type:loadTexture( string.format("res/ui/icon/title_%02d.png", toint(v.etype)) )
    
    -- 调整对话框大小以适应超长属性
    if propSize.height > 550 then
        local offset = propSize.height - 460
        -- self.ui.pnl_equip_props:setContentSize(295,propSize.height)
        -- 这里不调整pnl_equip_props的尺寸，直接调整他的位置，它的子对象超出它的边界也能正常显示
        self.ui.pnl_equip_props:setPosition(150,12 + offset)
        self.ui.pnl_back:setContentSize( cc.size(600,600 + offset) )
        self.ui.pnl_dialog:setContentSize( cc.size(640,680 + offset) )
        self.ui.pnl_controls:setPosition(0, offset)
        
        -- 调整对话框位置，使其中间偏下的位置，方便操作
        --self.ui.pnl_dialog:setPosition(0, (960 - 550 - offset) / 2 - 27 )        
    else
        --self.ui.pnl_equip_props:setContentSize(295,460)
        self.ui.pnl_equip_props:setPosition(150,12)
        self.ui.pnl_back:setContentSize( cc.size(600,600) )
        --self.ui.pnl_back:setPosition(19,22)
        self.ui.pnl_dialog:setContentSize( cc.size(640,680) )
        self.ui.pnl_dialog:setPosition(0,178-55)
        self.ui.pnl_controls:setPosition(0,0)
    end
end

function EquipDetail:close()
  DialogManager:closeDialog(self)
end

return EquipDetail