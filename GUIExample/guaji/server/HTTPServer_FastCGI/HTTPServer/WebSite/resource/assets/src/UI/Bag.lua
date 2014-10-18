-- @module BagUI
require("src/UI/Dialog/BagSelect")
require("src/UI/Dialog/ItemSelect")

local cmd = require("src/Command")
local frameSize = cc.Director:getInstance():getWinSize()
BagUI = {
  ui = nil,
  needRefresh = false,
  itemList = {},
  bagNum = 0,       -- 背包装备数量
  filterFunc = nil, -- 过滤函数
  
  bag_item_module = nil,          -- 装备背包模板
  bag_item_select_module = nil,    -- 装备选择UI模板
  
  mode = 0  -- 0: 装备模式 1:道具模式
}

BagUI.bag_item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/bag-item.json")
BagUI.bag_item_module:retain()
BagUI.bag_item_select_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/bag-select-item.json")
BagUI.bag_item_select_module:retain()

function BagUI:create()

  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/bag.json"))
    
    self.ui.items_back:setContentSize(640,frameSize.height-390)
    self.ui.list_back:setContentSize(560,frameSize.height-480)
    self.ui.lbl_filtername:setPosition(cc.p(frameSize.width/2,frameSize.height-410))
    self.ui.scv_equipList:setContentSize(560,frameSize.height-500)  
    
  ui_add_click_listener(self.ui.btn_filter,function()
    DialogManager:showDialog("BagFilter")
  end)

  ui_add_click_listener(self.ui.btn_sellmul,function()
    DialogManager:showDialog("BagSellMul")
  end)
  
  ui_add_click_listener(self.ui.btn_item,function()
    self.mode = 1
    self:setNeedRefresh()
    UICommon.setVisible(self.ui.btn_sellmul,false)
    UICommon.setVisible(self.ui.btn_filter,false)
        self.ui.btn_equip:loadTextureNormal( "res/ui/button/btn_106.png")
        self.ui.btn_item:loadTextureNormal( "res/ui/button/btn_105.png")
    self.ui.lbl_filtername:setVisible(false)
    local type = "item"
    if BagUI:checkGuideIcon(type) then
        BagUI:removeGuideIcon(type)
    end
    self:refreshUI()
  end)
  
  ui_add_click_listener(self.ui.btn_equip,function()
    self.mode = 0
    self:setNeedRefresh()
    UICommon.setVisible(self.ui.btn_sellmul,true)
    UICommon.setVisible(self.ui.btn_filter,true)
        self.ui.btn_equip:loadTextureNormal( "res/ui/button/btn_105.png")
        self.ui.btn_item:loadTextureNormal( "res/ui/button/btn_106.png")
    self.ui.lbl_filtername:setVisible(true)
    self:refreshUI()
  end)  

  ui_add_click_listener(self.ui.btn_buycap,function()
    local function onBuyBag(param)
        if(tonum(param[1]) == 1)then
            GameUI:loadUinfo()
            self.ui.bag_capacity:setString( table.getn(self.itemList).."/" .. tonum(param[2].bag) )
        else
            MessageManager:show(param[2])
        end  
    end
    local function onOK()
       sendCommand("buyBag", onBuyBag, {})
    end
        
    AlertManager:yesno("购买背包", RTE( string.format("购买一次可以增加10个背包空间，需要花费 100 钻石，您还可以购买 %d 次", (200 - User.bag) / 10 ),25, cc.c3b(255,255,255)), onOK)    
  end)
    
  local el = self.ui.scv_equipList
  el:setDirection(ccui.ScrollViewDir.vertical)
  el:setTouchEnabled(true)
  el:setBounceEnabled(true)
  
  -- 任何装备除了已装备的
  self.filterFunc = function(v) 
    return not User.isEquiped(v) 
  end 

  self.mode = 0
  self:setNeedRefresh()

  return self.ui
end

