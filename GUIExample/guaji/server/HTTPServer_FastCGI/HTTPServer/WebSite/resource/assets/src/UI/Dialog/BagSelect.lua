local cmd = require("src/Command")

BagSelect = {
  ui = nil,
  equipsList = {},  -- ListView后面的数据
  needRefresh = false,
  mode = 0,-- 0:普通模式  1:选择更换装备模式 2:熔炼 3:选择传承装备 4:神器吞噬
  curEquip = nil,   -- 顶部显示当前装备
  curEquipUI = nil, -- 顶部显示当前装备UI
  
  countEquip = 0,   -- 选择装备计数
  equip = nil,
    
  filterFunc = nil, -- 过滤函数
    
  selectedEquipSet = {}, -- 融合时多选，选中的装备eid列表
  
  doEquipCallback = nil,
  ujob = 0 -- 选择装备时按职业筛选
}

function BagSelect:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/bag-select.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    tbl_act = {left = 0,top = 0, right =0, bottom = 10+(frameSize.height-960)/2}
    self.ui.pnl_back:getLayoutParameter():setMargin(tbl_act)
    

    ui_add_click_listener(self.ui.nativeUI,function()
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_ok,function()
        self:close()

        if(self.mode == 2)then -- 选择熔炼装备 
            local equips = {}
            for k,v in pairs(self.selectedEquipSet) do
            if(v == true)then
                table.insert(equips, User.userEquips[k])
            end
            end
            DialogManager:showDialog( "EquipRonglian", equips )
        elseif(self.mode == 3)then
            local equips = {}
            for k,v in pairs(self.selectedEquipSet) do
            if(v == true)then
                table.insert(equips, User.userEquips[k])
            end
            end
            DialogManager:showDialog( "EquipChuancheng", self.curEquip, equips[1] )  
        elseif(self.mode == 4)then
            local equips = {}
            for k,v in pairs(self.selectedEquipSet) do
            if(v == true)then
                table.insert(equips, User.userEquips[k])
            end
            end
            DialogManager:showDialog( "EquipTunshi", self.curEquip, equips )            
        end
    end)  

    ui_add_click_listener(self.ui.btn_close,function()
        self:close()
    end)  

    local el = self.ui.equip_list
    el:setDirection(ccui.ScrollViewDir.vertical)
    el:setItemsMargin(10)
    el:setTouchEnabled(true)
    el:setBounceEnabled(true)

    self.needRefresh = true
    return self.ui
end

-- 选择更换装备
function BagSelect:doOpenSelectEquip(eid, etype, ujob, callback)
    cclog("doOpenSelectEquip" .. eid .. "  " .. etype .. " " .. ujob)
    self.ujob = ujob
    self.needRefresh = true
    self.doEquipCallback = callback
    
    -- 同部位显示，除了自己和已装备的
    self.filterFunc = function(v)
      if(eid == tonum(v.eid) or User.isEquiped(v) ) then
        return false
      end
      
      return tonum(v.etype) == etype
    end 
    
    DialogManager:showDialog("BagSelect")
    BagSelect:setMode(1)
    BagSelect:refreshUI()
end

-- 设置顶部装备
function BagSelect:setCurEquip(equip)
    
    self.curEquip = equip
    
    if(equip ~= nil) then
        self.ui.pnl_head:setVisible(true)
      
        if(self.curEquipUI ~= nil)then
            self.curEquipUI:removeFromParent()
        end
      
        -- 顶部显示当前装备
        local size = self.ui.pnl_head:getContentSize()
        self.curEquipUI = ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/bag-select-item.json")
        self.curEquipUI:setAnchorPoint(cc.p(0,0))
        self.curEquipUI:setPosition(cc.p( 7, 7 ))
        self.curEquipUI:setTouchEnabled(false)
        self.curEquipUI:setBackGroundImage("res/ui/images/img_146.png")
        self.curEquipUI:setBackGroundImageCapInsets(cc.rect(145,59,1,1))
        ui_(self.curEquipUI,"btn_sell"):removeFromParent()
        ui_(self.curEquipUI,"chk_box"):removeFromParent()
      
        local imgCur = ccui.ImageView:create()
        imgCur:loadTexture("res/ui/images/img_65.png")
        self.curEquipUI:addChild(imgCur)
        imgCur:setAnchorPoint(cc.p(0,1))
        imgCur:setName("img_cur")
        imgCur:setPosition(cc.p(0,self.curEquipUI:getContentSize().height))
      
        self.ui.pnl_head:addChild(self.curEquipUI)

        self:setItemBaseInfo(ui_delegate(self.curEquipUI), equip)
      
        -- 重新设置header大小
        local s = self.curEquipUI:getContentSize()
        local newH = s.height + 14
        self.ui.pnl_head:setContentSize(cc.size(584,newH))
        local newY = 716 + 157 - newH
        self.ui.pnl_head:setPositionY( newY )
        self.ui.pnl_body:setContentSize(cc.size(584, newY - 101 - 13))
        self.ui.equip_list:setContentSize(cc.size(570, newY - 101 - 13 - 14))
    else
        self.ui.pnl_head:setVisible(false)
        self.ui.pnl_body:setContentSize(cc.size(584,775))
        self.ui.equip_list:setContentSize(cc.size(584 - 14,775 - 14))
    end  
    
    
