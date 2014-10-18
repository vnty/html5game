
local ItemSelect = {
  ui = nil,
  onSelectCallback = nil,
  filterFunc = nil
}

function ItemSelect:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/item-select.json"))

    ui_add_click_listener(self.ui.btn_close,function()
        self:close()
    end)
    
    ItemSelect.item_select_module = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/item-select-item.json")
    ItemSelect.item_select_module:retain()
end

function ItemSelect:doOpenSelectGem()
    DialogManager:showDialog("ItemSelect")
end

function ItemSelect:onShow(filter, callback)
    if(filter ~= nil) then
        self.filterFunc = filter
    else
        self.filterFunc = nil
    end
    self.onSelectCallback = callback
	self:refreshUI()
end

function ItemSelect:refreshUI()
    -- 清空背包所有的内容
    self.ui.item_list:removeAllItemsWithCleanup(false) -- 保留actions  
    self.itemList = {}
    
    table.foreach(User.userItems, function(k,v)
        local count = BagUI:getItemCount(k)
        if count > 0 then
            --创建一个item 
            local item = {}
            item.bag_item = ui_delegate(self.item_select_module:clone())
            UICommon.setItemImg(item.bag_item.item_img, k, count)
            ui_add_click_listener(item.bag_item.btn_select, function()
                self:close()
            	self.onSelectCallback(k)
            end)
            
            if(self.filterFunc == nil) then
                cclog("filterFunc is nil")      
                table.insert( self.itemList, item )
            elseif( self.filterFunc(k) ) then
                table.insert( self.itemList, item )
            end
        end
    end)  

    local num = table.getn(self.itemList)
    local height = math.max(560, math.ceil(num / 5) * 112 )
    self.ui.item_list:setInnerContainerSize(cc.size(500, height))

    -- 创建item renderer
    local x = 5
    local y = height - 175
    for k,v in pairs(self.itemList) do
        self.ui.item_list:addChild(v.bag_item.nativeUI)
        v.bag_item.nativeUI:setPosition(cc.p(x,y))
        x = x + 107
        if(x >= 500)then
            x = 5
            y = y - 180
        end
    end
    
    if(num > 0) then
        self.ui.lbl_message:setVisible(false)
    else
        self.ui.lbl_message:setVisible(true)
    end
    
    self.ui.item_list:jumpToTop() -- 背包切换模式以后自动滚动到top
end

function ItemSelect:close()
    DialogManager:closeDialog(self)
end

return ItemSelect