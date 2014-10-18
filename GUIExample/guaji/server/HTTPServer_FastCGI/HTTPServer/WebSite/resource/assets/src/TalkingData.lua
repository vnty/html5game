TalkingData={
    defaultTypeString="(S)V",
    defaultTypeInt="(I)V"
}

function TalkingData:doLogger(funcName,tableData,paramTypes) --@return typeOrObject
    if( cc.PLATFORM_OS_ANDROID == targetPlatform) then
        Platform:callNativeFunc("org/cocos2dx/lua/TalkingData",funcName,tableData,paramTypes);
    elseif(cc.PLATFORM_OS_IPAD==targetPlatform or cc.PLATFORM_OS_IPHONE==targetPlatform)then
        local function createKeyTable(t1)
            local t2={}
            local lenT1=#t1
            for var=1, lenT1 do
            	t2[tostring(var)]=t1[var];
            end
            return t2;
        end
        Platform:callNativeFunc("TalkingDataLog",funcName,createKeyTable(tableData));
    end
end

function TalkingData:setAccount(accountId)
    self:doLogger("setAccount",{accountId},self.defaultTypeString)
end
function TalkingData:setGameServer(gameServer)
    self:doLogger("setGameServer",{gameServer},self.defaultTypeString)
end
function TalkingData:setLevel(level)
    self:doLogger("setLevel",{level},self.defaultTypeInt)
end
function TalkingData:doChargeRequest(orderId,productName,money,ug,channelId)
    self:doLogger("doChargeRequest",{orderId,productName,money,ug,channelId},"(SSIIS)V")
end
function TalkingData:onChargeSuccess(orderId)
    self:doLogger("onChargeSuccess",{orderId},self.defaultTypeString)
end
function TalkingData:onReward(virtualCurrencyMoney,reason)
    self:doLogger("onReward",{virtualCurrencyMoney,reason},"(IS)V)")
end
function TalkingData:onPurchase(item,itemNumber,priceInVirtualCurrency)
    self:doLogger("onPurchase",{item,itemNumber,priceInVirtualCurrency},"(SII)V)")
end
function TalkingData:onUse(item,itemNumber)
    self:doLogger("onUse",{item,itemNumber},self.defaultTypeInt)
end
function TalkingData:onMissBegin(messionId)
    self:doLogger("onMissionBegin",{messionId},self.defaultTypeString)
end
function TalkingData:onMissComplete(messionId)
    self:doLogger("onMissionComplete",{messionId},self.defaultTypeString)
end
function TalkingData:onMissFailed(messionId,cause)
    self:doLogger("onMissionFailed",{messionId,cause},"(SS)V")
end
return TalkingData;
