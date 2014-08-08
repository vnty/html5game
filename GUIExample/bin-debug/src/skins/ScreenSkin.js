var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var ScreenSkin = (function (_super) {
        __extends(ScreenSkin, _super);
        function ScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.contentGroup_i(), this.titleDisplay_i(), this.backButton_i()];
        }
        Object.defineProperty(ScreenSkin.prototype, "skinParts", {
            get: function () {
                return ScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        ScreenSkin.prototype.contentGroup_i = function () {
            var t = new egret.Group();
            this.contentGroup = t;
            t.bottom = 0;
            t.percentWidth = 100;
            t.top = 90;
            return t;
        };
        ScreenSkin.prototype.backButton_i = function () {
            var t = new egret.Button();
            this.backButton = t;
            t.height = 58;
            t.label = "Back";
            t.skinName = skins.BackButtonSkin;
            t.width = 160;
            t.x = 16;
            t.y = 16;
            return t;
        };
        ScreenSkin.prototype.titleDisplay_i = function () {
            var t = new egret.Label();
            this.titleDisplay = t;
            t.fontFamily = "Tahoma";
            t.horizontalCenter = 0;
            t.size = 35;
            t.textColor = 0x727070;
            t.top = 25;
            return t;
        };
        ScreenSkin._skinParts = ["contentGroup", "titleDisplay", "backButton"];
        return ScreenSkin;
    })(egret.Skin);
    skins.ScreenSkin = ScreenSkin;
})(skins || (skins = {}));
