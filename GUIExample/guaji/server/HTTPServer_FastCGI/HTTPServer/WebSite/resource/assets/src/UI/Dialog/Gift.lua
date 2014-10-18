-- 每日奖励

local Gift = {
    ui = nil,
    itemlist=nil,
    item=nil,
}

function Gift:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/dialog-gift-new.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
    self.ui.Panel_3:getLayoutParameter():setMargin(tbl_act)
    
    self.ui.scv_list:setDirection(ccui.ScrollViewDir.vertical)
    self.ui.scv_list:setItemsMargin(3)
    
    ui_add_click_listener( self.ui.btn_close,function()
        DialogManager:closeDialog(self)
    end)

    ui_add_click_listener( self.ui.btn_cdk,function()
        DialogManager:showSubDialog(self,"CDkey")
    end)
    if(Platform.platformType==Platform.platform_appstore)then
         self.ui.btn_cdk:setVisible(false);
    end
    return self.ui
end

function Gift:onShow()
    self.item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/dialog-gift-item.json")
    self.itemlist = self.ui.scv_list

    self.itemlist:removeAllItems()
    self.itemlist:setItemModel(self.item)
    -- 清空pvp列表

    local function onGetGiftList(param)
        if(param[1] == 1)then
            local list = param[2]
            -- 排序一下
            table.sort(list, function(a,b) -- 活动,月卡,可领取
                if (tonum(a.gid) >= 80000 and tonum(a.gid) < 90000) and not (tonum(b.gid) >= 80000 and tonum(b.gid) < 90000) then
                    return true
                elseif (tonum(b.gid) >= 80000 and tonum(b.gid) < 90000) and not (tonum(a.gid) >= 80000 and tonum(a.gid) < 90000) then
                    return false
                elseif (tonum(b.gid) >= 80000 and tonum(b.gid) < 90000) and (tonum(a.gid) >= 80000 and tonum(a.gid) < 90000) then
                    return tonum(a.gid) > tonum(b.gid)
                elseif (tonum(a.gid) >= 60000 and tonum(a.gid) < 70000) and not (tonum(b.gid) >= 60000 and tonum(b.gid) < 70000) then
                    return true
                elseif (tonum(b.gid) >= 60000 and tonum(b.gid) < 70000) and not (tonum(a.gid) >= 60000 and tonum(a.gid) < 70000) then
                    return false
                else
                    return tonum(a.stat) > tonum(b.stat)
                end
            end)
            table.foreach(list, function(k,v)
                self.itemlist:pushBackDefaultItem()
                local custom_item = self.itemlist:getItem(self.itemlist:getChildrenCount()-1)
                local d = ui_delegate(custom_item)
                self:setItemInfo(d,v)
            end)
            
            User.paygift = tonum(param[3]) -- 首冲标志
            
            self.itemlist:refreshView()
            self.itemlist:jumpToTop()
        else
            MessageManager:show(param[2])
        end  
    end
    
    sendCommand("getGiftInfoNew", onGetGiftList, {} )
end

function Gift:refreshView(param)
--需优化,此处是删了重建
  -- 清空pvp列表
  cclog("gift refreshView")
  self.itemlist:removeAllItems()

  if(param[1] == 1)then
    local list = param[2]
    -- 排序一下
    table.sort(list, function(a,b) -- 活动,月卡,可领取
        if (tonum(a.gid) >= 80000 and tonum(a.gid) < 90000) and not (tonum(b.gid) >= 80000 and tonum(b.gid) < 90000) then
                return true
        elseif (tonum(b.gid) >= 80000 and tonum(b.gid) < 90000) and not (tonum(a.gid) >= 80000 and tonum(a.gid) < 90000) then
            return false
        elseif (tonum(b.gid) >= 80000 and tonum(b.gid) < 90000) and (tonum(a.gid) >= 80000 and tonum(a.gid) < 90000) then
            return tonum(a.gid) > tonum(b.gid)
        elseif (tonum(a.gid) >= 60000 and tonum(a.gid) < 70000) and not (tonum(b.gid) >= 60000 and tonum(b.gid) < 70000) then
            return true
        elseif (tonum(b.gid) >= 60000 and tonum(b.gid) < 70000) and not (tonum(a.gid) >= 60000 and tonum(a.gid) < 70000) then
            return false
        else
            return tonum(a.stat) > tonum(b.stat)
        end
    end)

    table.foreach(list, function(k,v)
      self.itemlist:pushBackDefaultItem()
      local custom_item = self.itemlist:getItem(self.itemlist:getChildrenCount()-1)
      local d = ui_delegate(custom_item)
      -- 此处判断月卡是否显示 v.stat = 0显示
      self:setItemInfo(d,v)
    end)
    
    self.itemlist:refreshView()
    self.itemlist:jumpToTop()
  else
    MessageManager:show(param[2])
  end  
end

