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
            this.height = 44;
            this.width = 138;
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
            t.bold = true;
            t.fontFamily = "Arial";
            t.text = "-345";
            t.textColor = 65280;
            t.visible = false;
            t.x = 0;
            t.y = 27;
            return t;
        };
        BattleSkinRole.prototype.data_i = function () {
            var t = new egret.gui.Label();
            this.data = t;
            t.height = 13;
            t.size = 11;
            t.text = "Lv.40 宠物";
            t.textColor = 16777215;
            t.width = 85;
            t.x = 12;
            t.y = 1;
            return t;
        };
        BattleSkinRole.prototype.decHp_i = function () {
            var t = new egret.gui.Label();
            this.decHp = t;
            t.bold = true;
            t.fontFamily = "Arial";
            t.text = "-345";
            t.textColor = 16711680;
            t.visible = false;
            t.x = 0;
            t.y = 27;
            return t;
        };
        BattleSkinRole.prototype.hpText_i = function () {
            var t = new egret.gui.Label();
            this.hpText = t;
            t.height = 12;
            t.size = 7;
            t.text = "1500/50000";
            t.textAlign = "center";
            t.textColor = 0xFFFFFF;
            t.width = 80;
            t.x = 13;
            t.y = 14;
            return t;
        };
        BattleSkinRole.prototype.hp_i = function () {
            var t = new egret.gui.UIAsset();
            this.hp = t;
            t.height = 9;
            t.scale9Grid = egret.gui.getScale9Grid("4,6,2,2");
            t.source = "img_27";
            t.width = 85;
            t.x = 11;
            t.y = 14;
            return t;
        };
        BattleSkinRole.prototype.pic_i = function () {
            var t = new egret.gui.UIAsset();
            this.pic = t;
            t.height = 28;
            t.source = "10067";
            t.width = 28;
            t.x = 100;
            t.y = 4;
            return t;
        };
        BattleSkinRole.prototype.__3_i = function () {
            var t = new egret.gui.UIAsset();
            t.height = 42;
            t.scaleX = -1;
            t.source = "img_128";
            t.width = 136;
            t.x = 135;
            t.y = 0;
            return t;
        };
        BattleSkinRole._skinParts = ["pic", "hp", "data", "hpText", "decHp", "addHp"];
        return BattleSkinRole;
    })(egret.gui.Skin);
    ui.BattleSkinRole = BattleSkinRole;
    BattleSkinRole.prototype.__class__ = "ui.BattleSkinRole";
})(ui || (ui = {}));
