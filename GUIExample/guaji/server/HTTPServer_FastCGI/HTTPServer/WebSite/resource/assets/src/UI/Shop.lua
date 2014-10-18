-- @module ShopUI

local cmd = require("src/Command")
local frameSize = cc.Director:getInstance():getWinSize()
local ShopUI = {
  ui = nil,
  itemlist = nil,
  goods = nil,
  buys = nil,
  shop_item = nil,
  refreshtime = 0,
  isOld=0,
  reset=0,
  n=0
}

function ShopUI:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/shop.json"))
  
    self.ui.Image_55:setContentSize(640,frameSize.height-(frameSize.height-960)/7- 395)
    self.ui.list_back:setContentSize(560,frameSize.height-(frameSize.height-960)/7 - 455)
    self.ui.list_item:setContentSize(550,frameSize.height-(frameSize.height-960)/7 - 470)
    self.ui.slider_back:setContentSize(8,frameSize.height-(frameSize.height-960)/7- 470)
  
  self.shop_item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/shop_item.json")
  self.shop_item:retain()
  self.itemlist = self.ui.list_item
  
  ui_add_click_listener(self.ui.btn_buyall,function()
    AlertManager:yesno("全部购买",RTE(string.format("是否购买全部商品?",ug),25,cc.c3b(255,255,255)),function()
        self:buyAll()
    end)
  end)
  
  ui_add_click_listener(self.ui.btn_buycoin,function()
        DialogManager:showDialog("ShopBuyCoin")
  end)
  
  ui_add_click_listener(self.ui.btn_refresh,function()
        function onOK()
             self:refreshItems()
        end
        local ug=ShopUI:resetUg(self.reset+1)    
        AlertManager:yesno("刷新商店",RTE(string.format("刷新商店需要%d钻,是否继续?",ug),25,cc.c3b(255,255,255)),onOK)
  end)
  
  return self.ui
end

function ShopUI:onShow()
    GameUI:setMainHeaderVisible(true)
    local now = getSystemTime()
--    dump(self.refreshtime)
--    if now > self.refreshtime then
--        dump(now)
        self:refreshShop()
--    end
end

function ShopUI:buyAll()
  table.foreach(self.goods,function(k,v)
    if(self:isGoodsInBuys(toint(v)) == false) then
     self:onBuyBtnClick(toint(v))
    end
  end)
end
function ShopUI:resetUg(reset)
    local ug=0
    if reset==1 then
        ug=50
    elseif reset>=2 and reset<=3 then
        ug=100
    elseif reset>=4 and reset<=6 then
        ug=200
    elseif reset>=7 and reset<=10 then
        ug=350
    elseif reset>=11  then
        ug=500
    end
    return ug
end
function ShopUI:refreshItems()
  sendCommand("resetShop", function(param)
    if param[1]==1 then
        self.goods = {}
        self.buys = {}  
        self:onGetShop(param)
        local ug=self:resetUg(self.reset)
        GameUI:addUserUg(-ug)  
        GameUI.mainHeader:refreshUinfoDisplay()
    elseif param[1]==0 then
        MessageManager:show(param[2])
    end
  end)
end

function ShopUI:onGetShop(param)
 if(param[1]==1) then
    local d = ui_delegate(self.ui.shop_info)
    --刷新次数
    self.reset=tonumber(param[2].reset)
    
    --设置时间
    self.refreshtime = tonum(param[2].ts)
    --local time = UICommon.timeFormat( tonum(param[2].tsleft) )
    --d.txt_time:setString(time)
    
    --查看是不是新的版本
    local rate=toint(tonum(param[2].n)*400/(tonum(param[2].n)+20)+100)
    self.n=toint(param[2].n)
    self.ui.lbl_rate:setString(rate.."%")
    self.isOld = tonum(param[2].v)
  
    --设置商品
   local goodsTable = string.split(param[2].goods,",")

   
    table.foreach(goodsTable,function(k,v)
     if(toint(v)>10) then
        table.insert(self.goods,toint(v))    
      end
    end)
    --设置已买商品
    local buyTable = string.split(param[2].buys,",")
    table.foreach(buyTable,function(k,v)
      if(toint(v)~=0) then
        table.insert(self.buys,toint(v))
      end
    end)
    self:draw()
    if param[4] ~= nil then
        MessageManager:show(param[4],cc.c3b(255,0,0)) 
    end
 else
    MessageManager:show(param[2])
 end