-- type: 1 礼包Icon 
function Gift:setItemInfo(d,v)
    if v ~= nil and toint(v.gid/10000) == 6 then--月卡
        d.nativeUI:removeAllChildren()  
        d.nativeUI:setBackGroundImage("res/ui/images/img_206.jpg")
        ui_add_click_listener(d.nativeUI,function()
            Platform:buyItem(1, 2)
        end)
        return
    end
    if v ~= nil and toint(v.gid/10000) == 8 then -- 活动
        d.nativeUI:removeAllChildren()
        local image = ccui.ImageView:create()
        image:loadTexture("res/ui/img_activity/images_"..v.pindex..".jpg")
        local s=d.nativeUI:getContentSize()
        image:setAnchorPoint(cc.p(0.5,0.5))
        image:setPosition(s.width/2,s.height/2)
        d.nativeUI:addChild(image)
        ui_add_click_listener(d.nativeUI,function()
            DialogManager:closeDialog(self)
            DialogManager:showDialog("Activity"..(toint(v.gid)%10000))
        end)
        if v.name ~= nil then
            --TODO 限时活动时间
            local pLabel = UICommon.createLabel(v.name, 18)
            pLabel:setAnchorPoint(cc.p(0.5,0.5))
            pLabel:setPosition(cc.p(s.width/2-55,s.height/2-37)) 
            d.nativeUI:addChild(pLabel)
        end
        return
    end
    UICommon.loadExternalTexture( d.img_icon, string.format("res/item/gift%d.png", v.pindex ))--v.icon))

    -- 标题
    local s = d.pnl_info1:getContentSize()
    local info = ccui.RichText:create()
    info:setPosition(0,s.height)
    info:setAnchorPoint( cc.p(0,1) )
    info:ignoreContentAdaptWithSize(false)
    info:setContentSize(s)
    info:setLocalZOrder(10)
    d.pnl_info1:addChild(info)

    info:pushBackElement(RTE(string.format(v.name), 25,cc.c3b(255,204,0)))  

    -- 奖励内容
    s = d.pnl_info2:getContentSize()
    info = ccui.RichText:create()
    info:setPosition(0,s.height)
    info:setAnchorPoint( cc.p(0,1))
    info:ignoreContentAdaptWithSize(false)
    info:setContentSize(s)
    info:setLocalZOrder(10)
    d.pnl_info2:addChild(info)

    -- 礼包内容
    local gs = v.gift
    table.foreach(gs, function(k,v)
        if tonum(v.itemid) > 0 then
            if tonum(v.itemid) == 6 then
                local e = ConfigData.cfg_equip[toint(v.count.eid)]
                local lv = toint(e.lv)-toint(e.lv)%5
                lv=math.min(70,lv)
                lv=math.max(1,lv)
                local sock = ""
                if toint(v.count.sock) > 0 then
                    sock = "带"..v.count.sock.."孔"
                end
                local etype = ConfigData.cfg_equip_etype[toint(e.etype)]
                local einfo = ""
                if toint(v.count.advp) > 0 then
                    einfo = "神器"
                elseif toint(v.count.pcount) == 4 then
                    einfo = "橙色"
                elseif toint(v.count.pcount) == 3 then
                    einfo = "紫色"
                elseif toint(v.count.pcount) == 2 then
                    einfo = "蓝色"
                elseif toint(v.count.pcount) == 1 then
                    einfo = "绿色"
                elseif toint(v.count.pcount) == 0 then
                    einfo = "白色"
                end
                local color = User.starToColor(toint(v.count.pcount))
                if toint(v.count.advp) > 0 then
                    color = cc.c3b(255,0,0)
                end
                info:pushBackElement(RTE( lv.."级" .. sock .. einfo .. etype .. " ",20, color) )
            else
                local c = ConfigData.cfg_item[toint(v.itemid)]
                info:pushBackElement(RTE( c.name.."*" .. v.count .. " ",20, cc.c3b(0,232,58)) )
            end
        end
    end)

    if(tonum(v.stat)==1)then
        ui_add_click_listener(d.btn_get,function()
            local function onGetGift(p)
                dump(p)
                if p[1] == 1 then
                    MessageManager:show("领取成功")
                    self:refreshView(p[3])
                    if table.getn(p[2]) > 0 then
                        table.foreach(p[2],function(k,v)
                            if toint(v.itemid) > 0 then
                                if toint(v.itemid) ~= 6 then
                                    local c = ConfigData.cfg_item[toint(v.itemid)]
                                    MessageManager:show("获得"..c.name.."*"..v.count)
                                    BagUI:addItem(toint(v.itemid),toint(v.count))
                                else
                                    local msg = "获得"
                                    local lv = toint(v.count.lv) - toint(v.count.lv) % 5
                                    lv=math.min(70,lv)
                                    lv=math.max(1,lv)
                                    msg = msg .. lv .. "级"
                                    if toint(v.count.sock) > 0 then
                                        msg = "带"..v.count.sock.."孔"
                                    end
                                    local etype = ConfigData.cfg_equip_etype[toint(v.count.etype)]
                                    local einfo = ""
                                    if toint(v.count.advp) > 0 then
                                        einfo = "神器"
                                    elseif toint(v.count.star) == 4 then
                                        einfo = "橙色"
                                    elseif toint(v.count.star) == 3 then
                                        einfo = "紫色"
                                    elseif toint(v.count.star) == 2 then
                                        einfo = "蓝色"
                                    elseif toint(v.count.star) == 1 then
                                        einfo = "绿色"
                                    elseif toint(v.count.star) == 0 then
                                        einfo = "白色"
                                    end
                                    local color = User.starToColor(toint(v.count.star))
                                    if toint(v.count.advp) > 0 then
                                        color = cc.c3b(255,0,0)
                                    end
                                    msg = msg .. einfo .. etype
                                    MessageManager:show(msg, color)
                                    BagUI:addEquipToBag(v.count,true)
                                end
                            end
                        end)
                    end
                    GameUI:loadUinfo()
                else
                    MessageManager:show(p[2])
                end
            end
            sendCommand("getGiftNew",onGetGift,{v.gid})
        end)
        d.lbl_notok:setVisible(false)
    else
        d.btn_get:setVisible(false)
    end
end

return Gift