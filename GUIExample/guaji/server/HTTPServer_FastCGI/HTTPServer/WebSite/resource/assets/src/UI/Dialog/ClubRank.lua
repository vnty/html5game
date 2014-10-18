local ClubRank = {
    ui = nil,
    members = {},
    bosshp = 1,
    item_module = nil
}

function ClubRank:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-rank.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
    self.ui.Panel_3_0_0:getLayoutParameter():setMargin(tbl_act)

    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-rank-item.json")
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

function ClubRank:onShow(members)
    dump(members)
    self.members = members
    self.ui.lbl_myrank:setVisible(false)
    self.ui.lbl_leader:setVisible(false)
    self:setRankList()
end

function ClubRank:setRankList()
    local itemlist = self.ui.item_list

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)

--    table.sort(self.members,function(a, b)
--        return tonum(a.tempscore) > tonum(b.tempscore)
--    end)

    for i = 1, math.max(table.getn(self.members), 8) do
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        if i <= table.getn(self.members) then
            self:setItemInfo(d, self.members[i], i)
        else
            self:setItemInfo(d, nil, i)
        end
--        if i <= table.getn(self.members) and tonum(self.members[i].uid) == tonum(User.uid) then
--            self.ui.lbl_myrank:setString("我的排名 : "..i)
--            if self.bosshp ~= 0 then
--                self.ui.lbl_score:setString("我的伤害 : "..self.members[i].tempscore)
--            end
--        end
    end

    itemlist:refreshView()
    itemlist:jumpToTop()
end

function ClubRank:setItemInfo(d, v, i)
    d.lbl_rank:setString(i)
    if v ~= nil then
        d.lbl_lv:setString("Lv."..v.clv)
        d.lbl_leader:setString(v.uname)
        d.lbl_name:setString(v.cname)
        d.lbl_id:setString(v.cid)
        if i == 1 then
            d.lbl_rank:setColor(cc.c3b(255,204,0))
            d.lbl_lv:setColor(cc.c3b(255,204,0))
            d.lbl_leader:setColor(cc.c3b(255,204,0))
            d.lbl_name:setColor(cc.c3b(255,204,0))
            d.lbl_id:setColor(cc.c3b(255,204,0))
        elseif i == 2 then
            d.lbl_rank:setColor(cc.c3b(255,0,255))
            d.lbl_lv:setColor(cc.c3b(255,0,255))
            d.lbl_leader:setColor(cc.c3b(255,0,255))
            d.lbl_name:setColor(cc.c3b(255,0,255))
            d.lbl_id:setColor(cc.c3b(255,0,255))
        elseif i == 3 then
            d.lbl_rank:setColor(cc.c3b(0,204,255))
            d.lbl_lv:setColor(cc.c3b(0,204,255))
            d.lbl_leader:setColor(cc.c3b(0,204,255))
            d.lbl_name:setColor(cc.c3b(0,204,255))
            d.lbl_id:setColor(cc.c3b(0,204,255))
        end
    else
        d.lbl_lv:setVisible(false)
        d.lbl_leader:setVisible(false)
        d.lbl_name:setVisible(false)
    end
end

function ClubRank:close()
    DialogManager:closeDialog(self)
end

return ClubRank