function BagUI:getBag()
  -- 读取背包
  local function onGetBag(param)
    cclog("onGetBag start...")
    local bag = param[2];
    
    -- 先计算已装备了的
    table.foreach(bag, function(k,v)
      local euser = tonum(v.euser) 
      if(euser == 1)then
        User.userEquip[tonum(v.etype)] = tonum(v.eid)  -- 人物的装备，部位->eid 
      elseif(euser ~= 0)then
        if(User.userPartnerEquip[euser] == nil)then
          User.userPartnerEquip[euser] = {}
        end
        User.userPartnerEquip[euser][tonum(v.etype)] = tonum(v.eid) -- 佣兵的装备
      end
    end)
    
    -- 加入背包
    table.foreach(bag, function(k,v)    
      self:addEquipToBag(v,false)
    end)
    cclog("onGetBag end...")
    
    -- 道具
    local items = param[3]
    for _,v in pairs(items) do
        User.userItems[tonum(v.itemid)] = tonum(v.count)
    end
  end      
  sendCommand("getBag", onGetBag)
end

-- 增加道具
function BagUI:addItem(itemid, n)
    itemid = tonum(itemid)
    if(itemid == 6) then -- 装备 n为装备信息
        BagUI:addEquipToBag(n,true)
        return
    end
    n = tonum(n)
    if(itemid <= 0) then
        return
    end
    if(itemid == 1) then -- 金币
        GameUI:addUserCoin(n)
        return
    end
    if(itemid == 2) then --钻石
        GameUI:addUserUg(n)
        return
    end
    if(itemid == 5) then -- 经验
        GameUI:addUserExp(n)
        return
    end
    -- itemid=3 精华// itemid=4, 神器碎片 以及 其他
    User.userItems[itemid] = tonum(User.userItems[itemid]) + n
    if(User.userItems[itemid] < 0) then
        User.userItems[itemid] = 0
    end
end

-- 减少道具
function BagUI:reduceItem(itemid, n)
    if itemid ~= 6 then -- 6为装备
        self:addItem(itemid, -n)
    else
        BagUI:removeEquipFromBag(n.eid)
    end
end

function BagUI:getItemCount(itemid)
    itemid = tonum(itemid)
    -- 之后增加对装备/金币/钻石等的支持
    if itemid == 3 then
        -- 强化精华单独处理一下，兼容原来的User.s1结构，等服务器端升级完毕后，再废除User.s1
        return tonum(User.userItems[itemid]) + User.s1
    end
    
    return tonum(User.userItems[itemid])
end

function BagUI:doOpenNormal()
  -- 任何装备除了已装备的
  self.filterFunc = function(v) 
    return not User.isEquiped(v) 
  end 

  self.ui.lbl_filtername:setString("所有装备")  
  self:refreshUI()
end

function BagUI:doOpenNormalWithTypeFilter(i)
  self.ui.lbl_filtername:setString(ConfigData.cfg_equip_etype[i])
  self.filterFunc = function(e)
    return not User.isEquiped(e) and tonum(e.etype) == i  
  end

  self:setNeedRefresh()
  
  self:refreshUI()
end

function BagUI:doOpenNormalWithStarFilter(star)
  self.ui.lbl_filtername:setString(User.starToText(star))
  self.filterFunc = function(e)
    return not User.isEquiped(e) and tonum(e.star) == star  
  end

  self:setNeedRefresh()
  self:refreshUI()
end

function BagUI:doOpenNormalWithMain()
  self.ui.lbl_filtername:setString("神器")
  self.filterFunc = function(e)
    return not User.isEquiped(e) and User.isAdvEquip(e)
  end
  

  self:setNeedRefresh()
  self:refreshUI()
end

function BagUI:doDoSellMulti(star,callback)
  local function onSell(param)
    if(param[1] == 1)then
        local msg = "共卖出"..param[4].."件 获得 ".. param[2] .. "金币"
        if(tonum(param[3]) > 0)then
          msg = msg ..  " ".. param[3] .."精华"
        end
        MessageManager:show(msg)
        
        BagUI.bagNum = BagUI.bagNum - toint(param[4])
        
        GameUI:addUserCoin(param[2])
        GameUI:addUserJinghua(param[3])
        
        table.foreach(User.userEquips, function (k,v)
          -- 强化过的不会被卖
          if not User.isEquiped(v) and not User.isAdvEquip(v) and not User.isUpLv(v) then
            if(toint(v.star) == star)then
              cclog("sell "..v.eid)
              User.userEquips[k] = nil
            end
          end
        end)

        BagUI:setNeedRefresh()
        BagUI:refreshUI()
        MainBtn:checkMaxBag()
    else
      MessageManager:show(param[2])
    end
  end
   
  sendCommand("sellEquipByStar",onSell,{star})
