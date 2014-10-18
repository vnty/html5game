-- @module PartnerUI

local cmd = require("src/Command")
tbl_where = {left = 0, top = 0, right = 10, bottom = 0}
PartnerUI = {
  ui = nil,
  partnerlist ={},
  curPartner = nil,  -- 当前选中的雇佣兵
  etypelist = {1,2,5,7},
  
  equipDetail = nil,
  lvlimit={15,20,25},
  lastULv = 0 -- 用于判断是否需要刷新
}

function PartnerUI:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/partner.json"))
    local frameSize = cc.Director:getInstance():getWinSize()
    self.ui.pros_back0:setContentSize(640,280+(frameSize.height-960)/5)
    self.ui.equip_skill_back:setContentSize(640,295+4*(frameSize.height-960)/5)
    tbl_where.top = (frameSize.height-960)/12+307
    self.ui.btn_more_detail:getLayoutParameter():setMargin(tbl_where)
    self.ui.pros_back:setPosition(cc.p(300,98+(frameSize.height-960)/6))
    self.ui.job_back:setPosition(cc.p(138,245+(frameSize.height-960)/6))
    self.ui.power_back:setPosition(cc.p(502,245+(frameSize.height-960)/6))
    self.ui.Label_4940:setPosition(cc.p(300,193+(frameSize.height-960)/6))
    self.ui.hp_back:setPosition(cc.p(120,193+(frameSize.height-960)/6))
    self.ui.mp_back:setPosition(cc.p(480,193+(frameSize.height-960)/6))
    
    self.ui.equip_back:setPosition(cc.p(frameSize.width/2,210+4*(frameSize.height-960)/6))
    self.ui.skill_back:setPosition(cc.p(frameSize.width/2,65+2*(frameSize.height-960)/6))
  
    --更换装备
    for _,v in pairs(self.etypelist) do 
        local item_img = self.ui["equip_"..v]
        item_img:setTouchEnabled(true)
    
        ui_add_click_listener(item_img, function()
            self:itemImageClicked(v)
        end)
    end
    
--佣兵修改
   -- for _,v in pairs(self.etypelist) do 
   --     local img_bac = self.ui["skill_img_bac_"..v]
   --     img_bac:setTouchEnabled(true)
--
    --   ui_add_click_listener(img_bac, function()
   --         if(self.curPartner ~= nil) then
   --             DialogManager:showDialog("PartnerSkill")
   --         else
    --            MessageManager:show("正在加载，请稍候...")
    --        end
   --     end)
   -- end
    
    
--  
    
  
    ui_add_click_listener(self.ui.btn_enforce, function()
        if(self.curPartner ~= nil) then
            DialogManager:showDialog("PartnerEntryEnforce")
        else
            MessageManager:show("正在加载，请稍候...")
        end
        local type = "uppartner"
        if PartnerUI:checkGuideIcon(type) then
            PartnerUI:removeGuideIcon(type)
        end
    end)
  
    ui_add_click_listener(self.ui.btn_partner_skill, function()
        if User.ulv < 25 then
            MessageManager:show("佣兵技能25级开启")
            return 
        end
        if(self.curPartner ~= nil) then
            DialogManager:showDialog("PartnerSkill")
        else
            MessageManager:show("正在加载，请稍候...")
        end
    end)
  
    ui_add_click_listener(self.ui.btn_rest, function()
        --休息或出战
        self:setPartner()
    end)
    
    ui_add_click_listener(self.ui.btn_more_detail, function()
        --休息或出战
        DialogManager:showDialog("PartnerDetail")
    end)
    
    -- 佣兵上方头像
    for i = 1,5 do
        --      self.ui["head_back_"..i]:setVisible(false)
        if(i>3) then
            self.ui["head_back_"..i]:setVisible(false)
        else
            self.ui["btn_head_"..i]:setVisible(false)
            self.ui["head_lbl_"..i]:setString(self.lvlimit[i].."级开放")
        end
    end
    
    self.lastULv = 0
  
    self:onShow()
    return self.ui
end

function PartnerUI:onShow()
    if self.lastULv ~= User.ulv then
        -- 玩家等级变化了才需要刷新
        self.lastULv = User.ulv
        self:getPartnerList()
    end
end

