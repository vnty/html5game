var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var VSliderSkin = (function (_super) {
            __extends(VSliderSkin, _super);
            function VSliderSkin() {
                _super.call(this);

                this.minHeight = 13;
                this.minWidth = 13;
                this.elementsContent = [this.track_i(), this.trackHighlight_i(), this.thumb_i()];
                this.states = [
                    new egret.gui.State("normal", []),
                    new egret.gui.State("disabled", [])
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
                var t = new egret.gui.Button();
                this.thumb = t;
                t.height = 24;
                t.horizontalCenter = 0;
                t.skinName = skins.simple.VSliderThumbSkin;
                t.width = 24;
                return t;
            };
            VSliderSkin.prototype.trackHighlight_i = function () {
                var t = new egret.gui.UIAsset();
                this.trackHighlight = t;
                t.horizontalCenter = 0;
                t.source = "vslider_fill_png";
                t.width = 10;
                return t;
            };
            VSliderSkin.prototype.track_i = function () {
                var t = new egret.gui.UIAsset();
                this.track = t;
                t.percentHeight = 100;
                t.horizontalCenter = 0;
                t.source = "vslider_track_png";
                t.width = 10;
                return t;
            };
            VSliderSkin._skinParts = ["track", "trackHighlight", "thumb"];
            return VSliderSkin;
        })(egret.gui.Skin);
        simple.VSliderSkin = VSliderSkin;
        VSliderSkin.prototype.__class__ = "skins.simple.VSliderSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
