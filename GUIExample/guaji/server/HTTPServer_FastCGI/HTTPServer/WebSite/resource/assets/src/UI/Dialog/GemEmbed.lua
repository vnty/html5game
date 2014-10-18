-- 宝石镶嵌

local GemEmbed = {
    ui = nil,
    equip = nil,
--    gem = nil,
    cando = false -- 条件是否满足
}

function GemEmbed:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/gem-embed.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        self:close()
    end)
  
    self.ui.item_img_main:setTouchEnabled(true)
    self.ui.Label_53:setString("")
    
--    self.ui.Label_52:setString("人物35级可以对装备进行打孔")
    
    for i=1, 4 do
        ui_add_click_listener( ui_(self.ui["item_Panel_0"..i],"item_img_0"), function()
            -- 选择宝石
            local sock = toint(self.equip.sock)
            local gems = string.split( self.equip.gemstr, "," )
            if(i <= sock) then
                if(tonum(gems[i]) == 0) then
                    local filterFunc = function(v)
                        local itemid = tonum(v)
                        if( toint(itemid/100) <= 4 and toint(itemid/100) >= 1 and toint(itemid%100) >= 1 and toint(itemid%100) <= 15) then
                            return true
                        end
                        return false
                    end
                    DialogManager:showSubDialog(self, "GemSelect", filterFunc, function(k)
                        local onOnGem = function(params)
                            if(params[1] == 1) then
                                self.equip=params[2]
                                BagUI:reduceItem(k, 1)
                                BagUI:setNeedRefresh()
                                BagUI:updateEquip(self.equip,true)
                                BagUI:refreshUI()
                                self:refreshUI()
                            else
                                MessageManager:show(params[2])
                            end
                        end
                        --                        AlertManager:yesno("宝石镶嵌", RTE( string.format("确定要镶嵌该宝石吗?", 25, cc.c3b(255,255,255))), openSock)
                        sendCommand("onGem", onOnGem,{toint(self.equip.eid), k})
                    end)
                end 
            else
                local onOpenSock = function(params)
                    if(params[1] == 1) then
                        -- TODO 目前直接写在客户端,有待以后修改
                        self.equip.sock = toint(params[2])
                        if(params[3]) then
                            dump(params[3])
                            for i=1,table.getn(params[3]) do
                                if(tonum(params[3][i].itemid) > 3) then
                                    BagUI:addItem(tonum(params[3][i].itemid),tonum(params[3][i].count))
                                elseif(tonum(params[3][i].itemid) == 1) then
                                    GameUI:addUserCoin(tonum(params[3][i].count))
                                elseif(tonum(params[3][i].itemid) == 2) then
                                    User.ug = User.ug + (tonum(params[3][i].count))
                                elseif(tonum(params[3][i].itemid) == 3) then
                                    GameUI:addUserJinghua(tonum(params[3][i].count))
                                end
                            end
                        end
                        BagUI:setNeedRefresh()
                        BagUI:updateEquip(self.equip,true)
                        --                        GameUI:loadUinfo()
                        --                        BagUI:
                        BagUI:refreshUI()
                        self:refreshUI()
                    else
                        MessageManager:show(params[2])
                    end
                end
                if(User.ulv >= 20) then
                    local cost = "  请先开第"..(sock+1).."个孔"
                    if(i == 1 and i <= (sock+1)) then
                        cost = "  开孔将消耗"..(toint(self.equip.lv)*1000).."金币."
                    elseif(i == 2 and i <= (sock+1)) then
                        cost = "  开孔将消耗一个"..ConfigData.cfg_item[41].name
                    elseif(i == 3 and i <= (sock+1)) then
                        cost = "  开孔将消耗一个"..ConfigData.cfg_item[42].name
                    elseif(i == 4 and i <= (sock+1)) then
                        cost = "  开孔将消耗一个"..ConfigData.cfg_item[43].name
                    end
                    local openSock = function()
                        if i <= (sock+1) then
                            sendCommand("openSock", onOpenSock, {self.equip.eid})
                        end
                    end
                    AlertManager:yesno("装备钻孔", RTE( cost, 25, cc.c3b(255,255,255)), openSock)
                else
                    MessageManager:show("人物等级20级开放开孔功能")
                end
            end
        end)     
    end
    
    
    
    ui_add_click_listener( self.ui.btn_do, function()
--        self:doGemEmbed()
        self:unDoGemEmbed()
    end)
  
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpGemEmbed())
    end)
end

function GemEmbed:close()
    DialogManager:closeDialog(self)
end

function GemEmbed:onShow(equip)
    self.equip = equip
--    self.ui.Label_53:setString(equip.name)
    -- 装备icon和部位
    self:refreshUI()
end