end

function ShopUI:refreshShop()
  cclog("shop refresh")
  self.goods = {}
  self.buys = {}
  sendCommand("getShopnew", function(param)
    self:onGetShop(param)
  end)
end


function ShopUI:draw()
  self.itemlist:removeAllChildren()
  
  local num = table.getn(self.goods)-table.getn(self.buys)
    local height = math.max(frameSize.height - 500, math.ceil(num / 3) * 220 )
  self.itemlist:setInnerContainerSize(cc.size(550, height))
  
  local x = 12
  local y = height-220
 
  --for i=table,..,1,-1 do
  local sortFunc = function(a, b)
     local flag1=a%10000 
     local place1=(flag1-flag1%1000)/1000
     local flag2=b%10000 
     local place2=(flag2-flag2%1000)/1000
     if(place1>place2)then return true
     else return false end
  end
  table.sort(self.goods, sortFunc)
  
  table.foreach(self.goods,function(k,v)
  if(self:isGoodsInBuys(toint(v)) == false) then
      --        local custom_item = self.itemlist:getChildren(self.itemlist:getChildrenCount()-1)
      -- 原来的v是一个equip对象,现在的v是一个eid和type的组合
      local buyeid=toint(v)
      local flag=buyeid%10000
      local eid=(buyeid-flag)/10000
      local buytype=1--1是金币，2是砖石
      local ismain=0--是否是高级装备
      local num=1--道具数量
      local mCheap=0--是否打折
      local mPrice=1--价格
      local place=0--位置，6,7,8为高级装备位置
      local ieid=0--item带数量的id
      local cf=0--装备信息
      local name=""--装备名称
      place=(flag-flag%1000)/1000
      flag=flag%1000 --属于冗余信息,避免某等级符合条件装备过少时id重复所用
      local isItem=1   --2是道具，1是装备
      
      if flag~=0 then
          if(eid<1000) then
            num=eid%10
            isItem=2
            ieid=eid
            eid=(eid-num)/10
            if  num==0 then num=10 end
          end
          cclog('goods'..eid) 
          if(isItem==1)then
            cf = ConfigData.cfg_equip[eid]
            name = cf.ename
          else
            cf = ConfigData.cfg_item[eid]
            name = cf.name
          end
          local gstar=flag%10
       
          if(self.isOld == 1) then
          
             if(place>=6 and place<=8)then
                ismain=1
              end
              mCheap=10-((flag-flag%100)/100)
              
              local pricearr={
                    [1]={
                        [3]=50,[4]=240,[5]=2200,
                    },
                    [2]={ 
                        [40]=2200,[41]=240,[221]=70,[231]=240,[213]=70,[223]=200,[233]=700,[230]=2200,[220]=650,[210]=220,
                    },
               }
         
               if flag%100>=20 then
                   buytype=2
               else
                   buytype=1
               end    
               if(isItem==1 and gstar==3 and buytype==1)then
                    mPrice=math.ceil(cf.lv*3000*mCheap/10)
               elseif(isItem==1 and buytype==2)then
                    mPrice=math.ceil(pricearr[isItem][gstar]*mCheap/10)
               elseif buytype==2 then
                    mPrice=math.ceil(pricearr[isItem][ieid]*mCheap/10)
               end       
            
          else
              if flag%100>=20 then
              	buytype=2
              end
              
              local pricearr={
                  [1]={
                       [2]=500,[3]=3000, },
                  [2]={ 
                       [3]=45,[4]=288,
                   },
               }
               if buytype==1 and cf.lv~=nil then
                    mPrice=cf.lv*pricearr[1][gstar]
               else
                    mPrice=pricearr[2][gstar]
               end
    
           end
         
          -- 根据eid,buytype,ismain 显示商城中的物品
          local v = { eid=buyeid ,ename = name, star = gstar, buytype = buytype, ceid = eid, price =mPrice,cheap = mCheap,senior = ismain,isItem=isItem,num=num}
         
          local d = ui_delegate(self.shop_item:clone())
          self.itemlist:addChild(d.nativeUI)
          self:setItemInfo(d,v)
          d.nativeUI:setPosition(cc.p(x,y))
          x = x + 177
          if(x >= 500)then
            x = 12
            y = y - 225
          end
        end--当装备不为空时的判断结束
    end
  end)
