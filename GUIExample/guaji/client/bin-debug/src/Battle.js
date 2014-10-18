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
        this.gameData = [['若风', '3', '38', '1000', '10000']];
        //名字，资源，等级，攻击，血量
        this.monsterData = [
            ['血环弓箭手', '36', '41', '500', '5000'],
            ['血环暗法师', '35', '40', '400', '4000'],
            ['狂爪龙人', '34', '39', '300', '3000'],
            ['尖石掠夺者', '32', '38', '200', '2000'],
            ['尖塔蜘蛛', '21', '37', '100', '1000']];
        this.battleData = [];
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    Battle.prototype.onAddToStage = function (event) {
        this.skinName = ui.BattleSkin;

        var battleType = this["type"];
        battleType.source = "img_131_02";

        var roleUI;
        var roleBmp;
        var i;
        for (i = 0; i < 1; i++) {
            roleBmp = new egret.gui.UIAsset;
            roleBmp.source = 'hero_003';
            roleUI = this["role1"];
            roleBmp.x = roleUI.x;
            roleBmp.y = roleUI.y;
            //this.addElementAt(roleBmp, 0);
        }

        this.initBattle();
        //this.drawBattleData();
    };

    //初始战斗
    Battle.prototype.initBattle = function () {
        this.initRole();
        this.initMonster();
    };

    //初始角色
    Battle.prototype.initRole = function () {
    };

    //初始怪物
    Battle.prototype.initMonster = function () {
        var roleUI;
        var vo;
        for (var i = 0; i < 3; i++) {
            var index = 0;
            vo = new UnitVo;
            vo.uid = i;
            vo.name = this.monsterData[index][0];
            vo.res = this.monsterData[index][1];
            vo.level = Number(this.monsterData[index][2]);
            vo.attack = Number(this.monsterData[index][3]);
            vo.hp = vo.hpMax = Number(this.monsterData[index][4]);
            vo.res = this.monsterData[index][1];

            roleUI = this["role" + (i + 3)];
            this.setData(roleUI, vo);
        }
    };

    //设置数据 为空就隐藏
    Battle.prototype.setData = function (target, vo) {
        if (typeof vo === "undefined") { vo = null; }
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
Battle.prototype.__class__ = "Battle";
