var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ui;
(function (ui) {
    var BattlePetSkin = (function (_super) {
        __extends(BattlePetSkin, _super);
        function BattlePetSkin() {
            _super.call(this);
            this.height = 42;
            this.width = 138;
            this.elementsContent = [this.pic_i(), this.__3_i(), this.hp_i(), this.data_i(), this.hpText_i()];
            this.states = [
                new egret.gui.State("normal", [
                ]),
                new egret.gui.State("disabled", [
                ])
            ];
        }
        Object.defineProperty(BattlePetSkin.prototype, "skinParts", {
            get: function () {
                return BattlePetSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        BattlePetSkin.prototype.data_i = function () {
            var t = new egret.gui.Label();
            this.data = t;
            t.height = 13;
            t.size = 11;
            t.text = "Lv.40 宠物";
            t.textColor = 0xFFFFFF;
            t.width = 85;
            t.x = 42;
            t.y = 0;
            return t;
        };
        BattlePetSkin.prototype.hpText_i = function () {
            var t = new egret.gui.Label();
            this.hpText = t;
            t.height = 12;
            t.size = 7;
            t.text = "1500/50000";
            t.textAlign = "center";
            t.textColor = 0xFFFFFF;
            t.width = 80;
            t.x = 41;
            t.y = 13;
            return t;
        };
        BattlePetSkin.prototype.hp_i = function () {
            var t = new egret.gui.UIAsset();
            this.hp = t;
            t.height = 9;
            t.scale9Grid = egret.gui.getScale9Grid("4,6,2,2");
            t.source = "img_27";
            t.width = 85;
            t.x = 39;
            t.y = 14;
            return t;
        };
        BattlePetSkin.prototype.pic_i = function () {
            var t = new egret.gui.UIAsset();
            this.pic = t;
            t.height = 28;
            t.source = "p_10003";
            t.width = 28;
            t.x = 10;
            t.y = 4;
            return t;
        };
        BattlePetSkin.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            t.height = 42;
            t.source = "img_128";
            t.width = 136;
            t.x = 0;
            t.y = 0;
            return t;
        };
        BattlePetSkin._skinParts = ["pic", "hp", "data", "hpText"];
        return BattlePetSkin;
    })(egret.gui.Skin);
    ui.BattlePetSkin = BattlePetSkin;
    BattlePetSkin.prototype.__class__ = "ui.BattlePetSkin";
})(ui || (ui = {}));
