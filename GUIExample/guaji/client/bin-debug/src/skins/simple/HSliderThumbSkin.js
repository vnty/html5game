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
        var HSliderThumbSkin = (function (_super) {
            __extends(HSliderThumbSkin, _super);
            function HSliderThumbSkin() {
                _super.call(this);
                this.elementsContent = [this.__4_i()];
                this.states = [
                    new egret.gui.State("up", [
                    ]),
                    new egret.gui.State("down", [
                    ]),
                    new egret.gui.State("disabled", [
                    ])
                ];
            }
            HSliderThumbSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                t.fillMode = "scale";
                t.percentHeight = 100;
                t.source = "hslider_thumb_png";
                t.percentWidth = 100;
                return t;
            };
            return HSliderThumbSkin;
        })(egret.gui.Skin);
        simple.HSliderThumbSkin = HSliderThumbSkin;
        HSliderThumbSkin.prototype.__class__ = "simple.HSliderThumbSkin";
    })(simple = skins.simple || (skins.simple = {}));
})(skins || (skins = {}));
