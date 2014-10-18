local cmd = require("src/Command")

-- @module PvpUI 
PvpUI = {
  ui=nil,
  pvpList={},
  needRefresh=true,
  pvpCfg = nil,
  my = nil
}

function PvpUI:create()
  local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/pvp.json")
  self.ui = ui_delegate(nativeUI)
  local frameSize = cc.Director:getInstance():getWinSize()
  self.ui.Panel_12:setContentSize(640,frameSize.height-210)
  self.ui.Panel_11:setPosition(cc.p(0,frameSize.height-420))
    self.ui.Panel_3:setPosition(cc.p(32,5*(frameSize.height-960)/6+85-(frameSize.height-960)/2))
    self.ui.Panel_3:setContentSize(578,frameSize.height-498-(frameSize.height-960)/2)
    self.ui.pvp_list:setContentSize(560,frameSize.height-510-(frameSize.height-960)/2)
--  self.ui.pvp_index:setString("我的排名")
  local pl = self.ui.pvp_list
  pl:setDirection(ccui.ScrollViewDir.vertical)
  pl:setItemsMargin(5)
  pl:setTouchEnabled(false)
  
  ui_add_click_listener(self.ui.btn_refresh, function(sender,eventType)
      PvpUI:getPvp()
  end)
  
  ui_add_click_listener(self.ui.btn_rank, function(sender,eventType)
      DialogManager:showDialog("PvpRank")
  end)
  
  ui_add_click_listener(self.ui.btn_buy, function(sender,eventType)
    self:doBuyPvp()
  end)  
  
  ui_add_click_listener(self.ui.btn_shop, function()
    DialogManager:showDialog("HonorShop")
  end)
  
  PvpUI:getPvp()
  return self.ui
end

function PvpUI:onShow()
    self.ui.lbl_times:setString( string.format("今日剩余挑战次数： %d", User.pvp) ) 
    local rtes = {}
    
    if( self.my ~= nil ) then
        table.insert(rtes, RTE(string.format("  Lv.%d %s\n", User.ulv, User.uname),22,cc.c3b(255,255,255)) )
        table.insert(rtes, RTE("  排名",20, cc.c3b(0,216,255)) )
        table.insert(rtes, RTE(self.my.index,20, cc.c3b(255,204,0)) )
        table.insert(rtes, RTE(" 战力",20, cc.c3b(0,216,255)) )
        table.insert(rtes, RTE(User.zhanli .."\n",20, cc.c3b(255,204,0)) )
    
        table.insert(rtes, RTE("  排名奖励：",20, cc.c3b(243,3,244)) )
    
        local awards = self.my.awards
        if table.getn(awards) > 0 then
            for _,v in pairs(awards) do
                if tonum(v.itemid) > 0 and tonum(v.count) > 0 then
                    local c = ConfigData.cfg_item[tonum(v.itemid)]
                    table.insert(rtes, RTE(" " .. c.name,20, cc.c3b(0,216,255)) )
                    table.insert(rtes, RTE( "*".. v.count,20, cc.c3b(0,232,58)) )
                    if tonum(v.itemid) == 7 then
                        local c2 = ConfigData.cfg_item[8]
                        table.insert(rtes, RTE(" " .. c2.name,20, cc.c3b(0,216,255)) )
                        table.insert(rtes, RTE( "*".. v.count,20, cc.c3b(0,232,58)) )
                    end
                end
            end
        end

    end
    
    self.ui.pnl_info:removeAllChildren()
    UICommon.createRichText(self.ui.pnl_info, rtes )
end

function PvpUI:getPvp()
  local function onGetPvp(param)
    if param[1] ~= 1 then
        MessageManager:show(param[2])
        return
    end
    -- 显示个人信息
    UICommon.loadExternalTexture(self.ui.img_player, User.getUserHeadImg(User.ujob, User.usex))
    
    self.ui.pnl_info:removeAllChildren() 
    self.ui.lbl_times:setString( string.format("今日剩余挑战次数： %d", User.pvp) )
    -- 对手列表
    User.userPvpList=param[2]
    
    --我的信息
    self.my = param[3] 
    local rtes = {}
    table.insert(rtes, RTE(string.format("  Lv.%d %s\n", User.ulv, User.uname),22,cc.c3b(255,255,255)) )
    table.insert(rtes, RTE("  排名",20, cc.c3b(0,216,255)) )
    table.insert(rtes, RTE(self.my.index,20, cc.c3b(255,204,0)) )
    table.insert(rtes, RTE(" 战力",20, cc.c3b(0,216,255)) )
    table.insert(rtes, RTE(User.zhanli .."\n",20, cc.c3b(255,204,0)) )
    
    table.insert(rtes, RTE("  排名奖励：",20, cc.c3b(243,3,244)) )
    
    local awards = self.my.awards
    if table.getn(awards) > 0 then
        for _,v in pairs(awards) do
            if tonum(v.itemid) > 0 and tonum(v.count) > 0 then
                local c = ConfigData.cfg_item[tonum(v.itemid)]
                table.insert(rtes, RTE(" " .. c.name,20, cc.c3b(0,216,255)) )
                table.insert(rtes, RTE( "*".. v.count,20, cc.c3b(0,232,58)) )
                if tonum(v.itemid) == 7 then
                    local c2 = ConfigData.cfg_item[8]
                    table.insert(rtes, RTE(" " .. c2.name,20, cc.c3b(0,216,255)) )
                    table.insert(rtes, RTE( "*".. v.count,20, cc.c3b(0,232,58)) )
                end
            end
        end
    end

    UICommon.createRichText(self.ui.pnl_info, rtes )

    --info:pushBackElement(RTE( string.format("我的历史最高排名：%d （突破时额外奖励钻石）", self.my.bestindex ),20, cc.c3b(188,128,200)) )
    
    self.needRefresh=true
    PvpUI:refreshUI()
  
  end
  
  sendCommand("getpvp",onGetPvp)