--  self.itemlist:jumpToTop()

end

function ShopUI:isGoodsInBuys(eid)
  local result = false
  table.foreach(self.buys,function(k,v)
    if(v == eid) then
      result = true
    end
  end)
  return result
end
function ShopUI:goodsPrice(eid)
end
function ShopUI:setItemInfo(d,v)
  d.lbl_name:setString(v.ename)
  d.lbl_name:setColor( User.starToColor(toint(v.star)) )
  d.lbl_name:setFontName(Config.font)
  d.lbl_name:getVirtualRenderer():enableShadow( cc.c4b(255,0,0,0), cc.size(1,-1), 0 )
  if(v.isItem==1)then
    UICommon.setEquipImg(d.item_img, v)
  else
    UICommon.setItemImg(d.item_img, v.ceid, v.num ,false,v.star)
  end
  
  if(toint(v.buytype) == 2) then
        d.icon_cost:loadTexture("res/ui/icon/icon_02.png")
  end
  
  d.txt_cost:setString(v.price)
  
  if(v.cheap == 8) then
    d.img_cheap:loadTexture("res/ui/images/img_208.png")
  elseif(v.cheap == 5)then
    d.img_cheap:loadTexture("res/ui/images/img_209.png")
  elseif(v.cheap == 1)then
     d.img_cheap:loadTexture("res/ui/images/img_210.png")
  else 
    d.img_cheap:setVisible(false);
  end
   
  if(v.senior == 1) then
    d.Panel_1947:setBackGroundImage("res/ui/images/img_207.png")
    d.img_vip:setVisible(true)
  else
    d.img_vip:setVisible(false)
  end
  
  ui_add_click_listener(d.btn_buy, function()
        self:onBuyBtnClick(toint(v.eid))
  end)
  
  local function touchEvent(sender,eventType)
        print("touch -- itemid == "..v.ceid)
        if  eventType == ccui.TouchEventType.ended  and tonum(v.ceid) < 1000 then
            DialogManager:showDialog("ItemDetail", tonum(v.ceid),false)
      end
    end
    d.item:setTouchEnabled(true)
    d.item:addTouchEventListener(touchEvent) 
end

function ShopUI:onBuyBtnClick(eid)
  local function callback(param)
  dump(param)
    if(param[1]==1) then
        MessageManager:show("购买"..param[2].ename.."成功")
        BagUI:addEquipToBag(param[2],true)  
        table.insert(self.buys,eid)
        self:draw()
        -- 本地扣钱
        GameUI:onLoadUinfo(param[3])
        if(toint(self.itemlist:getChildrenCount())==0) then
            self:refreshShop()
        end
    elseif param[1]==2 then
      
        if toint(param[2].itemid )== 6 then
        --parem[2].iteamid==6代表是装备，param[2].count是一个equip array
          MessageManager:show("购买"..(param[2].count).ename.."成功")
          BagUI:addEquipToBag(param[2].count,true)
        else
           local eid = param[2].itemid
           local count=tostring(param[2].count)
           MessageManager:show("购买"..count.."个"..ConfigData.cfg_item[eid].name.."成功")
           BagUI:addItem(eid,param[2].count)
        end
        table.insert(self.buys,eid)
        self:draw()
        if(toint(self.itemlist:getChildrenCount())==0) then
            self:refreshShop()
        end
         local price=param[2].price
         if(param[2].buytype==1)then --buytype
            GameUI:addUserCoin(-price)
        else
            GameUI:addUserUg(-price)
        end
        GameUI.mainHeader:refreshUinfoDisplay()
        self.n=self.n+1
        self:showNewRate();
    else
      MessageManager:show(param[2]) 
    end
  end
  cclog("buy eid :"..eid)
  sendCommand("buyEquip",callback,{eid})
end

function ShopUI:showNewRate() --@return typeOrObject
    local function changeRate()
        local rate=toint(self.n*400/((self.n)+20)+100);
        self.ui.lbl_rate:setString(rate.."%")     
    end
    local s1=cc.ScaleTo:create(0.3,1,0);
    local c1=cc.CallFunc:create(changeRate)
    local s2 = cc.ScaleTo:create(0.3,1,1);
    local easeBackOut=cc.EaseBackOut:create(s2)
    local sq =cc.Sequence:create(s1,c1,easeBackOut);
    self.ui.lbl_rate:runAction(sq);
end

return ShopUI