package.path = "../lua/?.lua;lua/?.lua;" .. package.path
package.cpath =  "../clibs/?.dll;clibs/?.dll;" .. package.cpath

local socketObj = {};
local json = require 'json4';

local Redis = require 'redis';
local redis = Redis.connect('127.0.0.1', 6379);

--用户信息
local cmd10001 = 10001;
--弹出信息
local cmd11001 = 11001;

--强化信息
local cmd40002 = 40002;

--注册消息
function init()
 
	--用户信息
	userHadnle();
	
	--战斗处理
	--battleHadnle();
	
	--请求排行榜
	--rankHadnle();
	
	--NPC
	npcHadnle();
end;

--逻辑服务器调用保存
function saveGameData()
	redis:save();
end;

--注册协议回调方法
function regLister(cmd, fun)
	socketObj[cmd] = fun;
end;

--发送数据
function sendData(user, cmd, args)
	local data = {};
	data.user = user;
	data.cmd = cmd;
	data.args = args;
	send(encode(data));
end;

--接受请求数据
function parseData(argsTxt)
	
	local args = decode(argsTxt);
	trace(args.cmd);
	fun	= socketObj[args.cmd];
	if(fun == nil) then
		return;
	end;

	fun(args.user, args.cmd, args);
end;

-----------------------用户信息

--用户模块
function userHadnle()
	regLister(10001, user_getData);
end;

function user_getData(user, cmd, args)
	local result = {};
	
	local isNew = redis:get(user);
	--创建账号
	if (isNew == nil) then
		redis:set(user .. "_name", "vnty");
		redis:set(user .. "_money", 1000);
		redis:set(user .. "_level", 1);
		redis:set(user .. "_exp", "0");
		redis:set(user .. "_attack", "30");
		redis:set(user .. "_hp", "100");
		
		redis:set(user, os.time());
	end;

--读取账号数据	
	result.name = redis:get(user .. "_name");
	result.money = redis:get(user .. "_money");
	result.level = redis:get(user .. "_level");
	result.exp = redis:get(user .. "_exp");

	local levelJson = getConfigItem(1, result.level);

	--运算战斗属性
	result.attack = tonumber(redis:get(user .. "_attack")) + tonumber(levelJson.attack);
	result.hp = redis:get(user .. "_hp");

	--返回客户端数据
	sendData(user, cmd10001, result)
end

function user_Msg(usre, msgType, msgValue)
	local result = {};
	result.msg = msgValue;
	result.type = msgType;
	sendData(user, cmd11001, result);
end;

------------------------NPC
--NPC模块
function npcHadnle()
	regLister(40001, npc_npcData);
	regLister(40002, npc_reqUpPro);
end;

function npc_npcData(user, cmd, args)
	
	sendData(user, 10001, result);
end;

function npc_reqUpPro(user, cmd, args)
	local result = {};
	result.attack = redis:get(user .. "_attack");
	result.hp = redis:get(user .. "_hp");
	result.money = redis:get(user .. "_money");
	if(tonumber(result.money) < 100) then
		return;
	end;
	
	result.money = tonumber(result.money) - 100;
	result.attack  = tonumber(result.attack)  + 10;
	redis:set(user .. "_money", result.money );
	redis:set(user .. "_attack", result.attack);
	user_getData(user, cmd40002, args);
end;

function getConfigItem(configName, index)
	return decode(vtyConfigGet(configName, index, 3));
end

function getConfigItemValue(configName, index)
	
end