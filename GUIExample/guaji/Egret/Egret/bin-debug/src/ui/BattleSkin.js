var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ui;
(function (ui) {
    var BattleSkin = (function (_super) {
        __extends(BattleSkin, _super);
        function BattleSkin() {
            _super.call(this);
            this.__s = egret.gui.setProperties;
            this.__s(this, ["height", "width"], [834, 640]);
            this.elementsContent = [this.bg_i(), this.role3_i(), this.role5_i(), this.__3_i(), this.type_i(), this.role4_i(), this.role1_i(), this.role2_i(), this.skill1_i(), this.attackBtn_i()];
            this.states = [
                new egret.gui.State("normal", [
                    new egret.gui.SetProperty("attackBtn", "x", 270),
                    new egret.gui.SetProperty("attackBtn", "y", 261)
                ]),
                new egret.gui.State("disabled", [
                ])
            ];
        }
        Object.defineProperty(BattleSkin.prototype, "skinParts", {
            get: function () {
                return BattleSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        BattleSkin.prototype.attackBtn_i = function () {
            var t = new egret.gui.Button();
            this.attackBtn = t;
            this.__s(t, ["enabled", "label", "skinName", "x", "y"], [true, "开始", ui.Battl109Skin, 257, 255]);
            return t;
        };
        BattleSkin.prototype.bg_i = function () {
            var t = new egret.gui.UIAsset();
            this.bg = t;
            this.__s(t, ["source", "x", "y"], ["img_129", 0, 0]);
            return t;
        };
        BattleSkin.prototype.role1_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role1 = t;
            this.__s(t, ["height", "skinName", "width", "x", "y"], [85, ui.BattlePlayerSkin, 288, 14, 36]);
            return t;
        };
        BattleSkin.prototype.role2_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role2 = t;
            this.__s(t, ["height", "skinName", "width", "x", "y"], [40, ui.BattlePetSkin, 137, 22, 126]);
            return t;
        };
        BattleSkin.prototype.role3_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role3 = t;
            this.__s(t, ["height", "skinName", "width", "x", "y"], [36, ui.BattleSkinRole, 137, 467, 52]);
            return t;
        };
        BattleSkin.prototype.role4_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role4 = t;
            this.__s(t, ["height", "skinName", "width", "x", "y"], [36, ui.BattleSkinRole, 137, 467, 104]);
            return t;
        };
        BattleSkin.prototype.role5_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role5 = t;
            this.__s(t, ["height", "skinName", "width", "x", "y"], [36, ui.BattleSkinRole, 137, 467, 160]);
            return t;
        };
        BattleSkin.prototype.skill1_i = function () {
            var t = new egret.gui.Label();
            this.skill1 = t;
            this.__s(t, ["size", "text", "textColor", "visible", "x", "y"], [12, "标签", 0xFFFFFF, false, 160, 100]);
            return t;
        };
        BattleSkin.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            this.__s(t, ["source", "x", "y"], ["img_131", 304, -4]);
            return t;
        };
        BattleSkin.prototype.type_i = function () {
            var t = new egret.gui.UIAsset();
            this.type = t;
            this.__s(t, ["source", "x", "y"], ["img_131_01", 305, -4]);
            return t;
        };
        BattleSkin._skinParts = ["bg", "role3", "role5", "type", "role4", "role1", "role2", "skill1", "attackBtn"];
        return BattleSkin;
    })(egret.gui.Skin);
    ui.BattleSkin = BattleSkin;
    BattleSkin.prototype.__class__ = "ui.BattleSkin";
})(ui || (ui = {}));
//# sourceMappingURL=BattleSkin.js.map