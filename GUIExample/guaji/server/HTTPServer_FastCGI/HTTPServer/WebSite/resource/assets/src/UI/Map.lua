Map = {
    ui = nil,
    itemlist = nil,
    mapid = 0,   --当前地图
    report = nil,
    maxmap = 0,
    needRefresh = true
}

function Map:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/map.json"))

  local map_item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/map_item.json")
  
   local frameSize = cc.Director:getInstance():getWinSize()
   self.ui.Panel_5:setContentSize(640,frameSize.height - 230)
   self.ui.Panel_12:setContentSize(590,frameSize.height - 312)
   self.ui.map_list:setContentSize(576,frameSize.height - 326)
  
  
  self.itemlist = self.ui.map_list
  self.itemlist:setItemsMargin(8)
  self.itemlist:setItemModel(map_item)
  
  ui_add_click_listener(self.ui.btn_buy,function()
    local function onOK()
      sendCommand("buyPvb",function(param)
        if(param[1] == 1)then
            GameUI:onLoadUinfo(param[2])
            self.ui.lbl_left:setString( string.format("%d", tonum(User.pvb) ) )
        else
            MessageManager:show(param[2])
        end
      end)
    end
    
    local cost = 0
    if User.pvbbuy < 1 then
    	cost = 50
    elseif(User.pvbbuy < 3)then
        cost = 100
    elseif(User.pvbbuy < 6)then
        cost = 200
    elseif(User.pvbbuy < 10)then
        cost = 400
    else
        cost = 800        
    end
    
    local vip = ConfigData.cfg_vip[User.vip]
    
    AlertManager:yesno("购买挑战次数", 
    {   
        RTE( string.format("今天第%d次购买挑战BOSS次数将花费%d钻石，确定？", User.pvbbuy + 1, cost),25, cc.c3b(255,255,255)),
        RTE( string.format("(您是VIP%d，今天还可以购买%d次)", User.vip, vip.buypvb - User.pvbbuy),20, cc.c3b(152,84,162))
    }, onOK)  
  end)
  
  self.report = nil
  self.maxmap = 0
  self.needRefresh = true
  
  return self.ui
end

function Map:onShow(type)
    self:draw(type)
   
end

