-- 多人团战
local GvgDetail = {
    ui = nil,
    gvg_item_module = nil,
    myTeam = nil,
    myMembers = nil,
    isLeader = false,
    topUI = nil
}
local frameSize = cc.Director:getInstance():getWinSize()
function GvgDetail:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/gvg-detail.json"))
    --self.ui.Label_24:setVisible(false)
    self.ui.Panel_5_0_0:setContentSize(640,644+(frameSize.height-960))
    self.ui.Panel_5_0_0:setPosition(cc.p(0,62+(frameSize.height-960)/2))
    self.ui.Image_20:setContentSize(580,367+(frameSize.height-960))
    self.ui.ListPlayer:setContentSize(570,352+(frameSize.height-960))
    self.ui.Image_14:setPosition(cc.p(frameSize.width/2,766+(frameSize.height-960)))
    self.ui.Image_20:setPosition(cc.p(frameSize.width/2,(frameSize.height-960)/2+447))
    
    self.topUI = ui_delegate(self.ui.Panel_iteamLeader)
    
    self.gvg_item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/gvg-item.json")
    self.gvg_item_module:retain()

    self.ui.ListPlayer:setDirection(ccui.ScrollViewDir.vertical)
    self.ui.ListPlayer:setItemsMargin(3)
    self.ui.ListPlayer:setPosition(cc.p(16,4))
    self.ui.lbl_name:setString(User.uname.."的小队")
    ui_add_click_listener(self.ui.btn_fresh, function()
        GvgDetail:getGvgInfo()
    end)
    return self.ui
end

function GvgDetail:onShow()
    GameUI:setMainHeaderVisible(true)
    
    self.myMembers = GvgUI.myMembers
    self.myTeam = GvgUI.myTeam
    self.isLeader = (tonum(User.uid)==tonum(GvgUI.myTeam.uid))
    
    if(self.myMembers ~= nil) then
        if(tonum(self.myTeam.uid) == tonum(User.uid))then
            self.ui.Panel_leader:setVisible(true)
            self.ui.Panel_player:setVisible(false)
        else
            self.ui.Panel_player:setVisible(true)
            self.ui.Panel_leader:setVisible(false)
        end
        self:getGvgList()
    else
        self:getGvgInfo()
    end

end

function GvgDetail:getGvgList()

    local itemlist = self.ui.ListPlayer

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.gvg_item_module)
    local allZhanli=0;
    -- 按战力排序 ,队长在最前
    table.sort(self.myMembers, function(a, b)
        if(tonum(a.uid) == tonum(self.myTeam.uid)) then
            return true
        end
        if(tonum(b.uid) == tonum(self.myTeam.uid)) then
            return false
        end
        return tonum(a.zhanli) < tonum(b.zhanli)
        
    end)
    
    for i = 1, table.getn(self.myMembers) do
--        if(tonum(self.myMembers[i].uid) ~= tonum(self.myTeam.uid)) then
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        self:setItemInfo(d, self.myMembers[i])
--        else
--            self:setTopUI(self.myMembers[i])
--        end
        allZhanli = self.myMembers[i].zhanli+allZhanli
    end
    
    self.ui.lbl_strength:setString("总战力："..allZhanli.."("..table.getn(self.myMembers).."/10)")
    itemlist:refreshView()
    itemlist:jumpToTop()    
end

function GvgDetail:getGvgInfo()
    local callback = function(params)
        if(params[1] == 0) then
            MessageManager:show(params[2])
        elseif(params[1] == 1) then
            self.myMembers = params[2] 
            self.myTeam =params[3]
            self:getGvgList()
        else
            self.myMembers = nil
            self.myTeam = nil
        end
    end
    
    sendCommand("getMygvg", callback)
end

function GvgDetail:setItemInfo(d, member)
    --    d.lbl_rank:setVisible(false)
    d.header_img:setTouchEnabled(true)
    ui_add_click_listener(d.header_img, function()
        DialogManager:showDialog("PvpDetail",member.uid)
    end)
    d.lbl_name:setString(member.uname)
    --    d.lbl_power:setString("战力:"..member.zhanli)
    d.lbl_power:setVisible(false)
    d.lbl_rank:setString("战力:"..member.zhanli)
    UICommon.loadExternalTexture( d.header_img, User.getUserHeadImg(member.ujob, member.sex))
--    d.lbl_message:setString("uid: "..member.uid)
    if(member.skill ~= nil) then
        local skils = string.split(member.skill, ",")
        for i=1,4 do
            if(tonum(skils[i]) ~=0 ) then
                d["img_skill"..i]:setVisible(true)
                d["img_skill"..i]:loadTexture( string.format("res/skill/%d.png", skils[i]))
            else
                d["img_skill"..i]:setVisible(false)   
            end
        end
    else
        for i=1,4 do
            d["img_skill"..i]:setVisible(false)   
        end
    end
    
    if(tonum(member.uid) == tonum(self.myTeam.uid)) then
        d.btn_out:setVisible(false)
        d.img_leader:setVisible(true)
    else
        ui_add_click_listener( d.btn_out, function()
            local onOK = function(params)
                self:replaceMember(member.uid)
--                GameUI:addUserUg(-(self.myTeam.opt + 1)*10)
                MainUI:refreshUinfoDisplay()
            end
            AlertManager:yesno("更换队员",RTE("更换队员需要"..((self.myTeam.opt + 1)*10).."钻石,是否继续?",25,cc.c3b(255,255,255)), onOK)
        end)
        d.btn_out:setVisible(self.isLeader)
        d.img_leader:setVisible(false)
    end
    
end

function GvgDetail:setTopUI(member)
    self:setItemInfo(self.topUI, member)
end

function GvgDetail:replaceMember(muid)
    local callback = function(params)
        if(params[1] == 1) then
            User.ug = User.ug - tonum((self.myTeam.opt + 1) * 10)
            MainUI:refreshUinfoDisplay()
            self.myMembers = params[2]
            self.myTeam = params[3]
            if(self.myMembers ~= nil) then
                self:getGvgList()
            end
        else
            MessageManager:show(params[2])
        end
    end
    
    sendCommand("delGvg", callback, {muid})
end

function GvgDetail:close()
    DialogManager:closeDialog(self)
end


return GvgDetail