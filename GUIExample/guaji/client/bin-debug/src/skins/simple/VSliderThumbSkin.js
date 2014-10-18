var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var VSliderThumbSkin = (function (_super) {
            __extends(VSliderThumbSkin, _super);
            function VSliderThumbSkin() {
                _super.call(this);

                this.elementsContent = [this.__4_i()];
                this.states = [
                    new egret.gui.State("up", []),
                    new egret.gui.State("down", []),
                    new egret.gui.State("disabled", [])
                ];
            }
            VSliderThumbSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                t.percentHeight = 100;
                t.source = "vslider_thumb_png";
                t.percentWidth = 100;
                return t;
            };
            return VSliderThumbSkin;
        })(egret.gui.Skin);
        simple.VSliderThumbSkin = VSliderThumbSkin;
        VSliderThumbSkin.prototype.__class__ = "skins.simple.VSliderThumbSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
