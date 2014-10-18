-- 装备强化

local EquipQianghua = {
    ui = nil,
    equip = nil,
    cando = false, -- 条件是否满足
}

function EquipQianghua:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/equip-qianghua.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        if GameUI.curUIName == "bagUI" then
            BagUI:refreshUI()
        end
        DialogManager:closeDialog(self)
    end)

    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpQianghua())
    end)
    
    ui_add_click_listener( self.ui.btn_enforce, function()
        local function onUpEquip(param)
        if(tonum(param[1]) == 1)then
          -- 成功
          MessageManager:show("强化成功！")
          MessageManager:show("金币-"..self.coinCost,cc.c3b(255,255,0))
          MessageManager:show("强化精华-"..self.jinghuaCost,cc.c3b(255,255,0))      

          -- 更新金币和强化精华
          GameUI:addUserJinghua(-self.jinghuaCost)
          GameUI:addUserCoin(-self.coinCost)          
          GameUI:loadUinfo()
          
          self.equip = param[2]
          
          BagUI:updateEquip(self.equip,false)      

          -- 更新装备
          self:onShow(self.equip)
        else
          
          MessageManager:show("强化失败： " .. param[2])
        end
    end  
    sendCommand( "upEquip", onUpEquip, {self.equip.eid})
  end)
end


function EquipQianghua:onShow(equip)
  self.equip = equip
  
  -- 装备icon和部位
  UICommon.setEquipImg(self.ui.item_img,equip)  
  
  -- 显示装备属性  
  UICommon.showEquipDetails(self.ui.pnl_equip_props, equip) 
  
  -- 所需金币和数量
  local cf = ConfigData.cfg_equip[tonum(equip.ceid)]
  local n, add = User.getEquipUpInfo( equip.star, equip.uplv, cf.lv, tonum(equip.etype) )
  self.coinCost = n * 2000
  self.jinghuaCost = n
    
  self.ui.lbl_msg:setString( string.format("下一级强化 主属性 +%d%%", add ))
    
  self.ui.lbl_coin:setString( string.format("需要金币：%d (当前拥有：%d)", self.coinCost, User.ucoin ))
  if(User.ucoin >= self.coinCost)then
    self.ui.lbl_coin:setColor(cc.c3b(255,255,255))
  else
    self.ui.lbl_coin:setColor(cc.c3b(255,0,0))
  end
  
    self.ui.lbl_jinghua:setString( string.format("需要强化精华：%d (当前拥有：%d)", self.jinghuaCost, BagUI:getItemCount(3) ))
    if(BagUI:getItemCount(3) >= self.jinghuaCost )then
        self.ui.lbl_jinghua:setColor(cc.c3b(255,255,255))
    else
        self.ui.lbl_jinghua:setColor(cc.c3b(255,0,0))
    end
end


return EquipQianghua