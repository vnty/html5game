var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var HProgressBarSkin = (function (_super) {
        __extends(HProgressBarSkin, _super);
        function HProgressBarSkin() {
            _super.call(this);

            this.elementsContent = [this.__1_i(), this.thumb_i(), this.track_i(), this.labelDisplay_i()];
        }
        Object.defineProperty(HProgressBarSkin.prototype, "skinParts", {
            get: function () {
                return HProgressBarSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        HProgressBarSkin.prototype.labelDisplay_i = function () {
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
        HProgressBarSkin.prototype.__1_i = function () {
            var t = new egret.UIAsset();
            t.percentHeight = 100;
            t.source = "h-progress-bg";
            t.percentWidth = 100;
            return t;
        };
        HProgressBarSkin.prototype.thumb_i = function () {
            var t = new egret.UIAsset();
            this.thumb = t;
            t.source = "h-progress-thumb";
            return t;
        };
        HProgressBarSkin.prototype.track_i = function () {
            var t = new egret.UIComponent();
            this.track = t;
            t.percentHeight = 100;
            t.percentWidth = 100;
            return t;
        };
        HProgressBarSkin._skinParts = ["thumb", "track", "labelDisplay"];
        return HProgressBarSkin;
    })(egret.Skin);
    skins.HProgressBarSkin = HProgressBarSkin;
})(skins || (skins = {}));
