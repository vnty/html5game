ClubMemberView = {
    ui = nil,
    members = nil,
    item_module = nil, 
    type = 1
}

function ClubMemberView:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/club-member-view.json")
    self.ui = ui_delegate(nativeUI)
  
    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-member-view-item.json")
    self.item_module:retain()

    self.ui.item_list:setDirection(ccui.ScrollViewDir.vertical)
    self.ui.item_list:setItemsMargin(10) 
    
    ui_add_click_listener( self.ui.btn_close, function()
        self:close()
    end)
    
    ui_add_click_listener( self.ui.btn_leave, function()
        self:leaveClub()
    end)
    
    ui_add_click_listener( self.ui.btn_manage, function()
        DialogManager:showDialog("ClubManage")
    end)
    
    ui_add_click_listener( self.ui.btn_setpos, function()
--        DialogManager:showDialog("ClubManage")
        -- TODO 加条件判断是否可操作
        self:onShow(self.members,2)
    end)
    
    return self.ui
end

function ClubMemberView:onShow(members, type)
    self.members = members
    self.type = type
    if type == 2 then
        self.ui.btn_setpos:setVisible(false)
        self.ui.lbl_score:setString("位置")
        self.ui.lbl_state:setString("职业")
    else
        self.ui.btn_setpos:setVisible(true)
        self.ui.lbl_score:setString("状态")
        self.ui.lbl_state:setString("职位")
    end
    self:refreshUI(self.members)
end

function ClubMemberView:refreshUI()
    self.ui.lbl_lv:setString("公会等级: "..ClubMember.sysclub.clv)
    self.ui.lbl_count:setString("公会人数: "..ClubMember.sysclub.count.."/"..ClubMember.sysclub.maxcount)
    self.ui.btn_leave:setTitleText("退出公会")
    self:setMembers(self.members)
end

function ClubMemberView:setMembers(members)
    local itemlist = self.ui.item_list

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)
    
    -- TODO 要优化,有点慢
    if self.type == 1 then
        table.sort(members, function(a, b)
            if tonum(a.state) > tonum(b.state) then
                return true
            elseif tonum(a.state) < tonum(b.state) then
                return false
            else
                return tonum(a.zhanli) > tonum(b.zhanli)
            end
        end)
    else
        table.sort(members, function(a, b)
            if tonum(a.pos)~=0 and tonum(b.pos)==0 then
                return true
            elseif tonum(a.pos)==0 and tonum(b.pos)~=0 then
                return false
            elseif tonum(a.pos)==1 and tonum(b.pos)~=1 then
                return true
            elseif tonum(a.pos)~=1 and tonum(b.pos)==1 then
                return false
            else
                return tonum(a.zhanli) > tonum(b.zhanli)
            end
        end)
    end
    for i = 1, math.max(table.getn(members),8) do
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        self:setItemInfo(d, members[i])
    end

    itemlist:refreshView()
    itemlist:jumpToTop()
end

function ClubMemberView:setItemInfo(d, member)
    if member ~= nil then
        local cid = ClubMember.sysclub.cid
        
        ui_add_click_listener(d.nativeUI, function()
--            DialogManager:closeDialog(self)
            if self.type ~= 2 then
                DialogManager:showDialog("ClubMemberViewDetail", member)
            else
                DialogManager:showDialog("PvpDetail",member.uid)
            end
        end)

        d.lbl_name:setString(member.uname)
        d.lbl_zhanli:setString(member.zhanli)
        d.lbl_lv:setString("Lv. "..member.ulv)
        if self.type == 2 then
            d.btn_pos1:setVisible(false)
            d.btn_pos2:setVisible(false)
            d.lbl_score:setVisible(false)
            local job = ""
            if tonum(member.ujob) == 1 then
                job="战士"
            elseif tonum(member.ujob) == 2 then
                job="猎人"
            elseif tonum(member.ujob) == 3 then
                job="法师"
            end
            d.lbl_stat:setString(job)
            
            if tonum(member.pos) == 2 then
                d.btn_pos2:setVisible(true)
            else
                d.btn_pos1:setVisible(true)
            end
            
            ui_add_click_listener(d.btn_pos1, function()
                if ClubMember.myclub == nil or tonum(ClubMember.myclub.state) ~= 1000 then
                    MessageManager:show("只有会长可以调整站位")
                    return
                end
                local onSetPos = function(params)
                    if params[1] == 1 then
                        member.pos=2
                        d.btn_pos1:setVisible(false)
                        d.btn_pos2:setVisible(true)
                        MessageManager:show("已将"..member.uname.."设置为后排")
                    else
                        MessageManager:show(params[2])
                    end
                end
                sendCommand("setMemberPos", onSetPos, {member.uid, cid, 2})
            end)
            
            ui_add_click_listener(d.btn_pos2, function()
                if ClubMember.myclub == nil or tonum(ClubMember.myclub.state) ~= 1000 then
                    MessageManager:show("只有会长可以调整站位")
                    return
                end
                local onSetPos = function(params)
                    if params[1] == 1 then
                        member.pos=1
                        d.btn_pos1:setVisible(true)
                        d.btn_pos2:setVisible(false)
                        MessageManager:show("已将"..member.uname.."设置为前排")
                    else
                        MessageManager:show(params[2])
                    end
                end
                sendCommand("setMemberPos", onSetPos, {member.uid, cid, 1})
            end)
            
        else
            d.btn_pos1:setVisible(false)
            d.btn_pos2:setVisible(false)
            d.lbl_stat:setVisible(true)
            d.lbl_score:setString(member.score)
            local state = "会员"
            -- 颜色区分
            if tonum(member.state) == 1000 then
                state = "会长"
                d.lbl_name:setColor(cc.c3b(255,204,0))
                d.lbl_zhanli:setColor(cc.c3b(255,204,0))
                d.lbl_lv:setColor(cc.c3b(255,204,0))
