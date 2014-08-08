var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var AlertScreenSkin = (function (_super) {
        __extends(AlertScreenSkin, _super);
        function AlertScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.button_i()];
        }
        Object.defineProperty(AlertScreenSkin.prototype, "skinParts", {
            get: function () {
                return AlertScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        AlertScreenSkin.prototype.button_i = function () {
            var t = new egret.Button();
            this.button = t;
            t.horizontalCenter = 0;
            t.label = "Show Alert";
            t.skinName = skins.ButtonSkin;
            t.verticalCenter = 0;
            return t;
        };
        AlertScreenSkin._skinParts = ["button"];
        return AlertScreenSkin;
    })(egret.Skin);
    screenContentSkins.AlertScreenSkin = AlertScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
