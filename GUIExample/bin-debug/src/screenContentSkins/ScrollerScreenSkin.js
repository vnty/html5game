var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var ScrollerScreenSkin = (function (_super) {
        __extends(ScrollerScreenSkin, _super);
        function ScrollerScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.__1_i(), this.__4_i()];
        }
        ScrollerScreenSkin.prototype.__1_i = function () {
            var t = new egret.Rect();
            t.bottom = 99;
            t.fillAlpha = 0;
            t.left = 99;
            t.right = 99;
            t.strokeAlpha = 1;
            t.strokeColor = 0x009aff;
            t.top = 99;
            return t;
        };
        ScrollerScreenSkin.prototype.__2_i = function () {
            var t = new egret.UIAsset();
            t.source = "egret_labs";
            return t;
        };
        ScrollerScreenSkin.prototype.__3_i = function () {
            var t = new egret.Group();
            t.elementsContent = [this.__2_i()];
            return t;
        };
        ScrollerScreenSkin.prototype.__4_i = function () {
            var t = new egret.Scroller();
            t.bottom = 100;
            t.left = 100;
            t.right = 100;
            t.top = 100;
            t.viewport = this.__3_i();
            return t;
        };
        return ScrollerScreenSkin;
    })(egret.Skin);
    screenContentSkins.ScrollerScreenSkin = ScrollerScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
