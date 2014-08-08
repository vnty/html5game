var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var ButtonScreenSkin = (function (_super) {
        __extends(ButtonScreenSkin, _super);
        function ButtonScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.__6_i()];
        }
        ButtonScreenSkin.prototype.__1_i = function () {
            var t = new egret.VerticalLayout();
            t.horizontalAlign = "contentJustify";
            t.verticalAlign = "middle";
            return t;
        };
        ButtonScreenSkin.prototype.__2_i = function () {
            var t = new egret.Button();
            t.label = "Normal Button";
            return t;
        };
        ButtonScreenSkin.prototype.__3_i = function () {
            var t = new egret.Button();
            t.enabled = false;
            t.label = "Disabled Button";
            return t;
        };
        ButtonScreenSkin.prototype.__4_i = function () {
            var t = new egret.ToggleButton();
            t.label = "Normal ToggleButton";
            return t;
        };
        ButtonScreenSkin.prototype.__5_i = function () {
            var t = new egret.ToggleButton();
            t.enabled = false;
            t.label = "Normal ToggleButton";
            t.selected = true;
            return t;
        };
        ButtonScreenSkin.prototype.__6_i = function () {
            var t = new egret.Group();
            t.horizontalCenter = 0;
            t.verticalCenter = 0;
            t.layout = this.__1_i();
            t.elementsContent = [this.__2_i(), this.__3_i(), this.__4_i(), this.__5_i()];
            return t;
        };
        return ButtonScreenSkin;
    })(egret.Skin);
    screenContentSkins.ButtonScreenSkin = ButtonScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
