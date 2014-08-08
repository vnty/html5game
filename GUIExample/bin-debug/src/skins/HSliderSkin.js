var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var HSliderSkin = (function (_super) {
        __extends(HSliderSkin, _super);
        function HSliderSkin() {
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
        Object.defineProperty(HSliderSkin.prototype, "skinParts", {
            get: function () {
                return HSliderSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        HSliderSkin.prototype.thumb_i = function () {
            var t = new egret.Button();
            this.thumb = t;
            t.skinName = skins.SliderThumbSkin;
            t.verticalCenter = 0;
            return t;
        };
        HSliderSkin.prototype.trackHighlight_i = function () {
            var t = new egret.UIAsset();
            this.trackHighlight = t;
            t.height = 13;
            t.source = "h-slider-highlight";
            t.verticalCenter = 0;
            return t;
        };
        HSliderSkin.prototype.track_i = function () {
            var t = new egret.UIAsset();
            this.track = t;
            t.height = 13;
            t.source = "h-slider-bg";
            t.verticalCenter = 0;
            t.percentWidth = 100;
            return t;
        };
        HSliderSkin._skinParts = ["track", "trackHighlight", "thumb"];
        return HSliderSkin;
    })(egret.Skin);
    skins.HSliderSkin = HSliderSkin;
})(skins || (skins = {}));
