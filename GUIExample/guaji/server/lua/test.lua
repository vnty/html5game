repeat
	for  i=1,100  do 
		local rnd;
		
		rnd = math.random(1000);
		if (rnd % 2) ==0 then  
			 for  j=1,36  do 
			 	rnd = math.random(1000);
				 	if (rnd % 8) ==0 then 
				 		����̨.��� ("��");
				 	else
				 		����̨.��� ("  ");
				 	end
			 
			 end
		end ;  
		����̨.��� ("\n");
	end
	local attack;
	attack = tonumber(����̨.��ȡ����(0, 1, "����ֵ"));
	����̨.��� (type(attack));
	attack = attack + 10;			
	����̨.��� ("����yes��һ�ο�������\n");
	����̨.��� ("����" .. attack .. "����");
	txt=����̨.����()
	
until  txt ~= "yes";	

����̨.��� ("\n","���Զ������ֵ","\n");

print (����̨.test())