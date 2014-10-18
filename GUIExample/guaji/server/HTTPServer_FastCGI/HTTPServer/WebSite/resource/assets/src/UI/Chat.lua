local ByteArray = require("src/quick-x/ByteArray2")
local socket = require("socket.core")
local RTS = require("src/UI/RichTextScroll")

local ChatUI = class()

function ChatUI:ctor()
    self.pnlChat = nil
    self.worldChatRTS = nil
    self.clubChatRTS = nil
    
    self.richtextlist = {}
    self.sock = nil
    self.connected = false
    self.editBox = nil
    self.lastSendTime = 0
    self.curChannel = "world"
    self.recentUids = {}
    self.recentUidsClub = {}    
    self.myClubId = 0
    self.clubRecentChatTS = 0 -- 公会最近聊天信息的Timestamp
end

function ChatUI:enterChat()
    self.pnlChat.nativeUI:setVisible(true)

    UICommon.setVisible(self.pnlChat.button_chat_setup,true)
    UICommon.setVisible(self.pnlChat.button_chat_channel,true)
    self:switchToChannel()
end

function ChatUI:exitChat()
    self.pnlChat.nativeUI:setVisible(false)
    self.pnlChat.chat_log:setTouchEnabled(false)
    self.pnlChat.club_chat_log:setTouchEnabled(false)
    UICommon.setVisible(self.pnlChat.button_chat_setup,false)
    UICommon.setVisible(self.pnlChat.button_chat_channel,false)
end

function ChatUI:switchToChannel()
   if self.curChannel == "world" then
        self.pnlChat.chat_log:setVisible(true)
        self.pnlChat.chat_log:setTouchEnabled(true)
        self.pnlChat.club_chat_log:setVisible(false)
        self.pnlChat.club_chat_log:setTouchEnabled(false)
        
        BattleUI.ui.lbl_map:setString("世界聊天")
        self.pnlChat.button_chat_channel:setTitleText("公会聊天")
    elseif self.curChannel == "club" then
        self.pnlChat.chat_log:setVisible(false)
        self.pnlChat.chat_log:setTouchEnabled(false)
        self.pnlChat.club_chat_log:setVisible(true)
        self.pnlChat.club_chat_log:setTouchEnabled(true)

        BattleUI.ui.lbl_map:setString("公会聊天")
        self.pnlChat.button_chat_channel:setTitleText("世界聊天")        
    end
end

