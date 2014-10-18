--@module Scheduler
Scheduler = {}

local sharedScheduler = cc.Director:getInstance():getScheduler()

local function wrappedListener(l)
  return function ()
    xpcall(l,
    __G__TRACKBACK__)
  end
end

function Scheduler.scheduleUpdateGlobal(listener)
    return Scheduler.scheduleGlobal(listener, 0)
end

function Scheduler.scheduleGlobal(listener, interval)
    return sharedScheduler:scheduleScriptFunc(wrappedListener(listener), interval, false)
end

-- 取消
function Scheduler.unscheduleGlobal(handle)
    if handle ~= nil then
        sharedScheduler:unscheduleScriptEntry(handle)
    end
end

-- 运行一次
function Scheduler.performWithDelayGlobal(listener, delay)
    local handle
    handle = Scheduler.scheduleGlobal(
        function()
        Scheduler.unscheduleGlobal(handle)
        listener()
    end, delay)
    return handle
end

-- 有限次数的倒计时, time = 次数
function Scheduler.scheduleGlobalWithTime(listener, interval, time, onComplete)
    local handle
    local i = time
    handle = Scheduler.scheduleGlobal(function()
        i = i - 1
        listener(i)
        if(i <= 0)then
          Scheduler.unscheduleGlobal(handle)
          if(onComplete ~= nil)then
            onComplete()
          end
        end
    end, interval, false)
    return handle
end

-- 在某个node上进行schedule，node被删除，schedule也会随之销毁
function Scheduler.scheduleNode(node, listener, interval)
    local delay = cc.DelayTime:create(interval)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(listener))
    node:runAction(cc.RepeatForever:create(sequence))
end

-- 在某个node上进行schedule，node被删除，schedule也会随之销毁
function Scheduler.scheduleNodeOnce(node, listener, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(listener))
    node:runAction(sequence)
end

return Scheduler
