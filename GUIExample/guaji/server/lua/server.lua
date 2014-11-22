/*
local socketObj = {};
local redis = require 'redis';
local client = redis.connect('127.0.0.1', 6379);

function init()
 
	--用户信息
	userHadnle();
	
	--战斗处理
	battleHadnle();
	
	--请求排行榜
	rankHadnle();
	
	--NPC
	npcHadnle();
end;

function sendData(user, cmd, args)

end;

function parseData(user, cmd, args)
	
	fun	= socketObj[cmd];
	userHadnle(user, cmd, args);
end;

function userHadnle()
 
	regLister(10001, user_getData);
end;


function user_getData(user, cmd, args)
	local result = {};
	
	result.name = redis.get(user .. "_money");
	result.money = redis.get(user .. "_money");
	result.level = redis.get(user .. "_level");
	result.exp = redis.get(user .. "_exp");

	--战斗属性
	result.attack = redis.get(user .. "_attack");
	result.hp = redis.get(user .. "_hp");

	sendData(user, 10001, result)
end

function npcHadnle()

	regLister(40001, npc_npcData);
	regLister(40002, npc_reqUpPro);
end;

function npc_reqUpPro()
{

}

function regLister(cmd, fun)
	socketObj[cmd] = fun;
end;

*/