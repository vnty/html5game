-- @module SkillUI

local cmd = require("src/Command")

SkillUI = {
  ui = nil,
  skilllist = nil,
  currentId = 0,
  lastUlv = 0,
  maxIndex=0,
}


function SkillUI:create()
    local frameSize = cc.Director:getInstance():getWinSize()
    self.ui = ui_delegate(ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/skill.json"))
  
    self.ui.Panel_5_0:setContentSize(640,frameSize.height - 200)
    self.ui.lbl_map:setPosition(cc.p(frameSize.width/2,frameSize.height-(frameSize.height-960)/12-230))
    self.ui.Panel_5_1:setPosition(cc.p(31,5*(frameSize.height-960)/6+104-(frameSize.height-960)/2))
    self.ui.Panel_5_1:setContentSize(582,frameSize.height - 356-(frameSize.height-960)/2)
    self.ui.skill_list:setContentSize(565,frameSize.height - 372-(frameSize.height-960)/2)
    
    self.skilllist = self.ui.skill_list
    self.skilllist:setItemsMargin(8)
    self.skilllist:setTouchEnabled(true)
    self.skilllist:setBounceEnabled(true)
    
    local function listViewEvent(sender, eventType)
        if eventType == ccui.ListViewEventType.onsSelectedItem then
            local i = sender:getCurSelectedIndex()
            cclog("skill ".. i)
            self.currentId = i+1;
            if(i>=self.maxIndex and i<self:getSkillNum()) then
                DialogManager:showDialog("SkillSelect","pve")
            end
        end
    end
  
    self.skilllist:addEventListener(listViewEvent)
  
    self:initCurrentSkillView()
  
    ui_add_click_listener( self.ui.btn_change,function()
        DialogManager:showDialog("SkillSelect","pve")
    end)
   
    ui_add_click_listener( self.ui.btn_master,function()
        MessageManager:show("技能专精尚未开放")
    end)   
   
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showDialog("HelpDialog", HelpText:helpSkill())
    end)   
    
    ui_add_click_listener( self.ui.btn_pvp,function()
        DialogManager:showDialog("SkillPvp")
    end)
    
    self.lastUlv = 0
  
    return self.ui
end

function SkillUI:onShow()
    -- 用户等级没变化，不需要刷新
    if self.lastUlv == User.ulv then
        return
    end
    self.lastUlv = User.ulv

    self:initCurrentSkillView()
end


function SkillUI:initCurrentSkillView()
    
    self.skilllist:removeAllItems()
    local n = self:getSkillNum();
  
    self.ui.lbl_tips:setString(string.format("人物等级%d开启", User.ulv))
  
    for i=1,n do
        if(User.userSkill[i]~=nil) then
            local skill_item = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item.json"))
            self.skilllist:pushBackCustomItem(skill_item.nativeUI)
            local data = ConfigData.cfg_skill[toint(User.userSkill[i])]
            self:setItemInfo(skill_item,data,i)
            self.maxIndex=i
        else
            local skill_item_empty = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item_empty.json"))
            self.skilllist:pushBackCustomItem(skill_item_empty.nativeUI)
            skill_item_empty.img_lock:setVisible(false)
        end
    end
  
    if(n<4)then
        for i = n+1, 4 do
            local skill_item_empty = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/skill_item_empty.json"))
            self.skilllist:pushBackCustomItem(skill_item_empty.nativeUI)
            local lvt = {
                [1] = 5,
                [2] = 15,
                [3] = 25,
                [4] = 35
            }
            skill_item_empty.txt_info:setString( string.format("人物等级%d级开启", lvt[i]) )
            skill_item_empty.txt_info:setColor( cc.c3b(69,183,212) )
        end
    end
end

function SkillUI:setItemInfo(d,v,i)
   local x = d.checkbox:getPositionX()
   local y = d.checkbox:getPositionY()
   d.checkbox:removeFromParent()
   
   if(v~=nil) then
    d.txt_name:setString(v.sname)
    d.txt_info:setString(v.tips)
   else
    d.txt_name:setString("没有装备技能");
    d.txt_info:setString("无")
    return
   end
   
   d.txt_mp:setString( string.format("消耗MP：%d", v.mp) )
   d.lbm_order:setString(i)
   d.img_skill:loadTexture( string.format("res/skill/%d.png", v.sid))
   d.img_lock:setVisible(false)
   
   if(i ~= 1)then
        d.btn_order:loadTextureNormal("res/ui/button/btn_117.png")
        ui_add_click_listener( d.btn_order,function()
            -- 这里要延后执行，因为switchSkill中会把item清掉导致事件返回时出现问题
            Scheduler.performWithDelayGlobal(function()
                self:switchSkill(v.sid,-1)
            end,0.1)
        end)
   end   
end

function SkillUI:switchSkill(sid,direction)-- [-1 up] [1 down]
  local position = self:getSkillPosition(sid)
  if(position == nil) then
    return
  end
  
  local newPosition = position + direction
  local newSid = User.userSkill[newPosition]
  if(newSid ~= nil) then
    User.userSkill[position] = newSid
    User.userSkill[newPosition] = sid
    self:initCurrentSkillView()
    self:sendEquipSkill()
  end
end

function SkillUI:getSkillPosition(sid)
  local result = nil
  table.foreach(User.userSkill,function(k,v)
    if(toint(v) == toint(sid)) then
      result = toint(k)
    end
  end)
  return result
end

function SkillUI:sendEquipSkill()
  local function onSetSkill(params)
    if params[1]==1 then
        local skill = string.split(params[2],",");
        local n = 1
        table.foreach(skill,function(k,v)
            cclog("onGetSkill ".. k .. " " .. v)
            if(tonum(v) > 0) then
                User.userSkill[toint(n)] = toint(v);
                n = n + 1;
            end
        end)
    else
        User.userSkill={}
        SkillUI:initCurrentSkillView()
        MessageManager:show(params[2])
    end
  end
  
  --发送装备技能的请求
  
  self.maxIndex=0
  local str_skill = "";
  table.foreach(User.userSkill,function(k,v)
    cclog(k.."  "..v)
    str_skill = str_skill..v..",";
    self.maxIndex=k
  end)
  str_skill = string.sub(str_skill, 1, -2)
  
  cclog("equiped skill str:"..str_skill)
  sendCommand("setSkill", onSetSkill,{str_skill})
end

function SkillUI:getSkillNum()
  local n = 0
  if(User.ulv>=35) then
    n = 4;
  elseif User.ulv>=25 then
    n = 3;
  elseif User.ulv>=15 then
    n = 2;
  elseif User.ulv>=5 then
    n = 1;
  end
  return n
end

return SkillUI;