end

function PvpUI:pvpAttack(uid, callback)
  sendCommand("pvp",callback,{uid,0})
end

function PvpUI:refreshUI()
  if(self.needRefresh==false) then
    return
  end
  self.needRefresh=false
  
  local pvp_item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/pvp_item.json")
  local itemlist = self.ui.pvp_list
  
  -- 清空pvp列表
  itemlist:removeAllItems()
  itemlist:setItemModel(pvp_item)
  
  self.pvpList = {}

  table.foreach(User.userPvpList, function(k,v)
    table.insert(self.pvpList, v)

    itemlist:pushBackDefaultItem()
    local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
    local d = ui_delegate(custom_item)
    
    self:setItemInfo(d,v)
  end)
    
end



-- 名字、排名、等级、职业、按钮(排名(php) 职业 按钮未完成)
function PvpUI:setItemInfo(d,v)
    d.img_rank_back:setVisible(false)
    
    UICommon.loadExternalTexture( d.img_icon, User.getUserHeadImg(v.ujob, v.sex))
    d.img_icon:setTouchEnabled(true)
    ui_add_click_listener(d.img_icon,function()
        if tonum(v.uid) < 10000 then
            MessageManager:show("我是NPC,请不要点我")
            return
        end
        DialogManager:showDialog("PvpDetail",v.uid)
    end) 
   
    local label = UICommon.createLabel("Lv."..v.ulv, 20)
    label:setColor(cc.c3b(255,255,255))
    label:setAnchorPoint(cc.p(0,0))
    label:setPosition(cc.p(32,0))
    label:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
    label:enableOutline(cc.c4b(0,0,0,255),2)      
    d.img_icon:addChild(label)   
    UICommon.loadExternalTexture( d.icon_job, User.getUserJobIcon(toint(v.ujob)))
    local rtes = {}
    
    table.insert( rtes, RTE( v.uname,22,cc.c3b(255,255,255)))
--    table.insert( rtes, RTE( "[",20,cc.c3b(255,255,255)))
--    table.insert( rtes, RTE( User.getJobName(v.ujob),20,cc.c3b(0,255,0)))
--    table.insert( rtes, RTE( "]",20,cc.c3b(255,255,255)))  
    if(tonum(v.uid)<10000) then
        table.insert( rtes, RTE( "[NPC]",22,cc.c3b(255,255,255)))
    elseif v.cname ~= nil then
        table.insert( rtes, RTE( "[",22,cc.c3b(255,255,255)))
        table.insert( rtes, RTE( v.cname,22,cc.c3b(204,153,255)))
        table.insert( rtes, RTE( "]",22,cc.c3b(255,255,255)))
    end
    table.insert( rtes, RTE( "\n",22,cc.c3b(255,255,255))) 
     
    table.insert( rtes, RTE("排名",20, cc.c3b(0,216,255)) )
    table.insert( rtes, RTE(v.index,20, cc.c3b(255,204,0)) )
    table.insert( rtes, RTE(" 战力",20, cc.c3b(0,216,255)) )
    table.insert( rtes, RTE(v.zhanli .. "\n",20, cc.c3b(255,204,0)) )
    
    table.insert( rtes, RTE("排名奖励：",20, cc.c3b(243,3,244)) )
    
    local awards = v.awards
    if table.getn(awards) > 0 then
        for _,vv in pairs(awards) do
            if tonum(vv.itemid) > 0 and tonum(vv.count) > 0 then
                local c = ConfigData.cfg_item[tonum(vv.itemid)]
                table.insert(rtes, RTE(" " .. c.name,20, cc.c3b(0,216,255)) )
                table.insert(rtes, RTE( "*".. vv.count,20, cc.c3b(0,232,58)) )
                if tonum(vv.itemid) == 7 then
                    local c2 = ConfigData.cfg_item[8]
                    table.insert(rtes, RTE(" " .. c2.name,20, cc.c3b(0,216,255)) )
                    table.insert(rtes, RTE( "*".. vv.count,20, cc.c3b(0,232,58)) )
                end
            end
        end
    end
    
    UICommon.createRichText(d.pnl_info1, rtes )
    
    ui_add_click_listener(d.btn_attack, function(sender,eventType)
        if(User.pvp > 0)then
            --进入战斗结算,之后刷新pvp
        --    local function onPvpAttack(param)
        --      cclog(vardump(param))
        --    end
        --    self:pvpAttack(v.uid, onPvpAttack)
            local b = require("src/UI/Battle")
            GameUI:switchTo("battleUI")
            b:addPvpBattle(v)
        else
            --MessageManager:show("竞技次数不足，请购买次数或者明天再来吧！")
            --AlertManager:yesno("挑战次数不足","")
            PvpUI:doBuyPvp(v)
        end
    end)
end
function PvpUI:doBuyPvp(v)
    local function onOK()
        sendCommand("buyPvp",function(param)
            if(param[1] == 1)then
                GameUI:onLoadUinfo(param[2])
                self.ui.lbl_times:setString( string.format("今日剩余挑战次数： %d", User.pvp) )
                if v ~= nil then
                    local b = require("src/UI/Battle")
                    GameUI:switchTo("battleUI")
                    b:addPvpBattle(v)
                end
            else
                MessageManager:show(param[2])
            end
        end)
    end
    AlertManager:yesno("购买挑战次数", RTE("购买一次挑战次数将花费50钻石",25, cc.c3b(255,255,255)), onOK)      
end

return PvpUI