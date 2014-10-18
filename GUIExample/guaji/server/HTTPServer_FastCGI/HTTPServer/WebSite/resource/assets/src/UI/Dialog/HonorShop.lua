local HonorShop = {
    ui = nil,
    reset = 0,
    goods = {}, 
    buys = {},
    notBuys = {},
}

function HonorShop:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/honor-shop.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)
    
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpHonorExchange())
    end)
    
    ui_add_click_listener(self.ui.btn_reset,function()
        function onOK()
            self:resetItems()
        end
        local h=self:getResetHonor(self.reset+1)    
        AlertManager:yesno("刷新商店",RTE(string.format("刷新荣誉商店需要%d荣誉,是否继续?",h),25,cc.c3b(255,255,255)),onOK)
    end)

  

    return self.ui
end

function HonorShop:close()
    DialogManager:closeDialog(self)
end

function HonorShop:getBuyItemid(i)
    return tonum(self.notBuys[i])
end

function HonorShop:buyItem(itemid)
    
    local function callback(params)
        dump(params)
        if params[1] == 1 then
            local itemname = ConfigData.cfg_item[params[2].itemid].name
            MessageManager:show("兑换成功!获得"..itemname.."*"..params[2].count)
            -- 刷新背包
            BagUI:addItem(params[2].itemid, params[2].count)
            BagUI:reduceItem(7,params[2].price)
            BagUI:setNeedRefresh()
            --刷新界面显示
            self.ui.lbl_honor:setString(tonum(User.userItems[7]))
            table.insert(self.buys,params[2].buyeid)
            self:draw()
            if(toint(table.getn(self.buys))==6) then
                self:getShopItem()
            end
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("buyHonorShop",callback,{itemid})
end


function HonorShop:onShow()

    self.ui.lbl_honor:setString(tonum(User.userItems[7]))
    self:getShopItem()
   
end
function HonorShop:getShopItem()
    local function callback(params)
        if params[1] == 1 then
            self.goods={}
            self.buys={}
            self.notBuys = {}
            self:setItemList(params[2])
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getHonorShop",callback)
end
function HonorShop:resetItems()
    local function callback(params)
        if params[1] == 1 then
            self.goods={}
            self.buys={}
            self.notBuys = {}
            self:setItemList(params[2])
            local h=self:getResetHonor(self.reset)
            BagUI:reduceItem(7,h)
            self.ui.lbl_honor:setString(tonum(User.userItems[7]))
           
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("resetHonorShop",callback)
end

function HonorShop:getResetHonor(times)
    if times <= 1 then
        return 10
    elseif times <= 3 then
        return 30
    elseif times <= 6 then
        return 80
    else
        return 150
    end
end

function HonorShop:setItemList(params)
    local goodsTable = string.split(params['goods'], ",")
    table.foreach(goodsTable, function(k, v)
        if toint(v) ~= 0 then
            table.insert(self.goods,toint(v))
        end
    end)
    
    local buysTable = string.split(params['buys'], ",")
    table.foreach(buysTable, function(k, v)
        if toint(v) ~= 0 then
            table.insert(self.buys, toint(v))
        end
    end)
    self:draw()
    self.reset = toint(params['reset'])
end

function HonorShop:draw()
 
    for n = 1, 6 do
        self.ui["pnl_buy_"..n]:setVisible(false)
    end
    local i = 0
    table.foreach(self.goods,function(k,v)
        if  self:isGoodsInBuys(v) == false then
            i = i + 1
            local itemid = math.floor(toint(v)/100000)
            self.ui["pnl_buy_"..i]:setVisible(true)
            local pnl = self.ui["pnl_buy_"..i]
            local p = ConfigData.cfg_honor_shop[toint(itemid)]
            local name = ConfigData.cfg_item[tonum(itemid)].name
            UICommon.setItemImg(ui_(pnl, "Image_18"), tonum(itemid), 0, false)
            ui_(pnl, "lbl_ug"):setString(name)
            ui_(pnl,"lbl_price"):setString(p.cost.."荣誉")
            table.insert(self.notBuys,toint(v))
            local btn = ui_(pnl, "btn_buy")
            ui_(pnl, "lbl_num"):setVisible(false)
            ui_add_click_listener(btn, function(sender,eventType)
             self:buyItem(v)
            end)
            
            local function touchEvent(sender,eventType)
                print("touch -- itemid == "..itemid)
                if  eventType == ccui.TouchEventType.ended then
                    DialogManager:showDialog("ItemDetail", tonum(itemid),false)
                end
            end
            ui_(pnl,"item"):setTouchEnabled(true)
            ui_(pnl,"item"):addTouchEventListener(touchEvent) 
        end
    end)
    
end

function HonorShop:isGoodsInBuys(eid)
    local res = false
    
    table.foreach(self.buys,function(k,v)
        if toint(v) == toint(eid) then
            res = true
        end
    end)
    return res
end

return HonorShop