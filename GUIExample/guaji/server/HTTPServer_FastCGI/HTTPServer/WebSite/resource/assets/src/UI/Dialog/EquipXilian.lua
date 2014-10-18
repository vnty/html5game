-- 装备洗练

local EquipXilian = {
    ui = nil,
    equip = nil,
    cando = false, -- 条件是否满足
}

function EquipXilian:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/equip-xilian.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        if GameUI.curUIName == "bagUI" then
            BagUI:refreshUI()
        end
        DialogManager:closeDialog(self)
    end)
    
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self,"HelpDialog", HelpText:helpXilian())
    end) 

  ui_add_click_listener( self.ui.btn_enforce, function()
    self:Xilian()
  end)
  
  ui_add_click_listener( self.ui.btn_enforce2, function()
    self:Xilian2()
  end)
  
end

function EquipXilian:onShow(equip)
  self.equip = equip
  
  -- 装备icon和部位
  UICommon.setEquipImg(self.ui.item_img,equip)  
  
  -- 显示装备属性  
  UICommon.showEquipDetails(self.ui.pnl_equip_props, equip, nil, nil, true)
  --宝石属性 
--  local socks = tonum(equip.sock)
--  local gems = string.split( equip.gemstr, "," )
--  for i = 1, socks do
--      local g = tonum(gems[i])
--      if g ~= 0 then
--          local cg = ConfigData.cfg_gem[g]
--          rt:pushBackElement ( RTE( string.format("%s %s\n", cg.name, User.getPropStr(toint(cg.type), tonum(cg.value))), 20, cc.c3b(245,3,247) ))
--      end
--  end
  
  -- 洗炼所需金币(((装备等级+2)/5取整)*5+5)*500
  local cf = ConfigData.cfg_equip[tonum(equip.ceid)]
  local lv = tonum(cf.lv)
  local slv = math.max(lv - lv % 5, 1)
  self.xilianCoin = (math.floor( (slv + 2 ) / 5 ) * 5 + 5) * 500
  --self.jinglianCoin = (math.floor( (lv + 2 ) / 5 ) * 5 + 5) * 2000
  self.ui.lbl_xilian:setString( string.format("普通洗炼需要金币：%d (当前拥有：%d)", self.xilianCoin , User.ucoin ))
  self.ui.lbl_xilian2:setString( string.format("高级洗炼需要钻石：%d (当前拥有：%d)", 50 , User.ug ))
  --self.ui.lbl_jinglian:setString( string.format("精炼提高副属性，需要花费金币：%d (当前拥有：%d)", self.jinglianCoin , User.ucoin ))
end


function EquipXilian:Jinglian()
  local function onJinglianEquip(param)
    if(tonum(param[1]) == 1)then
      -- 成功
      --MessageManager:show("洗炼成功！")
      if(tonum(param[3]) > 0)then
        MessageManager:show( string.format("额外获得 %d 点属性！",tonum(param[3])))
      end
      
      self.equip = param[2]
      
      BagUI:updateEquip(self.equip, false)

      -- 更新金币和强化精华
      GameUI:loadUinfo()
      GameUI:addUserCoin(-self.jinglianCoin)

      -- 更新装备
      self:onShow(self.equip)
    else
      
      MessageManager:show("精炼失败： " .. param[2])
    end
end  
sendCommand( "jinglianEquip", onJinglianEquip , {self.equip.eid})
end


function EquipXilian:Xilian()
    local function onResetEquip(param)
    if(tonum(param[1]) == 1)then
        -- 成功
        --MessageManager:show("洗炼成功！")
        MessageManager:showMessageNode(self.ui.btn_enforce, "金币-"..self.xilianCoin,cc.c3b(255,255,0))      

        if(tonum(param[3]) > 0)then
            MessageManager:show( string.format("额外获得 %d 点属性！",tonum(param[3])))
        end
      
        -- 更新金币
        GameUI:addUserCoin(-self.xilianCoin)
        GameUI:loadUinfo()
      
        self.equip = param[2]
        dump(self.equip)
      
        BagUI:updateEquip(self.equip, false)
        
        -- 更新装备
        self:onShow(self.equip)
    else
      
        MessageManager:show("洗练失败： " .. param[2])
    end
end  
sendCommand( "resetEquip", onResetEquip , {self.equip.eid})
end

function EquipXilian:Xilian2()
    local function onResetEquip(param)
        if(tonum(param[1]) == 1)then
            -- 成功
            --MessageManager:show("洗炼成功！")
            MessageManager:showMessageNode(self.ui.btn_enforce2, "钻石-"..50,cc.c3b(255,255,0))      

            if(tonum(param[3]) > 0)then
                MessageManager:show( string.format("额外获得 %d 点属性！",tonum(param[3])))
            end

            -- 更新钻石
            GameUI:addUserUg(-50)
            GameUI:loadUinfo()

            self.equip = param[2]
            dump(self.equip)

            BagUI:updateEquip(self.equip, false)

            -- 更新装备
            self:onShow(self.equip)
        else

            MessageManager:show("洗练失败： " .. param[2])
        end
    end  
    sendCommand( "resetEquip2", onResetEquip , {self.equip.eid})
end

return EquipXilian