local GvgResultInfo = {
    ui = nil,
    item_module = nil,
    my = {},
    enemy = {},
    win = nil,
    log = nil
}

function GvgResultInfo:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/gvg-result-info.json"))

    self.item_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/gvg-result-info-item.json")
    self.item_module:retain()
    
    self.ui.my_list:setItemsMargin(5)
    self.ui.my_list:setDirection(ccui.ScrollViewDir.vertical)

    ui_add_click_listener(self.ui.btn_close, function()
        self:close()
    end)
    
    ui_add_click_listener(self.ui.Button_12, function()
        self:close()
    end)

    return self.ui
end

function GvgResultInfo:onShow(params, team1, team2,mygid,lun, type)
    dump(params)
    self.mygid = tonum(mygid)
    self.win = tonum(params["win"])
    self.ui.lbl_title:setString("第"..lun.."轮战斗")
    self.ui.lbl_team1:setString("["..team1.."]")
    self.ui.lbl_team2:setString("["..team2.."]")
    self.my={}
    self.enemy={}
    table.foreach(params["log"], function(k,v)
        if self.win==self.mygid then
            self.ui.lbl_team1_result:setString("胜利")
        else
            self.ui.lbl_team1_result:setString("失败")    
        end
        if(self.mygid == tonum(k)) then
            table.foreach(v, function(k, v)
                self.my[toint(k)] = v
            end)
        else
            table.foreach(v, function(k, v)
                self.enemy[toint(k)] = v
            end)
        end
    end)
    if type == 2 then
        if lun == 1 then
            self.ui.lbl_title:setString("决赛战斗详情")
        elseif lun == 2 then
            self.ui.lbl_title:setString("半决赛战斗详情")
        else
            self.ui.lbl_title:setString(lun.."强战斗详情")
        end
        self:getGvgResultInfoList(2)
    else
        self:getGvgResultInfoList(1)
    end
end

function GvgResultInfo:getGvgResultInfoList(type)
    local mylist = self.ui.my_list

    -- 清空列表
    mylist:removeAllItems()
    mylist:setItemModel(self.item_module)

    -- 我方按照击杀->得分排序
    table.sort(self.my, function(a, b)
        if tonum(a.kill) > tonum(b.kill) then
            return true
        elseif tonum(a.kill) < tonum(b.kill) then
            return false
        else
            return tonum(a.score) > tonum(b.score)
        end
    end)
    
    -- 敌方按照击杀排序
    table.sort(self.enemy, function(a, b)
        if tonum(a.kill) > tonum(b.kill) then
            return true
        elseif tonum(a.kill) < tonum(b.kill) then
            return false
        else
            return tonum(a.score) > tonum(b.score)
        end
    end)
    
    -- 设置信息
    for i = 1, math.max(table.getn(self.my),table.getn(self.enemy)) do
        mylist:pushBackDefaultItem()
        local custom_item = mylist:getItem(mylist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        self:setItemInfo(d, self.my[i], self.enemy[i], type)
    end
    
    mylist:refreshView()
    mylist:jumpToTop()
end

function GvgResultInfo:setItemInfo(d, my, enemy, type)
    self:setItemInfo2(ui_delegate(d.img_myTeam), my, 1, type)
    self:setItemInfo2(ui_delegate(d.img_heTeam), enemy, 2, type)
end

function GvgResultInfo:setItemInfo2(d, v, type, type2) --@return typeOrObject
	if(v ~= nil) then
        d.lbl_lv:setString(v.name)
--        d.lbl_name:setString(v.name)
        d.lbl_name:setVisible(false)
        if(tonum(v.uid) == tonum(User.uid)) then
--            d.lbl_name:setColor(cc.c3b(255,204,0))
            d.lbl_lv:setColor(cc.c3b(255,204,0))
            if(type == 1) then
                d.img_myTeam:loadTexture("res/ui/images/img_205.png")
            else
                d.img_heTeam:loadTexture("res/ui/images/img_205.png")
            end
        end
        
        d.nativeUI:setTouchEnabled(true)
        ui_add_click_listener(d.nativeUI, function()
            DialogManager:showDialog("PvpDetail",v.uid)
        end)
        
        if(tonum(v.kill) ~= 0) then
            d.lbl_kill:setString("击杀:"..v.kill)
        else
            d.lbl_kill:setString("未击杀")
        end
        d.lbl_hurt:setString("得分"..v.score)
        if type2 == 2 then
            if tonum(v.pos)==2 then 
                d.lbl_pos:setString("后排")
            else
                d.lbl_pos:setString("前排")
            end
        else
            d.lbl_pos:setVisible(false)
        end
	else
        d.lbl_lv:setVisible(false)
        d.lbl_name:setVisible(false)
        d.lbl_kill:setVisible(false)
        d.lbl_hurt:setVisible(false)
        d.lbl_pos:setVisible(false)
	end
end

function GvgResultInfo:viewResultInfo()
    self:close()
    DialogManager:showDialog("GvgResultInfo", v)    
end

function GvgResultInfo:close()
    DialogManager:closeDialog(self)
end

return GvgResultInfo