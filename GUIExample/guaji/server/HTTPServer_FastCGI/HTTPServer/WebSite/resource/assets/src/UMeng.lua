UMeng = {
}

-- 充值
function UMeng:pay(money, ug, source)
--public static void pay(double, double, int);
--Signature: (DDI)V
-- 参数中带有double类型的java函数不能直接调用，会出错

    if( cc.PLATFORM_OS_ANDROID == targetPlatform ) then
        local luaj = require "luaj"
        local ok,ret  = luaj.callStaticMethod("org/cocos2dx/lua/AppUtils","LogPay",{money, ug, source},"(III)V")
        --local ok,ret  = luaj.callStaticMethod("com/umeng/analytics/game/UMGameAgent","pay",{money, ug, source},"(DDI)V")
        if not ok then
            error("UMeng:pay error:", ret)
        end
    else
    end
end

-- 充值并且直接购买
function UMeng:payAndBuyItem(money,item,num,ug,source)
--public static void pay(double, java.lang.String, int, double, int);
--Signature: (DLjava/lang/String;IDI)V
end

-- 商城购买道具
function UMeng:buy(item,num,price)
--public static void buy(java.lang.String, int, double);
--Signature: (Ljava/lang/String;ID)V
end

-- 使用道具
function UMeng:use(item,num,price)
--public static void use(java.lang.String, int, double);
--Signature: (Ljava/lang/String;ID)V
end

-- 日常奖励金币
function UMeng:bonus(coin, trigger)
-- public static void bonus(double, int);
--   Signature: (DI)V
end

-- 日常奖励道具
function UMeng:bonusItem(item,num,price,trigger)
--public static void bonus(java.lang.String, int, double, int);
  --Signature: (Ljava/lang/String;IDI)V
end

-- 玩家等级
function UMeng:setPlayerLevel(level)
    if( cc.PLATFORM_OS_ANDROID == targetPlatform ) then
        local luaj = require "luaj"
        local ok,ret  = luaj.callStaticMethod("com/umeng/analytics/game/UMGameAgent","setPlayerLevel",{level},"(Ljava/lang/String;)V")
        if not ok then
            error("UMeng:setPlayerLevel error:", ret)
        end
    else
    end
end 

-- 开始地图等级
function UMeng:startLevel(lv)
    if( cc.PLATFORM_OS_ANDROID == targetPlatform ) then
        local luaj = require "luaj"
        local ok,ret  = luaj.callStaticMethod("com/umeng/analytics/game/UMGameAgent","startLevel",{lv},"(Ljava/lang/String;)V")
        if not ok then
            error("UMeng:startLevel error:", ret)
        end
    else
    end
end

-- 完成地图等级
function UMeng:finishLevel(lv)
    if( cc.PLATFORM_OS_ANDROID == targetPlatform ) then
        local luaj = require "luaj"
        local ok,ret  = luaj.callStaticMethod("com/umeng/analytics/game/UMGameAgent","finishLevel",{lv},"(Ljava/lang/String;)V")
        if not ok then
            error("UMeng:finishLevel error:", ret)
        end
    else
    end
end

-- 挑战地图等级失败
function UMeng:failLevel(lv)

end


return UMeng