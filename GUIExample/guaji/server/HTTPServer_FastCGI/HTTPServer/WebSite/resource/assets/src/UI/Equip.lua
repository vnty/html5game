-- @module EquipUI
EquipUI = { 
  ui = nil,
  img_new_set = {}
}

require("src/Command")
require("src/UI/DialogManager")

function EquipUI:create()
    local frameSize = cc.Director:getInstance():getWinSize()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/equip.json"))
    local where1 = {left = -1,top = 0,right = 22,bottom = 0}
    self.ui.ImageView_4886:setContentSize(640,280+(frameSize.height-960)/2)
    self.ui.ImageView_4886:getLayoutParameter():setMargin(where1)
    self.ui.ImageView_4892:setPosition(cc.p(frameSize.width/2,230+(frameSize.height-960)/2))
    self.ui.lbl_back:setPosition(cc.p(frameSize.width/2-23,90+(frameSize.height-960)/5))
    self.ui.btn_more_detail:setPosition(cc.p(608,83+(frameSize.height-960)/5))
    self.ui.hp_back:setPosition(cc.p(121,180+(frameSize.height-960)/5))
    self.ui.mp_back:setPosition(cc.p(469,180+(frameSize.height-960)/5))
    where1.bottom = 140+(frameSize.height-960)/9
    self.ui.equips:getLayoutParameter():setMargin(where1)
    where1.top =290+(frameSize.height-960)/3
    self.ui.name_back:getLayoutParameter():setMargin(where1)
    where1.left =0
    where1.top =300+(frameSize.height-960)/3
    self.ui.img_chenghao:getLayoutParameter():setMargin(where1)
    where1.top =298+(frameSize.height-960)/3
    self.ui.lbl_power:getLayoutParameter():setMargin(where1)
    where1.top =290+(frameSize.height-960)/3
    where1.right = 0
    self.ui.Image_16:getLayoutParameter():setMargin(where1)
    
    --self.ui.equips:setPosition(cc.p(frameSize.width/2,135+(frameSize.height-960)/30))
   -- self.ui.name_back:setPosition(cc.p(2,290+(frameSize.height-960)))
   -- self.ui.img_chenghao:setPosition(cc.p(220,290+(frameSize.height-960)/30))
   -- self.ui.lbl_power:setPosition(cc.p(22,290+(frameSize.height-960)/30))
    -- 设置装备按钮点击事件
    for i,v in pairs(ConfigData.cfg_equip_etype) do
        local item_img = self.ui["equip_"..i] 
        if(item_img ~= nil)then
            item_img:setTouchEnabled(true)
            ui_add_click_listener( item_img,
            function(sender,eventType)
                cclog("equip choose " .. i)
                local eid = User.userEquip[i]
                
                if(tonum(eid) ~= 0) then
                    local dialog = DialogManager:showDialog( "EquipDetail", User.userEquips[eid] )
                    dialog.doSetEquipCallback = function(equip)
                        if(User.isEquiped(equip))then
                            -- 更换
                            BagSelect:doOpenSelectEquip(tonum(equip.eid), tonum(equip.etype), User.ujob, self.doEquip)
                            BagSelect:setCurEquip(equip)
                        end
                    end
                    --self.equipDetail.ui.nativeUI:setPosition(cc.p(0,735))
                else
                    BagSelect:doOpenSelectEquip(0, i, User.ujob, self.doEquip)
                    BagSelect:setCurEquip(nil)
                end
          
                self.img_new_set[i]:setVisible(false)
            end )
        
            -- 有新可用装备的提示
            local img_new = ccui.ImageView:create()
            img_new:loadTexture("res/ui/icon/icon_26.png")
            local s = item_img:getContentSize()
            --img_new:setAnchorPoint(cc.p(1,1))
            img_new:setPosition(s.width/2,s.height/2)
            item_img:addChild(img_new)
            local ani = UICommon.createAnimation("res/effects/new.plist", "res/effects/new.png", "new_%02d.png", 10, 20, cc.p(0.45,0.50))
            img_new:addChild(ani)
            s = img_new:getContentSize()        
            ani:setPosition(s.width/2+3,s.height/2+5)
            img_new:setVisible(false)
            img_new:setTouchEnabled(false)
            self.img_new_set[i] = img_new
        end
    end   
  
    ui_add_click_listener(self.ui.btn_more_detail,function(sender,eventType)
        DialogManager:showDialog( "PlayerDetail" )
    end)
  
    --1zs 2lr 3fs
    if User.ujob == 1 then
        self.ui.icon_job:loadTexture("res/ui/images/img_08.png")
        self.ui.text_job:loadTexture("res/ui/icon/text_05.png")
    elseif User.ujob == 2 then
        self.ui.icon_job:loadTexture("res/ui/images/img_07.png")
        self.ui.text_job:loadTexture("res/ui/icon/text_04.png")    
    elseif User.ujob == 3 then
        self.ui.icon_job:loadTexture("res/ui/images/img_09.png")
        self.ui.text_job:loadTexture("res/ui/icon/text_06.png")
    end
    self.ui["lbl_"..User.ujob]:setColor(cc.c3b(0,255,0))
    self.ui.img_job:loadTexture( User.getUserImg(User.ujob,User.usex) )

    return self.ui
