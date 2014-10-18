local GvgResult = {
    ui = nil,
    item_module = nil,
    result = nil, 
    win = nil,
    myteam = nil
}

function GvgResult:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/gvg-result.json"))

    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/gvg-result-item.json")
    self.item_module:retain()
    self.ui.item_list:setItemsMargin(8)  

    self.ui.item_list:setDirection(ccui.ScrollViewDir.vertical)
        
    ui_add_click_listener(self.ui.btn_close, function()
        self:close()
    end)
    
    return self.ui
end

function GvgResult:onShow(params, gid)
    self.gid = tonum(gid)
    self.result = params
    if(self.result ~= nil and table.getn(self.result) ~= 0) then
        if(tonum(self.result[1].gid) == self.gid) then
            self.myteam = self.result[1].gname
        else
            self.myteam = self.result[1].armname
        end
    end
    self:getGvgResultList()
end

function GvgResult:getGvgResultList()
    local itemlist = self.ui.item_list

    -- 清空pvp列表
    itemlist:removeAllItems()
    itemlist:setItemModel(self.item_module)
    
    -- 按照场次排序
--    table.insert(self.result,{armgid=2133, armname="test1", bout=9,gid="2126", glogid="4375",gname="这是测试最后的",logid="2188",result=0})
    local maxbout = 0
    for i=1,table.getn(self.result) do
        maxbout = math.max(tonum(self.result[i].bout)+1, maxbout)
    end
    table.sort(self.result, function(a, b)
        return tonum(a.bout) < tonum(b.bout)
    end)
    
    local j = 1
    for i = 1, maxbout do
        itemlist:pushBackDefaultItem()
        local custom_item = itemlist:getItem(itemlist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        if(self.result[j] ~= nil and tonum(self.result[j].bout)+1 == i) then
            self:setItemInfo(d, i, self.result[j])
            j = j + 1
        else
            self:setItemInfo(d, i)
        end
    end

    itemlist:refreshView()
    itemlist:jumpToTop()
end

function GvgResult:setItemInfo(d, i, v)
    d.lbl_session:setString("第"..i.."轮")
    if(v ~= nil) then
        local win = 0
        local team1 = ""
        local team2 = ""
        d.lbl_team1_name:setString("["..v.gname.."]")
        d.lbl_team2_name:setString("["..v.armname.."]")
        d.lbl_team2_result:setVisible(false)
        if(tonum(v.result) == 1) then
            d.lbl_team1_result:setString("胜利")
            d.lbl_team2_result:setString("失败")
            team1 = v.gname
            team2 = v.armname
        else
            d.lbl_team2_result:setString("胜利")
            d.lbl_team2_name:setColor(cc.c3b(72,199,35))
            d.lbl_team2_result:setColor(cc.c3b(235,202,59))
            d.lbl_team1_result:setString("失败")
            d.lbl_team1_name:setColor(cc.c3b(247,31,35))
            d.lbl_team1_result:setColor(cc.c3b(247,31,35))
            team1 = v.gname
            team2 = v.armname
        end
            ui_add_click_listener( d.btn_view, function()
            self:viewResultInfo(v.logid, team1, team2,i)
        end)
    else
        d.lbl_team2_result:setVisible(true)
        d.lbl_team1_name:setString("["..self.myteam.."]")
        d.lbl_team2_name:setVisible(false)
        d.lbl_team1_result:setString("胜利")
        d.lbl_team2_result:setString("轮空")
        d.lbl_team2_result:setColor(cc.c3b(255,255,255))
        d.btn_view:setVisible(false)
    end 
end

function GvgResult:viewResultInfo(logid, team1, team2,lun)
    local callback = function(params)
        if(params[1] == 1) then
--            self:close()
            DialogManager:showDialog("GvgResultInfo", params[2], team1, team2,self.gid,lun)
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("getGvglog", callback, {logid})
end

function GvgResult:close()
    DialogManager:closeDialog(self)
end

return GvgResult