function PartnerUI:getPartnerList()
    local function onGetPartner(param)
        if(param[1]==1) then

            dump(param[2])
            --TODO 看看可不可以放在create里
            local n = 1
            table.foreach(param[2],function(k,v)
                table.insert(self.partnerlist,v)
                self.ui["head_back_"..n]:setVisible(true)
                self.ui["head_lbl_"..n]:setVisible(false)
                self.ui["btn_head_"..n]:setVisible(true)
                local icon = self.ui["btn_head_"..n]
                ui_add_click_listener(icon, function()
                    self:onHeadBtnClick(v)
                end)

                UICommon.loadExternalTextureNormal( icon, User.getPartnerHead(v) )

                --基础
                v.baseProps = {}
                User.equipPropsToTable(v.baseProps, v.partnerbase)        

                --升级
                v.upProps = {}
                User.equipPropsToTable(v.upProps, v.upep)

                --oldep
                v.oldProps = {}
                User.equipPropsToTable(v.oldProps, v.oldep)

                --oldzhuanjing
                if v.oldzhuanjing == nil or v.oldzhuanjing == "" then
                    v.oldzhuanjingProps = {0,0,0,0,0}
                else
                    v.oldzhuanjingProps = string.split(v.oldzhuanjing, ",")
                end
                    
                --newzhuanjing
                if v.newzhuanjing == nil or v.newzhuanjing == "" then
                    v.newzhuanjingProps = {0,0,0,0,0}
                else
                    v.newzhuanjingProps = string.split(v.newzhuanjing, ",")
                end
                -- 装备
                v.equipProps = {}
                User.equipPropsToTable(v.equipProps, v.partnerep)
                User.updateSecondProps(v.equipProps, v.mainp, 0)

                --没有选择则默认选中第一个，如果有出战的，选择出战的
                local head_back=self.ui["head_back_"..n]
                if(self.curPartner == nil) then
                    self.curPartner = v
                end 
                if User.partnerid ~= 0 and tonum(v.partnerid) == User.partnerid then
                    self.curPartner = v
                end

                if(User.userPartnerEquip[tonum(v.partnerid)] == nil)then
                    User.userPartnerEquip[tonum(v.partnerid)] = {}
                end
                n = n + 1
            end)

            self:refreshView()
        end
    end
    self.partnerlist = {}
    self.curPartner = nil
    sendCommand("getPartner",onGetPartner)
end

function PartnerUI:refreshView()
--  self.ui.pic_head:setTitleText(self.curPartner.name)
  if(self.curPartner == nil)then
    return
  end
  
  local n=1
  table.foreach(self.partnerlist,function(k,v)
    local head_back=self.ui["head_back_"..n]
    if toint(v.partnerid)==toint(self.curPartner.partnerid) then
        head_back:loadTexture("res/ui/images/img_120.png")
    else
        head_back:loadTexture("res/ui/images/img_121.png")
    end
    n=n+1
  end)
  
  local baseprops = {}
  -- 计算基础属性: 基础属性 + 成长属性 + 培养属性
  for _,v in pairs({1,2,3,4}) do
    baseprops[v] = tonum(self.curPartner.baseProps[v]) + tonum(self.curPartner.upProps[v])*toint(User.ulv) + toint(self.curPartner.oldProps[v])
  end
  baseprops[10] = 5
  baseprops[11] = 10
    -- 计算一下二级属性
  User.updateSecondProps(baseprops, self.curPartner.mainp, User.ulv)
  
  -- 显示小伙伴属性
  local function getUserPropStr(pi)
    local str = tonum(baseprops[pi]) + toint(PartnerUI.curPartner.equipProps[pi])
    local zhuanjingarr = {
        [6] = 1,
        [12] = 1.5,
        [26] = 10,
        [27] = 20,
        [31] = 1,
    }
    local basearr={
        [26] = 39,
        [31] = 33,
        [7] = 35,
        [8] = 36,
        [12] = 38,
        [6] = 34,
        [9] = 37,
        [5] = 48,
        [10] = 14,
        [11] = 14
    }
    if zhuanjingarr[pi] ~= nil then
        -- TODO 考虑其他方式,容易死循环...
        if pi == 6 then
            --魔抗
            str = tonum(str) + tonum(getUserPropStr(3)) * zhuanjingarr[pi] * tonum(PartnerUI.curPartner.oldzhuanjingProps[3])
        elseif pi == 12 then
            --暴击
            str = tonum(str) + tonum(getUserPropStr(2)) * zhuanjingarr[pi] * tonum(PartnerUI.curPartner.oldzhuanjingProps[2])
        elseif pi == 26 then
            --生命
            str = tonum(str) + tonum(getUserPropStr(4)) * zhuanjingarr[pi] * tonum(PartnerUI.curPartner.oldzhuanjingProps[4])
        elseif pi == 27 then
            --魔法
            str = tonum(str) + tonum(User.ulv * zhuanjingarr[pi]) * tonum(PartnerUI.curPartner.oldzhuanjingProps[5])
        elseif pi == 31 then
            --物抗
            str = tonum(str) + tonum(getUserPropStr(1)) * zhuanjingarr[pi] * tonum(PartnerUI.curPartner.oldzhuanjingProps[1])
        end
    end
    if basearr[pi] ~= nil then
        str = toint(tonum(str) * (1 + tonum(tonum(baseprops[tonum(basearr[pi])]) + tonum(PartnerUI.curPartner.equipProps[tonum(basearr[pi])]))/ 10000))
    end
    return str
  end

  local d = self.ui
  local eps = { 1,2,3,4,5,6,7,8,9,12,26,27 }
  for _,v in pairs(eps) do
    d["lbl_"..v]:setString(getUserPropStr(v))
  end
  
  d.lbl_dmg:setString(getUserPropStr(10).."~"..getUserPropStr(11))
