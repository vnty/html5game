local PartnerSelectTrain = {
    ui = nil,
    TrainType = {0,0,0,0,0},  --"0"无锁定"1"锁定，数组的排列数表示力量、敏捷、智力、耐力、魔力
    trainNum = 0,
    Nowdb_Growth = {0,0,0,0,0},  --服务端数据
    NowpBr_Growth = {0,0,0,0,0},  --得到的随机值（首先与服务端数据相同，修改不锁定的值）
    str_type = {"power","agility","intelligence","endurance","magic"},
    Max_Growth = 0,

}
local cinside = 1

function PartnerSelectTrain:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/partner_select_train.json"))
    self.clean(self)

    
    self.ui.btn_accept:setVisible(false)
    self.ui.btn_return:setVisible(false) --保存取消按钮
    self.ui.btn_train:setVisible(true)   --培养按钮
    
    self.ui.lbl_money:setString(string.format("专精培养消耗：%d金",toint(User.ulv/5)*5000))  --金币消耗
    self.ui.lbl_diamond:setString(string.format("每锁定一条属性消耗：%d钻石",20)) 
    self.Max_Growth =(toint(User.ulv/5))*0.1+0.1   --成长的最大值
    self:onShow()       
    
    ui_add_click_listener( self.ui.btn_close,function()
        self:close()
    end)
    ---专精培养
    ui_add_click_listener(self.ui.btn_train,function()
        self.Max_Growth =(toint(User.ulv/5))*0.1+0.1   --成长的最大值
        self:ParnterTrain()
    end)
    
    
    ---保存专精
    ui_add_click_listener( self.ui.btn_accept,function()
        self.ui.btn_train:setVisible(true)
        self.ui.btn_accept:setVisible(false)
        self.ui.btn_return:setVisible(false)
        self:accept() 
    end)
    ---取消专精
    ui_add_click_listener( self.ui.btn_return,function()
        self.ui.btn_train:setVisible(true) 
        self.ui.btn_accept:setVisible(false)
        self.ui.btn_return:setVisible(false)
        self:cancel() 
    end)

    ui_add_click_listener( self.ui.btn_help,function()
        DialogManager:showDialog("HelpDialog", HelpText:helpPartnerZhuanjing())
    end)
    
    return self.ui
 end
 
 
function PartnerSelectTrain:onShow()
    local function getonoldzhuanjing(szhuan)
        if(szhuan[1]==1) then
        self.Nowdb_Growth = szhuan[2]
        dump(self.Nowdb_Growth)                                      --服务端原值数组赋值给self.nowdb_growth
        local i_dex = 1
        while i_dex<6 do
          if (100*self.Nowdb_Growth[i_dex]/self.Max_Growth)>60 then
                 self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setVisible(false)
                 self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setVisible(true)
                 self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setPercent(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)
            else
                 self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setVisible(false)
                 self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setVisible(true)
                 self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setPercent(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)
            end
            self.ui[string.format("lbl_%s",self.str_type[i_dex])]:setString(string.format("%s/%s",self.Nowdb_Growth[i_dex],self.Max_Growth))    
            i_dex = i_dex + 1
        end
            self.ui.lbl1_power:setString(string.format("每100点力量额外提升%s点物抗",100*self.Nowdb_Growth[1]))
            self.ui.lbl1_agility:setString(string.format("每100点敏捷额外提升%s点暴击",150*self.Nowdb_Growth[2]))
            self.ui.lbl1_intelligence:setString(string.format("每100点智力额外提升%s点魔抗",100*self.Nowdb_Growth[3]))
            self.ui.lbl1_endurance:setString(string.format("每100点耐力额外提升%s点生命值",1000*self.Nowdb_Growth[4]))
            self.ui.lbl1_magic:setString(string.format("佣兵等级%s级额外提升%s点魔法值",User.ulv,toint(User.ulv*20*self.Nowdb_Growth[5])))
        else --错误
            MessageManager:show(szhuan[2])
        end
    end
    sendCommand("getoldzhuanjing",getonoldzhuanjing,{PartnerUI.curPartner.partnerid})--param) 
 
 	
 end
 
 