end

function EquipUI:onShow()
    self:refreshUI()
end

-- 取装备列表
function EquipUI:getEquip(onEndCallback)
  -- 读取装备
  local function onGetEquip(param)
      --ep = "0|0,1|3907,2|4141,3|3732,4|3781,5|2032,10|1001,11|1995",
      --es = 作废
      --skill = "0|201|202",
      --uid = "100035",
      -- partner
    User.onEquipProps(param[2].ep)
    
    -- 设置已装备技能
    local skill = string.split(param[2].skill,",");
    local n = 1
    table.foreach(skill,function(k,v)
      cclog("onGetSkill ".. k .. " " .. v)
      if(tonum(v) > 0) then
        User.userSkill[toint(n)] = toint(v);
        n = n+1;
      end
    end)
    local pvpskill = string.split(param[2].pvpskill,",")
    n = 1
    table.foreach(pvpskill,function(k,v)
        if(tonum(v) > 0) then
            User.userPvpSkill[toint(n)] = toint(v);
            n = n + 1
        end
    end)
    
    -- 小伙伴
    User.partnerid = toint(param[2].partnerid)
    
    self:refreshUI()
    
    if onEndCallback then
        onEndCallback()
    end
  end        
  sendCommand("getEquip", onGetEquip)
end

-- 提示有更强的装备
function EquipUI:showNewEquipTips(etype)
  self.img_new_set[tonum(etype)]:setVisible(true)
  if(GameUI:getCurUIName() ~= "equipUI")then
    MainBtn:setNewEquip(1)
  end
end

function EquipUI:refreshUI()
  local equipList = self.ui.equip_list
  
  for i,v in pairs(ConfigData.cfg_equip_etype) do
    local eid = tonum(User.userEquip[i])
    local e = self.ui["equip_"..i]
    if(e ~= nil)then
      if(eid ~= 0)then
        local v = User.userEquips[eid]
        UICommon.setEquipImg(e,v)
      else
        -- 没有装备
        UICommon.setEquipImg(e,nil)
      end 
    end
  end
  
  -- 计算玩家属性
  User.userProps = User.getBaseProps(User.ujob, User.ulv)
  User.updateSecondProps(User.userProps,User.ujob, User.ulv)
--  User.updateThirdProps(User.userProps)
    
  -- 显示userEquip玩家属性
  local function getUserPropStr(pi)
      local str = ""
      str = tonum(User.userProps[pi]) + tonum(User.userEquipProps[pi])
      --if(tonum(User.userEquipProps[pi]) > 0) then
      --  str = str .. "(+" .. tonum(User.userEquipProps[pi]) .. ")"
      --end
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
      if basearr[pi] ~= nil then
        str = toint(tonum(str) * (1 + tonum(User.userEquipProps[tonum(basearr[pi])])/ 10000))  --百分比属性 TODO 加全身强化
      end
      
      return str
  end

  local d = self.ui
  local eps = { 1,2,3,4,5,6,7,8,9,12,26,27 }
  for _,v in pairs(eps) do
    d["lbl_"..v]:setString(getUserPropStr(v))
  end

  d.lbl_dmg:setString( getUserPropStr(10) .. "-" .. getUserPropStr(11))
  
  d.lbl_power:setString("战力：" .. toint(User.zhanli))
  d.lbl_name:setString("Lv."..User.ulv.." "..User.uname)
 
  if toint(User.uCheng)>0 and toint(User.uCheng) <10 then
    
    local chenghao,color,imgurl=User.getChengHao(User.uCheng)
    d.lbl_chenghao:setString(chenghao.name)
    d.lbl_chenghao:setColor(color)
    d.img_chenghao:loadTexture(imgurl)
    d.img_chenghao:setVisible(true)
  else
    d.img_chenghao:setVisible(false)
  end
end

function EquipUI.doEquip(e,showChanges)

  -- 保存更换前的属性数据  
  local oldUserEquipProps = clone(User.userEquipProps)
    
  local function onSetEquip(param)
    if(param[1] == 1)then
      --MessageManager:show("装备成功 ")

      -- 更新装备
      local newEid = tonum(e.eid)
      local oldEid = tonum(User.userEquip[tonum(e.etype)]) 
      User.userEquip[tonum(e.etype)] = newEid 
      
      -- 更新装备的标记
      if(oldEid ~= 0)then
        User.userEquips[oldEid].euser = 0
        BagUI.bagNum = BagUI.bagNum + 1 
      end
      
      if(newEid ~= 0)then
        User.userEquips[tonum(e.eid)].euser = 1
        BagUI.bagNum = BagUI.bagNum - 1
      end
            
      -- 更新玩家属性
      User.onEquipProps(param[2])
      GameUI:onLoadUinfo(param[3])
      
      -- 显示属性变化值
      if(showChanges ~= false)then
        MessageManager:showEquipChange(oldUserEquipProps,User.userEquipProps)
      end
      MainBtn:checkMaxBag()
      
       -- 跳转到装备界面
      EquipUI:refreshUI()
      BagUI:setNeedRefresh()
   else
      -- 失败
      MessageManager:show(param[2])
    end
  end
  
  sendCommand("setEquip", onSetEquip, {e.eid, e.etype})
end

return EquipUI