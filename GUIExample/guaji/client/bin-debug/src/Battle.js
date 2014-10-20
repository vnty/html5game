/**
 * Created by Administrator on 2014/10/14.
 */
var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var Battle = (function (_super) {
    __extends(Battle, _super);
    function Battle() {
        _super.call(this);
        //名字，资源，等级，攻击，血量
        this.gameData = [['若风', 'hero_003', '38', '1000', '10000']];
        //名字，资源，等级，攻击，血量
        this.monsterData = [['血环弓箭手', '10060', '41', '500', '5000'], ['血环暗法师', '10061', '40', '400', '4000'], ['狂爪龙人', '10062', '39', '300', '3000'], ['尖石掠夺者', '10063', '38', '200', '2000'], ['尖塔蜘蛛', '10064', '37', '100', '1000']];
        this.battleData = [];
        this.unitDic = [];
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    Battle.prototype.onAddToStage = function (event) {
        this.skinName = ui.BattleSkin;
        var battleType = this["type"];
        battleType.source = "img_131_02";
        //this.drawBattleData();
        this.attackBtn = this["attackBtn"];
        this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.btnTouchHandler, this);
        this.initBattle();
    };
    Battle.prototype.btnTouchHandler = function (evt) {
        switch (evt.target) {
            case this.attackBtn:
                console.log("attackBtn");
                var vo = this.unitDic[3];
                vo.hp -= 100;
                if (vo.hp < 0)
                    vo.hp = 0;
                this.upDataRoleHp();
                this.attackEffect();
                break;
        }
    };
    //初始战斗
    Battle.prototype.initBattle = function () {
        this.initRole();
        this.initMonster();
    };
    //初始角色
    Battle.prototype.initRole = function () {
        var roleUI;
        var vo;
        var index = 0;
        vo = new UnitVo;
        vo.uid = 0;
        vo.name = this.gameData[index][0];
        vo.res = this.gameData[index][1];
        vo.level = Number(this.gameData[index][2]);
        vo.attack = Number(this.gameData[index][3]);
        vo.hp = vo.hpMax = Number(this.gameData[index][4]);
        roleUI = this["role1"];
        this.setData(roleUI, vo);
        this.unitDic[0] = vo;
    };
    Battle.prototype.upDataRoleHp = function () {
        var vo = this.unitDic[3];
        var roleUI;
        roleUI = this["role3"];
        var hpBar = roleUI["hp"];
        var hpText = roleUI["hpText"];
        hpBar.scaleX = vo.hp / vo.hpMax;
        hpText.text = vo.hp + "/" + vo.hpMax;
        var decHp = roleUI["decHp"];
        decHp.text = "-100";
        decHp.visible = true;
        this.tw = egret.Tween.get(decHp);
        this.tw.to({ y: -17 }, 2000);
        this.tw.call(this.decHpComplete, decHp);
    };
    Battle.prototype.decHpComplete = function (target) {
        target.y = 17;
        target.visible = false;
    };
    Battle.prototype.attackEffect = function () {
        var roleUI;
        roleUI = this["role1"];
        var targetUI;
        targetUI = this["role3"];
        var ags = { role: '1', tx: 14 };
        this.tw = egret.Tween.get(roleUI);
        this.tw.to({ x: 14 + 50 }, 300);
        this.tw.call(this.moveComplete, roleUI, ags);
        var ags = { role: '3', tx: 467 };
        this.tw = egret.Tween.get(targetUI);
        this.tw.to({ x: 467 + 25 }, 300);
        this.tw.call(this.moveComplete, targetUI, ags);
    };
    Battle.prototype.moveComplete = function (target, ags) {
        var id = "role" + ags.role;
        var tx = ags.tx;
        this.tw = egret.Tween.get(target);
        this.tw.to({ x: tx }, 150);
    };
    //初始怪物
    Battle.prototype.initMonster = function () {
        var roleUI;
        var vo;
        for (var i = 0; i < 3; i++) {
            var index = Math.round(Math.random() * this.monsterData.length) - 1;
            console.debug(index + '');
            if (index == -1)
                index = 0;
            vo = new UnitVo;
            vo.uid = i;
            vo.name = this.monsterData[index][0];
            vo.res = this.monsterData[index][1];
            vo.level = Number(this.monsterData[index][2]);
            vo.attack = Number(this.monsterData[index][3]);
            vo.hp = vo.hpMax = Number(this.monsterData[index][4]);
            this.unitDic[3 + i] = vo;
            roleUI = this["role" + (i + 3)];
            this.setData(roleUI, vo);
        }
    };
    //设置数据 为空就隐藏
    Battle.prototype.setData = function (target, vo) {
        if (vo === void 0) { vo = null; }
        if (vo == null) {
            this.visible = false;
            return;
        }
        target["data"].text = "lv:" + vo.level + '   ' + vo.name;
        target["pic"].source = vo.res;
    };
    Battle.prototype.drawBattleData = function () {
        this.visible = false;
    };
    return Battle;
})(egret.gui.Panel);
