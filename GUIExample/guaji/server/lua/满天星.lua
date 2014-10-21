math.randomseed(os.time());

for  i=1,100  do 
	local rnd,txt;
	txt=""
	rnd = math.random(1000);
	if (rnd % 2) ==0 then  
		 for  j=1,36  do 
		 	rnd = math.random(1000);
			 	if (rnd % 8) ==0 then 
			 		txt=txt.. ("бя");
			 	else
			 		txt=txt.. ("  ");
			 	end
		 
		 end
	end ;
	print (txt);
end
