local ClubView = {
    ui = nil,
    list = {},
    type=0,
    time=0,
    item_module = nil
}

function ClubView:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-view.json"))

    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-view-item.json")
    self.item_module:retain()
    self.ui.item_list:setItemsMargin(10) 

    self.ui.item_list:setDirection(ccui.ScrollViewDir.vertical)

    ui_add_click_listener(self.ui.btn_close, function()
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_close2, function()
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_help,function()
        DialogManager:showDialog("HelpDialog", HelpText:helpClubPvp())
    end)
    
    ui_add_click_listener(self.ui.btn_clubjoin, function()
        local function callback(params)
            if params[1] == 1 then
                MessageManager:show("报名成功")
                self.ui.btn_clubjoin:setVisible(false)
                self.ui.lbl_clubjoin:setVisible(true)
            else
                MessageManager:show(params[2])
            end
        end
        local cid = 0
        if ClubMember.sysclub ~= nil then
            cid = ClubMember.sysclub.cid
        end
        sendCommand("joinCvc",callback, {cid})
    end)
    
    ui_add_click_listener(self.ui.btn_viewnext, function()
        local function callback(params)
            if params[1] == 1 then
            dump(params[2])
                self:onShow(5,params[2],0)
            else
                MessageManager:show(params[2])
            end
        end
        local cid = 0
        if ClubMember.sysclub ~= nil then
            cid = ClubMember.sysclub.cid
        end
        sendCommand("getNextCvcList",callback, {cid})
    end)
    
    ui_add_click_listener(self.ui.btn_viewnow, function()
        local function callback(params)
            if params[1] == 1 then
                self:onShow(4,params[2],0)
            else
                MessageManager:show(params[2])
            end
        end
        local cid = 0
        if ClubMember.sysclub ~= nil then
            cid = ClubMember.sysclub.cid
        end
        sendCommand("getNowCvcList",callback,{cid})
    end)
    
    Scheduler.scheduleNode(self.ui.nativeUI, function()
        local time = UICommon.timeFormatNumber( toint(self.time) )
        if self.time > 0 then
            self.ui.txt_time:setString("报名倒计时: "..time)
        end
        if(self.time > 0) then
            self.time = self.time - 1
        end
    end ,1)
    
    return self.ui
end

function ClubView:onShow(type,list, time)
--    self.list = list
    self.type= type
    self.time = tonum(time)
    self.ui.lbl_subtitle:setString("公会争霸赛报名")
    if type == 0 or type == 1 then
        self.ui.pnl_item:setVisible(false)
        self.ui.pnl_join:setVisible(true)
        self.ui.lbl_num:setVisible(false)
        self.ui.txt_time:setString(list)
        self.ui.lbl_num:setVisible(true)
        self.ui.btn_clubjoin:setVisible(false)
        self.ui.lbl_clubjoin:setVisible(false)
        self.ui.lbl_nojoin:setVisible(false)
        self.ui.lbl_subtitle:setString("公会争霸赛报名")
        self.ui.btn_viewnow:setVisible(false)
        self.ui.btn_viewnext:setVisible(false)
    elseif type == 2 then
        -- 比赛前,未报名或无公会
        self.ui.pnl_item:setVisible(false)
        self.ui.pnl_join:setVisible(true)
        self.ui.btn_viewnext:setVisible(false)
        self.ui.btn_viewnow:setVisible(false)
        if ClubMember.sysclub ~= nil then
            -- 未报名
            self.ui.lbl_num:setVisible(true)
            self.ui.btn_clubjoin:setVisible(true)
            self.ui.lbl_clubjoin:setVisible(false)
            self.ui.lbl_nojoin:setVisible(false)
        else
            -- 无公会
            self.ui.lbl_num:setVisible(false)
            self.ui.btn_clubjoin:setVisible(false)
            self.ui.lbl_clubjoin:setVisible(false)
            self.ui.lbl_nojoin:setVisible(true)
        end
        list = tonum(list)
        if list>=64 then
            self.ui.lbl_num:setString("报名数量已达成")
            self.ui.lbl_num:setColor(cc.c3b(0,255,51))
        else
            self.ui.lbl_num:setString("当前报名数量不足")
            self.ui.lbl_num:setColor(cc.c3b(255,0,0))
        end
    elseif type == 3 then
        -- 比赛前,已报名
        self.ui.pnl_item:setVisible(false)
        self.ui.pnl_join:setVisible(true)
        self.ui.btn_viewnext:setVisible(false)
        self.ui.btn_viewnow:setVisible(false)
        self.ui.lbl_num:setVisible(true)
        self.ui.btn_clubjoin:setVisible(false)
        self.ui.lbl_clubjoin:setVisible(true)
        self.ui.lbl_nojoin:setVisible(false)
        list = tonum(list)
        if list>=64 then
            self.ui.lbl_num:setString("报名数量已达成")
            self.ui.lbl_num:setColor(cc.c3b(0,255,51))
        else
            self.ui.lbl_num:setString("当前报名数量不足")
            self.ui.lbl_num:setColor(cc.c3b(255,0,0))
        end
    elseif type == 4 then
        -- 至少产生了32强,可以看对战列表
        self.list = list
