package.path = "../lua/?.lua;lua/?.lua;" .. package.path
package.cpath =  "../clibs/?.dll;clibs/?.dll;" .. package.cpath

local settings = {
    host     = '127.0.0.1',
    port     = os.getenv("REDIS_PORT") or 6379,
    database = 14,
    password = nil,
}

function init()
	local my = {};
	my.name = "张学友";
	my.hp = 1000;
	
	local json = require 'json';
	
	print(json:encode(my));
	
	
	local redis = require 'redis';
	print("1" ); 
	local client = redis.connect('127.0.0.1', 6379);
	print("2" );
	local response = client:ping();
	local name = client:get("name");
	print(response);
	print(name);
end;
