-- 宝石升级

local GemUp = {
    ui = nil,
    gem = nil,
    cando = false, -- 条件是否满足
    needGemId = 0,
    needGemCount = 0,
    needCoin = 0
}

function GemUp:create()
    local nativeUI = ccs.GUIReader:shareReader():widgetFromJsonFile("res/ui/gem-up.json")
    self.ui = ui_delegate(nativeUI)
  
    ui_add_click_listener( self.ui.btn_close, function()
        self:close()
    end)
  
    self.ui.item_img_main:setTouchEnabled(true)
    ui_add_click_listener( self.ui.item_img_main, function()
        -- 选择宝石
        local filterFunc = function(v)
            local itemid = tonum(v)
            if( toint(itemid/100) <= 4 and toint(itemid/100) >= 1 and toint(itemid%100) >= 1 and toint(itemid%100) <= 15) then
                return true
            end
            return false
        end
         
        DialogManager:showSubDialog(self, "ItemSelect", filterFunc, function(k)
            self:onSelectGem(k)
        end)
    end)

    ui_add_click_listener( self.ui.btn_up, function()
        self:doGemUp()
    end)
  
    ui_add_click_listener( self.ui.btn_help, function()
        DialogManager:showSubDialog(self, "HelpDialog", HelpText:helpGemUp())
    end)
    
--    self.ui.Label_expend:setColor(cc.c3b(255,255,255))
end

function GemUp:close()
    BagUI:refreshUI()
    DialogManager:closeDialog(self)
end

function GemUp:onShow(itemid)
  
    UICommon.setItemImg(self.ui.item_img_main, 0, 0) 
  
    self.ui.pnl_require:removeAllChildren()
--    UICommon.createRichText(self.ui.pnl_require, { RTE("请选择要升级的宝石") } )
    
    self.ui.Label_expend1:setVisible(false)
    self.ui.Label_expend2:setVisible(false)
    
    self.ui.lbl_luck:setString(User.uluck)
    self.ui.luck_bar:setPercent(0)
    if(itemid~=nil) then
        self:onSelectGem( itemid )
    end
end

function GemUp:onSelectGem(k)
    self.gem = ConfigData.cfg_gem[k]
    UICommon.setItemImg(self.ui.item_img_main, k, 0, false)
    
    self.ui.Label_23:setString( self.gem.name )
    
    -- 升级条件
    self.ui.pnl_require:removeAllChildren()
--    local rtes = {RTE( "升级到下一级宝石需要：\n")}
    self.needCoin = self.gem.coin
    if(self.needCoin ~= 0) then
        self.ui.Label_expend2:setString("金币"..self.needCoin.."(当前拥有:"..User.ucoin..")")
        self.ui.Label_expend2:setVisible(true)
        if(tonum(self.needCoin) <= User.ucoin) then
           self.ui.Label_expend2:setColor(cc.c3b(255,255,255))
        else
            self.ui.Label_expend2:setColor(cc.c3b(255,0,0)) 
        end
    end
--    table.insert(rtes, RTE("金币*".. self.needCoin .. "\n"))
    
    self.needGemId = tonum(self.gem.needid)
    self.needGemCount = tonum(self.gem.count)
    if self.needGemId ~= 0 then
        local need = ConfigData.cfg_gem[self.needGemId]
--        table.insert(rtes, RTE( need.name .. "*".. self.needGemCount))
        self.ui.Label_expend1:setString( need.name.."*"..self.needGemCount.."(当前拥有:"..BagUI:getItemCount(self.needGemId)..")")
        self.ui.Label_expend1:setVisible(true)
        if(self.needGemCount <= BagUI:getItemCount(self.needGemId)) then
            self.ui.Label_expend1:setColor(cc.c3b(255,255,255))
        else
            self.ui.Label_expend1:setColor(cc.c3b(255,0,0)) 
        end
    else
        self.ui.Label_expend1:setVisible(false)
    end
--    UICommon.createRichText(self.ui.pnl_require, rtes )

    self.ui.lbl_luck:setString( string.format("%d/%d", User.uluck, tonum(self.gem.maxluck)) )
    local percent = math.min(100, 100.0 * User.uluck / self.gem.maxluck )
    self.ui.luck_bar:setPercent(percent)
end

function GemUp:doGemUp()
    if(self.gem == nil)then
        MessageManager:show("请选择要升级的宝石")
        return
    end

    local function onGemCallback(param)
        dump(param)
        if(tonum(param[1]) == 1)then
            GameUI:addUserCoin(-self.needCoin)
            if self.needGemId ~= 0 then
                BagUI:reduceItem(self.needGemId, self.needGemCount)
            end
            
            if tonum(param[2]) == 1 then
                -- 成功
                MessageManager:show("升级成功！")

                BagUI:reduceItem(self.gem.itemid,1)
                BagUI:addItem(tonum(param[3]), param[4])       
                
                User.uluck = 0
                self:onSelectGem( tonum(param[3]) )
            elseif tonum(param[2]) == 2 then
                MessageManager:show( "升级失败，幸运值增加！", cc.c3b(255,255,0) )
                User.uluck = toint(param[3])
                cclog(self.gem.itemid)
                self:onSelectGem( toint(self.gem.itemid) )
            end
            BagUI:setNeedRefresh()
--            GameUI:loadUinfo()
        else
            MessageManager:show(param[2])
        end
    end  
    sendCommand( "upGemnew", onGemCallback , {self.gem.itemid})
end

return GemUp