function GemEmbed:doGemEmbed()
    if(self.gem == nil)then
        MessageManager:show("请选择要镶嵌的宝石")
        return
    end

    local function onGemCallback(param)
        dump(param)
        if(tonum(param[1]) == 1)then
            -- 成功
            MessageManager:show("镶嵌成功！")
    
            self.equip = param[2] 
            BagUI:updateEquip(self.equip, true)
            BagUI:setNeedRefresh()
            BagUI:refreshUI()          
    
            -- 更新宝石
            BagUI:reduceItem(self.gem.itemid,1)
    
            self:close()
        else
            MessageManager:show(param[2])
        end
    end  
    sendCommand( "onGem", onGemCallback , {self.gem.itemid, self.equip.eid})
end

function GemEmbed:unDoGemEmbed()
    -- 一键卸下
    local onOffGem = function(params)
        if(params[1] == 1) then
            local gems = string.split( self.equip.gemstr, "," )
            for i = 1, table.getn(gems) do
                if(toint(gems[i]) ~= 0) then
                    BagUI:addItem(toint(gems[i]), 1)
                    BagUI:setNeedRefresh()
                end
            end
            self.equip = params[2]
            BagUI:updateEquip(self.equip,true)
            BagUI:setNeedRefresh()
            BagUI:refreshUI()
            self:refreshUI()
        else
            if(params[2]) then
                MessageManager:show(params[2])
            end
        end
    end
    sendCommand("offGem",onOffGem,{self.equip.eid})
end

function GemEmbed:refreshUI()
    local equip = self.equip
    local lv = toint(equip.lv) - toint(equip.lv % 5)
    if lv == 0 then
        lv = 1
    end
    local name = "Lv "..lv.." "..equip.ename
    if(tonum(equip.uplv) > 0) then
        name = name .." +".. equip.uplv
    end

    self.ui.Label_53:setString(name)

    UICommon.setEquipImg(self.ui.item_img_main, equip) 
    UICommon.setItemImg(self.ui.item_img_0, 0, 0) 

    local sock = toint(equip.sock)
    local gems = string.split( equip.gemstr, "," )
    for i=1,4 do
        if(i <= sock) then
            local g = tonum(gems[i])
            if(g == 0) then
                ui_(self.ui["item_Panel_0"..i],"item"):setVisible(false)
                ui_(self.ui["item_Panel_0"..i],"Image_select"):setVisible(true)
                ui_(self.ui["item_Panel_0"..i],"Image_noSock"):setVisible(false)
                ui_(self.ui["item_Panel_0"..i],"ug_name"):setVisible(false)
                ui_(self.ui["item_Panel_0"..i],"lbl_add"):setVisible(false)
            else
                local gemInfo = ConfigData.cfg_gem[g]
                local color = cc.c3b(255,255,255)
                local effect = ""
                if(toint(gemInfo.type) == 1) then
                    effect = "力量 +"
                    color = cc.c3b(255,0,0)
                elseif(toint(gemInfo.type) == 2)then
                    effect = "敏捷 +"
                    color = cc.c3b(0,255,33)
                elseif(toint(gemInfo.type) == 3)then
                    effect = "智力 +"
                    color = cc.c3b(0,204,255)
                elseif(toint(gemInfo.type) == 4)then
                    effect = "耐力 +"
                    color = cc.c3b(255,204,0)
                end
                effect = effect .. gemInfo["value"]      
                ui_(self.ui["item_Panel_0"..i],"lbl_add"):setVisible(true)
                ui_(self.ui["item_Panel_0"..i],"lbl_add"):setString(effect)
                ui_(self.ui["item_Panel_0"..i],"lbl_add"):setColor(color)
                ui_(self.ui["item_Panel_0"..i],"ug_name"):setVisible(true)
                ui_(self.ui["item_Panel_0"..i],"ug_name"):setString(gemInfo.name)
                ui_(self.ui["item_Panel_0"..i],"ug_name"):setColor(color)
                ui_(self.ui["item_Panel_0"..i],"Image_select"):setVisible(false)
                ui_(self.ui["item_Panel_0"..i],"Image_noSock"):setVisible(false)
                UICommon.setItemImg( ui_(self.ui["item_Panel_0"..i],"item"), gems[i], 0, false)
                ui_(self.ui["item_Panel_0"..i], "item"):setVisible(true)
            end
        else
            ui_(self.ui["item_Panel_0"..i],"Image_noSock"):setVisible(true)
            ui_(self.ui["item_Panel_0"..i],"Image_select"):setVisible(false)
            ui_(self.ui["item_Panel_0"..i], "item"):setVisible(false)
            ui_(self.ui["item_Panel_0"..i], "ug_name"):setVisible(true)
            ui_(self.ui["item_Panel_0"..i], "ug_name"):setString("点击钻孔")
            ui_(self.ui["item_Panel_0"..i], "ug_name"):setColor(cc.c3b(255,255,255))
            ui_(self.ui["item_Panel_0"..i], "lbl_add"):setVisible(false)
        end
    end
end

return GemEmbed