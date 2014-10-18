-- @module PartnerEnforce

local PartnerEnforce = {
  ui = nil,
  newep = nil
}

function PartnerEnforce:create()
  self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/partner_enforce.json"))
  self.ui.nativeUI:setTouchEnabled(true)
  for i=1,4 do
    ui_add_click_listener(self.ui["btn_enforce_"..i],function()
      self:upPartner(i)
    end)
  end
  
  self.ui.panel_after:setVisible(false)
  self.ui.panel_after:setTouchEnabled(false)
  ui_add_click_listener( self.ui.btn_close,function()
    self:close()
  end)

  ui_add_click_listener(self.ui.btn_cancel,function()
    self:cancel()
  end)

  ui_add_click_listener(self.ui.btn_accept,function()
    self:accept()
  end)

  return self.ui
end

function PartnerEnforce:onShow()

    --1战士 2猎人 3法师
    self.ui.lbl_name:setString("Lv."..User.ulv.." "..PartnerUI.curPartner.name)

    UICommon.loadExternalTexture( self.ui.header_img, User.getPartnerHead(PartnerUI.curPartner) )

    local mainprop=""
    if(toint(PartnerUI.curPartner.mainp)==1) then
        mainprop="主属性：力量"
    elseif(toint(PartnerUI.curPartner.mainp)==2) then
        mainprop="主属性：敏捷"
    elseif(toint(PartnerUI.curPartner.mainp)==3) then
        mainprop="主属性：智力"
    end
    self.ui.lbl_job:setString( "职业："..User.getJobName(toint(PartnerUI.curPartner.mainp) ) )
    self.ui.main_prop:setString(mainprop)
    self.ui.lbl_coin_cost:setString( string.format("%d金币", User.ulv * 500) )
  
    local function getUserPropStr(pi)
        local str = tonum(PartnerUI.curPartner.baseProps[pi]) + 
                  tonum(PartnerUI.curPartner.upProps[pi])*toint(User.ulv) + 
                  tonum(PartnerUI.curPartner.oldProps[pi])
        return str
    end

    local d = self.ui
    local eps = { 1,2,3,4 }
    for _,v in pairs(eps) do
        d["lbl_"..v]:setString(getUserPropStr(v))
    end
  
    -- 刷新一下，有可能换过佣兵
    self:refreshView()
    self:cancel()
end

function PartnerEnforce:upPartner(v)
    -- 判断VIP等级权限
    if(v == 2)then
        if(User.vip < 2) then
            MessageManager:show("VIP2以上才可以进行高级培养")
            return
        end
    elseif(v == 3)then
        if(User.vip < 5) then
            MessageManager:show("VIP5以上才可以进行白金培养")
            return
        end
    elseif(v == 4)then
        if(User.vip < 8) then
            MessageManager:show("VIP8以上才可以进行至尊培养")
            return
        end
    end
           
    local function onUpPartner(param)
        if(param[1] == 1) then
            dump(param)
            -- 提示扣钱，很多人不知道
            if v == 1 then
                MessageManager:show("金币-" .. User.ulv * 500, cc.c3b(255,255,0))
                GameUI:addUserCoin(-User.ulv * 500)
            elseif v == 2 then
                MessageManager:show("钻石-20", cc.c3b(255,255,0))
                GameUI:addUserUg(-20)
            elseif v == 3 then
                MessageManager:show("钻石-60", cc.c3b(255,255,0))
                GameUI:addUserUg(-60)
            elseif v == 4 then
                MessageManager:show("钻石-200", cc.c3b(255,255,0))
                GameUI:addUserUg(-200)
            end
            MainUI:refreshUinfoDisplay()
            PartnerUI.curPartner.newProps = {}
            User.equipPropsToTable(PartnerUI.curPartner.newProps,param[2])
    --      local nprops = string.split(param[2],",")
    --      table.foreach(nprops,function(sk,sv)
    --        local sub = string.split(sv,"|")
    --        PartnerUI.curPartner.newProps[toint(sub[1])] = sub[2]
    --      end)
          
    --      DialogManager:showDialog("PartnerEnforceResult",param[2])
            self:showEnforceResult(param[2])
        else
            MessageManager:show(param[2])
        end
    end

    sendCommand("upPartner",onUpPartner,{PartnerUI.curPartner.partnerid,v})
end

function PartnerEnforce:close()
   DialogManager:closeDialog(self)
end

function PartnerEnforce:showEnforceResult(param)
  self.ui.panel_before:setVisible(false)
  self.ui.panel_after:setVisible(true)
  self.ui.panel_before:setTouchEnabled(false)
  self.ui.panel_after:setTouchEnabled(true)
  self.ui.btn_accept:setTouchEnabled(true)
  self.ui.btn_cancel:setTouchEnabled(true)
  self.newep = param

  local function getUserPropStr(pi,type)
    local str = ""
    str = tonum(PartnerUI.curPartner.baseProps[pi]) + tonum(PartnerUI.curPartner.upProps[pi])*toint(User.ulv) + tonum(PartnerUI.curPartner[type.."Props"][pi])
    return str
  end

  local d = self.ui
  local eps = { 1,2,3,4 }
  for _,v in pairs(eps) do
    local old = getUserPropStr(v,"old")
    local new = getUserPropStr(v,"new")
    local newText = d["lbl_"..v.."_new"]
    d["lbl_"..v]:setString(old)

    if(new > old)then
      newText:setString(new .. "( +".. new - old ..")")
      newText:setColor(cc.c3b(0,255,0))
    elseif(new < old)then
      newText:setString(new .. "( -".. old - new ..")")    
      newText:setColor(cc.c3b(255,0,0))
    else
      newText:setString(new)    
      newText:setColor(cc.c3b(255,255,255)) 
    end
  end

end

function PartnerEnforce:accept()
    local function onComfirmPartner()
        local old = clone(PartnerUI.curPartner.oldProps)
        local new = clone(PartnerUI.curPartner.newProps)
        User.updateSecondProps(old,PartnerUI.curPartner.mainp, User.ulv)
        User.updateSecondProps(new,PartnerUI.curPartner.mainp, User.ulv)
        MessageManager:showEquipChange(old,new)
    
        PartnerUI.curPartner.oldProps = PartnerUI.curPartner.newProps
        PartnerUI:refreshView()
        self:refreshView()
        self:cancel()
    end
    
    sendCommand("comfirmPartner",onComfirmPartner,{PartnerUI.curPartner.partnerid})
end

function PartnerEnforce:cancel()
  self.ui.panel_before:setVisible(true)
  self.ui.panel_after:setVisible(false)
  self.ui.panel_before:setTouchEnabled(true)
  self.ui.panel_after:setTouchEnabled(false)
  self.ui.btn_accept:setTouchEnabled(false)
  self.ui.btn_cancel:setTouchEnabled(false)
end

function PartnerEnforce:refreshView()
  local function getUserPropStr(pi,type)
    local str = ""
    str = tonum(PartnerUI.curPartner.baseProps[pi]) + tonum(PartnerUI.curPartner.upProps[pi])*toint(User.ulv) + tonum(PartnerUI.curPartner[type.."Props"][pi])
    return str
  end

  local d = self.ui
  local eps = { 1,2,3,4 }
  for _,v in pairs(eps) do
    local old = getUserPropStr(v,"old")
    d["lbl_"..v]:setString(old)
  end
end

return PartnerEnforce