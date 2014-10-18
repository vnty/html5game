local ClubManage = {
    ui = nil,
}

function ClubManage:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-manage.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_setzhanli, function(sender,eventType)
        self:setClubZhanli()
    end)
    
    ui_add_click_listener(self.ui.btn_setnote, function(sender,eventType)
        self:setClubNote()
    end)
    
    return self.ui
end

function ClubManage:close()
    DialogManager:closeDialog(self)
end

function ClubManage:onShow()
    self.ui.lbl_zhanli:setString("战力大于 "..ClubMember.sysclub.zhanli.." 才可加入")
    self.ui.lbl_note:setString(ClubMember.sysclub.note)
end

function ClubManage:setClubZhanli()
    if tonum(ClubMember.myclub.state) < 1000 then
        MessageManager:show("只有会长可以设置战力")
        return
    end
    self:close()
    DialogManager:showDialog("ClubSet", 3, "请输入战力数值", ClubMember.sysclub.cid)
end

function ClubManage:setClubNote()
    if tonum(ClubMember.myclub.state) < 1000 then
        MessageManager:show("只有会长可以更改公告")
        return
    end
    self:close()
    if ClubMember.sysclub ~= nil and ClubMember.sysclub.note ~= "" then
        DialogManager:showDialog("ClubSetGongGao", 4, ClubMember.sysclub.note, ClubMember.sysclub.cid)
    else
        DialogManager:showDialog("ClubSetGongGao", 4, "请输入公会公告", ClubMember.sysclub.cid)
    end
    
end

return ClubManage