require("src/Global")
require("src/UI/Bag")
require("src/UI/Equip")
require("src/UI/Pvp")
require("src/UI/HelpText")
require("src/User")

GameUI = {
  curUI = nil,
  curUIName = nil,
  gameLoadingUI = nil,    -- 游戏初始化中的界面
  mainBackUI = nil,       -- 游戏界面背景
  mainBtn    = nil,       -- 主菜单
  mainHeader = nil,       -- 游戏顶部
  mainUIs = {},           -- 主要游戏界面
  configure = {}          -- 游戏相关配置,比如声音等
}

-- 游戏布局

-- gameScene
--   -gameRoot
--     -main-back 游戏背景界面  zOrder 0
--       -equipUI 装备界面
--       -bagUI   背包
--       -mainUI  主页
--       -shopUI  商店
--       -skillUI 技能
--       -hireUI  雇佣兵
--     -main_btn  主界面按钮 zOrder 1
--     -main_header 主界面头部 zOrder 1
--     -systemBroadcast 系统广播 zOrder 10
--   -dialogUI  对话框界面 zOrder 10-20
--   -gameLoading 游戏读取中界面 zOrder 30 
--   -alertUI   警告框        zOrder 50
--   -messageUI 飘字           zOrder 100 

-- 初始化主页
function GameUI:initMainUI()
    self.mainBackUI = ccui.Widget:create()
    GameUI.configure['music'] = cc.UserDefault:getInstance():getStringForKey("music")
    if GameUI.configure['music'] == nil or GameUI.configure['music'] == "" then
        GameUI.configure['music'] = 1
        cc.UserDefault:getInstance():setStringForKey("music", GameUI.configure['music'])
    end
    return self.mainBackUI
end

function GameUI:doEnterGame()
    -- 切换至主界面
    self.mainBtn = require("src/UI/MainBtn")
    self.mainHeader = require("src/UI/MainHeader")
    local mainScene = cc.Scene:create()

    -- 背景
    local back = cc.Sprite:create("res/back.jpg")
    mainScene:addChild(back,-1,-1)
    back:setPosition(cc.p(320,568))

    gameRoot = ccui.Widget:create()
    mainScene:addChild(gameRoot)
    gameRoot:setPosition(globalOrigin)
    
    self.gameLoadingUI = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/game-loadingNew.json"))
    self.gameLoadingUI.setPercent=function(self,percent)
        if(percent<0)then percent=0 end
        if(percent>100)then percent=100 end
        local min=18;
        local max=523;
        local desWidth=(max-min)*percent/100+min;
        cclog("scaleWidth:"..desWidth);
        
        self.bar_process:setSize(desWidth,23);
    end
    
    gameRoot:addChild(self.gameLoadingUI.nativeUI, 30,30)

    gameRoot:addChild(self:initMainUI(),0,0) -- 确保0,1的zOrder
    gameRoot:addChild(self.mainBtn:create(),1,1)
    gameRoot:addChild(self.mainHeader:create(),1,1)

    MessageManager:purgeMessages()
    cc.Director:getInstance():pushScene(mainScene)
    
    self.gameLoadingUI.lbl_msg:setString("正在初始化UI...")
    self.gameLoadingUI:setPercent(0)
    
    -- 这里使用performWithDelayGlobal是为了更新UI，否则UI不会更新
    Scheduler.performWithDelayGlobal( function()
        -- 读取背包和装备数据
        require("src/UI/Bag")
        require("src/UI/Equip")

        GameUI:initUI("bagUI")
        GameUI:initUI("equipUI")
        GameUI:initUI("battleUI")
        GameUI:initUI("mainUI")    	
    
        self.gameLoadingUI:setPercent(10)
        
        local function onGetEquipEnd()
            self.gameLoadingUI.lbl_msg:setString("正在启动游戏...")
            self.gameLoadingUI:setPercent(50)
            
            -- 切换场景以后要打开对话框delay执行
            Scheduler.performWithDelayGlobal( function()
            
                GameUI:initUI("partnerUI") -- 要等bag初始化完毕
                GameUI:initUI("gvgUI")
                --    GameUI:initUI("clubUI")
                --    GameUI:initUI("clubMember")
                GameUI:switchTo("mainUI")
                playGameMusic("bg2");
                BattleUI:startNextBattle()
                self.gameLoadingUI:setPercent(100)
                -- 切换场景以后要打开对话框delay执行
                self:showAutoUI()             
            end, 0)            
        end
        
        self.gameLoadingUI.lbl_msg:setString("正在获取背包...")
        self.gameLoadingUI:setPercent(30)
        Scheduler.performWithDelayGlobal( function()
            BagUI:getBag()
            EquipUI:getEquip(onGetEquipEnd)
            User.loadGuide()
        end, 0)
        
    end, 0)
