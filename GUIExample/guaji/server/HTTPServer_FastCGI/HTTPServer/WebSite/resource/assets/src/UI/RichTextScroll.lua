-- TODO:目前就聊天在用这个，到时候战斗日志也可以用这个

local RichTextScroll = class("RichTextScroll",nil)

function RichTextScroll:ctor(panel)
    self.ui = ui_delegate(panel)
    self.richtextlist = {}
    self.richtext = nil
    self.adjustRichTextFlag = true
    
    self:addRichText()
end

function RichTextScroll:appendText(...)
    self:addRichText()

    local arg = {...}
    for i=1, table.getn(arg) do
        self.richtext:pushBackElement(arg[i])
        self.lastElement = arg[i]
    end
    self.richtext:pushBackElement(RTE("\n"))  

    self.richtext:formatText() -- 强制渲染，这样richText:getRealSize()得到的值才正确
    self:adjustRichText() -- 调整文字
end

function RichTextScroll:addRichText()
    local richtext = ccui.RichText:create()
    local s = self.ui.nativeUI:getContentSize()
    local n = table.getn(self.richtextlist)
    self.richtextlist[n+1] = richtext

    self.ui.nativeUI:addChild(richtext)
    richtext:setPositionX(0)
    richtext:setPositionY(s.height)
    richtext:setAnchorPoint(cc.p(0,1))
    richtext:ignoreContentAdaptWithSize(false)
    richtext:setContentSize(s)
    richtext:setTouchEnabled(false)

    self.richtext = richtext

    if(n>=1) then
        local y = self.richtextlist[n]:getPositionY()-self.richtextlist[n]:getRealSize().height
        richtext:setPositionY(y)
    end
end

function RichTextScroll:adjustRichText()
    --cclog("adjustRichText Y = " .. self.richtext:getPositionY())
    --cclog("adjustRichText H = " ..self.richtext:getRealSize().height)
    if(self.richtext == nil or self.adjustRichTextFlag == false)then
        return
    end

    local y = self.richtext:getPositionY() - self.richtext:getRealSize().height
    if(y<0) then -- 滚屏
        local s = self.ui.nativeUI:getContentSize()
        local gap = -y
        local newRichTextList = {}
        for i=1, table.getn(self.richtextlist) do
            local y1 = self.richtextlist[i]:getPositionY()
            local h1 = self.richtextlist[i]:getRealSize().height

            if(y1 - h1 >= s.height )then
                -- 超出边界了，删！
                self.richtextlist[i]:removeFromParent()
            else
                self.richtextlist[i]:setPositionY(y1 + gap) -- 普通向上滚屏

                table.insert(newRichTextList,self.richtextlist[i])
            end
        end

        self.richtextlist = newRichTextList
    end
end

return RichTextScroll

