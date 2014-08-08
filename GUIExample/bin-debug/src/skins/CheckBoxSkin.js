var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var CheckBoxSkin = (function (_super) {
        __extends(CheckBoxSkin, _super);
        function CheckBoxSkin() {
            _super.call(this);

            this.elementsContent = [this.__10_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__8", "source", "checkbox-up")
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__8", "source", "checkbox-down")
                ]),
                new egret.State("disabled", [
                    new egret.SetProperty("__8", "source", "checkbox-disabled")
                ]),
                new egret.State("upAndSelected", [
                    new egret.SetProperty("__8", "source", "checkbox-up-selected")
                ]),
                new egret.State("downAndSelected", [
                    new egret.SetProperty("__8", "source", "checkbox-down-selected")
                ]),
                new egret.State("disabledAndSelected", [
                    new egret.SetProperty("__8", "source", "checkbox-disabled-selected")
                ])
            ];
        }
        Object.defineProperty(CheckBoxSkin.prototype, "skinParts", {
            get: function () {
                return CheckBoxSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        CheckBoxSkin.prototype.__7_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = 5;
            t.verticalAlign = "middle";
            return t;
        };
        CheckBoxSkin.prototype.__8_i = function () {
            var t = new egret.UIAsset();
            this.__8 = t;
            t.verticalCenter = 1;
            return t;
        };
        CheckBoxSkin.prototype.__9_i = function () {
            var t = new egret.Group();
            t.elementsContent = [this.__8_i()];
            return t;
        };
        CheckBoxSkin.prototype.labelDisplay_i = function () {
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
        CheckBoxSkin.prototype.__10_i = function () {
            var t = new egret.Group();
            t.layout = this.__7_i();
            t.elementsContent = [this.__9_i(), this.labelDisplay_i()];
            return t;
        };
        CheckBoxSkin._skinParts = ["labelDisplay"];
        return CheckBoxSkin;
    })(egret.Skin);
    skins.CheckBoxSkin = CheckBoxSkin;
})(skins || (skins = {}));
