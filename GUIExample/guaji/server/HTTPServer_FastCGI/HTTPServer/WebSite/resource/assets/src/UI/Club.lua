ClubUI = {
    ui = nil,
    item_module = nil,
    clubs = {}, 
    myClub = nil,
    sysClub = nil
}

function ClubUI:create()
    self.ui = ui_delegate(ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/club.json"))
    
    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-item.json")
    self.item_module:retain()
    
    self.ui.item_list:setItemsMargin(10)

    self.ui.item_list:setDirection(ccui.ScrollViewDir.vertical)
    
    ui_add_click_listener(self.ui.btn_create, function()
        if User.ulv < 18 then
            MessageManager:show("人物等级到达18级才可创建公会")
            return
        end
        self:createClub()
    end)

    ui_add_click_listener(self.ui.btn_refresh, function()
        self:refreshClub()
    end)
    
    ui_add_click_listener(self.ui.btn_search, function()
        self:searchClub()
    end)
    
    ui_add_click_listener(self.ui.btn_rank,function()
        local function callback(params)
            if params[1] == 1 then
                DialogManager:showDialog("ClubRank", params[2])
            else
                MessageManager:show(params[2])
            end
        end
        sendCommand("getClubRank",callback,{0})
    end)
    
    ui_add_click_listener(self.ui.btn_cvc,function()
        local function callback(params)
            if params[1] == 0 or params[1] == 1 then
                MessageManager:show(params[2])
            end
            DialogManager:showDialog("ClubView",params[1],params[2],params[3])
        end
        sendCommand("getCvcInfo",callback,{0})
    end)
    
    ui_add_click_listener(self.ui.btn_help,function()
         DialogManager:showDialog("HelpDialog", HelpText:helpClub())
    end)
    return self.ui
end

function ClubUI:onShow()
    self:setClubList()
end

function ClubUI:searchClub() 
    DialogManager:showDialog("ClubSet", 2, "请输入公会ID")
end

function ClubUI:refreshClub()
    local callback = function(params)
        if params[1] == 1 then
            -- 有公会
            ClubMember.myclub = params[2]
            ClubMember.sysclub = params[3]
            GameUI:switchTo("clubMember")
        elseif params[1] == 2 then
            -- 没公会
            ClubUI.clubs = params[2]
            self:setClubList()
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getMyClub", callback, {User.zhanli})
end

function ClubUI:getClub()
    self:setClubList()
end

function ClubUI:createClub()
    DialogManager:showDialog("ClubSet", 1, "请输入您的公会名字")
end

function ClubUI:setClubList()
    local itemlist = self.ui.item_list

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)

    -- 按照场次排序
    for i = 1, table.getn(self.clubs) do
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        self:setItemInfo(d, self.clubs[i])
    end
    if table.getn(self.clubs) == 0 then
        MessageManager:show("当前没有满足条件的公会")
        MessageManager:show("请提升战力或稍晚点来看看")
    end
    itemlist:refreshView()
    itemlist:jumpToTop()
end

function ClubUI:setItemInfo(d, club)
    d.lbl_name:setString(""..club.cname)
    d.lbl_lv:setString("Lv."..club.clv)
    -- ps 服务器端暂时没有处理人数增减
    d.lbl_count:setString(club.count.."/"..club.maxcount)
    d.pnl_join:setVisible(false)
    d.pnl_nojoin:setVisible(false)
    d.lbl_limit:setString("战力>"..club.zhanli)
    if User.zhanli >= tonum(club.zhanli) then
        d.pnl_join:setVisible(true)
    else
        d.pnl_nojoin:setVisible(true)
    end    
    ui_add_click_listener(d.btn_join, function()
        local callback = function(params)
            if params[1] == 1 then
                MessageManager:show("已成功加入")
                ClubMember.myclub = params[2]
                ClubMember.sysclub = params[3]
                GameUI:switchTo("clubMember")
                
                -- 更新公会ID
                BattleUI.chatUI:updateClub(toint(ClubMember.myclub.cid))
            else
                MessageManager:show(params[2])
            end
        end
        sendCommand("joinClub", callback, {club.cid})
    end)
end

return ClubUI