end

function BagUI:onShow()
 -- doOpenNormal
end

function BagUI:doSellEquip(v)
  -- 分解按钮
  local function onSell(param)
    if(param[1] == 1)then
      local msg = "获得 ".. param[2] .. "金币  "
      if(tonum(param[3]) > 0)then
        msg = msg .. param[3] .."精华"
      end 
      MessageManager:show(msg)
            
      -- remove from User.userEquipsBag
      BagUI:removeEquipFromBag(tonum(v.eid))
      
      GameUI:addUserCoin(param[2])
      GameUI:addUserJinghua(param[3])
      
      -- 重新刷新UI, TODO: 优化性能

      self:setNeedRefresh()
      self:refreshUI()
    else
      -- 失败
      MessageManager:show("卖出装备失败"..param[2])
      
    end
  end

  sendCommand("sellEquip", onSell, {tonum(v.eid)})
end

function BagUI:setNeedRefresh()
  self.needRefresh = true
end

function BagUI:setItemInfo(d,v)
    UICommon.setEquipImg(d.item_img, v)
    
    -- 点击装备打开详细面板
    ui_add_click_listener(d.nativeUI, function()
        DialogManager:showDialog( "EquipDetail", v )
    end)
end

function BagUI:addBagNum(num)
    BagUI.bagNum = BagUI.bagNum + num
end

function BagUI:delBagNum(num)
    BagUI.bagNum = BagUI.bagNum - num
end

function BagUI:removeEquipFromBag(eid)
    dump("removeEquipFromBag " .. eid)
    self:setNeedRefresh()
    local e = User.userEquips[tonum(eid)]
    User.userEquips[tonum(eid)] = nil
  
    -- 释放控件
    if e.bag_item ~= nil then 
        e.bag_item.nativeUI:release()
    end
    
    if e.bag_item_select ~= nil then  
        e.bag_item_select.nativeUI:release()
    end
    
    BagUI.bagNum = BagUI.bagNum - 1
    if(BagUI.bagNum == User.bag - 1) then 
        MainBtn:checkMaxBag()
    end
end

-- isNew 是否为新掉落的装备， 否则即更新装备
function BagUI:addEquipToBag(e, isNew) 
    self.needRefresh = true

    local eid = tonum(e.eid)
  
    User.userEquips[eid] = e
    User.updateEquipInfo(e)
  
    -- 显示有一件新装备
    if(isNew)then
        MainBtn:addNewEquipNum(1)
    
        -- 是否比现有装备好，提示
        if(not User.isEquiped(e))then
            local nowEid = tonum(User.userEquip[tonum(e.etype)])
            if( User.isJobFit(e,User.ujob) and (nowEid == 0 or User.equipCompare(e, User.userEquips[nowEid] ))  )then
                EquipUI:showNewEquipTips(e.etype)
            end
        end
    end
  
    -- setupEquipRenderer  是直接创建，这样登陆时装备多的话就会卡一下
    -- setupEquipRenderer2 是访问到的时候再创建，这样第一次打开背包或者熔炼选择、更换装备选择时就会卡
    -- 目前还是登陆卡一下感受更好，因为登陆的时候卡一下正常，游戏中卡感觉很差
    -- 最好的解决方案是启动的时候创建，但是增加一个loading条，不要让玩家觉得游戏卡了
    self:setupEquipRenderer(e)
    --self:setupEquipRenderer2(e)
 
    if(not User.isEquiped(e)) then
        BagUI.bagNum = BagUI.bagNum + 1
        if(BagUI.bagNum == User.bag) then 
            MainBtn:checkMaxBag()
        end
    end
end

