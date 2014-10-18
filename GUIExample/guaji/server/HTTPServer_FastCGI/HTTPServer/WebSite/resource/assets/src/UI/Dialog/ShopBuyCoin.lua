-- @module ShopUI

local cmd = require("src/Command")

local ShopBuyCoin = {
  ui = nil,
  itemlist = nil,
  goods = nil,
  buys = nil,
  shop_item = nil,
  refreshtime = 0,
}

function ShopBuyCoin:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/shop_buycoin.json"))
    
  ui_add_click_listener(self.ui.btn_buyall,function()
    self:buyAll()
  end)
  
  ui_add_click_listener(self.ui.btn_close,function()
    self:close()
  end)
  
  ui_add_click_listener(self.ui.btn_buyall,function()
    local function onBuyCoin(param)
      if(param[1] == 1)then
        MessageManager:show("金币 +" .. param[2])
        GameUI:onLoadUinfo(param[3])
        self:refreshShop()
      else
        MessageManager:show(param[2])
      end
  end
    sendCommand("buyCoinAll", onBuyCoin, {})
  end)  
  
  ui_add_click_listener(self.ui.btn_buy,function()
    local function onBuyCoin(param)
        if(param[1] == 1)then
            MessageManager:show("金币 +" .. param[2])
            
            GameUI:onLoadUinfo(param[3])
            self:refreshShop()
        else
            MessageManager:show(param[2])
        end
    end
    sendCommand("buyCoin", onBuyCoin, {})
  end)
  
  return self.ui
end

function ShopBuyCoin:onShow()
    self:refreshShop()
end


function ShopBuyCoin:refreshShop()
    local vip = ConfigData.cfg_vip[User.vip]
    self.ui.lbl_vip:setString( string.format("您当前等级为VIP%d，每天可以购买%d次", User.vip, vip.buycoin) )
    self.ui.lbl_left:setString( "剩余购买次数：" .. vip.buycoin - User.buycoin )
    
    local b = nil
    for i = 1, table.getn(ConfigData.cfg_buy_coin) do
        b = ConfigData.cfg_buy_coin[i]
        dump(User.buycoin.."|"..b.min.."|"..b.max)
        if( User.buycoin + 1 >= b.min and User.buycoin + 1 <= b.max )then
            self.ui.lbl_coin:setString( "金币：" .. b.coin * User.ulv )
            self.ui.lbl_ug:setString( string.format("售价：%d钻石",  b.price ) )
            break
        end
    end
end

function ShopBuyCoin:close()
    DialogManager:closeDialog(self)
end

return ShopBuyCoin