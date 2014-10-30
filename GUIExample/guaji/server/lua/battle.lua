function battle(my, target)
	--报告
	local report = "";
	--计次
	local i = 0;
	--对象类型
	local targetType = 0;   

	math.randomseed(os.time())  
	
	while (my.hp > 0) and (target.hp > 0) do
	
		targetType = i % 2;
		
		if targetType == 0 then
			report = report .. "若风 对 暗夜树精 造成" .. getHurt(my, target)  .. "伤害\n";
			end;
		
		if targetType == 1 then
			report = report .. "暗夜树精 对 若风 造成" .. getHurt(target, my) .. "伤害\n";
			end;
		report = report .. "若风HP: " .. my.hp .. "\n暗夜树精HP: " .. target.hp .. "\n"
		report = report .. "-----------------------------\n"
		i = i + 1;	
	end;
		
	控制台.输出(report);
end

function getHurt(my, target)

	local hurt;
	local baseHurt;
	local skillHurt;
	-------------------常量
	-- 防御最高值
	local CONSTANT_DEFMAX = 10000;
	
	--伤害 攻击减去对方防御
	hurt = math.random(my.attack, my.attackMax) - target.def;
	--基础攻击伤害 攻击1/4
	baseHurt = my.attack * 0.25;
	--技能伤害 直接比例
	skillHurt = 2;
		
	--伤害大于基础伤害 伤害为：（己方攻击-对方防御）*技能伤害
	if hurt >= baseHurt then
		hurt = hurt * skillHurt;
	end
		
	--伤害少于基础伤害 攻击*25%*(1-敌方防御/10000)*技能伤害
	if  hurt < baseHurt then
		hurt = baseHurt * (1 - target.def / CONSTANT_DEFMAX) * skillHurt;
	end	
	
	target.hp = target.hp - hurt;
	if target.hp < 0 then
		target.hp = 0;
	end;
		
	return hurt;
end

function init()

    local my = {};
	--攻击
	my.attack = 10;
	my.attackMax = 100;
	--防御
	my.def = 5;
	my.defMax = 50;
	--魔抗
	my.mdef = 5;
	my.defMax = 50;
	--生命值
	my.hp = 10000;
	my.hpMaX = 10000;
	--魔法值
	my.mp = 200;
	my.mpMax = 200;
	--闪避
	my.duck = 10;
	--暴击
	my.crit = 10;
	--韧性
	my.ten = 10;
	--命中
	my.hit = 10;
	
	local target = {};
	--攻击
	target.attack = 10;
	target.attackMax = 100;
	--防御
	target.def = 5;
	target.defMax = 50;
	--魔抗
	target.mdef = 5;
	target.defMax = 50;
	--生命值
	target.hp = 3000;
	target.hpMaX = 3000;
	--魔法值
	target.mp = 200;
	target.mpMax = 200;
	--闪避
	target.duck = 10;
	--暴击
	target.crit = 10;
	--韧性
	target.ten = 10;
	--命中
	target.hit = 10;
	
	battle(my, target);
end