end

-- 选择熔炼装备
function BagSelect:doOpenRonglianEquip(autoSelectCallback)
    self.needRefresh = true
--    self.selectedEquipSet = {}

    --同部位任何装备除了自己和已装备的以及宝石镶嵌的
    self.filterFunc = function(v)
        local eid = tonum(v.eid)
        if( User.isEquiped(v) or User.isAdvEquip(v) or User.isGemEquip(v)) then
            return false
        end
      
        -- 符合条件，计算熔炼值
        v.uppoint = User.getRonglianValue(v.star)         
        return true
    end 
    
    -- 自动筛选模式
    if autoSelectCallback ~= nil then
        local list = {}
  
        -- 筛选符合条件的装备
        table.foreach(User.userEquips, function(k,v)
            -- 过滤一下
            if( self.filterFunc(v) )then
                table.insert( list, v )
                if(v.bag_item_select.chk_box:getSelectedState() == true)then
                    self.selectedEquipSet[tonum(v.eid)] = false
                    v.bag_item_select.chk_box:setSelectedState(false)
                end
            end  
            self.countEquip = 0  
        end)
  
        -- 按星级/lv逆向排序
        table.sort(list, function(a,b)
            if( tonum(a.star) ~= tonum(b.star) ) then
                return tonum(a.star) < tonum(b.star)
            end
            return tonum(ConfigData.cfg_equip[tonum(a.ceid)].lv) < tonum(ConfigData.cfg_equip[tonum(b.ceid)].lv)
        end)
        
        local equipList = {}
        for i = 1, 6 do
            if(list[i] ~= nil)then
                table.insert(equipList, list[i])
                if(list[i].bag_item_select.chk_box:getSelectedState() == false)then
                    self.selectedEquipSet[tonum(list[i].eid)] = true
                    list[i].bag_item_select.chk_box:setSelectedState(true)
                    self.countEquip = self.countEquip + 1
                end
            else
                break
            end
        end
        
        
        autoSelectCallback(equipList)
    else    
        DialogManager:showDialog("BagSelect")
        BagSelect:setMode(2)
        BagSelect:setCurEquip(nil)    
        BagSelect:refreshUI()
        --判断是否隐藏选择框
        BagSelect:chkSelectedListE(self.countEquip)
    end
    BagSelect:chkSelectedListE(self.countEquip)
end

-- 选择传承装备
function BagSelect:doOpenChuanchengEquip(equip)
    self.needRefresh = true
    self.selectedEquipSet = {}
    self.equip = equip
    -- 同部位任何装备除了自己的非神器
    self.filterFunc = function(v)
      local eid = tonum(v.eid)
      if(eid == tonum(equip.eid) or User.isAdvEquip(v)) then
        return false
      end
      
      return tonum(equip.etype) == tonum(v.etype)
    end 
    
    DialogManager:showDialog("BagSelect")
    BagSelect:setMode(3)
    BagSelect:setCurEquip(equip)
    BagSelect:refreshUI()
    BagSelect:chkSelectedList(equip)
end