---专精培养花费
function PartnerSelectTrain:costMoney(trainNum)
    --扣去身上的金币和钻石
    MessageManager:showMessageNode(self.ui.btn_train,string.format("金币-%s金",toint(User.ulv/5) * 5000), cc.c3b(255,255,0))
    if trainNum>0 then
        Scheduler.performWithDelayGlobal(function()
            MessageManager:showMessageNode(self.ui.btn_train,string.format("钻石-%s钻石",trainNum*20), cc.c3b(255,255,0))
        end, 0.5) 
    end
    GameUI:addUserCoin(-User.ulv * 1000)
    GameUI:addUserUg(-20*(trainNum))
end
 
 
function PartnerSelectTrain:ParnterTrain()
    local uid = User.uid
    local param = {0,0,0,0,0,0,0}
    param[1] = PartnerUI.curPartner.partnerid
    if self.ui.checkbox_power:getSelectedState()==true then   --力量 
        self.TrainType[1] = 0                                  --0表示锁定
        param[2] = 0
    else
        self.TrainType[1] = 1 
        param[2] = 1     
    end
    if self.ui.checkbox_agility:getSelectedState()==true then  --敏捷
        self.TrainType[2] = 0
        param[3] = 0
    else
        self.TrainType[2] = 1   
        param[3] = 1     
    end
    if self.ui.checkbox_intelligence:getSelectedState()==true then  --智力
        self.TrainType[3] = 0 
        param[4] = 0
    else
        self.TrainType[3] = 1
        param[4] = 1        
    end
    if self.ui.checkbox_endurance:getSelectedState()==true then  --耐力
        self.TrainType[4] = 0 
        param[5] = 0
    else
        self.TrainType[4] = 1 
        param[5] = 1       
    end
    if self.ui.checkbox_magic:getSelectedState()==true then     --魔力
        self.TrainType[5] = 0 
        param[6] = 0
    else
        self.TrainType[5] = 1  
        param[6] = 1      
    end
    --   
    self.trainNum = 0                                           --专精锁定的个数
    local dex_i = 1
    while dex_i<6 do
        if self.TrainType[dex_i]==0 then
            self.trainNum = self.trainNum + 1
        end 
        dex_i = dex_i + 1
    end
    param[7] = self.trainNum
    local function onskillzhuangjing(res)                         --服务端得到随机值赋值给self.NowpBr_Growth
        if(res[1]==1) then
        
            self.ui.btn_accept:setVisible(true)
            self.ui.btn_return:setVisible(true)
            self.ui.btn_train:setVisible(false)
            
            self.NowpBr_Growth = res[2]
            PartnerUI.curPartner.newzhuanjingProps = res[2]
            self.costMoney(self,self.trainNum)
            cinside = 0                                          --判断有无出错标志位
            self.ui.lbl1_power:setString(string.format("每100点力量额外提升%s点物抗",100*self.NowpBr_Growth[1]))
            self.ui.lbl1_agility:setString(string.format("每100点敏捷额外提升%s点暴击",150*self.NowpBr_Growth[2]))
            self.ui.lbl1_intelligence:setString(string.format("每100点智力额外提升%s点魔抗",100*self.NowpBr_Growth[3]))
            self.ui.lbl1_endurance:setString(string.format("每100点耐力额外提升%s点生命值",1000*self.NowpBr_Growth[4]))
            self.ui.lbl1_magic:setString(string.format("佣兵等级%s级额外提升%s点魔法值",User.ulv,toint(User.ulv*20*self.Nowdb_Growth[5])))
        else --错误
            MessageManager:show(res[2])
            cinside = 1
        end
        Scheduler.performWithDelayGlobal(function()
            if(cinside == 0) then
                local function getonoldzhuanjing(szhuan)
                    dump(szhuan)
                    if(szhuan[1]==1) then
                        --self.ui.lbl_diamond:setString(string.format("锁定%d个属性消耗：%d钻石",self.trainNum ,self.trainNum*20)) 
                        self.Nowdb_Growth = szhuan[2]
                        dump(self.Nowdb_Growth)    --服务端原值数组赋值给self.nowdb_growth
                        local dex_m = 1
                        while dex_m < 6 do
                            if self.TrainType[dex_m]==1 then                            --未锁定
                                self.TrainProgressBar(self,self.Nowdb_Growth,self.NowpBr_Growth,dex_m)          --进度条及其上面的进度比例  
                            end
                            dex_m = dex_m + 1
                        end 
                    else --错误
                        MessageManager:show(szhuan[2])
                    end
                end
                sendCommand("getoldzhuanjing",getonoldzhuanjing,{PartnerUI.curPartner.partnerid})--param) 
            end
        end,0)
    end
    sendCommand("skillzhuanjing",onskillzhuangjing,param)
    
 end
 