--  local zhanli = math.floor(((getUserPropStr(10)+getUserPropStr(11))*(70+User.ulv)/70)+getUserPropStr(26)/10+getUserPropStr(27)/10+getUserPropStr(5)+getUserPropStr(31)+getUserPropStr(6)+getUserPropStr(7)+getUserPropStr(8)*5+getUserPropStr(12)+getUserPropStr(37))
  
  local zhanli = toint((getUserPropStr(10)+getUserPropStr(11))*(1+getUserPropStr(17)/10000)*(70+User.ulv)/70
                    +getUserPropStr(26)/10+getUserPropStr(27)*User.ulv/60+getUserPropStr(5)*(1+4*getUserPropStr(21)/10000)
                    +getUserPropStr(31)*(1+40*getUserPropStr(25)/10000)+getUserPropStr(6)*(1+getUserPropStr(47)/100)
                    +getUserPropStr(7)*(1+getUserPropStr(49)/100)+getUserPropStr(8)*5*(1+getUserPropStr(46)/100)
                    +getUserPropStr(12)*(1+(getUserPropStr(13))/10000)+getUserPropStr(9)*(1+4*getUserPropStr(24)/10000));
        
  PartnerUI.curPartner.zhanli=zhanli
  d.lbl_power:setString("战力:"..zhanli)
  
  -----------------
  --skill
  
    local skills = string.split(self.curPartner.skill, ",")
    --修改从服务端(4个技能)
    for i_dex = 1 ,4 do
        local data = ConfigData.cfg_skill[toint(skills[i_dex])]
        if data ~= nil then
            self.ui[string.format("skill_img_bac_%s",i_dex)]:setVisible(true)
            self.ui[string.format("skill_img_%s",i_dex)]:loadTexture( string.format("res/skill/%d.png", data.sid))
        else
            self.ui[string.format("skill_img_bac_%s",i_dex)]:setVisible(false)
        end
    end 
  --self.ui.skill_img:loadTexture( string.format("res/skill/%d.png", data.sid))
  --self.ui.lbl_skill:setString(data.sname)
  --self.ui.lbl_skill_info:setString(data.tips)
  --self.ui.lbl_mp:setString("消耗MP:"..data.mp)
  --
  -- 名字
  self.ui.lbl_name:setString( string.format("Lv. %d %s [%s]",User.ulv,self.curPartner.name,User.getJobName(self.curPartner.mainp) ))
  
  -----------------
  --状态 是否 出战
  if(toint(self.curPartner.partnerid) == toint(User.partnerid)) then
    self.ui.btn_rest:setTitleText("已出战")
    self.ui.btn_rest:setTitleColor(cc.c3b(168,70,51))
    self.ui.btn_rest:loadTextureNormal( "res/ui/button/btn_103.png" )
  else
    self.ui.btn_rest:setTitleText("休息中")
    self.ui.btn_rest:setTitleColor(cc.c3b(255,255,255))
    self.ui.btn_rest:loadTextureNormal( "res/ui/button/btn_102.png" )
  end
  
  -- 装备
  local equips = User.userPartnerEquip[tonum(self.curPartner.partnerid)]
  for _,v in pairs(self.etypelist) do
    local eid = tonum(equips[v]) 
    local item_img = self.ui["equip_"..v]
    if(eid ~= 0)then
      local equip = User.userEquips[eid]
      UICommon.setEquipImg(item_img,equip)
    else
      -- 没有装备
      UICommon.setEquipImg(item_img,nil)
    end 
  end
end

function PartnerUI:onHeadBtnClick(v)
  self.curPartner = v
  self:refreshView()
end

function PartnerUI:setPartner()
  local state = 0
  if(self.curPartner == nil) then
    return
  end
  if(self.curPartner ~= nil) then
    if(toint(User.partnerid) ~= toint(self.curPartner.partnerid)) then
      state = 1
    end
  end
  
  local function onSetPartner(param)
    if(state ==1) then
      User.partnerid = self.curPartner.partnerid
    else
      User.partnerid = 0
    end
    self:refreshView()
  end
  
  sendCommand("setPartner",onSetPartner,{self.curPartner.partnerid,state})
