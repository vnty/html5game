-- 装备熔炼

local EquipRonglian = {
    ui = nil,
    equips = {},
    forgeInfo = nil
}

function EquipRonglian:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/equip-ronglian.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        DialogManager:closeDialog(self)
        BagSelect:refreshSelectedListE()
    end)

    ui_add_click_listener( self.ui.btn_ronglian, function()
        if(self.forgeInfo ~= nil) then 
            EquipRonglian:doRonglian()
        else
            MessageManager:show("正在加载，请稍候...")
        end
    end)
  
    ui_add_click_listener( self.ui.btn_teshu, function()
        if(self.forgeInfo ~= nil) then
            DialogManager:showSubDialog(self,"EquipTeshuDazao", self)
        else
            MessageManager:show("正在加载，请稍候...")
        end
    end)
    
    ui_add_click_listener( self.ui.btn_newequip, function()
        if(self.forgeInfo ~= nil) then
            DialogManager:showSubDialog(self, "EquipRonglianDazao", self)
        else
            MessageManager:show("正在加载，请稍候...")
        end
    end)
  
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpRonglian())
    end)  

    -- 自动筛选被熔炼的装备
    ui_add_click_listener( self.ui.btn_auto_select, function()
        BagSelect:doOpenRonglianEquip( function(equips)
            EquipRonglian:onShow(equips)
        end )
    end)

    for i = 1,6 do
        local item = self.ui["item_img_"..i]
        item:setTouchEnabled(true)
        ui_add_click_listener(item,function()
        	-- 选择装备
        	self:close()
            BagSelect:doOpenRonglianEquip()
        end)
    end
    
    self.forgeInfo = nil
    self.equips = {}
end

function EquipRonglian:onShow(equips)
        
	if(equips == nil)then
	  equips = {}
	end
	
    self.equips = equips
    
	for i = 1,6 do
	  UICommon.setEquipImg( self.ui["item_img_"..i], self.equips[i])
	end
	
    if self.forgeInfo == nil or getSystemTime() > tonum(self.forgeInfo.forgets) + 60 then
	   self:getForgeInfo()
	end
end

function EquipRonglian:close()
	DialogManager:closeDialog(self)
end

function EquipRonglian:refreshFrogePoint()
    self.ui.lbl_ronglian:setString( string.format("当前熔炼值：%d", self.forgeInfo.forgepoint))	
end

function EquipRonglian:getForgeInfo()
    local function onGetForgeInfo(param)
        if(tonum(param[1]) == 1)then
            self.forgeInfo = param[2]
            self:refreshFrogePoint()
        else
            MessageManager:show(param[2])
        end
    end
    
    sendCommand("getForgeInfonew", onGetForgeInfo, {} )
end


function EquipRonglian:doRonglian()
    local function onDelEquip(param)
        dump(param)
        if(tonum(param[1]) == 1)then
            -- 成功
            MessageManager:show( string.format("成功！获得 %d 点熔炼值！",tonum(param[2]) ) )
            self.forgeInfo.forgepoint = tonum(self.forgeInfo.forgepoint) + tonum(param[2])
            EquipRonglian:refreshFrogePoint()
          
            -- 额外获得装备
            local equips = param[3]
            if(table.getn(equips) > 0)then
                for _,vv in pairs(equips) do
                    local v = vv[2]
                    if(User.isAdvEquip(v))then
                        MessageManager:show("意外获得神器：".. User.getEquipName(v), cc.c3b(255,0,0) )                
                    else
                        MessageManager:show("意外获得新装备：".. User.getEquipName(v), User.starToColor(v.star) )
                    end
                    BagUI:addEquipToBag(v,true)
                end
            end
          
            if(param[4] ~= 0)then
                MessageManager:show( string.format("获得 %d 强化精华！",tonum(param[4]) ) )
                GameUI:addUserJinghua(tonum(param[4]))        
            end
                    
            -- 删除旧装备
            for _,v in pairs(self.equips)do
                BagUI:removeEquipFromBag(v.eid)
            end
          
            self:onShow()
        else
            MessageManager:show("熔炼失败： " .. param[2])
        end
    end
    
    if(table.getn(self.equips) == 0)then
        MessageManager:show("请选择熔炼装备！")
        return
    end
    
    -- 看是否有橙装
    local b = false
    for _,v in pairs(self.equips) do
        if(tonum(v.star) == 4)then
            b = true
            break
        end
    end
    
    local function sendRonglianCmd()
        sendCommand( "delEquipnew", onDelEquip, { User.equipToString(self.equips) })  
    end
    
    if(b)then
        AlertManager:yesno("熔炼确认", RTE("即将被熔炼的装备中含有橙色装备，是否继续？",25, cc.c3b(255,255,255)), sendRonglianCmd )
    else
        sendRonglianCmd()
    end
    
end


return EquipRonglian
