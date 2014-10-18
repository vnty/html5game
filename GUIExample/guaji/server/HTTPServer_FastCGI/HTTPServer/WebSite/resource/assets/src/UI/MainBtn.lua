--@module MainBtn
-- 主界面按钮

MainBtn = {
  ui = nil,
  newEquipNum = 0,
}

function MainBtn:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/main_btn.json"))
  
    -- 切换界面
    ui_add_click_listener( self.ui.btn_main,
        function(sender,eventType)
            GameUI:switchTo("mainUI") 
            local type = "main"
            if MainBtn:checkGuideIcon(type) then
                MainBtn:removeGuideIcon(type)
            end
        end )   
    
    ui_add_click_listener( self.ui.btn_equip,
        function(sender,eventType)
            self:setNewEquip(0)
            GameUI:switchTo("equipUI")
        end )
      
    ui_add_click_listener( self.ui.btn_bag,
        function(sender,eventType)
            GameUI:switchTo("bagUI")
            BagUI:doOpenNormal() 

            self.newEquipNum = 0
--            self:checkMaxBag(false)
        end )
    
    ui_add_click_listener( self.ui.btn_skill,
        function(sender,eventType)
            if(User.ulv < 5)then
                MessageManager:show("技能功能5级开放")
                return
            end
            GameUI:switchTo("skillUI")
            local type = "skill"
            if MainBtn:checkGuideIcon(type) then
                MainBtn:removeGuideIcon(type)
                User.showGuide(type)
            end
        end)
  
    ui_add_click_listener( self.ui.btn_hire,
        function(sender,eventType)
            if(User.ulv < 15)then
            MessageManager:show("佣兵功能15级开放")
            return
        end
        GameUI:switchTo("partnerUI")
            local type = "partner"
            if MainBtn:checkGuideIcon(type) then
                MainBtn:removeGuideIcon(type)
                User.showGuide(type)
            end
        end)
  
    ui_add_click_listener( self.ui.btn_battle,
        function(sender,eventType)
            GameUI:switchTo("battleUI")
            local type = "battle"
            if MainBtn:checkGuideIcon(type) then
                MainBtn:removeGuideIcon(type)
                User.showGuide(type)
            end
        end)
   
    local ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.50,0.50))
    local s = self.ui.img_max_bag:getContentSize()        
    ani:setPosition(s.width/2+3,s.height/2+5)
    self.ui.img_max_bag:addChild(ani)
  
    ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.50,0.50))
    local s = self.ui.img_new_equip:getContentSize()        
    ani:setPosition(s.width/2+3,s.height/2+5)
    self.ui.img_new_equip:addChild(ani)

    self:checkMaxBag()
    self:setNewEquip(0)
  
    return self.ui.nativeUI
end

function MainBtn:onShow()

end

function MainBtn:addNewEquipNum(num)
  self.newEquipNum = self.newEquipNum + num
--  self:checkMaxBag()
end

--function MainBtn:setNewBagNum(num)
--  --[[if(num > 0)then
--    self.ui.img_new_bag:setVisible(true)
--  else
--    self.ui.img_new_bag:setVisible(false)
--  end]]
--  
--  self.ui.img_new_bag:setVisible(false)
--end

function MainBtn:checkMaxBag()
    cclog("bagNum : " ..BagUI.bagNum)
    if(BagUI.bagNum >= User.bag) then 
        self.ui.img_max_bag:setVisible(true)
        User.setGuide("delequipnew")
    else
        self.ui.img_max_bag:setVisible(false)
    end
end

function MainBtn:setNewEquip(num)  
  if(num > 0)then
    self.ui.img_new_equip:setVisible(true)
  else
    self.ui.img_new_equip:setVisible(false)
  end
end

function MainBtn:setGuideIcon(type)
    local btnname = "main"
    if type == "partner" then
        btnname = "hire"
    elseif type == "battle" or type == "skill" then
        btnname = type
    end
    if self.ui["btn_"..btnname] == nil then
        return 
    end
    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end
    
    local img_guide = ccui.ImageView:create("res/ui/icon/icon_26.png")
    img_guide:setTag(7777)
    img_guide:setPosition(cc.p(80,80))
    self.ui["btn_"..btnname]:addChild(img_guide)
    local ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.50,0.50))
    local s = img_guide:getContentSize()        
    ani:setPosition(s.width/2+3,s.height/2+5)
    img_guide:addChild(ani)
end

function MainBtn:removeGuideIcon(type)
    local btnname = "main"
    if type == "partner" then
        btnname = "hire"
    elseif type == "battle" or type == "skill" then
        btnname = type
    end
    if self.ui["btn_"..btnname] == nil then
        return false
    end
    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end
end

function MainBtn:checkGuideIcon(type)
    local btnname = "main"
    if type == "partner" then
        btnname = "hire"
    elseif type == "battle" or type == "skill" then
        btnname = type
    end
    
    if self.ui["btn_"..btnname] == nil then
        return false
    end
    
    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        return true
    end
    return false
end

return MainBtn