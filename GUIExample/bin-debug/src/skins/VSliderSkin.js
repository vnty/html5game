var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var VSliderSkin = (function (_super) {
        __extends(VSliderSkin, _super);
        function VSliderSkin() {
            _super.call(this);

            this.minHeight = 13;
            this.minWidth = 50;
            this.elementsContent = [this.track_i(), this.trackHighlight_i(), this.thumb_i()];
            this.states = [
                new egret.State("up", []),
                new egret.State("down", []),
                new egret.State("disabled", [])
            ];
        }
        Object.defineProperty(VSliderSkin.prototype, "skinParts", {
            get: function () {
                return VSliderSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        VSliderSkin.prototype.thumb_i = function () {
            var t = new egret.Button();
            this.thumb = t;
            t.horizontalCenter = 0;
            t.skinName = skins.SliderThumbSkin;
            return t;
        };
        VSliderSkin.prototype.trackHighlight_i = function () {
            var t = new egret.UIAsset();
            this.trackHighlight = t;
            t.horizontalCenter = 0;
            t.source = "v-slider-highlight";
            t.width = 13;
            return t;
        };
        VSliderSkin.prototype.track_i = function () {
            var t = new egret.UIAsset();
            this.track = t;
            t.percentHeight = 100;
            t.horizontalCenter = 0;
            t.source = "v-slider-bg";
            t.width = 13;
            return t;
        };
        VSliderSkin._skinParts = ["track", "trackHighlight", "thumb"];
        return VSliderSkin;
    })(egret.Skin);
    skins.VSliderSkin = VSliderSkin;
})(skins || (skins = {}));