function Map:draw(type)
    -- TODO: 优化，没必要每次都删了重建
    self.ui.lbl_left:setString( string.format("%d", tonum(User.pvb)) )
    if self.maxmap == User.umid and not self.needRefresh then
        return false
    end
    self.itemlist:removeAllItems()
    --更新note标题
    if (self.report ~= nil) then
        self.report:removeFromParent(true)
    end
    
    self.report = ccui.RichText:create()
    local size = self.ui.p_bg:getContentSize()
    self.report:setAnchorPoint(cc.p(0,1))
    self.report:ignoreContentAdaptWithSize(false)
    self.report:setContentSize(size)
    self.report:setLocalZOrder(10)
    self.ui.p_bg:addChild(self.report)

    local maxm = table.getn(ConfigData.cfg_map)
    local umid = User.umid
    
    local text={
        RTE("已经开启",20,cc.c3b(255,255,255)),
        RTE(string.format("%d个",User.umid),20,cc.c3b(3,240,4)),
        RTE("挂机地图,",20,cc.c3b(255,255,255)),
        RTE(string.format("%d个",maxm-math.min(User.umid,maxm)),20,cc.c3b(5,179,233)),
        RTE("未开启,",20,cc.c3b(255,255,255)),
        RTE("BOSS扫荡",20,cc.c3b(255,255,255)),
        RTE("VIP1",20,cc.c3b(255, 204, 0)),
        RTE("开放",20,cc.c3b(255,255,255)),
    }
    for _,v in pairs(text) do
        self.report:pushBackElement(v)  
    end
    self.report:formatText()
    self.report:setPosition(cc.p(10, 28))

    if(User.umid == 1) then
        umid=umid+1
    end
    for i = 1, math.min(umid,maxm) do
        self.itemlist:pushBackDefaultItem()
        local custom_item = self.itemlist:getItem(self.itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        
        self:setItemInfo(d,i,type)
    end
    if User.umid == 1 then 
    
    end
    self.itemlist:refreshView()
    self.itemlist:jumpToBottom()
    self.maxmap = User.umid
    self.needRefresh = false
    -- 新手指导吧.. 4级图了就不管了 会麻烦
    --[[if type ~= nil and math.min(User.umid,maxm) < 5 then
        self.ui.img_arr:setVisible(true)
        dump(math.min(User.umid,maxm,4))
        if type == 1 then
            self.ui.img_arr:setPosition(cc.p(125, 820-154*math.min(User.umid,maxm,4)))
        else
            self.ui.img_arr:setPosition(cc.p(515, 820-154*math.min(User.umid,maxm,4)))
        end
        
        self.ui.img_arr:stopAllActions()
        local sequence = cc.Sequence:create( cc.MoveBy:create(1,cc.p(0,15)),cc.MoveBy:create(1,cc.p(0,-15)) )
        self.ui.img_arr:runAction(cc.RepeatForever:create(sequence))
    else
        self.ui.img_arr:stopAllActions()
        self.ui.img_arr:setVisible(false)
    end]]--
end

function Map:setItemInfo(d,v, type)
  UICommon.loadExternalTexture(d.img_map,string.format("res/map/map_%03d.jpg",v))
  
  local m = ConfigData.cfg_map[v]
  d.lbl_mapname:setString( m.mname )
  d.lbl_monsterLv:setString( string.format("怪物等级 Lv.%d ", m.minlv+1) )
    
  d.img_new:setVisible(false)
  d.nativeUI:setTouchEnabled(true)
  d.img_map:setTouchEnabled(true)
  d.btn_pkBoss:setTouchEnabled(true)

  if User.umid == 1 and v == 2 then
        
        d.img_cur:setVisible(false)
        d.Panel_9:setBackGroundImageCapInsets(cc.rect(182,35,1,1))
        UICommon.loadExternalTexture(d.img_map,"res/map/map_101.jpg")
        d.btn_pkBoss:loadTextureNormal("res/map/map_102.jpg")
        d.nativeUI:setContentSize(553,145)
        d.Panel_9:setPosition(cc.p(0,0))
        d.Panel_10:removeFromParent(true)
        d.btn_pkBoss:setPosition(cc.p(81, 131))
        d.btn_pkBoss:setTouchEnabled(false)
        d.Panel_9:setTouchEnabled(false)
        
  elseif(v == self.mapid)then
  
        d.img_cur:setVisible(true)
        d.Panel_9:setBackGroundImage("res/ui/images/img_139.png")
        d.Panel_9:setBackGroundImageCapInsets(cc.rect(182,35,1,1))
 
  else
    d.img_cur:setVisible(false)
    if(v == User.umid) then  
        d.img_new:setVisible(true)
    end
  end
  
  if(v < User.umid and User.umid ~= 1) then
        if User.vip>0 then
            d.btn_pkBoss:loadTextureNormal("res/ui/button/btn_164.png")
        end
        d.nativeUI:setContentSize(553,145)
        d.Panel_9:setPosition(cc.p(0,0))
        d.Panel_10:removeFromParent(true)
  end 
  if(v >= 35) then
    d.nativeUI:setContentSize(553,145)
    d.Panel_9:setPosition(cc.p(0,0))
    d.Panel_10:removeFromParent(true)
  end
  ui_add_click_listener(d.img_map,function()
    cclog("start map ".. v)
    if self.mapid ~= v and BattleUI.battleStatisticsUI ~= nil then
        self:close()
        BattleUI.battleStatisticsUI:setInitData()
    end
    if self.mapid ~= v then
        self.needRefresh = true
    end
    self.mapid = v
    
    local b = require("src/UI/Battle")
    b:changeMap(v)
    GameUI:switchTo("battleUI")
  end)

  ui_add_click_listener(d.btn_pkBoss,function()
    cclog("pkboss")
    if(User.vip>0 and v<User.umid) then
        self:VIPpkBoss(v)
    else
        self:pkBoss(v)
    end
   
  end)
end
function Map:close()
    if(self.report ~= nil)then
        self.report:removeFromParent()
    end
    self.report = nil
    
end

function Map:pkBoss(v)
    if  User.pvb <= 0 then
        local bossCard=tonum(User.userItems[11])
        if bossCard > 0 then 
            AlertManager:yesno("提示",RTE(string.format("您还有%d张BOSS挑战券，是否使用BOSS挑战券",bossCard),25,cc.c3b(255,255,255)) ,function ()
                Map:onUse(v,1)
            end,"使用")
            return 
        else
            AlertManager:ok("提示", RTE("挑战BOSS的次数已用完！",25,cc.c3b(255,255,255)) )
            return
        end
    end
    self:close()
    local b = require("src/UI/Battle")
    GameUI:switchTo("battleUI")
    b:addPkBoss(v)
    return
end  

function Map:VIPpkBoss(v)
    local bossCard= tonum(User.userItems[11])
    if bossCard > 0 and User.pvb <= 0 then

        Scheduler.performWithDelayGlobal(function ()
            AlertManager:yesno("提示",RTE(string.format("您还有%d张BOSS挑战券，是否使用BOSS挑战券",bossCard),25,cc.c3b(255,255,255)),function()
                Map:onUse(v,2)
            end,"使用") 
        end,0)
        return 

    elseif User.pvb <= 0 then

        AlertManager:ok("提示", RTE("挑战BOSS的次数已用完！",25,cc.c3b(255,255,255)) )
        return

    elseif User.vip < 1 then

        AlertManager:ok("提示", RTE("VIP1及以上开始扫荡功能",25,cc.c3b(255,255,255)) )
        self:close()
        local b = require("src/UI/Battle")
        GameUI:switchTo("battleUI")
        b:addPkBoss(v)
        return 

    end
    sendCommand("pvbQuick",function (param)
        if param[1] == 1 then
            self:getGift(param[2])
        else
            MessageManager:show(param[2])
        end
    end,{v})
end

function Map:onUse(v,type)
    local function callback(params)
        if params[1] == 1 then
            User.pvb=1+User.pvb
            Map.ui.lbl_left:setString( string.format("%d", tonum(User.pvb)) )
            MessageManager:show("使用成功")
            BagUI:reduceItem(11,1)
            BagUI:setNeedRefresh()
            if v ~= nil and type ~= nil then
            if type == 1 then
                self:pkBoss(v)
            elseif type == 2 then
                self:VIPpkBoss(v)
            end
        end
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("useItem",callback,{11})
end
 
function Map:getGift(BattleLog)
    local texts = {}
    dump(BattleLog["log"])
        local log = BattleLog["log"]
        table.insert( texts, RTE("战斗胜利,",25,cc.c3b(255,255,255)))
        table.insert( texts, RTE("经验+"..log[4] ..",",25,cc.c3b(255,0,255)))
        GameUI:addUserExp(log[4])

        table.insert( texts, RTE("金钱+"..BattleLog["log"][5] ..",",25,cc.c3b(153,0,255)))
        GameUI:addUserCoin(log[5])
       
        GameUI:addUserJinghua(BattleLog["log"][7])
        if(log[7]~=0) then
            table.insert( texts, RTE("精华+"..log[7] .."\n",25,cc.c3b(0,102,255)))  
        end
        
        User.ug = User.ug + log[8];
        if(log[8]~=0) then
            table.insert( texts, RTE("钻石+"..log[8] .."\n",25,cc.c3b(0,102,255)))  
        end

        --获得装备
    local equipDataArr = log[6]--这是一个equips的array    
    if(table.getn(equipDataArr) ~= 0)then
        for i=1,table.getn(equipDataArr) do
            local equipData=equipDataArr[i]
            if equipData[1] ==1 then

                local e=equipData[2]
                table.insert( texts, RTE("获得装备 ",25,cc.c3b(255,255,255)))
                table.insert( texts, RTE("[".. User.getEquipName(e) .. "]",25,User.starToColor(e.star)) )
                table.insert( texts, RTE("\n"))
                BagUI:addEquipToBag(e,true)
            elseif equipData[1] == 2 then   
                table.insert( texts,  RTE("卖出",25,cc.c3b(255,255,255)))         
                table.insert( texts,  RTE( User.starToText(equipData[2]) .. "装备", 25, User.starToColor(equipData[2]) ))
                table.insert( texts, RTE(","))
                table.insert( texts,  RTE("获得金钱"..equipData[3],25,cc.c3b(153,0,255)))
                table.insert( texts, RTE(","))
                if(equipData[4]~=0) then
                    table.insert( texts, RTE("获得精华"..equipData[4],25,cc.c3b(0,102,255)))
                    table.insert( texts, RTE("\n"))                        
                end
            end
        end
    end
       --dump(BattleUI.BattleLog)
    local box = tonum(BattleLog["box"])
    local boxitem = tonum(BattleLog["boxitem"])
    local boxcount = tonum(BattleLog["boxcount"])
        if(box ~= 0) then
            table.insert( texts, RTE("发现",25,cc.c3b(255,255,255)))
            table.insert( texts, RTE(ConfigData.cfg_item[box].name,25,User.starToColor(box%10+1)))
            if(boxitem ~= 0 and boxcount ~= 0) then
            table.insert( texts, RTE(" 使用",25,cc.c3b(255,255,255)))
            table.insert( texts, RTE(ConfigData.cfg_item[box-10].name,25,User.starToColor(box%10+1)))
            table.insert( texts, RTE(" 获得",25,cc.c3b(255,255,255)))
            table.insert( texts, RTE(ConfigData.cfg_item[boxitem].name.."*"..boxcount,25,cc.c3b(19, 255, 19)))
            table.insert( texts, RTE("\n"))
            -- 物品刷新
            dump("---map box---") 
            BagUI:reduceItem(box-10, 1)
            BagUI:addItem(boxitem, boxcount)
            BagUI:setNeedRefresh()
        else
            table.insert( texts, RTE(" 没有",25,cc.c3b(255,255,255)))
            table.insert( texts, RTE(ConfigData.cfg_item[box-10].name,25,User.starToColor(box%10+1)))
            table.insert( texts, RTE(" 遗憾地离开了",25,cc.c3b(255,255,255)))
            table.insert( texts, RTE("\n"))
        end
    end
    
    AlertManager:ok("扫荡BOSS",texts)
    User.pvb=User.pvb-1
    self.ui.lbl_left:setString( string.format("%d", tonum(User.pvb)) )
end
return Map