--进度条及其上面的进度比例
function PartnerSelectTrain:TrainProgressBar(Nowdb_Growth,NowpBr_Growth,dex_m)--dex_m表示属性
    --得到5个属性的专精提升值   
    if (Nowdb_Growth[dex_m])<(NowpBr_Growth[dex_m]) then--原值小于培养值
        if(100*self.Nowdb_Growth[dex_m]/self.Max_Growth)>60 then
            self.ui[string.format("ProgressBar_%s_1",self.str_type[dex_m])]:setVisible(false)
            self.ui[string.format("ProgressBar_%s",self.str_type[dex_m])]:setVisible(true)
            self.ui[string.format("ProgressBar_%s",self.str_type[dex_m])]:setPercent(100*Nowdb_Growth[dex_m]/self.Max_Growth)
        else
            self.ui[string.format("ProgressBar_%s",self.str_type[dex_m])]:setVisible(false)
        self.ui[string.format("ProgressBar_%s_1",self.str_type[dex_m])]:setVisible(true)
            self.ui[string.format("ProgressBar_%s_1",self.str_type[dex_m])]:setPercent(100*Nowdb_Growth[dex_m]/self.Max_Growth)
        end 
        self.ui[string.format("Image_red_%s",self.str_type[dex_m])]:setVisible(false)
        self.ui[string.format("Image_green_%s",self.str_type[dex_m])]:setVisible(true)
        self.ui[string.format("Image_green_%s",self.str_type[dex_m])]:setContentSize(336*NowpBr_Growth[dex_m]/self.Max_Growth,42)
        self.ui[string.format("lbl_%s",self.str_type[dex_m])]:setString(string.format("%s->%s",Nowdb_Growth[dex_m],NowpBr_Growth[dex_m]))

    elseif (Nowdb_Growth[dex_m])>=(NowpBr_Growth[dex_m]) then--原值大于培养值
        if(100*self.Nowdb_Growth[dex_m]/self.Max_Growth)>60 then
            self.ui[string.format("ProgressBar_%s_1",self.str_type[dex_m])]:setVisible(false)
        self.ui[string.format("ProgressBar_%s",self.str_type[dex_m])]:setVisible(true)
            self.ui[string.format("ProgressBar_%s",self.str_type[dex_m])]:setPercent(100*NowpBr_Growth[dex_m]/self.Max_Growth)
        else
           self.ui[string.format("ProgressBar_%s",self.str_type[dex_m])]:setVisible(false)
    self.ui[string.format("ProgressBar_%s_1",self.str_type[dex_m])]:setVisible(true)
           self.ui[string.format("ProgressBar_%s_1",self.str_type[dex_m])]:setPercent(100*NowpBr_Growth[dex_m]/self.Max_Growth)
        end 
    self.ui[string.format("Image_green_%s",self.str_type[dex_m])]:setVisible(false)
    self.ui[string.format("Image_red_%s",self.str_type[dex_m])]:setVisible(true)
    self.ui[string.format("Image_red_%s",self.str_type[dex_m])]:setContentSize(336*Nowdb_Growth[dex_m]/self.Max_Growth,42)
    self.ui[string.format("lbl_%s",self.str_type[dex_m])]:setString(string.format("%s->%s",Nowdb_Growth[dex_m],NowpBr_Growth[dex_m]))
    end

    --self.NowpBr_Growth[dex_m] = self.Nowdb_Growth[dex_m]
end
  
