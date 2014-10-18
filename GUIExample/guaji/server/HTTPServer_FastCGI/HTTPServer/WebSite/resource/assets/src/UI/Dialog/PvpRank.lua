require("src/UI/Battle")

local PvpRank = {
  ui = nil,
}

function PvpRank:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/pvp-rank.json"))
  
  ui_add_click_listener( self.ui.btn_close,function()
    DialogManager:closeDialog(self)
  end)
  
  self.ui.pvp_rank_list:setDirection(ccui.ScrollViewDir.vertical)
  self.ui.pvp_rank_list:setItemsMargin(3)

  return self.ui
end

function PvpRank:onShow()
    self:getPvpRank()
end


-- 名字、排名、等级、职业、按钮(排名(php) 职业 按钮未完成)
function PvpRank:setItemInfo(d,v)
    UICommon.loadExternalTexture( d.img_icon, User.getUserHeadImg(v.ujob, v.sex) )
    UICommon.setVisible(d.btn_attack, false)
   
    d.img_icon:setTouchEnabled(true)
    ui_add_click_listener(d.img_icon,function()
        if tonum(v.uid) < 10000 then
            MessageManager:show("我是NPC,请不要点我 囧")
            return
        end
        DialogManager:showSubDialog(self, "PvpDetail",v.uid)
    end) 
        
    local label = UICommon.createLabel("Lv.".. v.ulv, 20)
    label:setColor(cc.c3b(255,255,255))
    label:setAnchorPoint( cc.p(0,0) )
    label:setPosition(32,0)
    label:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
    label:enableOutline(cc.c4b(0,0,0,255),2)      
    d.img_icon:addChild(label)    
    
    UICommon.loadExternalTexture( d.icon_job, User.getUserJobIcon(toint(v.ujob)))
    local rtes = {}
    table.insert(rtes, RTE( v.uname,22,cc.c3b(255,255,255)) )
--    table.insert(rtes, RTE( "[",20,cc.c3b(255,255,255)))
--    table.insert(rtes, RTE( User.getJobName(v.ujob),20,cc.c3b(0,255,0)))
--    table.insert(rtes, RTE( "]",20,cc.c3b(255,255,255)))
    
    if(tonum(v.uid)<10000) then
        table.insert( rtes, RTE( "[NPC]",22,cc.c3b(255,255,255)))
    elseif v.cname ~= nil then
        table.insert( rtes, RTE( "[",22,cc.c3b(255,255,255)))
        table.insert( rtes, RTE( v.cname,22,cc.c3b(204,153,255)))
        table.insert( rtes, RTE( "]",22,cc.c3b(255,255,255)))
    end
    table.insert(rtes, RTE( "\n",22,cc.c3b(255,255,255)))
    
    table.insert(rtes, RTE("排名",20, cc.c3b(0,216,255)) )
    table.insert(rtes, RTE(v.index,20, cc.c3b(255,204,0)) )
    table.insert(rtes, RTE(" 战力",20, cc.c3b(0,216,255)) )
    table.insert(rtes, RTE(v.zhanli .. "\n",20, cc.c3b(255,204,0)) )

    -- 一句话描述自己    
    if(v.sig == nil)then
        v.sig = "这个人很懒，什么也没留下"
    end
    table.insert(rtes, RTE(v.sig,20, cc.c3b(243,3,244)) )
    UICommon.createRichText(d.pnl_info1, rtes)
    
    if(tonum(v.index) <= 3)then
        d.img_rank:loadTexture( string.format("res/ui/images/img_%d.png", 177 + v.index ) )
    else
        d.img_rank_back:setVisible(false)
    end
end

function PvpRank:getPvpRank()
  local function onGetPvpRank(param)
    dump(param)
    if(param[1] == 1)then
    
      local pvp_item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/pvp_item.json")
      local itemlist = self.ui.pvp_rank_list
      
      -- 清空pvp列表
      itemlist:removeAllItems()
      itemlist:setItemModel(pvp_item)
      
      self.pvpList = {}
    
      table.foreach(param[2], function(k,v)
        table.insert(self.pvpList, v)
    
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        
        self:setItemInfo(d,v)
      end)
      
      itemlist:refreshView()
      itemlist:jumpToTop()
    else
      MessageManager:show(param[2])
    end
  end
  
  sendCommandG("getPvprank", onGetPvpRank)
end

return PvpRank