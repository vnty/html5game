local BagFilter = {
  ui = nil,
}

function BagFilter:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/bag-filter.json"))
  local frameSize = cc.Director:getInstance():getWinSize()
  tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
   self.ui.Panel_3_0:getLayoutParameter():setMargin(tbl_act)
  ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
    self:close()
  end)
  
  -- 按部位过滤
  for k,v in pairs(ConfigData.cfg_equip_etype) do
    if(self.ui["btn_type_"..k] ~= nil)then
      ui_add_click_listener(self.ui["btn_type_"..k], function(sender,eventType)
        BagUI:doOpenNormalWithTypeFilter(k)
        self:close()
      end)
    end
  end
  
  -- 按颜色过滤
  for i = 0, 4 do
    if(self.ui["btn_star_"..i] ~= nil)then
      ui_add_click_listener(self.ui["btn_star_"..i], function(sender,eventType)
        BagUI:doOpenNormalWithStarFilter(i)
        self:close()
      end)
    end
  end
  
  -- 只过滤神器
  ui_add_click_listener(self.ui.btn_ismain, function(sender,eventType)
    BagUI:doOpenNormalWithMain()
    self:close()
  end)
      
  -- 所有装备
  ui_add_click_listener(self.ui.btn_all, function(sender,eventType)
    BagUI.needRefresh = true
    BagUI:doOpenNormal()
    self:close()
  end)
  
  return self.ui
end

function BagFilter:onShow()

  -- 获得每个部位的装备数量
  local etnum = {}
  local starnum = {}
  local ismainnum = 0
  local allnum = 0
  for k,v in pairs(User.userEquips) do
    if(not User.isEquiped(v))then
      allnum = allnum + 1
      
      -- 部位
      local et = tonum(v.etype)
      etnum[et] = tonum(etnum[et]) + 1
      
      -- 星级
      local star = tonum(v.star)
      starnum[star] = tonum(starnum[star]) + 1
      
      -- 神器
      if( User.isAdvEquip(v) )then
        ismainnum = ismainnum + 1
      end
    end
  end

  for k,v in pairs(ConfigData.cfg_equip_etype) do
    self.ui["btn_type_"..k]:setTitleText(v.." *"..tonum(etnum[k]))
  end
  
  for i = 0, 4 do
    self.ui["btn_star_"..i]:setTitleText( User.starToText(i) .."装备 *"..tonum(starnum[i]))
  end
  
  self.ui.btn_all:setTitleText("所有装备 *"..allnum)
  self.ui.btn_ismain:setTitleText("神器 *"..ismainnum)
end

function BagFilter:close()
  DialogManager:closeDialog(BagFilter)
end

return BagFilter 