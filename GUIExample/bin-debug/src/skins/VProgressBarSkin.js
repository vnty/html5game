var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var VProgressBarSkin = (function (_super) {
        __extends(VProgressBarSkin, _super);
        function VProgressBarSkin() {
            _super.call(this);

            this.elementsContent = [this.__1_i(), this.thumb_i(), this.track_i(), this.labelDisplay_i()];
        }
        Object.defineProperty(VProgressBarSkin.prototype, "skinParts", {
            get: function () {
                return VProgressBarSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        VProgressBarSkin.prototype.labelDisplay_i = function () {
            var t = new egret.Label();
            this.labelDisplay = t;
            t.left = 5;
            t.maxDisplayedLines = 1;
            t.right = 5;
            t.size = 20;
            t.textAlign = "center";
            t.textColor = 0x707070;
            t.verticalAlign = "middle";
            t.verticalCenter = 0;
            return t;
        };
        VProgressBarSkin.prototype.__1_i = function () {
            var t = new egret.UIAsset();
            t.percentHeight = 100;
            t.source = "v-progress-bg";
            t.percentWidth = 100;
            return t;
        };
        VProgressBarSkin.prototype.thumb_i = function () {
            var t = new egret.UIAsset();
            this.thumb = t;
            t.source = "v-progress-thumb";
            return t;
        };
        VProgressBarSkin.prototype.track_i = function () {
            var t = new egret.UIComponent();
            this.track = t;
            t.percentHeight = 100;
            t.percentWidth = 100;
            return t;
        };
        VProgressBarSkin._skinParts = ["thumb", "track", "labelDisplay"];
        return VProgressBarSkin;
    })(egret.Skin);
    skins.VProgressBarSkin = VProgressBarSkin;
})(skins || (skins = {}));
