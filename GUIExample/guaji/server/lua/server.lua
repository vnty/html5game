function parseData(user, cmd, args)

	--用户信息
	if (cmd >= 10000 && cmd < 20000)then
		userHadnle(user, cmd, args);
	end;
	
	--战斗处理
	if (cmd >= 20000 && cmd < 30000)then
		battleHadnle(user, cmd, args);
	end;
	
	--请求排行榜
	if (cmd >= 30000 && cmd < 40000)then
		rankHadnle(user, cmd, args);
	end;
	
	--NPC
	if (cmd >= 40000 && cmd < 50000)then
		npcHadnle(user, cmd, args);
	end;
end;

function userHadnle()

end;