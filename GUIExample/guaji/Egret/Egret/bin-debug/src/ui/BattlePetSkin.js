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
            this.__s = egret.gui.setProperties;
            this.__s(this, ["height", "width"], [42, 138]);
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
            this.__s(t, ["height", "size", "text", "textColor", "width", "x", "y"], [13, 11, "Lv.40 宠物", 0xFFFFFF, 85, 42, 0]);
            return t;
        };
        BattlePetSkin.prototype.hpText_i = function () {
            var t = new egret.gui.Label();
            this.hpText = t;
            this.__s(t, ["height", "size", "text", "textAlign", "textColor", "width", "x", "y"], [12, 7, "1500/50000", "center", 0xFFFFFF, 80, 41, 13]);
            return t;
        };
        BattlePetSkin.prototype.hp_i = function () {
            var t = new egret.gui.UIAsset();
            this.hp = t;
            this.__s(t, ["height", "scale9Grid", "source", "width", "x", "y"], [9, egret.gui.getScale9Grid("4,6,2,2"), "img_27", 85, 39, 14]);
            return t;
        };
        BattlePetSkin.prototype.pic_i = function () {
            var t = new egret.gui.UIAsset();
            this.pic = t;
            this.__s(t, ["height", "source", "width", "x", "y"], [28, "p_10003", 28, 10, 4]);
            return t;
        };
        BattlePetSkin.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            this.__s(t, ["height", "source", "width", "x", "y"], [42, "img_128", 136, 0, 0]);
            return t;
        };
        BattlePetSkin._skinParts = ["pic", "hp", "data", "hpText"];
        return BattlePetSkin;
    })(egret.gui.Skin);
    ui.BattlePetSkin = BattlePetSkin;
    BattlePetSkin.prototype.__class__ = "ui.BattlePetSkin";
})(ui || (ui = {}));
//# sourceMappingURL=BattlePetSkin.js.map