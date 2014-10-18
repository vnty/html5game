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

            this.height = 834;
            this.width = 640;
            this.elementsContent = [this.bg_i(), this.role3_i(), this.role5_i(), this.role2_i(), this.role1_i(), this.__3_i(), this.type_i(), this.role4_i()];
            this.states = [
                new egret.gui.State("normal", []),
                new egret.gui.State("disabled", [])
            ];
        }
        Object.defineProperty(BattleSkin.prototype, "skinParts", {
            get: function () {
                return BattleSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        BattleSkin.prototype.bg_i = function () {
            var t = new egret.gui.UIAsset();
            this.bg = t;
            t.source = "img_129";
            t.x = 0;
            t.y = 0;
            return t;
        };
        BattleSkin.prototype.role1_i = function () {
            var t = new egret.gui.UIAsset();
            this.role1 = t;
            t.source = "img_127";
            t.x = 10;
            t.y = 49;
            return t;
        };
        BattleSkin.prototype.role2_i = function () {
            var t = new egret.gui.UIAsset();
            this.role2 = t;
            t.height = 42;
            t.source = "img_128";
            t.width = 136;
            t.x = 26;
            t.y = 162;
            return t;
        };
        BattleSkin.prototype.role3_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role3 = t;
            t.height = 36;
            t.skinName = ui.BattleSkinRole;
            t.width = 137;
            t.x = 467;
            t.y = 52;
            return t;
        };
        BattleSkin.prototype.role4_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role4 = t;
            t.height = 36;
            t.skinName = ui.BattleSkinRole;
            t.width = 137;
            t.x = 467;
            t.y = 104;
            return t;
        };
        BattleSkin.prototype.role5_i = function () {
            var t = new egret.gui.SkinnableComponent();
            this.role5 = t;
            t.height = 36;
            t.skinName = ui.BattleSkinRole;
            t.width = 137;
            t.x = 467;
            t.y = 160;
            return t;
        };
        BattleSkin.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            t.source = "img_131";
            t.x = 304;
            t.y = -4;
            return t;
        };
        BattleSkin.prototype.type_i = function () {
            var t = new egret.gui.UIAsset();
            this.type = t;
            t.source = "img_131_01";
            t.x = 305;
            t.y = -4;
            return t;
        };
        BattleSkin._skinParts = ["bg", "role3", "role5", "role2", "role1", "type", "role4"];
        return BattleSkin;
    })(egret.gui.Skin);
    ui.BattleSkin = BattleSkin;
    BattleSkin.prototype.__class__ = "ui.BattleSkin";
})(ui || (ui = {}));