--                d.lbl_score:setColor(cc.c3b(255,204,0))
                d.lbl_stat:setColor(cc.c3b(255,204,0))
            elseif tonum(member.state) == 100 then
                state = "副会长"
                d.lbl_name:setColor(cc.c3b(255,0,255))
                d.lbl_zhanli:setColor(cc.c3b(255,0,255))
                d.lbl_lv:setColor(cc.c3b(255,0,255))
--                d.lbl_score:setColor(cc.c3b(255,0,255))
                d.lbl_stat:setColor(cc.c3b(255,0,255))
            end
            d.lbl_stat:setString(state)
            local ts = tonum(member.tsleave)
            if ts < 600 then
                d.lbl_score:setString("在线")
                d.lbl_score:setColor(cc.c3b(0,255,0))
            else
                local min = math.floor(ts / 60)
                if min < 60 then
                    d.lbl_score:setString(min.."分钟前")
                    d.lbl_score:setColor(cc.c3b(207,207,207))
                elseif min < 24 * 60 then
                    local hour = math.floor(ts / 3600)
                    d.lbl_score:setString(hour.."小时前")
                    d.lbl_score:setColor(cc.c3b(207,207,207))
                else
                    local day = math.floor(ts / 86400)
                    if day < 5 then
                        d.lbl_score:setString(day.."天前")
                        d.lbl_score:setColor(cc.c3b(207,207,207))
                    else
                        d.lbl_score:setString("5天前")
                        d.lbl_score:setColor(cc.c3b(135,135,135))
                    end
                end
            end
--            d.lbl_score:setString(ts)
        end
    else
        d.lbl_name:setVisible(false)
        d.lbl_zhanli:setVisible(false)
        d.lbl_lv:setVisible(false)
        d.lbl_score:setVisible(false)
        d.lbl_stat:setVisible(false)
        d.btn_pos1:setVisible(false)
        d.btn_pos2:setVisible(false)
    end
end

function ClubMemberView:leaveClub()
--    if tonum(ClubMember.myclub.state) == 1000 then
--        -- 解散公会
--        local function onOK()
--            local function callback(params)
--                if params[1] == 1 then
--                    MessageManager:show("你已成功解散公会")
--                    self:close()
--                    GameUI:switchTo("mainUI")
--                else
--                    MessageManager:show(params[2])
--                end
--            end
--            sendCommand("delClub", callback, {User.zhanli, ClubMember.sysclub.cid})
--        end
--        AlertManager:yesno("离开公会", RTE("确定要解散公会吗?", 25, cc.c3b(255,255,255)),function()
--            AlertManager:yesno("离开公会", RTE("真的确定要解散公会吗?", 25, cc.c3b(255,255,255)),onOK)
--        end)
--    else
        -- 离开公会
        local function onOK()
            local function callback(params)
                if params[1] == 1 then
                    MessageManager:show("你已成功退出公会")
                    self:close()
                    GameUI:switchTo("mainUI")
                    
                    -- 更新公会ID
                    BattleUI.chatUI:updateClub(0)
                else
                    MessageManager:show(params[2])
                end
            end
            sendCommand("exitClub", callback, {User.zhanli, ClubMember.sysclub.cid})
        end
        AlertManager:yesno("退出公会", RTE("退出公会后您的贡献将被清零，且24小时内无法再加入公会。您确定退出公会吗？", 25, cc.c3b(255,255,255)),onOK)
--    end
end

function ClubMemberView:close()
    ClubMember:refreshUI()
    DialogManager:closeDialog(self)
end

return ClubMemberView