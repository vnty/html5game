var GameSocket = (function () {
    function GameSocket() {
        //个人数据
        this.cmd10001 = 10001;
        //通用弹出提示
        this.cmd11001 = 11001;
        //战斗
        this.cmd20001 = 20001;
        //排行榜
        this.cmd30001 = 30001;
        //NPC 面板数据
        this.cmd40001 = 40001;
        //NPC 提升属性
        this.cmd40002 = 40002;
        this.listerDic = {};
    }
    //请求我的数据
    GameSocket.prototype.reqMyData = function () {
        this.send(this.cmd10001, 1, 2);
    };

    //请求战斗
    GameSocket.prototype.reqBattle = function () {
        this.send(this.cmd10001, 1, 2);
    };

    //请求排行榜
    GameSocket.prototype.reqRank = function () {
        this.send(this.cmd10001, 1, 2);
    };

    //请求NPC
    GameSocket.prototype.reqNPC = function () {
        this.send(this.cmd40001);
    };

    //请求NPC 提升攻击力
    GameSocket.prototype.reqNPC_UpAttack = function () {
        this.send(this.cmd40002, 1);
    };

    //请求NPC 提升生命值
    GameSocket.prototype.reqNPC_UpHp = function () {
        this.send(this.cmd40002, 2);
    };

    GameSocket.prototype.send = function (id) {
        var args = [];
        for (var _i = 0; _i < (arguments.length - 1); _i++) {
            args[_i] = arguments[_i + 1];
        }
        this.urlloader = new egret.URLLoader();
        var urlreq = new egret.URLRequest();
        var msg = {};

        var myDate = new Date();

        msg.cmd = id;
        msg.user = "vnty";
        msg.time = myDate.getTimezoneOffset() + (Math.random() * 1000);
        msg.args = args;
        var test = JSON.stringify(msg);

        //访问不了是跨域问题，要不把服务器放在同一个域下，要不调低本地安全要求
        urlreq.url = "http://192.168.1.102:5658/" + test;

        //urlreq.url = "http://baidu.com";
        this.urlloader.load(urlreq);
        this.urlloader.addEventListener(egret.Event.COMPLETE, this.onComplete, this);
    };

    GameSocket.prototype.regLister = function (cmd, fun, thisObject) {
        var arr = this.listerDic[cmd];
        if (arr == null) {
            arr = [];
            this.listerDic[cmd] = arr;
        }
        arr.push({ obj: thisObject, fun: fun });
    };

    GameSocket.prototype.removeLister = function (cmd, fun) {
        var arr = this.listerDic[cmd];
        if (arr == null)
            return;
        delete arr.shift();
    };

    GameSocket.prototype.notify = function (cmd, args) {
        var arr = this.listerDic[cmd];
        if (arr == null)
            return;
        var funData;
        for (var key in arr) {
            funData = arr[key];
            funData.fun.call(funData.obj, args);
        }
    };

    GameSocket.prototype.onComplete = function (event) {
        this.parseData(this.urlloader.data);
    };

    GameSocket.prototype.parseData = function (data) {
        var obj = JSON.parse(data);
        console.log(obj.cmd);
        console.log(obj.user);
        this.notify(obj.cmd, obj.args);
    };
    return GameSocket;
})();
//# sourceMappingURL=GameSocket.js.map
