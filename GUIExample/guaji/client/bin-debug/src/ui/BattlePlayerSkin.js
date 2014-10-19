var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ui;
(function (ui) {
    var BattlePlayerSkin = (function (_super) {
        __extends(BattlePlayerSkin, _super);
        function BattlePlayerSkin() {
            _super.call(this);
            this.height = 83;
            this.width = 275;
            this.elementsContent = [this.pic_i(), this.__3_i(), this.data_i(), this.hp_i(), this.mp_i(), this.hpText_i()];
            this.states = [
                new egret.gui.State("normal", [
                ]),
                new egret.gui.State("disabled", [
                ])
            ];
        }
        Object.defineProperty(BattlePlayerSkin.prototype, "skinParts", {
            get: function () {
                return BattlePlayerSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        BattlePlayerSkin.prototype.data_i = function () {
            var t = new egret.gui.Label();
            this.data = t;
            t.height = 20;
            t.size = 18;
            t.text = "Lv.40 宠物";
            t.textColor = 0xFFFFFF;
            t.width = 160;
            t.x = 80;
            t.y = 4;
            return t;
        };
        BattlePlayerSkin.prototype.hpText_i = function () {
            var t = new egret.gui.Label();
            this.hpText = t;
            t.height = 16;
            t.size = 13;
            t.text = "1500/50000";
            t.textAlign = "center";
            t.textColor = 16777215;
            t.width = 166;
            t.x = 81;
            t.y = 30;
            return t;
        };
        BattlePlayerSkin.prototype.hp_i = function () {
            var t = new egret.gui.UIAsset();
            this.hp = t;
            t.height = 16;
            t.scale9Grid = egret.gui.getScale9Grid("4,6,2,2");
            t.source = "img_27";
            t.width = 170;
            t.x = 78;
            t.y = 30;
            return t;
        };
        BattlePlayerSkin.prototype.mp_i = function () {
            var t = new egret.gui.UIAsset();
            this.mp = t;
            t.height = 10;
            t.scale9Grid = egret.gui.getScale9Grid("5,6,1,1");
            t.source = "img_28";
            t.width = 167;
            t.x = 77;
            t.y = 50;
            return t;
        };
        BattlePlayerSkin.prototype.pic_i = function () {
            var t = new egret.gui.UIAsset();
            this.pic = t;
            t.height = 56;
            t.source = "hero_003";
            t.width = 56;
            t.x = 18;
            t.y = 6;
            return t;
        };
        BattlePlayerSkin.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            t.source = "img_127";
            t.x = 0;
            t.y = 0;
            return t;
        };
        BattlePlayerSkin._skinParts = ["pic", "data", "hp", "mp", "hpText"];
        return BattlePlayerSkin;
    })(egret.gui.Skin);
    ui.BattlePlayerSkin = BattlePlayerSkin;
    BattlePlayerSkin.prototype.__class__ = "ui.BattlePlayerSkin";
})(ui || (ui = {}));