-- 选择神器吞噬，只显示神器
function BagSelect:doOpenTunshi(equip, autoSelectCallback)
    self.needRefresh = true
    self.selectedEquipSet = {}
    
    -- 任何神器除了自己和已装备的
    self.filterFunc = function(v)
      local eid = tonum(v.eid)
      if(eid == tonum(equip.eid) or User.isEquiped(v) or User.isGemEquip(v)) then
        return false
      end
      
      return User.isAdvEquip(v)
    end 
    
    if autoSelectCallback ~= nil then
        local list = {}
  
        -- 筛选符合条件的装备
        table.foreach(User.userEquips, function(k,v)
            -- 过滤一下
            
            if( self.filterFunc(v))then
                table.insert( list, v )
                if(v.bag_item_select.chk_box:getSelectedState() == true)then
                    self.selectedEquipSet[tonum(v.eid)] = false
                    v.bag_item_select.chk_box:setSelectedState(false)
                end

            end 
            self.countEquip = 0     
        end)
        
        -- 按星级/lv逆向排序
        table.sort(list, function(a,b)
            if( tonum(a.star) ~= tonum(b.star) ) then
                return tonum(a.star) < tonum(b.star)
            end
            return tonum(ConfigData.cfg_equip[tonum(a.ceid)].lv) < tonum(ConfigData.cfg_equip[tonum(b.ceid)].lv)
        end)
        
        local equipList = {}
        for i = 1, 6 do
            if(list[i] ~= nil)then
                table.insert(equipList, list[i])
                if(list[i].bag_item_select.chk_box:getSelectedState() == false)then
                    self.selectedEquipSet[tonum(list[i].eid)] = true
                    list[i].bag_item_select.chk_box:setSelectedState(true)
                    self.countEquip = self.countEquip + 1
                end
            else
                break
            end
        end
        
        autoSelectCallback(equipList)
    else
        DialogManager:showDialog("BagSelect")
        BagSelect:setMode(4)
        BagSelect:setCurEquip(equip)
        BagSelect:refreshUI()
        --判断是否隐藏选择框
        BagSelect:chkSelectedListE(self.countEquip)
    end
    BagSelect:chkSelectedListE(self.countEquip)
end

function BagSelect:onShow()
    
end

function BagSelect:setMode(m)
  if(m == self.mode)then
    return
  end
  
  self.mode = m
  self.ui.equip_list:jumpToTop() -- 背包切换模式以后自动滚动到top
  self.needRefresh = true
end

function BagSelect:onSellBtnClick(v)
  if math.floor(v.lv/5)*5 > User.ulv+10 then
    MessageManager:show("无法穿比自己等级高10级的装备")
    return
  end
  -- 分解/装备按钮
  if(self.mode == 1)then
    self:close()
    self.doEquipCallback(v)
  end 
end

function BagSelect:setItemBaseInfo(d,v)

    -- 部位和icon
    UICommon.setEquipImg(d.item_img, v)
    d.img_type:loadTexture( string.format("res/ui/icon/title_%02d.png", toint(v.etype)) )
      
    -- 显示装备属性  
    local rs = UICommon.showEquipDetails(d.pnl_equip_props, v)
    local newSize = cc.size(554, rs.height + 34)
    if newSize.height > 145 then
        -- 超出边界
        d.nativeUI:setContentSize(newSize)
    
        local function relocateItem(item, newheight)
            if(item ~= nil)then
                local py = item:getPositionY()
                item:setPositionY( newheight - 145 + py)
            end 
        end
        
        relocateItem(d.pnl_equip_props, newSize.height)
        relocateItem(d.item_img, newSize.height)
        relocateItem(d.btn_sell, newSize.height)
        relocateItem(d.chk_box, newSize.height)
        relocateItem(d.img_type, newSize.height)
        relocateItem(d.img_cur, newSize.height)
    end

    if(d.btn_sell ~= nil)then
        ui_add_click_listener(d.btn_sell, function()
            self:onSellBtnClick(v)
        end)
    end
  
    -- 多选
    ui_add_click_listener(d.nativeUI, function()
        if(self.mode == 2 or self.mode == 4)then
            if(self.countEquip < 6) then
                if(d.chk_box:getSelectedState() == false)then
                    self.selectedEquipSet[tonum(v.eid)] = true
                    d.chk_box:setSelectedState(true)
                    self.countEquip = self.countEquip + 1
                else
                    self.selectedEquipSet[tonum(v.eid)] = nil
                    d.chk_box:setSelectedState(false)
                    self.countEquip = self.countEquip - 1
                end
                BagSelect:chkSelectedListE(self.countEquip)
            elseif(self.countEquip == 6) then
                if(d.chk_box:getSelectedState() ~= false) then
                    self.selectedEquipSet[tonum(v.eid)] = nil
                    d.chk_box:setSelectedState(false)
                    self.countEquip = self.countEquip - 1
                end
                BagSelect:chkSelectedListE(self.countEquip)
            end
        elseif(self.mode == 3) then
            if(self.countEquip < 1) then
                if(d.chk_box:getSelectedState() == false)then
                    self.selectedEquipSet[tonum(v.eid)] = true
                    d.chk_box:setSelectedState(true)
                    self.countEquip = self.countEquip + 1
                else
                    self.selectedEquipSet[tonum(v.eid)] = nil
                    d.chk_box:setSelectedState(false)
                    self.countEquip = self.countEquip - 1
                end
                BagSelect:chkSelectedList(self.equip)
            elseif(self.countEquip == 1) then
                if(d.chk_box:getSelectedState() ~= false) then
                    self.selectedEquipSet[tonum(v.eid)] = nil
                    d.chk_box:setSelectedState(false)
                    self.countEquip = self.countEquip - 1
                end
                BagSelect:chkSelectedList(self.equip)
            end
        end
    end)