--        if table.getn(self.list) > 1 then
--            self.ui.btn_viewnext:setVisible(true)
--        else
--            self.ui.btn_viewnext:setVisible(false)
--        end
--        self.ui.btn_viewnow:setVisible(true)
        self.ui.pnl_item:setVisible(true)
        self.ui.pnl_join:setVisible(false)
        if table.getn(self.list) > 2 then
            self.ui.lbl_subtitle:setString(2*table.getn(self.list).."强战况")
        elseif table.getn(self.list) == 2 then
            self.ui.lbl_subtitle:setString("半决赛战况")
        elseif table.getn(self.list) == 1 then
            self.ui.lbl_subtitle:setString("决赛战况")
        else
            self.ui.lbl_subtitle:setString("本场战况")
        end
        self:setList()
    elseif type == 5 then
        -- 对战列表在这看
        self.list = list
--        self.ui.btn_viewnext:setVisible(true)
--        if table.getn(self.list) < 64 then
--            self.ui.btn_viewnow:setVisible(true)
--        else
--            self.ui.btn_viewnow:setVisible(false)
--        end
        self.ui.pnl_item:setVisible(true)
        self.ui.pnl_join:setVisible(false)
        if table.getn(self.list) > 4 then
            self.ui.lbl_subtitle:setString(table.getn(self.list).."强对战列表")
        elseif table.getn(self.list) > 2 then
            self.ui.lbl_subtitle:setString("半决赛对战列表")
        elseif table.getn(self.list) == 2 then
            self.ui.lbl_subtitle:setString("决赛对战列表")
        end
        self:setNextList()
    elseif type == 6 then
        self.ui.pnl_item:setVisible(false)
        self.ui.pnl_join:setVisible(true)
        self.ui.btn_clubjoin:setVisible(false)
        self.ui.lbl_clubjoin:setVisible(false)
        self.ui.lbl_nojoin:setVisible(false)
        list=tonum(list)
        if list <= 1 then
            self.ui.btn_viewnow:setVisible(false)
            list = 1
        else
            self.ui.btn_viewnow:setVisible(true)
        end
        if list >= 7 then
            list = 7
            self.ui.btn_viewnext:setVisible(false)
        else
            self.ui.btn_viewnext:setVisible(true)
        end
        self.ui.lbl_num:setVisible(false)
        self.ui.lbl_num:setColor(cc.c3b(255,204,0))
        if list < 7 then
           self.ui.txt_time:setString("正在比赛中")
        else
            self.ui.txt_time:setString("比赛已结束,请等待下一场")
        end
        local num = (math.pow(2,8-list))
        if num > 64 then
            self.ui.lbl_subtitle:setString("公会争霸赛预选赛")
            self.ui.btn_viewnow:setTitleText("预选赛战况")
            self.ui.btn_viewnext:setTitleText((num/2).."强列表")
        elseif num > 4 then
            self.ui.lbl_subtitle:setString(num.."强争霸赛")
            self.ui.btn_viewnow:setTitleText(num.."强战况")
            if num <= 8 then
                self.ui.btn_viewnext:setTitleText("半决赛列表")
            else
                self.ui.btn_viewnext:setTitleText((num/2).."强列表")
            end
         elseif num > 2 then
            self.ui.lbl_subtitle:setString("公会争霸赛半决赛")
            self.ui.btn_viewnow:setTitleText("半决赛战况")
            self.ui.btn_viewnext:setTitleText("决赛列表")
        else
            self.ui.lbl_subtitle:setString("公会争霸赛决赛")
            self.ui.btn_viewnow:setTitleText("决赛战况")
            self.ui.btn_viewnext:setTitleText("决赛列表")
        end
    end
