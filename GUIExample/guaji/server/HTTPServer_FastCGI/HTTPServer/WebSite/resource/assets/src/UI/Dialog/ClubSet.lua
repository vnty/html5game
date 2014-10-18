local ClubSet = {
    ui = nil,
    EditName = nil, 
    cid = 0
}

function ClubSet:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/club-set.json"))

    ui_add_click_listener(self.ui.btn_close, function(sender,eventType)
        self:close()
    end)

    -- top
    local back = cc.Scale9Sprite:create("res/ui/images/img_110.png", cc.rect(20, 20, 1, 1))
    back:setContentSize(cc.size(0,0))
    self.EditName = cc.EditBox:create(cc.size(350,50), back)
    --    local EditName = cc.EditBox:create(cc.size(350,50), self.ui.info_back)
    self.EditName:setPosition(cc.p(250, 60))
    self.EditName:setFontSize(24)
    self.EditName:setFontColor(cc.c3b(255,255,255))
    self.EditName:setPlaceholderFontColor(cc.c3b(188,128,200))
    self.EditName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    
    --Handler
    --EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    self.ui.pnl_input:addChild(self.EditName)
    
    self.ui.pnl_create:setVisible(false)
    self.ui.pnl_search:setVisible(false)
    self.ui.pnl_setnote:setVisible(false)
    self.ui.pnl_setzhanli:setVisible(false)
    
    ui_add_click_listener(self.ui.btn_create, function(sender,eventType)
        local name = self.EditName:getText()
        if name == nil or name == "" then
            MessageManager:show("请输入公会名")
            return
        end
        local function callback(p)
            dump(p)
            if(p[1] == 1)then
                ClubMember.myclub = p[2]
                ClubMember.sysclub = p[3]
                self:close()
                GameUI:switchTo("clubMember")
                
                -- 更新公会ID
                BattleUI.chatUI:updateClub(toint(ClubMember.myclub.cid))
            else
                MessageManager:show(p[2])
            end
        end

        sendCommand("createClub",callback, {name})
    end)
    
    ui_add_click_listener(self.ui.btn_search, function(sender,eventType)
        local name = self.EditName:getText()
        if name == nil or name == "" then
            MessageManager:show("请输入公会ID")
            return
        end
        local function callback(p)
            if p[1] == 1 then
                self:close()
                ClubUI.clubs = p[2]
                GameUI:switchTo("clubUI")
            else
                MessageManager:show(p[2])
            end
        end

        sendCommand("findClub",callback, {name})
    end)
    
    ui_add_click_listener(self.ui.btn_setzhanli, function(sender,eventType)
        local name = self.EditName:getText()
        if name == nil or name == "" then
            MessageManager:show("请输入战力要求")
            return
        end
        local function callback(p)
            if(p[1] == 1)then
                MessageManager:show("设置成功")
                self:close()
                ClubMember:reloadInfo(function()
                    ClubMember:refreshUI()
                end)
            else
                MessageManager:show(p[2])
            end
        end
        if self.cid ~= 0 then
            sendCommand("setClubZhanli",callback, {name, self.cid})
        end
    end)
    
    ui_add_click_listener(self.ui.btn_setnote, function(sender,eventType)
        local name = self.EditName:getText()
        if name == nil then
            name = ""
        end
        local function callback(p)
            if(p[1] == 1)then
                MessageManager:show("修改成功")
                self:close()
                ClubMember:reloadInfo(function()
                    ClubMember:refreshUI()
                end)
            else
                MessageManager:show(p[2])
            end
        end
        if self.cid ~= 0 then
            sendCommand("setClubNote",callback, {name, self.cid})
        end
    end)
    
    return self.ui
end

-- TYPE: 1 创建公会 2 搜索公会 3 设置公会战力 4 设置公会公告
function ClubSet:onShow(type, default, cid)

    -- TODO 刷新公会
    self.EditName:setText("")
    self.EditName:setPlaceHolder(default)
    type = tonum(type)
    self.cid = tonum(cid)
        
    self.ui.pnl_create:setVisible(false)
    self.ui.pnl_search:setVisible(false)
    self.ui.pnl_setzhanli:setVisible(false)
    self.ui.pnl_setnote:setVisible(false)
    
    if type == 1 then
        self.EditName:setMaxLength(6)
        self.ui.pnl_create:setVisible(true)
    elseif type == 2 then
        self.EditName:setMaxLength(20)
        self.ui.pnl_search:setVisible(true)
    elseif type == 3 then
        self.EditName:setMaxLength(20)
        self.ui.pnl_setzhanli:setVisible(true)
    elseif type == 4 then
        self.EditName:setMaxLength(20)
        self.EditName:setText(default)
        self.ui.pnl_setnote:setVisible(true)
    end
    
end

function ClubSet:close()
    DialogManager:closeDialog(self)
end

return ClubSet