end

-- 刷新装备选择List
function BagSelect:refreshSelectedListE()
    self.selectedEquipSet = {}	
end

function BagSelect:chkSelectedListE(count)
    if(count >= 6) then
       self.filterFunc = function(v)
        local eid = tonum(v.eid)
        if(self.mode == 2) then
           if( User.isEquiped(v) or User.isAdvEquip(v) ) then
            return false
           end
        elseif(self.mode == 4) then
           if( User.isEquiped(v) ) then
            return false
           end
        end
        return true
       end 
       table.foreach(User.userEquips, function(k,v)
        if( self.filterFunc(v) )then
            if(v.bag_item_select.chk_box:getSelectedState() == false)then
                v.bag_item_select.chk_box:setVisible(false)
            end
        end  
       end)
    else
       self.filterFunc = function(v)
        local eid = tonum(v.eid)
        if(self.mode == 2) then
           if( User.isEquiped(v) or User.isAdvEquip(v) ) then
            return false
           end
        elseif(self.mode == 4) then
           if( User.isEquiped(v) ) then
            return false
           end
        end
        return true
       end 
       table.foreach(User.userEquips, function(k,v)
        if( self.filterFunc(v) )then
            if(v.bag_item_select.chk_box:getSelectedState() == false)then
                v.bag_item_select.chk_box:setVisible(true)
            end
        end  
       end)
    end
end

--传承选择List
function BagSelect:chkSelectedList(equip)
    if(self.mode == 3) then
        if(self.countEquip >= 1)then
            self.filterFunc = function(v)
                local eid = tonum(v.eid)
                if(eid == tonum(equip.eid) or User.isAdvEquip(v)) then
                    return false
                end
                return tonum(equip.etype) == tonum(v.etype)
            end
            table.foreach(User.userEquips, function(k,v)
                if(self.filterFunc(v))then
                    if(v.bag_item_select.chk_box:getSelectedState() == false)then
                        v.bag_item_select.chk_box:setVisible(false)
                    end
                end
            end) 
        else
            self.filterFunc = function(v)
                local eid = tonum(v.eid)
                if(eid == tonum(equip.eid) or User.isAdvEquip(v)) then
                    return false
                end
                return tonum(equip.etype) == tonum(v.etype)
            end
            table.foreach(User.userEquips, function(k,v)
                if(self.filterFunc(v))then
                    if(v.bag_item_select.chk_box:getSelectedState() == false)then
                        v.bag_item_select.chk_box:setVisible(true)
                    end
                end
            end) 
        end
    end

end

-- 设置显示不一样的地方
function BagSelect:setItemExtInfo(d,v)
    local size = d.nativeUI:getContentSize()
  d.chk_box:setTouchEnabled(false)

  -- remove
  local tip1 = d.nativeUI:getChildByTag(10001)
  local tip2 = d.nativeUI:getChildByTag(10002)
  if(tip1 ~= nil)then
    tip1:removeFromParent()
  end
  if(tip2 ~= nil)then
    tip2:removeFromParent()
  end
  
  -- 装备选择模式，判断是否是符合职业需求
  if(self.mode == 1)then
    dump(string.format("%d %d", v.ejob, self.ujob ))
    if( not User.isJobFit(v,self.ujob) )then
            local tip = UICommon.createLabel("职业不符", 30)
        tip:setColor(cc.c3b(255,30,0))    
        tip:setTag(10001)
        tip:setPosition(cc.p(size.width/2,size.height/2))
        tip:enableOutline(cc.c4b(0,0,0,255),2)      
        d.nativeUI:addChild(tip)      
        tip:runAction(cc.RepeatForever:create(cc.Sequence:create( cc.FadeIn:create(1), cc.FadeOut:create(1))))
    end
  end
    
  -- 熔炼可提升部分提示
  if(self.mode == 2)then
    if(v.uppoint > 0)then
      tip2 = UICommon.createLabel("可提供 " .. v.uppoint .. " 熔炼值", 30)
      tip2:setColor(cc.c3b(30,255,0))
      tip2:setTag(10002)      
      tip2:setPosition(cc.p(size.width/2,size.height/2))
      tip2:enableOutline(cc.c4b(0,0,0,255),2)      
      d.nativeUI:addChild(tip2)      
      tip2:runAction(cc.RepeatForever:create(cc.Sequence:create( cc.FadeIn:create(1), cc.FadeOut:create(1))))
      tip2:setPosition(cc.p(size.width/2,size.height/2))
    end
  end
  
  if(self.mode == 2 or self.mode == 3 or self.mode == 4)then
    if(self.selectedEquipSet[tonum(v.eid)] == true) then
      d.chk_box:setVisible(true)
      d.chk_box:setSelectedState(true)
      d.btn_sell:setVisible(false)
      d.btn_sell:setTouchEnabled(false) 
      self.countEquip = self.countEquip + 1   
    else
      d.chk_box:setVisible(true)
      d.chk_box:setSelectedState(false)
      d.btn_sell:setVisible(false)
      d.btn_sell:setTouchEnabled(false)
    end 
  else
    d.btn_sell:setVisible(true)
    d.btn_sell:setTouchEnabled(true)    
    d.chk_box:setVisible(false)
  end