end

function GameUI:showAutoUI()
    Scheduler.performWithDelayGlobal( function()
        DialogManager:showDialog("Gift")        
        MainUI:getNews()
        Scheduler.performWithDelayGlobal( function()
            sendCommand("getActivity3Info",function(params)
                if params[1] == 1 then
                    DialogManager:showDialog("Activity3")
                end
            end)
        end, 1)    
        
        self.gameLoadingUI.nativeUI:removeFromParent()
        self.gameLoadingUI = nil
    end, 0.5)

   
end
function GameUI:setMainHeaderVisible(f)
	self.mainHeader:setVisible(f)
end

-- 退出游戏到主界面
function GameUI:doExitGame()
    local function onDoLogout(param)
        -- 清理mainUIs
        for _,v in pairs(self.mainUIs) do
            dump("releasing ".. v.name)
            v.ui.nativeUI:release()
        end 
        self.mainUIs = {}
        self.curUI = nil
        self.mainUI = nil
        self.mainBtn = nil
        self.mainHeader = nil
        BagUI.bagNum = 0

        BattleUI:stopAndExit()
        
        DialogManager:doCleanup()

        User.init()

        loginUI:doExitGame()
    end

    -- 发送logout请求，确保之前的请求都回来并且处理完毕
    -- 否则UI被销毁了会出错； 这个前提是网络HTTP请求是单线程并按顺序的
    sendCommand("logout",onDoLogout,{})
end

function GameUI:switchTo(t, params)
    self:initUI(t)
    
    if(self.curUI ~= nil)then
        self.curUI.ui.nativeUI:setLocalZOrder(0)
        self.curUI.ui.nativeUI:setVisible(false)
    end
   
    self.mainUIs[t].ui.nativeUI:setLocalZOrder(10)
    self.mainUIs[t].ui.nativeUI:setVisible(true)
  
    self.curUI = self.mainUIs[t]
    self.curUIName = t
  
    if(self.mainHeader ~= nil)then
        self.mainHeader:setVisible(false)
    end
    
    if(self.mainUIs[t].onShow ~= nil)then
        if params ~= nil then
            self.mainUIs[t]:onShow(params)
        else
            self.mainUIs[t]:onShow()
        end
    end
end

function GameUI:initUI(t)
  if(self.mainUIs[t] == nil) then
    local e
    -- 还没有初始化
    if(t == "mainUI")then
      e = require("src/UI/MainUI")
      self.mainUI = e
    elseif(t == "equipUI") then
      -- 装备界面
      e = require("src/UI/Equip")
    elseif(t == "bagUI") then
      -- 背包界面
      e = require("src/UI/Bag")      
    elseif(t == "battleUI") then
      -- 战斗界面
      e = require("src/UI/Battle")
    elseif(t == "pvpUI") then
      -- pk界面
      e = require("src/UI/Pvp")
    elseif(t == "battlePvpUI") then
      -- pvp战斗界面
      e = require("src/UI/BattlePvp")
    elseif(t == "mapUI") then
      -- 地图界面
      e = require("src/UI/Map")
    elseif(t == "skillUI") then
      -- 技能界面
      e = require("src/UI/Skill")
    elseif(t == "shopUI") then
      -- 商店界面
      e = require("src/UI/Shop")
--    elseif(t == "shopUIBuyCoin")then
--      -- 商店购买金币界面
--      e = require("src/UI/ShopBuyCoin")
    elseif(t == "partnerUI") then
      -- 佣兵界面
      e = require("src/UI/Partner")
    elseif(t == "gvgUI") then
      -- 多人团战界面
      e = require("src/UI/Gvg")
    elseif(t == "gvgDetail") then
      -- 多人团战详情
      e = require("src/UI/GvgDetail")
    elseif(t == "clubUI") then
      -- 公会界面
      e = require("src/UI/Club")
    elseif(t == "clubMember") then
      -- 自己工会详情
      e = require("src/UI/ClubMember")
    end
    
    e:create()
    e.name = t
    e.ui.nativeUI:retain()
    self.mainBackUI:addChild(e.ui.nativeUI)
    
    self.mainUIs[t] = e
  end
