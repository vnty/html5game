set codeFile=%~d0 
%codeFile%
cd %cd%\redis
redis-server.exe redis.conf
echo �������
cmd