end


function BagSelect:refreshUI()
  if(self.needRefresh == false)then
    return
  end
  self.needRefresh = false
  local hasEquip = false
  self.countEquip = 0
  
  -- 只有融合是多选的
  if(self.mode == 2 or self.mode == 3 or self.mode == 4)then
    self.ui.btn_ok:setVisible(true)
    self.ui.btn_ok:setTouchEnabled (true)
    self.ui.btn_close:setVisible(false)
    self.ui.btn_close:setTouchEnabled (false)
  else
    self.ui.btn_ok:setVisible(false)
    self.ui.btn_ok:setTouchEnabled (false)
    self.ui.btn_close:setVisible(true)
    self.ui.btn_close:setTouchEnabled (true)
  end
  
  local itemlist = self.ui.equip_list
  
  -- 清空背包所有的内容
  itemlist:removeAllItemsWithCleanup(false)
  itemlist:jumpToTop()
  self.equipsList = {}
  
  -- 筛选符合条件的装备
  table.foreach(User.userEquips, function(k,v)
    -- 过滤一下
    if( self.filterFunc(v) )then
      table.insert( self.equipsList, v )
      hasEquip = true
    end    
  end)
    
  self.ui.lbl_message:setVisible(not hasEquip)
  self.ui.equip_list:setTouchEnabled(hasEquip)
  
  -- 按装备是否职业、主线装备、评分、等级排序从好到差排序
  local function sortByGoodToBad(a,b)
    local isJobOKA = User.isJobFit(a,self.ujob)
    local isJobOKB = User.isJobFit(b,self.ujob)
    if(isJobOKA ~= isJobOKB)then
        return isJobOKA
    end

    if( tonum(a.score) ~= tonum(b.score) ) then
        return tonum(a.score) > tonum(b.score)
    end
    
    local isMainA = User.isAdvEquip(a)
    local isMainB = User.isAdvEquip(b)
    if(isMainA ~= isMainB)then
        return isMainA
    end

    local lva = tonum(ConfigData.cfg_equip[tonum(a.ceid)].lv)
    local lvb = tonum(ConfigData.cfg_equip[tonum(b.ceid)].lv)
    if  lva ~= lvb  then
        return lva > lvb
    end
    
    -- sort function 必须有确定确定的比较结果，否则会出现invalid order function错误
    return a.eid > b.eid
  end
  
    local function sortByBadToGood(a,b)
        if( tonum(a.star) ~= tonum(b.star) ) then
            return tonum(a.star) < tonum(b.star)
        end
        return tonum(a.lv) < tonum(b.lv)
    end
  
  -- 更换装备和传承从好到差选
  if(self.mode == 1 or self.mode == 3)then
    table.sort(self.equipsList, sortByGoodToBad)
  else
  -- 熔炼和吞噬从差到好选
    table.sort(self.equipsList, sortByBadToGood)
  end
  
  -- 创建item renderer
  for k,v in pairs(self.equipsList) do
      local d = v.bag_item_select
      self:setItemExtInfo(d,v)
      itemlist:pushBackCustomItem(d.nativeUI)
   end
end

function BagSelect:close()
  DialogManager:closeDialog(BagSelect)
end

return BagSelect