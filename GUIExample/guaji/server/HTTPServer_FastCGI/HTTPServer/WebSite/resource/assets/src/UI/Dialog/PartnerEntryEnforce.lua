local PartnerEntryEnforce = {
         ui = nil
          }
          
 function PartnerEntryEnforce:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/partner_enter_enforce.json"))
    self.ui.btn_close:setTouchEnabled(true)
    self.ui.btn_public:setTouchEnabled(true)
    self.ui.btn_Expertise:setTouchEnabled(true)
    ui_add_click_listener( self.ui.btn_close,function()
        self:close()
    end)
    
    ui_add_click_listener(self.ui.btn_public, function()
        if(PartnerUI.curPartner ~= nil) then
            DialogManager:showDialog("PartnerEnforce")
        else
            MessageManager:show("正在加载，请稍候...")
        end
    end)    
    ui_add_click_listener(self.ui.btn_Expertise, function()
        if(PartnerUI.curPartner ~= nil) then
        if User.ulv >24  then
            DialogManager:showDialog("PartnerSelectTrain")
            else
            MessageManager:show("人物等级25级开启佣兵专精培养")
        end
                               
        else
            MessageManager:show("正在加载，请稍候...")
        end
    end)
    return self.ui    
 end
 
function PartnerEntryEnforce:onShow()

    --1战士 2猎人 3法师
    self.ui.lbl_name:setString(string.format("lv.%s  %s",User.ulv,PartnerUI.curPartner.name))

    UICommon.loadExternalTexture( self.ui.header_img, User.getPartnerHead(PartnerUI.curPartner) )

    local mainprop=""
    if(toint(PartnerUI.curPartner.mainp)==1) then
        
        mainprop="主属性：力量"
    elseif(toint(PartnerUI.curPartner.mainp)==2) then
        mainprop="主属性：敏捷"
    elseif(toint(PartnerUI.curPartner.mainp)==3) then
        mainprop="主属性：智力"
    end
    self.ui.main_prop:setString(mainprop)
    self.ui.lbl_job:setString( "职业："..User.getJobName(toint(PartnerUI.curPartner.mainp) ) )
    -- 刷新一下，有可能换过佣兵
    --self:refreshView()
    --self:cancel()
end
 
 
function PartnerEntryEnforce:close()
    DialogManager:closeDialog(self)
end
return PartnerEntryEnforce         