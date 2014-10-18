local PvpDetail = {
    ui = nil,
    uinfo = nil,
    uequip = nil,
    uequips = {}
}

function PvpDetail:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/pvp-detail.json"))

    ui_add_click_listener( self.ui.btn_close,function()
        DialogManager:closeDialog(self)
    end)
    
    -- 设置装备按钮点击事件
    for i,v in pairs(ConfigData.cfg_equip_etype) do
        local item_img = self.ui["equip_"..i] 
        if(item_img ~= nil)then
            item_img:setTouchEnabled(true)
            ui_add_click_listener( item_img, function(sender,eventType)
                cclog("equip choose " .. i)
                local v = self.uequips[i]
                if v ~= nil then
                    DialogManager:showSubDialog(self, "EquipDetail",v, self.uequips)
                end
            end )
        end
    end
    
    return self.ui
end

function PvpDetail:onShow(uid)
    self:getPvpDetail(uid)
end

function PvpDetail:getPvpDetail(uid)
    local function onGetPvpDetail(param)
    	if param[1] == 1 then
    	   self.uinfo = param[2]
    	   self.uequip = param[3]
    	   self.uequips = {}
    	   
    	   for _,v in pairs(param[4]) do
    	       self.uequips[tonum(v.etype)] = v
               User.updateEquipInfo(v)
    	   end
    	   
           self:refreshUI()
    	else
    	   MessageManager:show(param[2])
    	end
    end
    
	sendCommand("getPvpDetail",onGetPvpDetail,{uid})
end

function PvpDetail:refreshUI()
    --1zs 2lr 3fs
    if toint(self.uinfo.ujob) == 1 then
        self.ui.icon_job:loadTexture("res/ui/images/img_08.png")
        self.ui.text_job:loadTexture("res/ui/icon/text_05.png")
    elseif toint(self.uinfo.ujob) == 2 then
        self.ui.icon_job:loadTexture("res/ui/images/img_07.png")
        self.ui.text_job:loadTexture("res/ui/icon/text_04.png")    
    elseif toint(self.uinfo.ujob) == 3 then
        self.ui.icon_job:loadTexture("res/ui/images/img_09.png")
        self.ui.text_job:loadTexture("res/ui/icon/text_06.png")
    end

    self.ui.img_job:loadTexture( User.getUserImg( tonum(self.uinfo.ujob), tonum(self.uinfo.sex)) )

    local equipList = self.ui.equip_list

    for i,v in pairs(ConfigData.cfg_equip_etype) do
        local v = self.uequips[i]
        local e = self.ui["equip_"..i]
        if(v ~= nil)then
            UICommon.setEquipImg(e,v)
        else
                -- 没有装备
            UICommon.setEquipImg(e,nil,true)
        end 
    end

    local baseProps = User.getBaseProps(toint(self.uinfo.ujob), toint(self.uinfo.ulv))
    User.updateSecondProps(baseProps,toint(self.uinfo.ujob), toint(self.uinfo.ulv))
    dump(baseProps)
    
    local equipProps = {}
    User.equipPropsToTable(equipProps, self.uequip.ep)
    User.updateSecondProps(equipProps,toint(self.uinfo.ujob),0) -- 不计算MP
    
    -- 显示玩家属性
    local function getUserPropStr(pi)
        local str = ""
        str = tonum(baseProps[pi]) + tonum(equipProps[pi])
        local basearr={
            [26] = 39,
            [31] = 33,
            [7] = 35,
            [8] = 36,
            [12] = 38,
            [6] = 34,
            [9] = 37,
            [5] = 48,
            [10] = 14,
            [11] = 14
        }
        if basearr[pi] ~= nil then
            str = toint(tonum(str) * (1 + tonum(tonum(baseProps[tonum(basearr[pi])]) + tonum(equipProps[tonum(basearr[pi])]))/ 10000))  --百分比属性 TODO 加全身强化
        end
        return str
    end

    local d = self.ui
    local eps = { 1,2,3,4,5,6,7,8,9,12,26,27 }
    for _,v in pairs(eps) do
        d["lbl_"..v]:setString(getUserPropStr(v))
    end

    d.lbl_dmg:setString( getUserPropStr(10) .. "-" .. getUserPropStr(11))

    d.lbl_power:setString("战力：" .. self.uinfo.zhanli)
    d.lbl_title:setString("Lv."..self.uinfo.ulv.." ".. self.uinfo.uname)
    d.lbl_club:setString(self.uinfo.cname)
    if toint(self.uinfo.nowchid)>0 and toint(self.uinfo.nowchid) <10 then
        local chenghao,color,imgurl=User.getChengHao(self.uinfo.nowchid)
        d.lbl_chenghao:setString(chenghao.name)
        d.lbl_chenghao:setColor(color)
        d.img_chenghao:loadTexture(imgurl)
        d.img_chenghao:setVisible(true)
    else
        d.img_chenghao:setVisible(false)
    end

end

return PvpDetail