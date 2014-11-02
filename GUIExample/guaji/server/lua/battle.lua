

function battle(my, targetList)
	--报告
	local report = "";
	--计次
	local i = 0;
	--对象类型
	local targetType = 0;   
	local target;
	math.randomseed(os.time())  
	
	while (checkDie(my, targetList) == false) do
		
		targetType = i % 4;
		
		if targetType == 0 then
			target = getRandomTarget(targetList);
			if (target ~= nil) then
				report = report .. "若风 对 " .. target.name .. " 造成" .. getHurt(my, target)  .. "伤害\n";
			end;
			report = "使用技能 " .. useSkill(my, targetList) .. "\n";
		end;
		
		if targetType > 0 then
			target = targetList[targetType - 1];
			if (target.hp > 0) then
				report = report .. target.name .. " 对 若风 造成" .. getHurt(target, my) .. "伤害\n";
			end;
			
		end;
		
		report = report .. "-----------------------------\n";
		report = report .. showHp(my, targetList);
		report = report .. "-----------------------------\n";
		i = i + 1;	
	end;
		
	--控制台.输出(report);
	--控制台.输出(toTable(config).name);
	--控制台.输出(table2json(toTable(config)));
end;

--显示所有对象的生命值
function showHp(my, targetList)
	local report = "";
	report = report .. " --> 若风 HP: " .. my.hp .. "\n" 
	
	report = report .." --> ";
	for i = 0, 2 do
		report = report .. targetList[i].name .. " HP: " .. targetList[i].hp .. "   "
	end;
	
	return report .. "\n";
end;

--获取随机没死的目标
function getRandomTarget(targetList)
	local relust = false;
	local target;
	local index;
	
	while(relust == false) do
		index = math.random(0,2);
		target = targetList[index];
		if(target.hp > 0) then
			relust = true;
		end;
	end;
	
	return target;
end

--判断是否其中一个阵营失败
function checkDie(my, targetList)

	--自身阵营
	if my.hp <= 0 then
		return true;
	end;

	--对方阵营
	local i;
	--假设全死了
	local dieAll = true;
	
	for i = 0, 2 do
		if(targetList[i].hp > 0) then
			dieAll = false;
		end;
	end;
	
	if dieAll == true then
		return true;
	end;
	
	--前面都没返回就执行到这里返回FALSE即可
	return false;
end

function useSkill(my, targetList)
	local index = math.random(1, 3);
	local skillComVo = toolsToTable(控制台.读取配置(3, index, ""));
	local skillList = toolsStringSplit(skillComVo.com, "_");
	local skillConfig;
	local i;
	local skillName;
	for i = 1,toolsTableLen(skillList) do
		skillConfig = toolsToTable(控制台.读取配置(2, skillList[i], ""));
		skillName = skillConfig.name;
	end;
	
	return skillName;
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
	my.hp = 1000;
	my.hpMaX = 1000;
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
	
	local targetList = {};
	local target = {};
	local i = 0;

	for i = 0,2 do
		target = {};
		
		target.name = "暗夜树精" .. i;
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
		target.hp = 300;
		target.hpMaX = 300;
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
		
		targetList[i] = target;
	end;
	
	battle(my, targetList);
end

--数据还原成表格
function toolsToTable(config)
	local obj = {};
	local list = toolsStringSplit(config, ",");
	local i;
	local key;

	for i = 1, (toolsTableLen(list) / 2)do
		key = list[i * 2 - 1] ;
		value = list[i * 2] ;
		obj[key .. ""] = value;
	end;
	return obj;
end

--获取表格长度
function toolsTableLen(list)
	local count = 0;

	for k,v in pairs(list) do
		count = count + 1;
	end
	
	return count;
end

--分割文本
function toolsStringSplit(szFullString, szSeparator)  
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}  
		
	while true do  
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
	   if not nFindLastIndex then  
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
		break  
	   end  
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
	   nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end  

--表格到JSON
function toolsTable2json(t)  
        local function serialize(tbl)  
                local tmp = {}  
                for k, v in pairs(tbl) do  
                        local k_type = type(k)  
                        local v_type = type(v)  
                        local key = (k_type == "string" and "\"" .. k .. "\":")  
                            or (k_type == "number" and "")  
                        local value = (v_type == "table" and serialize(v))  
                            or (v_type == "boolean" and tostring(v))  
                            or (v_type == "string" and "\"" .. v .. "\"")  
                            or (v_type == "number" and v)  
                        tmp[#tmp + 1] = key and value and tostring(key) .. tostring(value) or nil  
                end  
                if tableLen(tbl) == 0 then  
                        return "{" .. table.concat(tmp, ",") .. "}"  
                else  
                        return "[" .. table.concat(tmp, ",") .. "]"  
                end  
        end  
        assert(type(t) == "table")  
        return serialize(t)  
end  