function ChatUI:init()
    self.pnlChat = ui_delegate(BattleUI.ui.pnl_chat)    
    self.worldChatRTS = RTS.new(self.pnlChat.chat_log)
    self.clubChatRTS = RTS.new(self.pnlChat.club_chat_log)
    
    -- top
    local back = cc.Scale9Sprite:create("res/ui/images/img_110.png", cc.rect(14, 14, 8, 8))
    local editBox = cc.EditBox:create(cc.size(421,41), back)
    editBox:setPosition(cc.p(210, 20))
    editBox:setFontSize(25)
    editBox:setFontColor(cc.c3b(255,255,255))
    editBox:setPlaceHolder("请在这里输入聊天内容...")
    editBox:setPlaceholderFontColor(cc.c3b(128,128,128))
    editBox:setMaxLength(30)
    editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    self.pnlChat.pnl_input:addChild(editBox)
    self.editBox = editBox

    ui_add_click_listener(BattleUI.ui.btn_do_send,function()
        local msg = self.editBox:getText()
        if(msg ~= "" and self.connected == true)then
            local st = getSystemTime()
            
            if self.lastSendTime + 10 < st then
                local cjson = require("cjson")
                local t = { content = {{ msg = msg }} }
                
                if tonum(User.uCheng) ~= 0 then
                    t.chid = User.uCheng
                end
                
                if self.curChannel == "club" then
                    -- 公会聊天频道发言
                    t.cid = self.myClubId
                end
                
                local tt = cjson.encode(t)
                self:doSendMsg( tt )
                --self:doSendMsg2( msg ) -- 目前先用doSendMsg版本，等客户端全都更新至sendMsg2后发送也改成doSendMsg2
                self.editBox:setText("")
                self.lastSendTime = st
            else
                if self.curChannel == "world" then
                    self.worldChatRTS:appendText(RTE("您发言太快啦，请稍事休息..."))
                elseif self.curChannel == "club" then
                    self.clubChatRTS:appendText(RTE("您发言太快啦，请稍事休息..."))
                end
            end
        end
    end)
    
    ui_add_click_listener(self.pnlChat.chat_log,function()
        if table.getn(self.recentUids) > 0 then
            DialogManager:showDialog("ChatRecent", self.recentUids)
        else
            MessageManager:show("目前还没有人发言")
        end
    end)
    
    ui_add_click_listener(self.pnlChat.club_chat_log,function()
        if table.getn(self.recentUidsClub) > 0 then
            DialogManager:showDialog("ChatRecent", self.recentUidsClub)
        else
            MessageManager:show("目前还没有人发言")
        end
    end)    
    
    -- 频道切换
    ui_add_click_listener(self.pnlChat.button_chat_channel,function()
        if self.curChannel == "world" then
            if self.myClubId == 0 then
                MessageManager:show("聊天未连接或您尚未加入公会")
                return
            end
            
            self.curChannel = "club"
        elseif self.curChannel == "club" then
            self.curChannel = "world"
        end
           
        self:switchToChannel() 
    end)
    
    local s = cc.UserDefault:getInstance():getStringForKey("disableChat")
    if s == "" then
        -- 未设置过，默认开启聊天
        cc.UserDefault:getInstance():setStringForKey("disableChat","1")
    end
  
    local dc = tonum(cc.UserDefault:getInstance():getStringForKey("disableChat"))
    
    if dc == 0 then
        self.worldChatRTS:appendText(RTE("您已关闭聊天，如需聊天，请在设置中打开聊天功能。"))
    end

    self:chatSetup(dc)
    
    --[[local i = 0
    Scheduler.scheduleGlobal(function()
        local s = i .. "玩家在地图里刷怪时，每隔1秒钟双方交替轮流进行攻击。每次战斗玩家拥有怪的数量*20秒的战斗时间。"
        --for i = 1, math.random() * 5 do
        --    s = s .. s
        --end
        i = i + 1
        self.worldChatRTS:appendText(RTE(s))
    end, 0.3)]]
end

-- 0: 关闭聊天， 1: 启用聊天
function ChatUI:chatSetup(tempchat)
    if tempchat == 0 and self.sock ~= nil then
        -- 关闭聊天
        self.worldChatRTS:appendText(RTE("正在关闭聊天..."))
        self:close()
    end
    
    if tempchat == 1 and self.sock == nil then
        self:connect()
    end
end

