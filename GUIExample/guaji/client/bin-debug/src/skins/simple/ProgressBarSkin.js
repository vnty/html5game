var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var ProgressBarSkin = (function (_super) {
            __extends(ProgressBarSkin, _super);
            function ProgressBarSkin() {
                _super.call(this);

                this.height = 100;
                this.elementsContent = [this.__3_i(), this.thumb_i(), this.track_i(), this.labelDisplay_i()];
                this.states = [
                    new egret.gui.State("normal", []),
                    new egret.gui.State("disabled", [])
                ];
            }
            Object.defineProperty(ProgressBarSkin.prototype, "skinParts", {
                get: function () {
                    return ProgressBarSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            ProgressBarSkin.prototype.labelDisplay_i = function () {
                var t = new egret.gui.Label();
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
            ProgressBarSkin.prototype.__3_i = function () {
                var t = new egret.gui.UIAsset();
                t.percentHeight = 100;
                t.source = "progressbar_track_png";
                t.percentWidth = 100;
                return t;
            };
            ProgressBarSkin.prototype.thumb_i = function () {
                var t = new egret.gui.UIAsset();
                this.thumb = t;
                t.source = "progressbar_fill_png";
                return t;
            };
            ProgressBarSkin.prototype.track_i = function () {
                var t = new egret.gui.UIComponent();
                this.track = t;
                t.percentHeight = 100;
                t.percentWidth = 100;
                return t;
            };
            ProgressBarSkin._skinParts = ["thumb", "track", "labelDisplay"];
            return ProgressBarSkin;
        })(egret.gui.Skin);
        simple.ProgressBarSkin = ProgressBarSkin;
        ProgressBarSkin.prototype.__class__ = "skins.simple.ProgressBarSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
