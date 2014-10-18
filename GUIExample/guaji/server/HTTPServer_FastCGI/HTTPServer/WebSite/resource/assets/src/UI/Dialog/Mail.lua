local Mail = {
    ui = nil,
    itemlist = nil,
    mailCount = 0
}

function Mail:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/mail.json"))
    self.ui.lbl_msg:setString( string.format("奖励领取后邮件将自动删除,系统自动清理7天前邮件"))
    local item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/mail-item.json")
    self.itemlist = self.ui.maillist
    self.itemlist:setItemsMargin(8)  
    self.itemlist:setItemModel(item)

    ui_add_click_listener( self.ui.btn_close,function()
        DialogManager:closeDialog(self)
        MainUI:refreshUinfoDisplay()
    end)

    return self.ui
end

function Mail:onShow()
    self:getMail()
end

function Mail:getMail()
    -- TODO: 优化，没必要每次都删了重建
    self.itemlist:removeAllItems()

    local function onGetMail(param)
        User.mail = 0
        if(param[1] == 1)then
            local i = 0
            for _,v in pairs(param[2]) do
                self.itemlist:pushBackDefaultItem()
                local custom_item = self.itemlist:getItem(self.itemlist:getChildrenCount()-1)
                local d = ui_delegate(custom_item)
        
                self:setItemInfo(d,v)
                i = i + 1
            end
            
            self.itemlist:refreshView()
            self.itemlist:jumpToTop()
            
            self.mailCount = table.getn(param[2])
            self:refreshMailCount()
        else
            MessageManager:show(param[2])
        end
    end
    
    sendCommand("getMail", onGetMail, {})
end

function Mail:refreshMailCount()
   -- self.ui.lbl_msg:setString( string.format("奖励领取后邮件将自动删除,系统自动清理7天前邮件"))
    --原代码（8.04）("当前还有%d个奖励未领取,领取后自动删除邮件",self.mailCount);
end

