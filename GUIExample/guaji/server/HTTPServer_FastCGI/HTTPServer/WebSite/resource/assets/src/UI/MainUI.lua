--@module MainUI

-- 主页
where1 = 
{
 left = 30,
 top = 0,
 right = 30,
 bottom = 0
}
MainUI = {
  ui = nil,
  battleWinRate = nil 
}
local frameSize = cc.Director:getInstance():getWinSize()
function MainUI:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/main-main.json"))
    where1 ={left = 30,top = 0,right = 30,bottom = 0}
    where1.left =30
    where1.top = 200 +1*(frameSize.height-960)/5
    self.ui.pnl_pvp:getLayoutParameter():setMargin(where1)
    where1.top = 460+2*(frameSize.height-960)/5
    self.ui.pnl_pvp2:getLayoutParameter():setMargin(where1)
    where1.top = 200+1*(frameSize.height-960)/5
    self.ui.pnl_pvp_0:getLayoutParameter():setMargin(where1)
    where1.top = 460+2*(frameSize.height-960)/5
    self.ui.pnl_pvp_0_1:getLayoutParameter():setMargin(where1)
    where1.top = 460+2*(frameSize.height-960)/5
    self.ui.pnl_pvp_0_2:getLayoutParameter():setMargin(where1)
    where1.top = 200+1*(frameSize.height-960)/5
    self.ui.pnl_shop:getLayoutParameter():setMargin(where1)
    where1.top = 720+4*(frameSize.height-960)/5
    where1.left =39
    self.ui.Panel_15_3:getLayoutParameter():setMargin(where1)
    where1.left =135
    self.ui.Panel_15_1:getLayoutParameter():setMargin(where1)
    where1.left =231
    self.ui.Panel_7:getLayoutParameter():setMargin(where1)
    where1.left =327
    self.ui.Panel_15_0:getLayoutParameter():setMargin(where1)
    where1.left =423
    self.ui.Panel_15_2:getLayoutParameter():setMargin(where1)
    where1.left =518
    self.ui.Panel_15:getLayoutParameter():setMargin(where1)
    --+(frameSize.height-960)/5
    ui_add_click_listener( self.ui.btn_pk,
        function(sender,eventType)
            -- pvp 
            if(tonum(User.zhanli) < 1000) then 
                MessageManager:show("竞技场1000战力开放")
                return
            end
            GameUI:switchTo("pvpUI")
        end )

    ui_add_click_listener( self.ui.btn_pvm,
        -- 多人团战
        function(sender,eventType)
            if(tonum(User.zhanli) < 1500) then 
                MessageManager:show("多人团战1500战力开放")
                return
            end
            GameUI:switchTo("gvgUI")
        end )
    
    ui_add_click_listener( self.ui.btn_shop,
        function(sender,eventType)
            GameUI:switchTo("shopUI") 
            local type = "shop"
            if MainUI:checkGuideIcon(type) then
                MainUI:removeGuideIcon(type)
            end
        end)
    
    ui_add_click_listener( self.ui.btn_battle,
        function(sender,eventType)
            GameUI:switchTo("battleUI")
        end)
    
    ui_add_click_listener( self.ui.btn_gift,
        function(sender,eventType)
            --DialogManager:showDialog("Gift",nil)
            MessageManager:show("天空塔暂未开放")
        end)    

    ui_add_click_listener( self.ui.btn_getnews,
        function(sender,eventType)
            self:getNews()
        end)   
    
    -- 返回到登陆界面
--    ui_add_click_listener( self.ui.btn_logout,
--        function(sender,eventType)
--            self:exitGame()
--        end)
    
    ui_add_click_listener( self.ui.btn_pay,
        function(sender,eventType)
            DialogManager:showDialog("Charge")
        end)
    
    
    ui_add_click_listener( self.ui.btn_feedback,
        function(sender,eventType)
            DialogManager:showDialog("Gift",nil)
            --Platform:openUMengFeedback()
            --AlertManager:ok("意见反馈", RTE( "请您加我们的GM服务QQ："..Config.gmQQ .. " (在 QQ添加好友/找服务 里面可以搜到)", 25, cc.c3b(255,255,255)))
--            DialogManager:showDialog("FriendShare")
        end)
    
    ui_add_click_listener( self.ui.btn_help,
        function(sender,eventType)
            DialogManager:showDialog("HelpDialog", HelpText:helpMain())
        end)

    ui_add_click_listener( self.ui.btn_mail,
        function(sender,eventType)
            DialogManager:showDialog("Mail")
        end)    
    
    ui_add_click_listener( self.ui.btn_ronglian,
        function(sender,eventType)
            --if User.ulv < 10 then
            --    MessageManager:show("人物等级10级开放")
            --    return
            --end
            DialogManager:showDialog("EquipRonglian")
            local type = "delequipnew"
            if MainUI:checkGuideIcon(type) then
                MainUI:removeGuideIcon(type)
                User.showGuide(type)
            end
        end)
    
    self.ui.img_header:setTouchEnabled(true)
    ui_add_click_listener( self.ui.img_header,
        function(sender,eventType)
            DialogManager:showDialog("PlayerInfo")
        end)    
    
    ui_add_click_listener( self.ui.btn_userdetail,
        function(sender,eventType)
            DialogManager:showDialog("PlayerInfo")
        end)
        
    ui_add_click_listener( self.ui.btn_union, function()
    --  公会系统
        if User.ulv < 12 then
            MessageManager:show("公会功能12级开放")
            return
        end 
        if GameUI.mainUIs["clubUI"] == nil then
            GameUI:initUI("clubUI")
        end
        if GameUI.mainUIs["clubMember"] == nil then
            GameUI:initUI("clubMember")
        end
        local callback = function(params)
            if params[1] == 1 then
                -- 有公会
                ClubMember.myclub = params[2]
                ClubMember.sysclub = params[3]
                GameUI:switchTo("clubMember")
            elseif params[1] == 2 then
                -- 没公会
                ClubMember.myclub = nil
                ClubMember.sysclub = nil
                ClubUI.clubs = params[2]
                GameUI:switchTo("clubUI")
            else
                MessageManager:show(params[2])
            end
        end
        sendCommand("getMyClub", callback, {User.zhanli})
    end)
          
    --1zs 2lr 3fs
    if User.ujob == 1 then
        self.ui.icon_job:loadTexture("res/ui/images/img_08.png")
    elseif User.ujob == 2 then
        self.ui.icon_job:loadTexture("res/ui/images/img_07.png")
    elseif User.ujob == 3 then
        self.ui.icon_job:loadTexture("res/ui/images/img_09.png")
    end
    
    self.ui.bmf_vip:setTouchEnabled(true)
    ui_add_click_listener( self.ui.bmf_vip,
        function(sender,eventType)
            DialogManager:showDialog("Vip")
        end) 
        
    local r = cc.RotateBy:create(10,-360)
    self.ui.img_circle:runAction(cc.RepeatForever:create(r))
    
    return self.ui
