var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var RadioButtonSkin = (function (_super) {
        __extends(RadioButtonSkin, _super);
        function RadioButtonSkin() {
            _super.call(this);

            this.elementsContent = [this.__10_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__8", "source", "radio-up")
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__8", "source", "radio-down")
                ]),
                new egret.State("disabled", [
                    new egret.SetProperty("__8", "source", "radio-down-selected")
                ]),
                new egret.State("upAndSelected", [
                    new egret.SetProperty("__8", "source", "radio-up-selected")
                ]),
                new egret.State("downAndSelected", [
                    new egret.SetProperty("__8", "source", "radio-down-selected")
                ]),
                new egret.State("disabledAndSelected", [
                    new egret.SetProperty("__8", "source", "radio-disabled-selected")
                ])
            ];
        }
        Object.defineProperty(RadioButtonSkin.prototype, "skinParts", {
            get: function () {
                return RadioButtonSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        RadioButtonSkin.prototype.__7_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = 5;
            t.verticalAlign = "middle";
            return t;
        };
        RadioButtonSkin.prototype.__8_i = function () {
            var t = new egret.UIAsset();
            this.__8 = t;
            t.verticalCenter = 1;
            return t;
        };
        RadioButtonSkin.prototype.__9_i = function () {
            var t = new egret.Group();
            t.elementsContent = [this.__8_i()];
            return t;
        };
        RadioButtonSkin.prototype.labelDisplay_i = function () {
            var t = new egret.Label();
            this.labelDisplay = t;
            t.fontFamily = "Tahoma";
            t.maxDisplayedLines = 1;
            t.size = 20;
            t.textAlign = "center";
            t.textColor = 0x707070;
            t.verticalAlign = "middle";
            return t;
        };
        RadioButtonSkin.prototype.__10_i = function () {
            var t = new egret.Group();
            t.layout = this.__7_i();
            t.elementsContent = [this.__9_i(), this.labelDisplay_i()];
            return t;
        };
        RadioButtonSkin._skinParts = ["labelDisplay"];
        return RadioButtonSkin;
    })(egret.Skin);
    skins.RadioButtonSkin = RadioButtonSkin;
})(skins || (skins = {}));
