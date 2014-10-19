var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var ui;
(function (ui) {
    var Battl109Skin = (function (_super) {
        __extends(Battl109Skin, _super);
        function Battl109Skin() {
            _super.call(this);
            this.height = 57;
            this.width = 150;
            this.elementsContent = [];
            this.__5_i();
            this.__6_i();
            this.__7_i();
            this.__8_i();
            this.states = [
                new egret.gui.State("up", [
                    new egret.gui.AddItems("__6", "", "last", "")
                ]),
                new egret.gui.State("over", [
                    new egret.gui.AddItems("__7", "", "last", "")
                ]),
                new egret.gui.State("down", [
                    new egret.gui.AddItems("__8", "", "last", "")
                ]),
                new egret.gui.State("disabled", [
                    new egret.gui.AddItems("__5", "", "last", "")
                ])
            ];
        }
        Battl109Skin.prototype.__5_i = function () {
            var t = new egret.gui.UIAsset();
            this.__5 = t;
            t.source = "btn_109";
            t.x = 1;
            t.y = 2;
            return t;
        };
        Battl109Skin.prototype.__6_i = function () {
            var t = new egret.gui.UIAsset();
            this.__6 = t;
            t.source = "btn_109";
            t.x = 1;
            t.y = 2;
            return t;
        };
        Battl109Skin.prototype.__7_i = function () {
            var t = new egret.gui.UIAsset();
            this.__7 = t;
            t.source = "btn_109";
            t.x = 1;
            t.y = 2;
            return t;
        };
        Battl109Skin.prototype.__8_i = function () {
            var t = new egret.gui.UIAsset();
            this.__8 = t;
            t.source = "btn_109";
            t.x = 1;
            t.y = 2;
            return t;
        };
        return Battl109Skin;
    })(egret.gui.Skin);
    ui.Battl109Skin = Battl109Skin;
    Battl109Skin.prototype.__class__ = "ui.Battl109Skin";
})(ui || (ui = {}));