end

function ClubView:setList()
    local itemlist = self.ui.item_list

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)
    
--    table.sort(self.list,function(a, b)
--        return tonum(a.tempscore) > tonum(b.tempscore)
--    end)
    for i = 1, math.max(table.getn(self.list),8) do
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        if i <= table.getn(self.list) then
            self:setItemInfo(d, self.list[i])
        else
            self:setItemInfo(d, nil)
        end
    end

    itemlist:refreshView()
    itemlist:jumpToTop()
end

function ClubView:setNextList()
    local itemlist = self.ui.item_list

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)
    
    table.sort(self.list, function(a,b)
        if tonum(a.week) ~= tonum(b.week) then
            return tonum(a.week) > tonum(b.week)
        end
        return tonum(a.gid) < tonum(b.gid)
    end)
    
    if table.getn(self.list) > 1 then
        for i = 1, math.max(table.getn(self.list),16),2 do
            itemlist:pushBackDefaultItem()
            local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
            local d = ui_delegate(custom_item)
            if i + 1 <= table.getn(self.list) then
                self:setItemInfo2(d, self.list[i], self.list[i+1])
            else
                self:setItemInfo2(d, nil, nil)
            end
        end
    end
    itemlist:refreshView()
    itemlist:jumpToTop()
end

function ClubView:setItemInfo2(d, v1, v2)
    d.pnl_winlose:setVisible(false)
    d.pnl_list:setVisible(true)
    if v1~=nil and v2~=nil then
        d.lbl_club1:setString(v1.name)
        d.lbl_club2:setString(v2.name)
        if ClubMember.sysclub ~= nil then
            if toint(v1.cid) == toint(ClubMember.sysclub.cid) then
                d.lbl_club1:setColor(cc.c3b(0,255,0))
            end
            if toint(v2.cid) == toint(ClubMember.sysclub.cid) then
                d.lbl_club2:setColor(cc.c3b(0,255,0))
            end 
        end
    else
        d.pnl_list:setVisible(false)
    end
end

function ClubView:setItemInfo(d, v)
    d.pnl_winlose:setVisible(true)
    d.pnl_list:setVisible(false)
    if v == nil then
        d.pnl_winlose:setVisible(false)
        return
    end
    local cname=v.cname
    local armname=v.armname
    if tonum(v.result) == 1 then
        d.lbl_win:setString(v.cname)
        d.lbl_lose:setString(v.armname)
    else
        d.lbl_win:setString(v.armname)
        d.lbl_lose:setString(v.cname)
        cname=v.armname
        armname=v.cname
    end
    if tonum(v.logid) == 0 then
        d.btn_viewlog:setVisible(false)
        d.img_win:setVisible(false)
        d.img_lose:setVisible(false)
    end
    ui_add_click_listener(d.btn_viewlog, function()
        local function callback(params)
            if(params[1]== 1) then
                DialogManager:showDialog("GvgResultInfo", params[2], cname, armname,v.cbid, table.getn(self.list), 2)
            else
                MessageManager:show(params[2])
            end
        end
        sendCommand("getCvclog",callback,{v.logid})
    end)
end

function ClubView:close()
    DialogManager:closeDialog(self)
end

return ClubView