function PartnerSelectTrain:accept()
    local uid = User.uid
    local function oncomfirmzhuanjing()
        PartnerUI.curPartner.oldzhuanjingProps = PartnerUI.curPartner.newzhuanjingProps
        PartnerUI:refreshView()
    end
    sendCommand("comfirmzhuanjing",oncomfirmzhuanjing,{PartnerUI.curPartner.partnerid})
    local function getonoldzhuanjing(szhuan)
        if(szhuan[1]==1) then
            --TODO 跳字
            self.Nowdb_Growth = szhuan[2]
            dump(self.Nowdb_Growth)                                      --服务端原值数组赋值给self.nowdb_growth
            local i_dex = 1
            while i_dex<6 do
                if(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)>60 then
                    self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setVisible(false)
                    self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setVisible(true)
                    self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setPercent(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)
                else
                    self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setVisible(false)
                    self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setVisible(true)
                    self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setPercent(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)
                end 
                self.ui[string.format("lbl_%s",self.str_type[i_dex])]:setString(string.format("%s/%s",self.Nowdb_Growth[i_dex],self.Max_Growth)) 
                i_dex = i_dex + 1
            end
            self.ui.lbl1_power:setString(string.format("每100点力量额外提升%s点物抗",100*self.Nowdb_Growth[1]))
            self.ui.lbl1_agility:setString(string.format("每100点敏捷额外提升%s点暴击",150*self.Nowdb_Growth[2]))
            self.ui.lbl1_intelligence:setString(string.format("每100点智力额外提升%s点魔抗",100*self.Nowdb_Growth[3]))
            self.ui.lbl1_endurance:setString(string.format("每100点耐力额外提升%s点生命值",toint(1000*self.Nowdb_Growth[4])))
            self.ui.lbl1_magic:setString(string.format("佣兵等级%s级额外提升%s点魔法值",User.ulv,toint(User.ulv*20*self.Nowdb_Growth[5])))
        else --错误
            MessageManager:show(szhuan[2])
        end
    end
    sendCommand("getoldzhuanjing",getonoldzhuanjing,{PartnerUI.curPartner.partnerid})--param) 
    -- end
    
    
   -- local function onComfirmPartner()
   --     local old = clone(PartnerUI.curPartner.oldProps)
   --     local new = clone(PartnerUI.curPartner.newProps)
   --     User.updateSecondProps(old,PartnerUI.curPartner.mainp, User.ulv)
   --     User.updateSecondProps(new,PartnerUI.curPartner.mainp, User.ulv)
   --     MessageManager:showEquipChange(old,new)

   --     PartnerUI.curPartner.oldProps = PartnerUI.curPartner.newProps
   --     PartnerUI:refreshView()
   --     self:refreshView()
  --      self:cancel()
  --  end

   -- sendCommand("comfirmPartner",onComfirmPartner,{PartnerUI.curPartner.partnerid})
    self.clean(self)
end

function PartnerSelectTrain:cancel()
    local function getonoldzhuanjing(szhuan)
        if(szhuan[1]==1) then
            self.Nowdb_Growth = szhuan[2]
            dump(self.Nowdb_Growth)                                      --服务端原值数组赋值给self.nowdb_growth
            local i_dex = 1
            while i_dex<6 do
                if(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)>60 then
                    self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setVisible(false)
                    self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setVisible(true)
                    self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setPercent(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)
                else
                    self.ui[string.format("ProgressBar_%s",self.str_type[i_dex])]:setVisible(false)
                    self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setVisible(true)
                    self.ui[string.format("ProgressBar_%s_1",self.str_type[i_dex])]:setPercent(100*self.Nowdb_Growth[i_dex]/self.Max_Growth)
                end 
                self.ui[string.format("lbl_%s",self.str_type[i_dex])]:setString(string.format("%s/%s",self.Nowdb_Growth[i_dex],self.Max_Growth)) 
                i_dex = i_dex + 1
            end
            self.ui.lbl1_power:setString(string.format("每100点力量额外提升%s点物抗",100*self.Nowdb_Growth[1]))
            self.ui.lbl1_agility:setString(string.format("每100点敏捷额外提升%s点暴击",150*self.Nowdb_Growth[2]))
            self.ui.lbl1_intelligence:setString(string.format("每100点智力额外提升%s点魔抗",100*self.Nowdb_Growth[3]))
            self.ui.lbl1_endurance:setString(string.format("每100点耐力额外提升%s点生命值",1000*self.Nowdb_Growth[4]))
            self.ui.lbl1_magic:setString(string.format("佣兵等级%s级额外提升%s点魔法值",User.ulv,toint(User.ulv*20*self.Nowdb_Growth[5])))
        else --错误
            MessageManager:show(szhuan[2])
        end
    end
    sendCommand("getoldzhuanjing",getonoldzhuanjing,{PartnerUI.curPartner.partnerid})--param)

     self.clean(self)
end
 
function PartnerSelectTrain:clean()
    local dex_i = 1
	while dex_i<6 do
        self.ui[string.format("Image_green_%s",self.str_type[dex_i])]:setVisible(false)
        self.ui[string.format("Image_red_%s",self.str_type[dex_i])]:setVisible(false)
        dex_i = dex_i + 1
	end
end
 
function PartnerSelectTrain:close()
    DialogManager:closeDialog(self)
end
return PartnerSelectTrain