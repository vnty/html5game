var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ui;
(function (ui) {
    var BattleSkinRole = (function (_super) {
        __extends(BattleSkinRole, _super);
        function BattleSkinRole() {
            _super.call(this);
            this.__s = egret.gui.setProperties;
            this.__s(this, ["height", "width"], [44, 138]);
            this.elementsContent = [this.pic_i(), this.__3_i(), this.hp_i(), this.data_i(), this.hpText_i(), this.decHp_i(), this.addHp_i()];
            this.states = [
                new egret.gui.State("normal", [
                ]),
                new egret.gui.State("disabled", [
                ])
            ];
        }
        Object.defineProperty(BattleSkinRole.prototype, "skinParts", {
            get: function () {
                return BattleSkinRole._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        BattleSkinRole.prototype.addHp_i = function () {
            var t = new egret.gui.Label();
            this.addHp = t;
            this.__s(t, ["bold", "fontFamily", "text", "textColor", "visible", "x", "y"], [true, "Arial", "-345", 65280, false, 0, 17]);
            return t;
        };
        BattleSkinRole.prototype.data_i = function () {
            var t = new egret.gui.Label();
            this.data = t;
            this.__s(t, ["height", "size", "text", "textColor", "width", "x", "y"], [13, 11, "Lv.40 宠物", 16777215, 85, 12, 1]);
            return t;
        };
        BattleSkinRole.prototype.decHp_i = function () {
            var t = new egret.gui.Label();
            this.decHp = t;
            this.__s(t, ["bold", "fontFamily", "text", "textColor", "visible", "x", "y"], [true, "Arial", "-345", 16711680, false, 0, 17]);
            return t;
        };
        BattleSkinRole.prototype.hpText_i = function () {
            var t = new egret.gui.Label();
            this.hpText = t;
            this.__s(t, ["height", "size", "text", "textAlign", "textColor", "width", "x", "y"], [12, 7, "1500/50000", "center", 0xFFFFFF, 80, 13, 14]);
            return t;
        };
        BattleSkinRole.prototype.hp_i = function () {
            var t = new egret.gui.UIAsset();
            this.hp = t;
            this.__s(t, ["height", "scale9Grid", "source", "width", "x", "y"], [9, egret.gui.getScale9Grid("4,6,2,2"), "img_27", 85, 11, 14]);
            return t;
        };
        BattleSkinRole.prototype.pic_i = function () {
            var t = new egret.gui.UIAsset();
            this.pic = t;
            this.__s(t, ["height", "source", "width", "x", "y"], [28, "10067", 28, 100, 4]);
            return t;
        };
        BattleSkinRole.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            this.__s(t, ["height", "scaleX", "source", "width", "x", "y"], [42, -1, "img_128", 136, 135, 0]);
            return t;
        };
        BattleSkinRole._skinParts = ["pic", "hp", "data", "hpText", "decHp", "addHp"];
        return BattleSkinRole;
    })(egret.gui.Skin);
    ui.BattleSkinRole = BattleSkinRole;
    BattleSkinRole.prototype.__class__ = "ui.BattleSkinRole";
})(ui || (ui = {}));
//# sourceMappingURL=BattleSkinRole.js.map