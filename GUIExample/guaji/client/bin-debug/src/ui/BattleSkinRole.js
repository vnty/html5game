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

            this.height = 178;
            this.width = 299;
            this.elementsContent = [this.pic_i(), this.__3_i(), this.data_i()];
            this.states = [
                new egret.gui.State("normal", []),
                new egret.gui.State("disabled", [])
            ];
        }
        Object.defineProperty(BattleSkinRole.prototype, "skinParts", {
            get: function () {
                return BattleSkinRole._skinParts;
            },
            enumerable: true,
            configurable: true
        });
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
        BattleSkinRole._skinParts = ["pic", "data"];
        return BattleSkinRole;
    })(egret.gui.Skin);
    ui.BattleSkinRole = BattleSkinRole;
    BattleSkinRole.prototype.__class__ = "ui.BattleSkinRole";
})(ui || (ui = {}));
