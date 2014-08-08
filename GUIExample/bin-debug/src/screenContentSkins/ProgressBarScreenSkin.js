var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var ProgressBarScreenSkin = (function (_super) {
        __extends(ProgressBarScreenSkin, _super);
        function ProgressBarScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.hProgressBar1_i(), this.hProgressBar2_i(), this.vProgressBar_i()];
        }
        Object.defineProperty(ProgressBarScreenSkin.prototype, "skinParts", {
            get: function () {
                return ProgressBarScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        ProgressBarScreenSkin.prototype.hProgressBar2_i = function () {
            var t = new egret.ProgressBar();
            this.hProgressBar2 = t;
            t.direction = "rightToLeft";
            t.height = 21;
            t.horizontalCenter = 120;
            t.skinName = skins.HProgressBarSkin;
            t.verticalCenter = 50;
            t.width = 250;
            return t;
        };
        ProgressBarScreenSkin.prototype.hProgressBar1_i = function () {
            var t = new egret.ProgressBar();
            this.hProgressBar1 = t;
            t.height = 21;
            t.horizontalCenter = 120;
            t.skinName = skins.HProgressBarSkin;
            t.verticalCenter = -50;
            t.width = 250;
            return t;
        };
        ProgressBarScreenSkin.prototype.vProgressBar_i = function () {
            var t = new egret.ProgressBar();
            this.vProgressBar = t;
            t.direction = "bottomToTop";
            t.height = 250;
            t.horizontalCenter = -120;
            t.skinName = skins.VProgressBarSkin;
            t.verticalCenter = 0;
            t.width = 100;
            return t;
        };
        ProgressBarScreenSkin._skinParts = ["hProgressBar1", "hProgressBar2", "vProgressBar"];
        return ProgressBarScreenSkin;
    })(egret.Skin);
    screenContentSkins.ProgressBarScreenSkin = ProgressBarScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
