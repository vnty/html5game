local EquipRonglianDazao = {
    ui = nil,
    resettime = 0,
    parent = nil
}

function EquipRonglianDazao:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/equip-ronglian-dazao.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        self:close()
    end)

    ui_add_click_listener( self.ui.btn_dazao, function()
        self:doGetNewEquip()
    end)
    
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpDaZao())
    end) 
    
    ui_add_click_listener( self.ui.btn_refresh, function()
        dump(self.resettime)
        if(self.resettime <= 0)then
            local function onYes()
                self:resetForge()
            end
            AlertManager:yesno("确认刷新", RTE("今日免费刷新已经用完，刷新一次需要花费20钻石，确定继续吗？",25, cc.c3b(255,255,255)), onYes)
        else
            self:resetForge()
        end
    end)
end

function EquipRonglianDazao:onShow(parent)
    self.parent = parent
    self:onForgetInfo(parent.forgeInfo)
end

function EquipRonglianDazao:onForgetInfo(forgeInfo)
    self.parent.forgeInfo = forgeInfo
     
    self.ui.lbl_ronglian:setString( string.format("打造所需要熔炼值：%d (当前拥有：%d)", forgeInfo.forgeneed, forgeInfo.forgepoint))
    if(tonum(forgeInfo.forgeneed) <= tonum(forgeInfo.forgepoint) )then
        self.ui.lbl_ronglian:setColor( cc.c3b(0,255,0) )   
    else
        self.ui.lbl_ronglian:setColor( cc.c3b(255,0,0) )
    end
    
    self.ui.pnl_equip_props:removeAllChildren()
    self.resettime = tonum(forgeInfo.resettime)
    self.ui.lbl_times:setString( string.format("今日免费刷新次数： %d", forgeInfo.resettime) )

    if forgeInfo.type == "equip" then
        -- 装备icon和部位
        local equip = forgeInfo.equip[2]
        User.updateEquipInfo(equip)

        self.ui.equip_img:setVisible(true)
        self.ui.item_img:setVisible(false)
        UICommon.setEquipImg(self.ui.equip_img, equip)
        self.ui.lbl_type:setVisible(true)
        self.ui.lbl_type:setString( ConfigData.cfg_equip_etype[toint(equip.etype)] )

        -- 显示装备属性  
        UICommon.showEquipDetails(self.ui.pnl_equip_props, equip, nil, true)
    elseif forgeInfo.type == "item" then
        self.ui.equip_img:setVisible(false)
        self.ui.lbl_type:setVisible(false)
        self.ui.item_img:setVisible(true)
        UICommon.setItemImg( self.ui.item_img, tonum(forgeInfo.item), 0)

        local c = ConfigData.cfg_item[tonum(forgeInfo.item)]
        local rtes = {}
        table.insert( rtes, RTE(c.desc,25,cc.c3b(255,255,255)) )
        UICommon.createRichText(self.ui.pnl_equip_props,rtes)
    end
end

function EquipRonglianDazao:resetForge()

    local function onGetForgeInfo(param)
    dump(param)
        if(tonum(param[1]) == 1)then
           self:onForgetInfo(param[2])
           GameUI:loadUinfo()
           MainUI:refreshUinfoDisplay()
        else
            MessageManager:show(param[2])
        end
    end
    
    sendCommand("resetForgenew", onGetForgeInfo, {} )
end


function EquipRonglianDazao:doGetNewEquip()

    local function onGetForgeEquip(param)
        if(tonum(param[1]) == 1)then
            -- 成功
            self:onForgetInfo(param[2])
          
            local forgeGet = param[3]
            if forgeGet.type == "equip" then
                -- 额外获得装备
                local v = forgeGet.equip[2]
                MessageManager:show("获得新装备：".. User.getEquipName(v), User.starToColor(v.star) )
                BagUI:addEquipToBag(v,true)
            elseif forgeGet.type == "item" then
                local itemid = tonum(forgeGet.item)
                local c = ConfigData.cfg_item[itemid]
                BagUI:addItem(itemid,1)
                MessageManager:show("获得物品：" .. c.name)
            end                    
        else
          MessageManager:show("失败： " .. param[2])
        end
    end
    sendCommand( "dazaoForgeEquip", onGetForgeEquip )  
  
end

function  EquipRonglianDazao:close()
    DialogManager:closeDialog(self)
    self.parent:refreshFrogePoint()
end

return EquipRonglianDazao