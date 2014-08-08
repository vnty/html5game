var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var ToggleOnOffButtonSkin = (function (_super) {
        __extends(ToggleOnOffButtonSkin, _super);
        function ToggleOnOffButtonSkin() {
            _super.call(this);

            this.elementsContent = [this.__7_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__7", "source", "toggle-up")
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__7", "source", "toggle-down")
                ]),
                new egret.State("disabled", [
                    new egret.SetProperty("__7", "source", "toggle-disabled")
                ]),
                new egret.State("upAndSelected", [
                    new egret.SetProperty("__7", "source", "toggle-up-selected")
                ]),
                new egret.State("downAndSelected", [
                    new egret.SetProperty("__7", "source", "toggle-down-selected")
                ]),
                new egret.State("disabledAndSelected", [
                    new egret.SetProperty("__7", "source", "toggle-disabled-selected")
                ])
            ];
        }
        ToggleOnOffButtonSkin.prototype.__7_i = function () {
            var t = new egret.UIAsset();
            this.__7 = t;
            return t;
        };
        return ToggleOnOffButtonSkin;
    })(egret.Skin);
    skins.ToggleOnOffButtonSkin = ToggleOnOffButtonSkin;
})(skins || (skins = {}));
