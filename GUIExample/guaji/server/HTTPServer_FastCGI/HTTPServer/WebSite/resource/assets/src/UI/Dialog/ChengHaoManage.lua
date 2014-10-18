local ChengHaoManage = {
    ui = nil,
    ChengHaoManagelist = nil,
    ChengNum = 0,
    chenglist=nil,
    allCheng=nil,
    boxlist = nil,
    chid = 0,
    myChengNum  = 0,
}

function ChengHaoManage:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/chenghao.json"))
    self.ui.nativeUI:setTouchEnabled(true)

    self.chenglist = self.ui.list_cheng
    self.chenglist:setItemsMargin(5)
    self.chenglist:setTouchEnabled(true)
    self.chenglist:setBounceEnabled(true)

    local cheng_item = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/chenghao-item.json")
    self.chenglist:setItemModel(cheng_item)

    ui_add_click_listener(self.ui.nativeUI,function()
        self:close()
    end)

    ui_add_click_listener( self.ui.btn_close,function()
        self:close()
    end)

    ui_add_click_listener( self.ui.btn_commit,function()
        self:equipCheng()
    end)
    
    ui_add_click_listener( self.ui.btn_cancel,function()
        self:cancel()
    end)
    return self.ui
end
function ChengHaoManage:isMyCheng(cheng)
      local flag=false
      table.foreach(User.userCheng,function(k,v)
        if(toint(cheng.chid)==toint(v.chid))then
            flag = true
        end
      end)
      return flag
end

function ChengHaoManage:setItemInfo(d,v)
    --使checkbox只能选中一个
    local function setSelectBox(box)
        table.foreach(self.boxlist,function(k,v)
            if(box == v) then
                v:setSelectedState(true)
            end
        end)
        self:checkboxDisable()
    end
   
    d.lbl_detail:setString( v.tips )
    d.lbl_chenghao:setString( v.name )
    if toint(v.type) == 2 then
        d.lbl_chenghao:setColor(cc.c3b(2,193,243))
        d.lbl_detail:setColor(cc.c3b(95,215,245))
        d.img_chenghao:loadTexture( "res/ui/images/img_232.png" )
    elseif toint(v.type) == 3 then
        d.lbl_chenghao:setColor(cc.c3b(251,94,251))
        d.lbl_detail:setColor(cc.c3b(190,146,241))
        d.img_chenghao:loadTexture( "res/ui/images/img_231.png" )
    end

    if self:isMyCheng(v) then
        
        local function selectedEvent(sender,eventType)
            if eventType == ccui.CheckBoxEventType.selected then             
                setSelectBox(sender)
            elseif eventType == ccui.CheckBoxEventType.unselected then
                self:checkboxEnable()   
            end
        end 
        d.checkbox:addEventListenerCheckBox(selectedEvent)

        table.insert(self.boxlist,d.checkbox)
        if(toint(v.chid) == toint(User.uCheng) ) then
            setSelectBox(d.checkbox)  
        end
        if(User.uCheng ~= 0) then
            self:checkboxDisable()
        end
        d.lbl_p:setVisible(false)
    else
    
        d.lbl_p:setVisible(true)
        d.checkbox:setEnabled(false)
        d.checkbox:setVisible(false)
    end
end

function ChengHaoManage:checkboxEnable()
    table.foreach(self.boxlist, function(k,v)
        v:setTouchEnabled(true)
        v:setBright(true) 
    end)
end

function ChengHaoManage:checkboxDisable()
    table.foreach(self.boxlist, function(k,v)
        if(v:getSelectedState() == false) then
            v:setTouchEnabled(false)
            v:setBright(false) 
        end
    end)
end

--从cfg中获取称号
function ChengHaoManage:getChengList()
    local optionCheng = {}
    self.chengNum = 0
    self.myChengNum = 0
    local n = 1
    table.foreach(ConfigData.cfg_chenghao,function(k,v)
       v["myChen"]=0
        if self:isMyCheng(v) then
           v.myChen = 1
            self.myChengNum=self.myChengNum+1
        else
            v.myChen = 0
        end
        
        if User.uCheng == toint(v.chid) then
            v.myChen = 2
        end
        
        optionCheng[n] = v
        self.chengNum = self.chengNum+1
        n = n+1
    end)
    table.sort(optionCheng,function (a, b)
        if a.myChen > b.myChen then
            return true
        elseif a.myChen < b.myChen then
            return false
        elseif a.type>b.type then
            return true
        else
            return false
        end
    end)
    return optionCheng
end

--初始化界面
function ChengHaoManage:initChengHaoView()
    self.allCheng = self:getChengList()
    self.ui.lbl_myCheng:setString(string.format("我的称号已达成：%d个 （未达成： %d个）", self.myChengNum ,9-self.myChengNum ))

    self.chenglist:removeAllItems()
    self.boxlist = {}
    table.foreach(self.allCheng,function(k,v)
        self.chenglist:pushBackDefaultItem()
        local custom_item = self.chenglist:getItem(self.chenglist:getChildrenCount()-1)
        local d = ui_delegate(custom_item)
        self:setItemInfo(d,v)
    end)
end

function ChengHaoManage:onShow()
    sendCommand("getAllChenghao", function (param)
    dump(param)
        if(param[1] == 1)then
            User.userCheng = param[2]
        end
        self:initChengHaoView()
    end)
end

function ChengHaoManage:cancel()
    DialogManager:closeDialog(self)
end

function ChengHaoManage:close()
    DialogManager:closeDialog(self)
end

function ChengHaoManage:equipCheng()
    local n = self.chenglist:getChildrenCount() -1
    local change=false
    for i=0,n do
        local custom_item = self.chenglist:getItem(i)
        local d = ui_delegate(custom_item)
        if(d.checkbox:getSelectedState() == true) then
            self.chid = self.allCheng[i+1].chid
            change=true
        end       
    end
    if( change == false) then
        self.chid = 0
    end 
    sendCommand("setChenghao", function (param)
        dump(param)
        if(param[1] == 1)then
            User.uCheng = param[2]
            MessageManager:show( "修改成功")
        else
            MessageManager:show(param[2])
        end
    end,{self.chid})
end

return ChengHaoManage