end

function PartnerUI:itemImageClicked(i)  
    if self.curPartner == nil then
        -- 有可能网络卡的时候没加载完
        return
    end

    local eid = tonum(User.userPartnerEquip[tonum(self.curPartner.partnerid)][i])
    if(tonum(eid) ~= 0) then
        local equipDetail = DialogManager:showDialog( "EquipDetail", User.userEquips[eid] )
        equipDetail.doSetEquipCallback = function(equip)
            if(User.isEquiped(equip))then
                -- 更换
                BagSelect:doOpenSelectEquip(tonum(equip.eid), tonum(equip.etype), self.curPartner.mainp, self.doEquip)
                BagSelect:setCurEquip(equip)
            end
        end
    
        --self.equipDetail.ui.nativeUI:setPosition(cc.p(0,673))
    else
        BagSelect:doOpenSelectEquip(0, i, self.curPartner.mainp, self.doEquip)
        BagSelect:setCurEquip(nil)
    end
end

function PartnerUI.doEquip(e,showChanges)
  if(PartnerUI.curPartner == nil) then 
    return 
  end
  -- 传承也会调用这个方法,但是可以传承非当前佣兵
  local partnerid = tonum(e.euser)
  if partnerid == 0 then
    partnerid = tonum(PartnerUI.curPartner.partnerid)
  end
  -- 保存更换前的属性数据  
  local oldUserEquipProps = clone(PartnerUI.curPartner.equipProps)
  
  local function onSetEquip(param)
    if(param[1] == 1)then
      --MessageManager:show("装备成功 ")
 
      -- 更新装备
      local newEid = tonum(e.eid)
      local oldEid = tonum(User.userPartnerEquip[partnerid][tonum(e.etype)]) 
      User.userPartnerEquip[partnerid][tonum(e.etype)] = tonum(e.eid)
      
      -- 更新装备的标记
      if(oldEid ~= 0)then
        User.userEquips[oldEid].euser = 0
        BagUI.bagNum = BagUI.bagNum + 1
      end
      
      if(newEid ~= 0)then
        User.userEquips[tonum(e.eid)].euser = partnerid
        BagUI.bagNum = BagUI.bagNum - 1
      end
      
      -- 更新佣兵装备属性
      -- TODO 不是当前佣兵更换装备时不改变, 传承
      PartnerUI.curPartner.equipProps = {}
      dump(param[2])
      User.equipPropsToTable(PartnerUI.curPartner.equipProps, param[2])
      
      -- 计算二级装备属性
      User.updateSecondProps(PartnerUI.curPartner.equipProps,PartnerUI.curPartner.mainp, 0)      
      
      -- 显示属性变化值
      if(showChanges ~= false)then
        MessageManager:showEquipChange(oldUserEquipProps,PartnerUI.curPartner.equipProps)
      end
      MainBtn:checkMaxBag()
      
      -- 跳转到装备界面
      PartnerUI:refreshView()
      BagUI:setNeedRefresh()
   else
      -- 失败
      MessageManager:show(param[2])
    end
  end
  
  if e.eid ~= 0 and math.floor(e.lv/5)*5 > User.ulv +10 then
    MessageManager:show("无法穿比佣兵等级高10级的装备")
    return
  else
    sendCommand("setPartnerEquip", onSetEquip, {partnerid, e.eid, e.etype })  
  end
end

function PartnerUI:setGuideIcon(type)
    dump(type)
    local btnname = ""
    if type == "uppartner" then
        btnname = "enforce"
    end
    if self.ui["btn_"..btnname] == nil then
        return 
    end
    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end
    dump(btnname)
    local img_guide = ccui.ImageView:create("res/ui/icon/icon_26.png")
    img_guide:setTag(7777)
    img_guide:setPosition(cc.p(125,45))
    self.ui["btn_"..btnname]:addChild(img_guide)
    local ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.50,0.50))
    local s = img_guide:getContentSize()        
    ani:setPosition(s.width/2+3,s.height/2+5)
    img_guide:addChild(ani)
end

function PartnerUI:removeGuideIcon(type)
    local btnname = ""
    if type == "uppartner" then
        btnname = "enforce"
    end
    if self.ui["btn_"..btnname] == nil then
        return false
    end
    local img = self.ui["btn_"..btnname]:getChildByTag(7777)
    if img ~= nil then
        img:removeFromParent(true)
    end
end

function PartnerUI:checkGuideIcon(type)
    local btnname = ""
    if type == "uppartner" then
        btnname = "enforce"
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

return PartnerUI