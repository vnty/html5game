local ClubSet = {
    ui = nil,
}

function ClubSet:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-member-detail.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_close2, function(sender,eventType)
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_out, function(sender,eventType)
        if tonum(ClubMember.myclub.state) < 100 then
            MessageManager:show("只有会长和副会长可以进行此操作")
            return
        end
        local function callback(p)
            if(p[1] == 1)then
                MessageManager:show("踢出会员成功!")
                ClubMember:reloadInfo(function()
                    self:close()
                end)
            else
                MessageManager:show(p[2])
            end
        end
        
        AlertManager:yesno("踢出会员", RTE("确定要将此人踢出公会吗?", 25, cc.c3b(255,255,255)),function()
            sendCommand("delMember",callback, {self.member.uid, ClubMember.myclub.cid})
        end)
    end)

    ui_add_click_listener(self.ui.btn_up, function(sender,eventType)
        if tonum(ClubMember.myclub.state) ~= 1000 then
            MessageManager:show("只有会长可以进行此操作")
            return
        end
        local function callback(p)
            if p[1] == 1 then
                MessageManager:show("任命副会长成功!")
                ClubMember:reloadInfo(function()
                    self:close()
                end)
            else
                MessageManager:show(p[2])
            end
        end

        sendCommand("upMember",callback, {self.member.uid, ClubMember.myclub.cid})
    end)

    ui_add_click_listener(self.ui.btn_down, function(sender,eventType)
        if tonum(ClubMember.myclub.state) ~= 1000 then
            MessageManager:show("只有会长可以进行此操作")
            return
        end
        local function callback(p)
            if p[1] == 1 then
                self:close()
                MessageManager:show("解除副会长成功!")
                ClubMember:reloadInfo(function()
                    self:close()
                end)
            else
                MessageManager:show(p[2])
            end
        end

        sendCommand("downMember",callback, {self.member.uid, ClubMember.myclub.cid})
    end)

    ui_add_click_listener(self.ui.btn_give, function(sender,eventType)
        if tonum(ClubMember.myclub.state) ~= 1000 then
            MessageManager:show("只有会长可以进行此操作")
            return
        end
        local function callback(p)
            dump(p)
            if(p[1] == 1)then
                MessageManager:show("转让公会成功")
--                ClubMember.myclub = p[2]
--                ClubMember.sysclub = p[3]
                ClubMember:reloadInfo(function()
                    self:close()
                end)
            else
                MessageManager:show(p[2])
            end
        end
        
        AlertManager:yesno("转让公会", RTE("确定要将公会转让给此人吗?", 25, cc.c3b(255,255,255)),function()
            sendCommand("changeClub",callback, {self.member.uid, ClubMember.myclub.cid})
        end)
    end)
    
    -- TODO 点击里面就能关闭
    self.ui.nativeUI:setTouchEnabled(true)
    ui_add_click_listener(self.ui.nativeUI, function()
        self:close()
    end)

    return self.ui
end

function ClubSet:onShow(member)
    -- 刷新公会
    self.member = member

    self.ui.pnl_member:setVisible(false)
    self.ui.pnl_vice:setVisible(false)
    self.ui.pnl_close:setVisible(true)
    
    dump(member.state)
    dump(ClubMember.myclub.state)
    if tonum(member.state) == 100 and tonum(ClubMember.myclub.state) >= 1000 then
        self.ui.pnl_vice:setVisible(true)
        self.ui.pnl_close:setVisible(false)
    elseif tonum(member.state) == 1 and tonum(ClubMember.myclub.state) >= 100 then
        self.ui.pnl_member:setVisible(true)
        self.ui.pnl_close:setVisible(false)
    end
    
    self.ui.lbl_lv:setString("Lv."..member.ulv)
    self.ui.lbl_name:setString(member.uname)
    local state = "会员"
    if tonum(member.state) == 1000 then
        state = "会长"
    elseif tonum(member.state) == 100 then
        state = "副会长"
    end
    self.ui.lbl_state:setString(state)
    self.ui.lbl_zhanli:setString(member.zhanli)
    self.ui.lbl_score:setString(member.score)
    
    UICommon.loadExternalTexture(self.ui.img_header, User.getUserHeadImg(member.ujob, member.sex))
    
end

function ClubSet:close()
    local callback = function(params)
        if params[1] == 1 then
            DialogManager:closeDialog(self)
            ClubMemberView:onShow(params[2], 1)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getClubMember", callback, {ClubMember.myclub.cid})
end

return ClubSet