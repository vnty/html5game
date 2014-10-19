var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var simple;
    (function (simple) {
        var HSliderSkin = (function (_super) {
            __extends(HSliderSkin, _super);
            function HSliderSkin() {
                _super.call(this);
                this.minHeight = 13;
                this.minWidth = 50;
                this.elementsContent = [this.track_i(), this.trackHighlight_i(), this.thumb_i()];
                this.states = [
                    new egret.gui.State("normal", [
                    ]),
                    new egret.gui.State("disabled", [
                    ])
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
                var t = new egret.gui.Button();
                this.thumb = t;
                t.height = 24;
                t.skinName = skins.simple.HSliderThumbSkin;
                t.verticalCenter = 0;
                t.width = 24;
                return t;
            };
            HSliderSkin.prototype.trackHighlight_i = function () {
                var t = new egret.gui.UIAsset();
                this.trackHighlight = t;
                t.height = 10;
                t.source = "hslider_fill_png";
                t.verticalCenter = 0;
                return t;
            };
            HSliderSkin.prototype.track_i = function () {
                var t = new egret.gui.UIAsset();
                this.track = t;
                t.height = 10;
                t.source = "hslider_track_png";
                t.verticalCenter = 0;
                t.percentWidth = 100;
                return t;
            };
            HSliderSkin._skinParts = ["track", "trackHighlight", "thumb"];
            return HSliderSkin;
        })(egret.gui.Skin);
        simple.HSliderSkin = HSliderSkin;
        HSliderSkin.prototype.__class__ = "simple.HSliderSkin";
    })(simple = skins.simple || (skins.simple = {}));
})(skins || (skins = {}));