end

function MainUI:exitGame()
    local function onOK()
        if(Platform:needGameLogin()) then
            Platform.platform.login_id=nil;
            Platform.platform.login_session=nil;
        end
        GameUI:doExitGame()
    end
    AlertManager:yesno("重新登录", RTE("将返回至登录界面",25, cc.c3b(255,255,255)), onOK)  
end

function MainUI:getNews()
    -- 读取公告
    local function onData(res)
        dump(res)
        local cjson = require("cjson")
        local news = cjson.decode(res)
        if news ~= nil and news.news ~= "" then
            local con = loadstring( "return ".. news.news )();
            DialogManager:showDialog("InfoDialog","最新公告", con)
        end
    end

    local cmd = require("src.Command").new()
    cmd.onData = onData
    cmd:doSend( string.format( "%s?func=servernews&platform=%s&ver=%s&installedVersion=%s&sid=%s",
        Config.getServerUrl(), Platform.platformType, Config.getCurVersion(), Config.gameVersion, User.server.index ))
end

function MainUI:onShow()
    self:refreshUinfoDisplay()
end

function MainUI:refreshUinfoDisplay()
  -- 设置主界面的参数
  self.ui.lbm_coin:setString(string.format("%d",User.ucoin))
  self.ui.lbm_zuanshi:setString(string.format("%d",User.ug))
  self.ui.lbl_lv:setString(string.format("等级:%d",User.ulv))
  self.ui.lbl_username:setString(User.uname)  
  --self.ui.lbl_exp:setString( string.format("经验：%d/%d", User.uexp - User.ulvExpMin, User.ulvExpMax - User.ulvExpMin ) )
  local p = math.floor(100.0 * (User.uexp - User.ulvExpMin) / (User.ulvExpMax - User.ulvExpMin))
  self.ui.expbar:setPercent(p)
  self.ui.bmf_vip:setString( string.format("V%d", User.vip))
  
  ui_(self.ui.btn_mail,"img_new"):setVisible(User.mail > 0)

end

function MainUI:setBattleRate( rate )
    rate = tonum(rate)
    local color = cc.c3b(255,255,255)
    if self.battleWinRate ~= nil then
        if self.battleWinRate < rate then
            color = cc.c3b(0,255,0)
        elseif self.battleWinRate < rate then
            color = cc.c3b(255,0,0)
        end
    end
    self.battleWinRate = rate
    self.ui.lbl_rate:setString("胜率:"..rate.."%")
    self.ui.lbl_rate:setColor(color)
    if(self.ui.lbl_map ~= nil)then
        local mname = ConfigData.cfg_map[tonum(Map.mapid)]
        if mname ~= nil then
            self.ui.lbl_map:setString("地图:"..mname.mname)
        end
    end
end

function MainUI:battleFinish(coin, exp)
    if GameUI.curUIName == "mainUI" then
        MessageManager:showMessageNode(self.ui.exp_back,"金币+"..coin)
        Scheduler.performWithDelayGlobal(function()
            MessageManager:showMessageNode(self.ui.exp_back,"经验+"..exp)
        end, 0.5) 
    end
end

function MainUI:setGuideIcon(type)
    local btnname = ""
    if type == "delequipnew" then
        btnname = "ronglian"
    elseif type == "shop" then
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
    img_guide:setPosition(cc.p(150,190))
    self.ui["btn_"..btnname]:addChild(img_guide)
    local ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.50,0.50))
    local s = img_guide:getContentSize()        
    ani:setPosition(s.width/2+3,s.height/2+5)
    img_guide:addChild(ani)
end

function MainUI:removeGuideIcon(type)
    local btnname = ""
    if type == "delequipnew" then
        btnname = "ronglian"
    elseif type == "shop" then
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

function MainUI:checkGuideIcon(type)
    local btnname = ""
    if type == "delequipnew" then
        btnname = "ronglian"
    elseif type == "shop" then
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


return MainUI 