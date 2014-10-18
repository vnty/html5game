local ClubShop = {
    ui = nil,
}

function ClubShop:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-shop.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_close2, function(sender,eventType)
        self:close()
    end)

    for i = 1,6 do
        local pnl = self.ui["pnl_buy_"..i]
        local btn = ui_(pnl, "btn_buy")
        local p = ConfigData.cfg_club_shop[i]
        local name = ConfigData.cfg_item[tonum(p.itemid)].name
        UICommon.setItemImg(ui_(pnl, "Image_18"), tonum(p.itemid), 0, false)
        ui_(pnl, "lbl_ug"):setString(name.."*"..p.num)
        ui_(pnl,"lbl_price"):setString(p.dkp.."贡献")

        ui_add_click_listener(btn, function(sender,eventType)
            self:buyItem(p.itemid, i, p.dkp)
        end)
        
        local function touchEvent(sender,eventType)
            print("touch -- itemid == "..p.itemid)
            if  eventType == ccui.TouchEventType.ended then
                DialogManager:showDialog("ItemDetail", tonum(p.itemid),false)
            end
        end
        ui_(pnl,"item"):setTouchEnabled(true)
        ui_(pnl,"item"):addTouchEventListener(touchEvent) 
    end

    return self.ui
end

function ClubShop:close()
    DialogManager:closeDialog(self)
    ClubMember:refreshUI()
end

function ClubShop:buyItem(id, i, dkp)
    local function callback(params)
        if params[1] == 1 then
            local itemname = ConfigData.cfg_item[params[2].itemid].name
            MessageManager:show("兑换成功!获得"..itemname.."*"..params[2].count)
            -- 刷新
            BagUI:addItem(params[2].itemid, params[2].count)
            BagUI:setNeedRefresh()
            
            ClubMember:reloadInfo(function()
                self:onShow()
            end)
            
        else
            MessageManager:show(params[2])
        end
    end
    sendCommand("buyClub",callback,{id, ClubMember.sysclub.cid})
end

function ClubShop:onShow()
    local numbers = {}
    for i=1, 6 do
        table.insert(numbers,tonum(ClubMember.sysclub["itemleft"..i]))
    end
    
    self.ui.lbl_dkp:setString(ClubMember.myclub.score.."/"..ClubMember.myclub.totalscore)
    
    for i = 1,table.getn(numbers) do
        local pnl = self.ui["pnl_buy_"..i]
        ui_(pnl, "lbl_num"):setString("剩余:"..numbers[i])
    end
end

return ClubShop