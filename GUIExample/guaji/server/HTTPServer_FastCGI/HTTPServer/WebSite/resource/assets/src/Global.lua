ui_ = function(nativeWidget, name)
  local u = ccui.Helper:seekWidgetByName( nativeWidget, name)
  return u
end

function ui_add_click_listener(ui, f) 
  ui:addTouchEventListener(
    function(sender,eventType)
      if eventType == ccui.TouchEventType.ended then
        f(sender,eventType)
      end
    end
  )
end

-- cocos2d-x 最大输出为16k字节超过会出错
function safe_print(str)
  if(string.len(str) >= 1024) then
    str = string.sub(str,1,1024) .. ' ...and more ' .. string.len(str) - 1024 .. 'bytes' 
  end
  
  print(str)
end

-- Cocos2d-x UI组建包装一下，这样可以使用：
-- xx.button:addListener()来访问控件
local tt={
    __index = function(t,k)
      local u = ui_(t.nativeUI, k)
      rawset(t,k,u)
      return u
    end
  }
function ui_delegate(nativeUI)
  if(nativeUI == nil)then
    return nil
  end
  
  local r = { ["nativeUI"] = nativeUI }
  setmetatable( r, tt)
  return r
end

Jedi = {
}

-- UNIX TIME STAMP, 单位秒，小数点后面是毫秒
function getSystemTime()
    local socket = require "socket.core"
    return socket.gettime()
end

-- 退出进程
function doExitApplication()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    cc.Director:getInstance():endToLua()
    if(cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform)then 
        os.exit()
    end
end

function Jedi.Set (list)
  local set = {}
  -- ipairs 和 pairs的区别！！
  -- ipairs 如果k有断档，就会停止！，比如 { [1] => 1, [2] => 2, [5] => 5 } 第三个元素就不会被遍历到！
  for _, l in pairs(list) do set[l] = true end
  return set
end

-- RichTextElement
function RTE(text,size,color)
  if(size == nil) then
    size = 25
  end

  if(color == nil) then
    color = cc.c3b(0,0,0)
  end
  
  return ccui.RichElementText:create(1, color, 255, text, Config.font, size)
end

-- 暂时没有用
function getAppVersion()
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local args = {}
        local sigs = "()Ljava/lang/String;"
        local luaj = require "luaj"
        local className = "com/cocos2dx/lua/AppUtils"
        local ok,ret  = luaj.callStaticMethod(className,"getAppVersionName",args,sigs)
        if not ok then
            print("luaj error:", ret)
        else
            print("The ret is:", ret)
        end
        
        return ret
    end
    
    return ""
end

-- 把一个变量序列换成一个lua脚本
function serializeTable(o)
    local ret = ""
    if type(o) == "number" then
        ret = ret .. o
    elseif type(o) == "string" then
        ret = ret .. string.format("%q", o)
    elseif type(o) == "table" then
        ret = ret .. "{\n"
        for k,v in pairs(o) do
            ret = ret .. "  " .. k .. " = "
            serializeTable(v)
            ret = ret .. ",\n"
        end
        ret = ret .. "}\n"
    else
        error("cannot serialize a " .. type(o))
    end
end

function deleteDownloadDir2(pathToSave)
    if cc.PLATFORM_OS_IPHONE==targetPlatform or cc.PLATFORM_OS_IPAD==targetPlatform then
        local luaoc=require "luaoc";
        local ok,ret =luaoc.callStaticMethod("MyPlatform","deleteTmpDir",nil);
    else
        deleteDownloadDir(pathToSave)
    end
end