function ChatUI:connect()
    self.worldChatRTS:appendText(RTE("正在连接服务器..."))

    local SocketTCP = require("src/quick-x/SocketTCP")
    local dataBuf = nil
    local packetLen = 0

    local function onStatus(__event)
        cclog("onStatus: %s", __event.name)
        if(__event.name == SocketTCP.EVENT_CONNECTED)then
            self.connected = true
            self.worldChatRTS:appendText(RTE("已成功连接到服务器...",25,cc.c3b(0,183,0)))
            dataBuf = ByteArray.new()
            self:doAuth()
        elseif(__event.name == SocketTCP.EVENT_CONNECT_FAILURE or __event.name == SocketTCP.EVENT_CLOSED)then
            self.connected = false        
            self.worldChatRTS:appendText(RTE("网络错误，正在尝试重新连接..."))
        elseif(__event.name == SocketTCP.EVENT_CLOSE)then
            self.connected = false        
            self.worldChatRTS:appendText(RTE("网络连接已关闭..."))         
        end
    end
   
    
    local function _onData(__event)
        dataBuf:appendData(__event.data)
        
        local av = dataBuf:getAvailable()
      --  cclog("socket status: %s, data:%s packetLen:%d", __event.name, ByteArray1.toString(__event.data),packetLen)
     --   cclog("data:%s",dataBuf:tostring())
        while av > 4 do
            
            local packetLen = dataBuf:readInt() -- 包长度不包括packetLen本身
            local packetStart = dataBuf:getPos()
            cclog("packetLen:%d start:%d", packetLen, packetStart)

            if av - 4 < packetLen then
                --数据包长度不够
                cclog("packet lack:%d/%d", av, packetLen )
                dataBuf:offset(-4) -- 下次还会重新读取包长度
                return
            end
            
            -- 读取mid
            local mid = dataBuf:readInt()
            
            cclog("socket protocol code:%x",mid)
            if(mid == 1022)then
                self:onChat1022(dataBuf)
            elseif mid == 1023 then
                self:onChat1023(dataBuf) -- 新的二进制聊天指令，尚未启用
            elseif mid == 1024 then
                self:onChat1024(dataBuf) -- 系统消息，一般是公告             
            elseif mid==1005 then
                self:onAuth(dataBuf)
            end
            
            -- 结束包长
            dataBuf:setPos( packetStart + packetLen )
            
            av = dataBuf:getAvailable()
            cclog("av:%d",av)
            if av == 0 then
                -- 清空缓存
                cclog("clearing dataBuf")
                dataBuf:init()
            end            
        end
    end
     
    local function onData(__event)
        xpcall(
            function()
                _onData(__event)
            end,
            function(msg)
                __G__TRACKBACK__(msg,false)-- 聊天出错不崩溃        	
            end
        )
    end
    
    local s = string.split(User.server.chatserver,":")
    dump(User.server.chatserver)
    cclog("connecting %s:%d",s[1],s[2])
    socket = SocketTCP.new( s[1], tonum(s[2]), true)
    socket:addEventListener(SocketTCP.EVENT_CONNECTED, onStatus)
    socket:addEventListener(SocketTCP.EVENT_CLOSE, onStatus)
    socket:addEventListener(SocketTCP.EVENT_CLOSED, onStatus)
    socket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, onStatus)
    socket:addEventListener(SocketTCP.EVENT_DATA, onData)
    
    socket:connect()
    
    --socket:send(ByteArray.new():writeByte(0x59):getPack())
    self.sock = socket
end

function ChatUI:onAuth(dataBuf)
    local rescode = dataBuf:readInt()
    local uid = dataBuf:readInt()
    local cid = dataBuf:readInt()
    
    -- 聊天验证成功
    cclog("chat onAuth " .. rescode)
    
    self.myClubId = cid
end

function ChatUI:onChat1022(dataBuf)
    -- 聊天
    local uid = dataBuf:readInt()
    local uname = dataBuf:readStringUShort()
    local msg = dataBuf:readStringUShort()

    cclog("msg:%s",msg)
    local cjson = require("cjson")
    local ret = cjson.decode(msg)
    --dump(ret['content'][1]['msg'])

    local textColor = cc.c3b(0,0,0)
    if uid == 0 then -- 系统消息
        textColor = cc.c3b(255,0,0)
    end

    local rtes = {}

    -- 称号
    local chid = tonum(ret.chid) 
    if chid ~= 0 then
        local c = ConfigData.cfg_chenghao[chid]
        table.insert(rtes, RTE( "[" .. c.name .. "]", 25, User.starToColor(c.type)))                    
    end
    
    table.insert( rtes, RTE( uname, 25, textColor) )

    table.insert(rtes, RTE( "：", 25, textColor))
    for _,v in pairs(ret.content) do
        table.insert(rtes, RTE(v.msg, 25, textColor) )
    end
    
    -- 是否为离线消息
    local ts = tonum(ret.ts)
    if ts > 0 then
        table.insert(rtes, RTE( "[" .. UICommon.timeAgoStr(getSystemTime() - ts) .. "]", 25, cc.c3b(128,128,128)) )
    end

    -- 公会频道
    local cid = tonum(ret.cid)
    if cid ~= 0 then
        table.insert(rtes, 1 , RTE( "[公会]", 25, cc.c3b(0,183,0)))

        self.clubChatRTS:appendText(unpack(rtes))
        self:addToRecentUids(self.recentUidsClub,uid)
        
        -- 最近一次公会聊天收到的时间
        self.clubRecentChatTS = toint(getSystemTime())
    end

    self.worldChatRTS:appendText(unpack(rtes))
    self:addToRecentUids(self.recentUids,uid)

    BattleUI:showNewChatMessage()