function BagUI:setupEquipRenderer(e)
    -- 创建控件  
    e.bag_item = ui_delegate(self.bag_item_module:clone())
    e.bag_item.nativeUI:retain()  
    self:setItemInfo(e.bag_item,e)

    e.bag_item_select = ui_delegate(self.bag_item_select_module:clone())
    e.bag_item_select.nativeUI:retain()
    BagSelect:setItemBaseInfo(e.bag_item_select, e)
end

function BagUI:setupEquipRenderer2(e)
    -- 创建控件函数，如果访问v.bag_item或v.bag_item_select不存在，则创建他们 
    setmetatable( e, {
    __index = function(t,k)
        if k == "bag_item" then
            --cclog("createing bag_item")
            local bag_item = ui_delegate(self.bag_item_module:clone())
            bag_item.nativeUI:retain()  
            self:setItemInfo(bag_item,e)
            rawset(t,k,bag_item)
            return bag_item
        elseif k == "bag_item_select" then
            --cclog("createing bag_item_select")
            local bag_item_select = ui_delegate(self.bag_item_select_module:clone())
            bag_item_select.nativeUI:retain()
            BagSelect:setItemBaseInfo(bag_item_select, e)
            rawset(t,k,bag_item_select)
            return bag_item_select
        else
            return nil
        end
    end })
end

-- 更新装备
function BagUI:updateEquip(e, showChanges)
  self.needRefresh = true

  local eid = tonum(e.eid)
  
  -- 先把原来的删掉
  if(User.userEquips[eid] ~= nil)then
    self:removeEquipFromBag(eid)
  else
    cclog(eid .. " not exist !")
    return    
  end

  User.userEquips[eid] = e
  BagUI.bagNum = BagUI.bagNum + 1
  if(BagUI.bagNum == User.bag) then
    MainBtn:checkMaxBag()
  end
  
  User.updateEquipInfo(e)

  -- 是否为已经装备了的装备
  if(User.isEquiped(e))then
    if(not User.isEquipedByPartner(e))then
      -- 更新人物数据
      EquipUI.doEquip(e, showChanges)
    else
      -- 更新雇佣兵数据
      PartnerUI.doEquip(e, showChanges)
    end
  else
    -- 是否比现有装备好，提示
    local nowEid = tonum(User.userEquip[tonum(e.etype)])
    if( User.isJobFit(e,User.ujob) and (nowEid == 0 or User.equipCompare(e, User.userEquips[nowEid] ))  )then
      EquipUI:showNewEquipTips(e.etype)
    end
  end
    
  -- 创建控件  
  e.bag_item = ui_delegate(self.bag_item_module:clone())
  e.bag_item.nativeUI:retain()  
  self:setItemInfo(e.bag_item,e)
  
  e.bag_item_select = ui_delegate(self.bag_item_select_module:clone())
  e.bag_item_select.nativeUI:retain()
  BagSelect:setItemBaseInfo(e.bag_item_select, e)
  
end


function BagUI:refreshUI()
  if(self.needRefresh == false)then
    return
  end
  self.needRefresh = false
    
  -- 清空背包所有的内容
  self.ui.scv_equipList:removeAllItemsWithCleanup(false) -- 保留actions  
  self.itemList = {}
 
  local num = 0
  if(self.mode == 0)then
      self.ui.bag_capacity_back:setVisible(true)  
      -- 筛选符合条件的装备
      table.foreach(User.userEquips, function(k,v)
        -- 过滤一下
        if( self.filterFunc(v) )then
          table.insert( self.itemList, v )
        end    
      end)
      
