repeat
	for  i=1,100  do 
		local rnd;
		
		rnd = math.random(1000);
		if (rnd % 2) ==0 then  
			 for  j=1,36  do 
			 	rnd = math.random(1000);
				 	if (rnd % 8) ==0 then 
				 		控制台.输出 ("★");
				 	else
				 		控制台.输出 ("  ");
				 	end
			 
			 end
		end ;  
		控制台.输出 ("\n");
	end
	local attack;
	attack = tonumber(控制台.读取配置(0, 1, "生命值"));
	控制台.输出 (type(attack));
	attack = attack + 10;			
	控制台.输出 ("键入yes再一次看满天星\n");
	控制台.输出 ("测试" .. attack .. "完整");
	txt=控制台.输入()
	
until  txt ~= "yes";	

控制台.输出 ("\n","测试多个返回值","\n");

print (控制台.test())