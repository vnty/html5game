local ByteArray2 = class("ByteArray2")

require("pack")

-- 简化版的ByteArray, 速度更快， 目前只支持BigEndian
function ByteArray2:ctor()
    self:init()
end

function ByteArray2:init()
    self._buf = ""
    self._pos = 1
end

function ByteArray2:getPos()
	return self._pos
end

function ByteArray2:setPos(p)
	self._pos = p
end

function ByteArray2:getBuf()
	return self._buf
end

function ByteArray2:appendData(__data)
    self._buf = self._buf .. __data
end

function ByteArray2:offset(o)
	self._pos = self._pos + o
end

function ByteArray2:getAvailable()
    return #self._buf - self._pos + 1
end

function ByteArray2:readStringUShort()
    local _, len = string.unpack(self._buf, ">H", self._pos)
    self._pos = self._pos + 2
    local __, __v = string.unpack(self._buf, ">A"..len, self._pos)
    self._pos = self._pos + len
    return __v
end

function ByteArray2:readInt()
    local _, i = string.unpack(self._buf, ">i", self._pos)
    self._pos = self._pos + 4
    return i
end

function ByteArray2:writeStringUShort(str)
    local s = string.pack(">P", str)
    self._buf = self._buf .. s
    return self
end

function ByteArray2:writeInt(i)
    local s = string.pack(">i",i)
    self._buf = self._buf .. s
    return self
end
function ByteArray2:tostring()
    local p={}
    for i=1,#self._buf do
        local c=string.byte(self._buf,i)
        table.insert(p,#p+1,string.format("%2x",c))
    end
    return table.concat(p," ")
end

return ByteArray2