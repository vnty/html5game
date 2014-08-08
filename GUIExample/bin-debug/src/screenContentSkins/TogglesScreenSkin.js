var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var TogglesScreenSkin = (function (_super) {
        __extends(TogglesScreenSkin, _super);
        function TogglesScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.__15_i()];
        }
        TogglesScreenSkin.prototype.__10_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = 20;
            return t;
        };
        TogglesScreenSkin.prototype.__11_i = function () {
            var t = new egret.RadioButton();
            t.label = "Radio Button 1";
            t.selected = true;
            t.value = "Data1";
            return t;
        };
        TogglesScreenSkin.prototype.__12_i = function () {
            var t = new egret.RadioButton();
            t.label = "Radio Button 2";
            t.value = "Data2";
            return t;
        };
        TogglesScreenSkin.prototype.__13_i = function () {
            var t = new egret.RadioButton();
            t.label = "Radio Button 3";
            t.value = "Data3";
            return t;
        };
        TogglesScreenSkin.prototype.__14_i = function () {
            var t = new egret.Group();
            t.layout = this.__10_i();
            t.elementsContent = [this.__11_i(), this.__12_i(), this.__13_i()];
            return t;
        };
        TogglesScreenSkin.prototype.__15_i = function () {
            var t = new egret.Group();
            t.horizontalCenter = 0;
            t.verticalCenter = 0;
            t.layout = this.__1_i();
            t.elementsContent = [this.__4_i(), this.__9_i(), this.__14_i()];
            return t;
        };
        TogglesScreenSkin.prototype.__1_i = function () {
            var t = new egret.VerticalLayout();
            t.gap = 30;
            t.horizontalAlign = "contentJustify";
            t.verticalAlign = "middle";
            return t;
        };
        TogglesScreenSkin.prototype.__2_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = 20;
            return t;
        };
        TogglesScreenSkin.prototype.__3_i = function () {
            var t = new egret.ToggleButton();
            t.selected = true;
            t.skinName = skins.ToggleOnOffButtonSkin;
            return t;
        };
        TogglesScreenSkin.prototype.__4_i = function () {
            var t = new egret.Group();
            t.layout = this.__2_i();
            t.elementsContent = [this.__3_i()];
            return t;
        };
        TogglesScreenSkin.prototype.__5_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = 20;
            return t;
        };
        TogglesScreenSkin.prototype.__6_i = function () {
            var t = new egret.CheckBox();
            t.label = "Check Box 1";
            t.selected = true;
            return t;
        };
        TogglesScreenSkin.prototype.__7_i = function () {
            var t = new egret.CheckBox();
            t.label = "Check Box 2";
            return t;
        };
        TogglesScreenSkin.prototype.__8_i = function () {
            var t = new egret.CheckBox();
            t.label = "Check Box 3";
            return t;
        };
        TogglesScreenSkin.prototype.__9_i = function () {
            var t = new egret.Group();
            t.layout = this.__5_i();
            t.elementsContent = [this.__6_i(), this.__7_i(), this.__8_i()];
            return t;
        };
        return TogglesScreenSkin;
    })(egret.Skin);
    screenContentSkins.TogglesScreenSkin = TogglesScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