end

-- TODO: 过12点的时候 refresh 一下，目前来看发生概率较低，暂时不做
function GameUI:refreshUinfoTime()
    GameUI:loadUinfo()
end

function GameUI:getCurUIName()
    return self.curUIName
end

function GameUI:loadUinfo()
  sendCommand("getUinfo", function(param)
    if(param[1] == 1)then
      GameUI:onLoadUinfo(param[3])
    end
  end )
end

function GameUI:onLoadUinfo(u)

    User.uid = toint(u.uid)
    User.ucoin = toint(u.ucoin)
    User.uname = u.uname
    local oldlv = tonum(User.ulv)
    
    User.usex = toint(u.sex)
    User.bag = toint(u.bag)
    User.uexp = toint(u.uexp)
    User.uptime = toint(u.uptime)
    User.umid = toint(u.umid)
    User.ug = toint(u.ug)
    User.ujob = toint(u.ujob)
    User.step = toint(u.step)
    User.ts = tonum(u.ts)
    User.zhanli = tonum(u.zhanli)
    User.pvb = tonum(u.pvb)
    User.pvbbuy = tonum(u.pvbbuy)
    User.pvp = tonum(u.pvp)
    User.pvequick = tonum(u.pvequick)
    User.vip = tonum(u.vip)
    User.vippay = tonum(u.vippay)
    User.buycoin = tonum(u.buycoin)
    User.mail = tonum(u.mail)
    User.uluck = tonum(u.uluck)
    User.s1 = tonum(u.s1)
    User.forgepoint = tonum(u.forgepoint)
    User.nextstar = tonum(u.forgestar)
    User.uCheng = tonumber(u.nowchid)
    -- 自动卖出
    User.sellstar = tonum(u.sellstar)
    User.selljob = tonum(u.selljob)
    User.partnerskill = tonum(u.partnerskill)
    if(User.ulv ~= toint(u.ulv))then
        User.ulv = toint(u.ulv)
        UMeng:setPlayerLevel(User.ulv)
        User.ulvExpMin = tonum(ConfigData.cfg_userlv[User.ulv].allexp)
        User.ulvExpMax = tonum(ConfigData.cfg_userlv[User.ulv].maxexp)
        Platform:doSubmitGameInfo();
    end
    if oldlv < 5 and User.ulv >= 5 then
        User.setGuide("skill")
    end
    if oldlv < 15 and User.ulv >= 15 then
        User.setGuide("partner")
    end
    if(self.mainUI)then
        MainUI:refreshUinfoDisplay()
    end

    if(self.mainHeader ~= nil)then
        self.mainHeader:refreshUinfoDisplay()
    end
    
    if(self.mainBtn ~= nil) then
        MainBtn:checkMaxBag()
    end
    
end

function GameUI:addUserCoin(coin)
  User.ucoin = User.ucoin + tonum(coin)
  MainUI:refreshUinfoDisplay()
end

function GameUI:addUserExp(exp)
  User.uexp = User.uexp + tonum(exp)
  if(User.uexp >= User.ulvExpMax )then
    local oldulv = User.ulv
    GameUI:loadUinfo()
    if User.ulv < 70 then
        BattleUI:appendText(RTE("你已经升级到 Lv"..User.ulv + 1))
    end
  end
end

function GameUI:addUserJinghua(num)
    BagUI:addItem(3,num)
end

function GameUI:addUserUg(num)
    User.ug = User.ug + tonum(num)
    MainUI:refreshUinfoDisplay()
end


function GameUI:onActive()
  cclog("GameUI:onActive")
  
  if(User.uid ~= 0)then -- 有可能没登录，在login界面
      sendCommand("getUinfo", function(param)
        if(param[1] == 1)then
          GameUI:onLoadUinfo(param[3])
        end
      end )
      
      if(BattleUI ~= nil and BattleUI.onDeviceActive ~= nil) then
        BattleUI:onDeviceActive()
      end
  end
end

function GameUI:onDeactive()
  cclog("GameUI:onDeactive")
end

return GameUI