end

function ChatUI:onChat1023(dataBuf)
    -- 新的聊天指令
    local uid = dataBuf:readInt()
    local channel = dataBuf:readInt() -- 频道 0: 系统  1: 世界 2: 公会 uid: 私聊
    local title = dataBuf:readInt()
    local uname = dataBuf:readStringUShort()
    local msg = dataBuf:readStringUShort()

    local textColor = nil
    if channel == 0 then
        textColor = cc.c3b(255,0,0)
    elseif channel == 1 then
        textColor = cc.c3b(0,0,0)
    elseif channel == 2 then
        textColor = cc.c3b(0,255,0)
    else
        textColor = cc.c3b(0,0,255)
    end

    self.worldChatRTS:appendText(RTE( uname .. "：" .. msg, 25, textColor))
    BattleUI:showNewChatMessage()
    self:addToRecentUids(uid)
end

function ChatUI:onChat1024(dataBuf)
    local msg = dataBuf:readStringUShort()
    local rtes = loadstring( "return ".. msg )();
    self.worldChatRTS:appendText(unpack(rtes))
    MessageManager:showSystemBroadcast(rtes)
    BattleUI:showNewChatMessage()
end

function ChatUI:doSendMsg(msg)
    local ba = ByteArray.new()
    ba:writeInt(16) -- chat
    :writeInt(User.uid) -- uid
    :writeStringUShort(msg)
    self:sendData(ba)
end

function ChatUI:doSendMsg2(msg)
    local ba = ByteArray.new()
    ba:writeInt(17) -- chat
        :writeInt(User.uid) -- uid
        :writeInt(1)
        :writeStringUShort(msg)
    self:sendData(ba)
end


function ChatUI:doAuth()
    local ba = ByteArray.new(ByteArray.ENDIAN_BIG)
    
-- 和AS3的用法相同，还支持链式调用
    ba:writeInt(0x04) -- auth
    :writeInt(User.uid) -- uid
    :writeInt(123123) -- sincode
    :writeInt(self.clubRecentChatTS)

    self:sendData(ba)
end

-- 更新公会（玩家加入、退出公会）
function ChatUI:updateClub(newClubId)
    self.myClubId = newClubId
    self.clubRecentChatTS = 0

    local ba = ByteArray.new(ByteArray.ENDIAN_BIG)

    -- 和AS3的用法相同，还支持链式调用
    ba:writeInt(19) -- update club id
        :writeInt(User.uid) -- uid
        :writeInt(newClubId) -- newclubid

    self:sendData(ba)
end

function ChatUI:sendData(ba)
    local ba2 = ByteArray.new()
    ba2:writeInt(#ba:getBuf())
    
    if not self.sock or not self.sock.isConnected then
        return 
    end

    local r = self.sock:send(ba2:getBuf()..ba:getBuf())
    --dump(r)
end

function ChatUI:addToRecentUids(uids, uid)
	table.insert( uids,1,uid.."")
	if table.getn(uids) > 12 then
        table.remove(uids,12)
	end
end

function ChatUI:close()
    if(self.sock ~= nil)then
        self.sock:close()
        self.sock = nil
    end
end

return ChatUI
