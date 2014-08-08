var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var CustomItemRendererSkin = (function (_super) {
        __extends(CustomItemRendererSkin, _super);
        function CustomItemRendererSkin() {
            _super.call(this);

            this.height = 85;
            this.elementsContent = [this.__3_i(), this.__4_i(), this.labelDisplay_i(), this.toggleButton_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__3", "source", "list-item-up"),
                    new egret.SetProperty("labelDisplay", "textColor", 0x727070)
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__3", "source", "list-item-selected"),
                    new egret.SetProperty("labelDisplay", "textColor", 0xeeedec)
                ])
            ];
        }
        Object.defineProperty(CustomItemRendererSkin.prototype, "skinParts", {
            get: function () {
                return CustomItemRendererSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        CustomItemRendererSkin.prototype.__4_i = function () {
            var t = new egret.UIAsset();
            t.left = 20;
            t.source = "list-item-icon";
            t.verticalCenter = 0;
            return t;
        };
        CustomItemRendererSkin.prototype.labelDisplay_i = function () {
            var t = new egret.Label();
            this.labelDisplay = t;
            t.fontFamily = "Tahoma";
            t.left = 60;
            t.right = 80;
            t.size = 26;
            t.verticalCenter = 0;
            return t;
        };
        CustomItemRendererSkin.prototype.__3_i = function () {
            var t = new egret.UIAsset();
            this.__3 = t;
            t.percentHeight = 100;
            t.percentWidth = 100;
            return t;
        };
        CustomItemRendererSkin.prototype.toggleButton_i = function () {
            var t = new egret.ToggleButton();
            this.toggleButton = t;
            t.right = 30;
            t.selected = true;
            t.skinName = skins.ToggleOnOffButtonSkin;
            t.verticalCenter = 0;
            return t;
        };
        CustomItemRendererSkin._skinParts = ["labelDisplay", "toggleButton"];
        return CustomItemRendererSkin;
    })(egret.Skin);
    skins.CustomItemRendererSkin = CustomItemRendererSkin;
})(skins || (skins = {}));
