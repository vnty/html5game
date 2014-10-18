-- @module MessageManager
MessageManager = {
    messageList = {},
    lastPos = nil, -- 最后一个label的位置
    
    systemBroadcastList = {}
}

function MessageManager:show(message, color)
  if(color == nil)then
    color = cc.c3b(0, 255, 0)
  end
  
  local size = cc.Director:getInstance():getWinSize()
  local messageNum = table.getn(self.messageList)
  local pos = nil
  
  if(messageNum==0)then
    -- 没有消息
    pos = cc.p(size.width / 2, size.height / 2)
    self.lastPos = pos
  else
    pos = cc.p(size.width / 2, self.lastPos.y - 40)
  end
  
  -- 飘个文字
  local pLable = UICommon.createLabel(message, 35)
  pLable:setColor(color)  
  pLable:setPosition(pos) 
  pLable:setScaleX(size.width / pLable:getContentSize().width)
  pLable:enableOutline(cc.c4b(0,0,0,255),3)
  cc.Director:getInstance():getRunningScene():addChild(pLable,100,100) -- Message 的zOrder 为 100
  
  local function callback()
    cclog("removing from parent")
    if(self.messageList[1] ~= pLable)then
        __G__TRACKBACK__("self.messageList[1] ~= pLable")
        return
    end
    table.remove(self.messageList,1)
    pLable:removeFromParent()
  end
  
  local scaleTo = cc.ScaleTo:create(0.1,1,1)
  local delay = cc.DelayTime:create(3)
  local fade = cc.FadeOut:create(0.5)
  local sequence = cc.Sequence:create(scaleTo, delay, fade, cc.CallFunc:create(callback))
  pLable:runAction(sequence)
      
  table.insert( self.messageList, pLable )
  
  -- 将文字居中，如果没有超过10条，按中心居中；如果超过10条，按最后十条居中
  local messageNum = table.getn(self.messageList)
  if(messageNum>=2 and messageNum <= 10)then
    for i = 1, messageNum do
        local v = self.messageList[i]
        v:stopActionByTag(9999) -- 如果之前有action，停掉
        local ac = cc.MoveTo:create(0.1, cc.p(size.width/2, size.height/2 + ((messageNum - 1) / 2 - (i - 1)) * 40 ))
        ac:setTag(9999)
        v:runAction(ac)
        self.lastPos = cc.p(size.width/2, size.height/2 + -(messageNum - 1) / 2 * 40 )
    end
  elseif(messageNum > 10)then
    local j = 0
    for i = messageNum, 1, -1 do
        local v = self.messageList[i]
        v:stopActionByTag(9999) -- 如果之前有action，停掉
        local ac = cc.MoveTo:create(0.1, cc.p(size.width/2, size.height/2 - (4.5 - j ) * 40 ))
        ac:setTag(9999)
        v:runAction(ac)
        j = j + 1
    end
    
    self.lastPos = cc.p(size.width/2, size.height/2 - 4.5 * 40 )    
  end

end

function MessageManager:showEquipChange(oldprop, newprop)
    self:purgeMessages();
  -- 显示属性变化值
  local changes = {}
  for k,v in pairs(ConfigData.cfg_equip_prop) do
    local o = tonum(oldprop[k])
    local n = tonum(newprop[k])
    if(o ~= n)then
      local color = nil
      if(n > o) then
        color = cc.c3b(0,255,0)
      else
        color = cc.c3b(255,0,0)
      end
      table.insert(changes, { message= User.getPropStr(k, math.ceil(n - o)) , color = color })
    end
  end
  
  for i=1,table.getn(changes) do
    Scheduler.performWithDelayGlobal(function()
      --doShowLine(i)
      self:show(changes[i].message,changes[i].color) 
    end, i * 0.1)
  end
end

-- 切换scene时清空MessageList，否则可能现在还存在的Message会导致出错
function MessageManager:purgeMessages()
    for _,v in pairs(self.messageList) do
        v:removeFromParent()
    end
    
    self.messageList = {}
    self.lastPos = nil
end

-- messageList {{message:_, color:_},...}
function MessageManager:showMessageDelay(messageList, delay)
    if delay == nil then
        delay = 0
    end
    self:purgeMessages()
    for i=1,table.getn(messageList) do
        Scheduler.performWithDelayGlobal(function()
            if messageList[i].color == nil then
                messageList[i].color = cc.c3b(0,255,0)
            end
            self:show(messageList[i].message,messageList[i].color) 
        end, i * delay) 
    end
