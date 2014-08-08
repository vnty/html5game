var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var SliderScreenSkin = (function (_super) {
        __extends(SliderScreenSkin, _super);
        function SliderScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.hSlider_i(), this.vSlider_i(), this.label_i()];
        }
        Object.defineProperty(SliderScreenSkin.prototype, "skinParts", {
            get: function () {
                return SliderScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        SliderScreenSkin.prototype.label_i = function () {
            var t = new egret.Label();
            this.label = t;
            t.fontFamily = "微软雅黑";
            t.horizontalCenter = 0;
            t.size = 20;
            t.text = "拖拽滑块以改变值";
            t.textColor = 0x727070;
            t.verticalCenter = 0;
            return t;
        };
        SliderScreenSkin.prototype.hSlider_i = function () {
            var t = new egret.HSlider();
            this.hSlider = t;
            t.horizontalCenter = 0;
            t.maximum = 100;
            t.value = 50;
            t.verticalCenter = 135;
            t.width = 250;
            return t;
        };
        SliderScreenSkin.prototype.vSlider_i = function () {
            var t = new egret.VSlider();
            this.vSlider = t;
            t.height = 250;
            t.horizontalCenter = -135;
            t.maximum = 100;
            t.value = 70;
            t.verticalCenter = 0;
            return t;
        };
        SliderScreenSkin._skinParts = ["hSlider", "vSlider", "label"];
        return SliderScreenSkin;
    })(egret.Skin);
    screenContentSkins.SliderScreenSkin = SliderScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
