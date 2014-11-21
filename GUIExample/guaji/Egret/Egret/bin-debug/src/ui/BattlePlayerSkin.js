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
            this.__s = egret.gui.setProperties;
            this.__s(this, ["height", "width"], [83, 275]);
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
            this.__s(t, ["height", "size", "text", "textColor", "width", "x", "y"], [20, 18, "Lv.40 宠物", 0xFFFFFF, 160, 80, 4]);
            return t;
        };
        BattlePlayerSkin.prototype.hpText_i = function () {
            var t = new egret.gui.Label();
            this.hpText = t;
            this.__s(t, ["height", "size", "text", "textAlign", "textColor", "width", "x", "y"], [16, 13, "1500/50000", "center", 16777215, 166, 81, 30]);
            return t;
        };
        BattlePlayerSkin.prototype.hp_i = function () {
            var t = new egret.gui.UIAsset();
            this.hp = t;
            this.__s(t, ["height", "scale9Grid", "source", "width", "x", "y"], [16, egret.gui.getScale9Grid("4,6,2,2"), "img_27", 170, 78, 30]);
            return t;
        };
        BattlePlayerSkin.prototype.mp_i = function () {
            var t = new egret.gui.UIAsset();
            this.mp = t;
            this.__s(t, ["height", "scale9Grid", "source", "width", "x", "y"], [10, egret.gui.getScale9Grid("5,6,1,1"), "img_28", 167, 77, 50]);
            return t;
        };
        BattlePlayerSkin.prototype.pic_i = function () {
            var t = new egret.gui.UIAsset();
            this.pic = t;
            this.__s(t, ["height", "source", "width", "x", "y"], [56, "hero_003", 56, 18, 6]);
            return t;
        };
        BattlePlayerSkin.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            this.__s(t, ["source", "x", "y"], ["img_127", 0, 0]);
            return t;
        };
        BattlePlayerSkin._skinParts = ["pic", "data", "hp", "mp", "hpText"];
        return BattlePlayerSkin;
    })(egret.gui.Skin);
    ui.BattlePlayerSkin = BattlePlayerSkin;
    BattlePlayerSkin.prototype.__class__ = "ui.BattlePlayerSkin";
})(ui || (ui = {}));
//# sourceMappingURL=BattlePlayerSkin.js.map