end

-- 在某个对象上面显示字
function MessageManager:showMessageNode(node, message, color)
    if(color == nil)then color = cc.c3b(0, 255, 0) end
  
    local size = cc.Director:getInstance():getWinSize()
    local messageNum = table.getn(self.messageList)
    local lposx,lposy = node:getPosition()
    dump(lposx)
    dump(lposy)
    local pnode = node:getParent()
    local pos = pnode:convertToWorldSpace( cc.p(lposx,lposy))
    cclog("X=%f Y=%f",pos.x, pos.y)
  
    -- 飘个文字
    local pLable = UICommon.createLabel(message, 35)
    pLable:setColor(color)  
    pLable:setPosition(cc.p(pos.x,pos.y+40)) 
    --pLable:setScaleX(size.width / pLable:getContentSize().width)
    pLable:enableOutline(cc.c4b(0,0,0,255),3)
    cc.Director:getInstance():getRunningScene():addChild(pLable,100,100) -- Message 的zOrder 为 100
  
    local function callback()
        pLable:removeFromParent()
    end
  
    local scaleTo = cc.ScaleTo:create(0.1,1,1)
    local delay = cc.DelayTime:create(0.5)
    local fade = cc.FadeOut:create(0.5)
    local sequence = cc.Sequence:create(delay, fade, cc.CallFunc:create(callback))
    pLable:runAction(sequence)

    local ac = cc.MoveBy:create(1, cc.p(0, 80) )
    pLable:runAction(ac)
end

-- 上电视功能
function MessageManager:showSystemBroadcast(msgs)
    table.insert(self.systemBroadcastList, msgs)

    if table.getn(self.systemBroadcastList) > 1 then
        dump(self.systemBroadcastList)
        return
    end
    
    MessageManager:_doShowSystemBroadcast(msgs)
end

function MessageManager:_doShowSystemBroadcast(msgs)
    local back = ccui.ImageView:create("res/ui/images/img_241.png")
    back:setPosition(cc.p(0,885))
    back:setAnchorPoint(cc.p(0,0))
    back:setLocalZOrder(40)
    gameRoot:addChild(back)
   
    back:setTouchEnabled(true)
    
    local function removeSystemBroadcast()
        back:removeFromParent()
        table.remove(self.systemBroadcastList,1)

        if table.getn(self.systemBroadcastList) > 0 then
            MessageManager:_doShowSystemBroadcast(self.systemBroadcastList[1])
            return
        end        
    end
    
    ui_add_click_listener(back, function() -- 点击关闭当前消息
        -- 因为cocos2d-x 3.2RC的bug，不能直接在点击回调里面删除Node，所以先设置成不可点击，然后再延迟删除
        back:setTouchEnabled(false)
        Scheduler.performWithDelayGlobal( removeSystemBroadcast, 0)
    end)

    local info = ccui.RichText:create()
    info:setAnchorPoint( cc.p(0,1) )
    info:ignoreContentAdaptWithSize(true)
    info:setTouchEnabled(false)
    back:addChild(info,10,10)

    for _,v in pairs(msgs) do
        info:pushBackElement(v)
    end

    info:formatText()    
    local s = info:getContentSize()

    local showTime = 5

    if s.width <= 640 then
        local x = (640 - s.width) / 2
        local y = 41 + s.height / 2
        info:setPosition(x,y)
    else
        local x = 0
        local y = 41 + s.height / 2
        info:setPosition(x,y)
        local offset = s.width - 640

        local moveTime = offset / 30 -- 每秒30像素
        showTime = math.max(5, moveTime + 2 )
        local sequence = cc.Sequence:create(cc.DelayTime:create(1), cc.MoveBy:create( math.max(3.5, moveTime) , cc.p(-offset, 0) ))
        info:runAction(sequence)
    end

    local function callback()
        removeSystemBroadcast()
    end

    local delay = cc.DelayTime:create(showTime)
    local fade = cc.FadeOut:create(0.5)
    local sequence = cc.Sequence:create(delay, fade, cc.CallFunc:create(callback))
    back:runAction(sequence)
end

return MessageManager