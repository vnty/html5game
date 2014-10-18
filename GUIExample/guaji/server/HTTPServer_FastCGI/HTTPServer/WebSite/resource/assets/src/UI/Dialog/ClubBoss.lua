local ClubBoss = {
    ui = nil,
    members = {},
    bosshp = 1,
    item_module = nil
}

function ClubBoss:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-boss.json"))

    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
    self.ui.Panel_3_0:getLayoutParameter():setMargin(tbl_act) 

    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-boss-item.json")
    self.item_module:retain()
    self.ui.item_list:setItemsMargin(10) 

    self.ui.item_list:setDirection(ccui.ScrollViewDir.vertical)

    ui_add_click_listener(self.ui.btn_close, function()
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_close2, function()
        self:close()
    end)
    
    return self.ui
end

function ClubBoss:onShow(members)
    self.bosshp = tonum(ClubMember.sysclub.bosshp)
    self.members = members
    if self.bosshp ~= 0 then
        self:setRankList()
    end
end

function ClubBoss:setRankList()
    local itemlist = self.ui.item_list

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)
    
    table.sort(self.members,function(a, b)
        return tonum(a.tempscore) > tonum(b.tempscore)
    end)
    
    for i = 1, math.max(table.getn(self.members), 8) do
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        if i <= table.getn(self.members) then
            self:setItemInfo(d, self.members[i], i)
        else
            self:setItemInfo(d, nil, i)
        end
        if i <= table.getn(self.members) and tonum(self.members[i].uid) == tonum(User.uid) then
            self.ui.lbl_myrank:setString("我的排名 : "..i)
            if self.bosshp ~= 0 then
                self.ui.lbl_score:setString("我的伤害 : "..self.members[i].tempscore)
            end
        end
    end

    itemlist:refreshView()
    itemlist:jumpToTop()
end

function ClubBoss:setItemInfo(d, v, i)
    d.lbl_rank:setString(i)
    if v ~= nil then
        d.lbl_lv:setString("Lv."..v.ulv)
        d.lbl_score:setString(v.tempscore)
        d.lbl_name:setString(v.uname)
        if self.bosshp ~= 0 then
            d.lbl_per:setString(toint(v.tempscore*100/self.bosshp).."%")
        else
            d.lbl_per:setVisible(false)
        end
    else
        d.lbl_lv:setVisible(false)
        d.lbl_score:setVisible(false)
        d.lbl_name:setVisible(false)
        d.lbl_per:setVisible(false)
    end
end

function ClubBoss:close()
    DialogManager:closeDialog(self)
end

return ClubBoss