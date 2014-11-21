var GameSocket = (function () {
    function GameSocket() {
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
    };

    GameSocket.prototype.parseData = function () {
    };
    return GameSocket;
})();
//# sourceMappingURL=GameSocket.js.map
