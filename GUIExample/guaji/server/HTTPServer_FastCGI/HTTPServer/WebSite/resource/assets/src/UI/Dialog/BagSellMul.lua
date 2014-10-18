local BagSellMul = {
  ui = nil,
}

function BagSellMul:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/bag-sellmul.json"))
  
  ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
    self:close()
  end)
  
  -- 按颜色卖
  for i = 0, 3 do
    if(self.ui["btn_star_"..i] ~= nil)then
      ui_add_click_listener(self.ui["btn_star_"..i], function(sender,eventType)
        BagUI:doDoSellMulti(i)
        self:close()
      end)
    end
  end
  
  return self.ui
end

function BagSellMul:onShow()
  local etnum = {}
  local starnum = {[0] = 0, [1] = 0, [2] = 0, [3] = 0}
  local ismainnum = 0
  local allnum = 0
  for k,v in pairs(User.userEquips) do
    if not User.isEquiped(v) and not User.isAdvEquip(v) then
      allnum = allnum + 1
      local et = tonum(v.etype)
      etnum[et] = tonum(etnum[et]) + 1
      local star = tonum(v.star)
      starnum[star] = tonum(starnum[star]) + 1
    end
  end
  
  for i = 0, 3 do
    self.ui["lbl_star_"..i]:setString( User.starToText(i) .."装备 *"..tonum(starnum[i]).."")
  end
  
end

function BagSellMul:close()
    DialogManager:closeDialog(BagSellMul)
end

return BagSellMul 