--       按装备是否为神器、宝石、强化、颜色、评分排序
      table.sort(self.itemList, function(a,b)
        local isMainA = User.isAdvEquip(a)
        local isMainB = User.isAdvEquip(b)
        if(isMainA ~= isMainB)then
          return isMainA
        end
        local isGemA=User.isGemEquip(a)
        local isGemB=User.isGemEquip(b)
        if (isGemA ~= isGemB) then
            return isGemA
        end
        
        if(tonum(a.uplv) ~= tonum(b.uplv)) then
            return tonum(a.uplv) > tonum(b.uplv)
        end
        
        if(tonum(a.star) ~= tonum(b.star))then
          return tonum(a.star) > tonum(b.star)
        end
        
        if(tonum(a.ceid) ~= tonum(b.ceid))then
          return tonum(a.ceid) > tonum(b.ceid)
        end
        
        return tonum(a.score) > tonum(b.score)
      end)
      
      num = table.getn(self.itemList)
      
      self.bagNum = num
      self.ui.bag_capacity:setString(num.."/"..User.bag)
      MainBtn:checkMaxBag()
  else
      self.ui.bag_capacity_back:setVisible(false)
       
      table.foreach(User.userItems, function(k,v)
        local count = BagUI:getItemCount(k) 
        if count > 0 then
            --创建一个item 
                local item = {}
                local showBtn=true
                item.itemid = k
                item.bag_item = ui_delegate(self.bag_item_module:clone())
                UICommon.setItemImg(item.bag_item.item_img, k, count )
                ui_add_click_listener(item.bag_item.nativeUI, function()
            	   DialogManager:showDialog("ItemDetail", k,showBtn)
                end)
                if k == 3 or k == 4 or k > 10 then
                   table.insert( self.itemList, item )
                end
        end      
      end)

      table.sort(self.itemList,function(a,b)
        return a.itemid < b.itemid
      end)
      num = table.getn(self.itemList)
  end
  
    local height = math.max(frameSize.height-400, math.ceil(num / 5) * 123 )
  self.ui.scv_equipList:setInnerContainerSize(cc.size(500, height))
  
  -- 创建item renderer
  local x = 5
  local y = height - 90
  for k,v in pairs(self.itemList) do
    self.ui.scv_equipList:addChild(v.bag_item.nativeUI)
    v.bag_item.nativeUI:setPosition(cc.p(x,y))
    x = x + 112
    if(x >= 560)then
      x = 5
      y = y - 123
    end
   end
   
   self.ui.scv_equipList:jumpToTop() -- 背包切换模式以后自动滚动到top
   
end

function BagUI:setGuideIcon(type)
    local btnname = ""
    if type == "item" then
        btnname = type
    end
    if self.ui["btn_"..btnname] == nil then
        return 
    end
    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end

    local img_guide = ccui.ImageView:create("res/ui/icon/icon_26.png")
    img_guide:setTag(7777)
    img_guide:setPosition(cc.p(120,45))
    self.ui["btn_"..btnname]:addChild(img_guide)
    local ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.50,0.50))
    local s = img_guide:getContentSize()        
    ani:setPosition(s.width/2+3,s.height/2+5)
    img_guide:addChild(ani)
end

function BagUI:removeGuideIcon(type)
    local btnname = ""
    if type == "item" then
        btnname = type
    end
    if self.ui["btn_"..btnname] == nil then
        return false
    end
    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end
end

function BagUI:checkGuideIcon(type)
    local btnname = ""
    if type == "item" then
        btnname = type
    end

    if self.ui["btn_"..btnname] == nil then
        return false
    end

    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        return true
    end
    return false
end

function BagUI:addItemArr(itemarr,showMsg)
    if showMsg == nil then
        showMsg = true
    end
    table.foreach(itemarr,function(k, v)
        BagUI:addItem(v.itemid, v.count)
        BagUI:setNeedRefresh()
        if showMsg then
            if tonum(v.itemid) ~= 6 then
                local c = ConfigData.cfg_item[toint(v.itemid)]
                MessageManager:show(string.format("获得%s*%s",c.name,v.count))
            else
                local lv = toint(v.count.lv) - toint(v.count.lv) % 5
                local colorTxt = User.starToText(v.count.star)
                local color = User.starToColor(v.count.star)
                if tonum(v.count.advp) > 1000 then
                    colorTxt = "双属性神器"
                    color = User.starToColor(5)
                elseif tonum(v.count.advp) > 0 then
                    colorTxt = "神器"
                    color = User.starToColor(5)
                end
                local color = User.starToColor(v.count.star)
                local etype = ConfigData.cfg_equip_etype2[toint(v.count.etype)]
                MessageManager:show(string.format("获得%s级%s%s",lv,colorTxt,etype),color)
            end
        end
    end)
end

return BagUI