function Mail:setItemInfo(d,v)
    local size = d.pnl_content:getContentSize()
    local rt = ccui.RichText:create()
    d.pnl_content:addChild(rt)

    rt:setAnchorPoint(cc.p(0,1))
    rt:ignoreContentAdaptWithSize(false)
    rt:setContentSize(size)
    rt:setLocalZOrder(10)

    dump(v)
    if(tonum(v.mtype) == 0) then
        -- 老的普通邮件
        
        rt:pushBackElement(RTE(v.mcontent.."\n", 20,cc.c3b(255,255,255)))
        if(tonum(v.ucoin) >0 or tonum(v.ug) >0 or tonum(v.us) >0 or tonum(v.itemid) > 0) then
            rt:pushBackElement(RTE("可获奖励：\n", 20,cc.c3b(0,204,255)))
        end
        if(tonum(v.ucoin) >0)then
            rt:pushBackElement(RTE( "金币*", 20,cc.c3b(0,204,255)) )
            rt:pushBackElement(RTE( v.ucoin .." ", 20,cc.c3b(0,255,36)) )
        end
        if(tonum(v.ug) >0)then
            rt:pushBackElement(RTE( "钻石*", 20,cc.c3b(0,204,255)) )
            rt:pushBackElement(RTE( v.ug .. " ", 20,cc.c3b(0,255,36)) )        
        end
        if(tonum(v.us) >0)then
            rt:pushBackElement(RTE( "强化精华*", 20,cc.c3b(0,204,255)) )
            rt:pushBackElement(RTE( v.us, 20,cc.c3b(0,255,36)) )
        end

        if tonum(v.itemid) > 0 then
            local c = ConfigData.cfg_item[tonum(v.itemid)]
            rt:pushBackElement( RTE(" ".. c.name,20, cc.c3b(0,216,255)) )
            rt:pushBackElement( RTE( "*".. v.count,20, cc.c3b(0,232,58)) )
        end
        
        if tonum(v.itemid) == 7 then
            local c = ConfigData.cfg_item[8]
            rt:pushBackElement( RTE(" ".. c.name,20, cc.c3b(0,216,255)) )
            rt:pushBackElement( RTE( "*".. v.count,20, cc.c3b(0,232,58)) )
        end        
        
        if tonum(v.ucoin) >0 or tonum(v.ug) >0 or tonum(v.us) >0 or tonum(v.itemid) > 0 then
            d.btn_view:setVisible(false)
            d.btn_del:setVisible(false)
            d.btn_getreward:setVisible(true)	
        else
            d.btn_view:setVisible(false)
            d.btn_del:setVisible(true)
            d.btn_del:setPosition(cc.p(450,85))
            d.btn_getreward:setVisible(false)
        end    
       
    elseif(tonum(v.mtype) == 1) then
        -- 多人团战邮件
        rt:pushBackElement(RTE(v.mcontent.."\n", 20,cc.c3b(255,255,255)))
        d.btn_view:setVisible(true)
        d.btn_del:setVisible(true)
        d.btn_del:setPosition(cc.p(450,50))
        d.btn_getreward:setVisible(false)
    elseif (tonum(v.mtype) == 2) then
        if (tonum(v.count) > 0) then
            local item,color = User.getChengHao(toint(v.count))
            rt:pushBackElement(RTE("恭喜您达成了新的称号-", 20,cc.c3b(255,255,255)))
            rt:pushBackElement(RTE(item.name.."\n", 20,color))
            rt:pushBackElement(RTE(item.tips.."\n", 20,cc.c3b(1,200,250)))
            rt:pushBackElement(RTE("您可以在个人界面展示您的称号\n", 20,cc.c3b(138,123,159)))
         end
        d.btn_view:setVisible(false)
        d.btn_del:setVisible(false)
        d.btn_getreward:setVisible(true)
    else
        -- 奇怪的邮件- -!
        d.btn_view:setVisible(false)
        d.btn_del:setVisible(false)
        d.btn_getreward:setVisible(false)
    end
     rt:formatText()
    local rs = rt:getRealSize()

    if rs.height > 104 then
        -- 大于原始高度
        d.pnl_content:setContentSize( cc.size(rs.width, rs.height) )
        rt:setPosition(cc.p(0,rs.height))
        local newSizeH = math.max(rs.height + 41, 145)
        d.nativeUI:setContentSize( cc.size(518, newSizeH) )
        d.btn_getreward:setPosition(cc.p(390,newSizeH))
        d.btn_view:setPosition(cc.p(450,newSizeH-35))
        d.btn_del:setPosition(cc.p(450,newSizeH-105))
    else
        rt:setPosition(cc.p(0,104))        
    end
    
    ui_add_click_listener(d.btn_view, function()
        local callback = function(params)
            if(params[1] == 1) then
--                DialogManager:closeDialog(self)
                DialogManager:showDialog("GvgResult", params[2], params[3])
            else
                MessageManager:show(params[2])
            end
        end
        -- 
        sendCommand("getGvgbattle", callback, {v.count})
    end)
    
    ui_add_click_listener(d.btn_del, function()
        local function callback(params)
            if(params[1] == 1)then
                local i = self.ui.maillist:getCurSelectedIndex()
                self.ui.maillist:removeItem(i)
                self.mailCount = self.mailCount - 1
                self:refreshMailCount()
            end
            MessageManager:show(params[2])
        end
        sendCommand("delMail", callback, {v.mid})
    end)
    
    ui_add_click_listener(d.btn_getreward,function()
        local function onGetMailReward(param)
            if(param[1] == 1)then
                local i = self.ui.maillist:getCurSelectedIndex()
                self.ui.maillist:removeItem(i)
                self.mailCount = self.mailCount - 1
                self:refreshMailCount()

                if(param[2] > 0) then
                    MessageManager:show("获得钻石 *" .. param[2])
                    GameUI:addUserUg(param[2])
                end
                if(param[3] > 0)then
                    MessageManager:show("获得金币 *" .. param[3])
                    GameUI:addUserCoin(param[3])
                end
                if(param[4] > 0)then
                    MessageManager:show("获得强化精华 *" .. param[4])
                    GameUI:addUserJinghua(param[4])
                end
                
                if table.getn(param[6]) > 0 then
                    for _,vv in pairs(param[6]) do
                        local c = ConfigData.cfg_item[tonum(vv.itemid)]
                        MessageManager:show( string.format("获得物品 %s *%d", c.name, vv.count ) )
                        BagUI:addItem( tonum(vv.itemid), vv.count )
                    end
                end
                BagUI:setNeedRefresh()
            else
                MessageManager:show(param[2])
            end
        end
        sendCommand("getMailReward", onGetMailReward,{v.mid})
    end)
end


return Mail