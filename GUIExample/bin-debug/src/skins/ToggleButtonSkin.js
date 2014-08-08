var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var ToggleButtonSkin = (function (_super) {
        __extends(ToggleButtonSkin, _super);
        function ToggleButtonSkin() {
            _super.call(this);

            this.height = 60;
            this.minWidth = 140;
            this.elementsContent = [this.__7_i(), this.labelDisplay_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__7", "source", "button-up"),
                    new egret.SetProperty("labelDisplay", "textColor", 0x1e7465)
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__7", "source", "button-down"),
                    new egret.SetProperty("labelDisplay", "textColor", 0x1e7465)
                ]),
                new egret.State("disabled", [
                    new egret.SetProperty("__7", "source", "button-disabled"),
                    new egret.SetProperty("labelDisplay", "textColor", 0x727070)
                ]),
                new egret.State("upAndSelected", [
                    new egret.SetProperty("__7", "source", "button-selected-up"),
                    new egret.SetProperty("labelDisplay", "textColor", 0xeeedec)
                ]),
                new egret.State("downAndSelected", [
                    new egret.SetProperty("__7", "source", "button-down"),
                    new egret.SetProperty("labelDisplay", "textColor", 0xeeedec)
                ]),
                new egret.State("disabledAndSelected", [
                    new egret.SetProperty("__7", "source", "button-selected-disabled"),
                    new egret.SetProperty("labelDisplay", "textColor", 0x727070)
                ])
            ];
        }
        Object.defineProperty(ToggleButtonSkin.prototype, "skinParts", {
            get: function () {
                return ToggleButtonSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        ToggleButtonSkin.prototype.labelDisplay_i = function () {
            var t = new egret.Label();
            this.labelDisplay = t;
            t.bottom = 12;
            t.fontFamily = "Tahoma";
            t.left = 10;
            t.right = 10;
            t.size = 20;
            t.textAlign = "center";
            t.top = 8;
            t.verticalAlign = "middle";
            return t;
        };
        ToggleButtonSkin.prototype.__7_i = function () {
            var t = new egret.UIAsset();
            this.__7 = t;
            t.percentHeight = 100;
            t.percentWidth = 100;
            return t;
        };
        ToggleButtonSkin._skinParts = ["labelDisplay"];
        return ToggleButtonSkin;
    })(egret.Skin);
    skins.ToggleButtonSkin = ToggleButtonSkin;
})(skins || (skins = {}));
