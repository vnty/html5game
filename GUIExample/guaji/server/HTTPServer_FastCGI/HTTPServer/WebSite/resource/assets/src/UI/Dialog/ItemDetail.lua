-- 标准的信息报告框

local ItemDetail = {
  ui = nil
}

function ItemDetail:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/item-detail.json"))
  
    self.ui.nativeUI:setTouchEnabled(true)
  
    ui_add_click_listener( self.ui.btn_close,function()
        self:close()
    end)
  
    ui_add_click_listener( self.ui.nativeUI, function()
        self:close()
    end)
  
    return self.ui
end

function ItemDetail:onShow(itemid,showBtn)
    self.ui.btn_gem:setVisible(false)
    self.ui.btn_one:setVisible(false)
    self.ui.btn_ten:setVisible(false)
    self.ui.btn_use:setVisible(false)
    self.ui.btn_build:setVisible(false)
    self.ui.btn_close1:setVisible(false)
    if(toint(itemid/100) <= 4 and toint(itemid/100) >= 1 and toint(itemid%100) >= 1 and toint(itemid%100) <= 15) then
        self.ui.btn_gem:setVisible(true)
        ui_add_click_listener( self.ui.btn_gem, function()
            if User.ulv < 15 then
                MessageManager:show("人物等级15级开放宝石升级")
                return
            end
            self:close()
            DialogManager:showDialog("GemUp", itemid)
        end)
    elseif(toint(itemid) == 12 or toint(itemid) ==13) then --宝石袋

        self.ui.btn_one:setVisible(true)
        self.ui.btn_ten:setVisible(true)
        local onOpenGem = function(params)
            if(params[1] == 1) then
                local messagelist = {}
                
                table.foreach(params[2], function(k,v)
                    local c = ConfigData.cfg_item[tonum(v)]
--                    if(c ~= nil) then 
--                        MessageManager:show("获得"..c.name.."一个")
--                    end
                    local message = {message = "获得"..c.name.."一个", color = cc.c3b(0,255,0)}
                    BagUI:addItem(v,1)
                    table.insert(messagelist, message)
                   
                end)
               
                MessageManager:showMessageDelay(messagelist, 0.1)
                BagUI:reduceItem(itemid, table.getn(params[2]))
                
                BagUI:setNeedRefresh()
                self.ui.item_img:getChildByTag(100):setString("x"..User.userItems[tonum(itemid)])
                
                if tonum(User.userItems[itemid]) == 0 then 
                    self:close()
                end
            else
                MessageManager:show(params[2])
            end
        end
        
        ui_add_click_listener( self.ui.btn_one, function()
            sendCommand("openGem",onOpenGem,{toint(itemid), 1})
        end)
        
        ui_add_click_listener( self.ui.btn_ten, function()
            sendCommand("openGem",onOpenGem,{toint(itemid), 10})
        end)
    elseif toint(itemid) == 4 then--神器合成
        self.ui.btn_build:setVisible(true)
        local magComposite = function(params)
            if(params[1] == 1) then
                local equip = params[2]
                local message = {message = "获得"..User.getEquipName(equip[2]).."一个", color = cc.c3b(0,255,0)}
                table.insert(messagelist, message)
                MessageManager:showMessageDelay(messagelist, 0.1) 
                BagUI:reduceItem(itemid,10)
                BagUI:addEquipToBag(equip[2], true) 
                BagUI:setNeedRefresh()
            else
                MessageManager:show(params[2])
            end
        end
        local function magicComposite(param)
            dump(param);
            local ret=param[1];
            if(ret==1)then
                local equip=param[2];
                MessageManager:show("获得新装备：".. User.getEquipName(equip), cc.c3b(255,0,0) )
                BagUI:reduceItem(itemid,10);
                BagUI:setNeedRefresh();
                BagUI:addEquipToBag(equip,true);
                User.updateEquipInfo(equip);
                DialogManager:showDialog( "EquipDetail", equip);
                self.ui.item_img:getChildByTag(100):setString("x"..User.userItems[tonum(itemid)])    
            else
                AlertManager:ok("提 示", RTE(param[2],25, cc.c3b(255,255,255)), nil);
            end
        end
        ui_add_click_listener( self.ui.btn_build, function()
            self:close()
            sendCommand("useItem",magicComposite,{toint(itemid)})
        end)  
    elseif  toint(itemid) == 11 then--BOSS挑战券
        self.ui.btn_use:setVisible(true)
        local addBoss = function(params)
            if(params[1] == 1) then
                User.pvb=1+User.pvb
                MessageManager:show("使用成功")
                BagUI:reduceItem(itemid,1)
                BagUI:setNeedRefresh()
                self.ui.item_img:getChildByTag(100):setString("x"..User.userItems[tonum(itemid)])
            else
                MessageManager:show(params[2])
            end
        end
        ui_add_click_listener( self.ui.btn_use, function()
            sendCommand("useItem",addBoss,{toint(itemid)})
        end)
    else 
        self.ui.btn_close1:setVisible(true)
        ui_add_click_listener( self.ui.btn_close1,function()
            self:close()
        end)
    end
    
    local c = ConfigData.cfg_item[tonum(itemid)]
--    local count = BagUI:getItemCount(itemid)
    UICommon.setItemImg(self.ui.item_img, itemid, User.userItems[tonum(itemid)])
--    self.ui.Label_detail:setVisible(false)
    
    self.ui.pnl_info:removeAllChildren()
    
    local rtes = {}
    table.insert( rtes, RTE(c.desc,25,cc.c3b(255,255,255)) )
    local rt = UICommon.createRichText(self.ui.pnl_info,rtes)
    rt:setTouchEnabled(false)
    
    if(showBtn == false)then
        self.ui.btn_gem:setVisible(false)
        self.ui.btn_one:setVisible(false)
        self.ui.btn_ten:setVisible(false)
        self.ui.btn_use:setVisible(false)
        self.ui.btn_build:setVisible(false)
        self.ui.btn_close1:setVisible(false)
    end
end

function ItemDetail:close()
    BagUI:refreshUI()
    DialogManager:closeDialog(self)
end

return ItemDetail