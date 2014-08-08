var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var LabelScreenSkin = (function (_super) {
        __extends(LabelScreenSkin, _super);
        function LabelScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.__8_i()];
        }
        LabelScreenSkin.prototype.__1_i = function () {
            var t = new egret.Label();
            t.fontFamily = "微软雅黑";
            t.percentHeight = 100;
            t.text = "左对齐文本";
            t.textColor = 0x727070;
            t.percentWidth = 100;
            return t;
        };
        LabelScreenSkin.prototype.__2_i = function () {
            var t = new egret.Label();
            t.fontFamily = "微软雅黑";
            t.percentHeight = 100;
            t.text = "水平居中文本";
            t.textAlign = "center";
            t.textColor = 0x727070;
            t.percentWidth = 100;
            return t;
        };
        LabelScreenSkin.prototype.__3_i = function () {
            var t = new egret.Label();
            t.fontFamily = "微软雅黑";
            t.percentHeight = 100;
            t.text = "右对齐文本";
            t.textAlign = "right";
            t.textColor = 0x727070;
            t.percentWidth = 100;
            return t;
        };
        LabelScreenSkin.prototype.__4_i = function () {
            var t = new egret.Label();
            t.fontFamily = "微软雅黑";
            t.percentHeight = 100;
            t.text = "垂直居中文本";
            t.textColor = 0x727070;
            t.verticalAlign = "middle";
            t.percentWidth = 100;
            return t;
        };
        LabelScreenSkin.prototype.__5_i = function () {
            var t = new egret.Label();
            t.fontFamily = "微软雅黑";
            t.percentHeight = 100;
            t.text = "底对齐文本";
            t.textColor = 0x727070;
            t.verticalAlign = "bottom";
            t.percentWidth = 100;
            return t;
        };
        LabelScreenSkin.prototype.__6_i = function () {
            var t = new egret.Label();
            t.bold = true;
            t.fontFamily = "微软雅黑";
            t.percentHeight = 100;
            t.text = "粗体文本";
            t.textAlign = "right";
            t.textColor = 0x727070;
            t.verticalAlign = "bottom";
            t.percentWidth = 100;
            return t;
        };
        LabelScreenSkin.prototype.__7_i = function () {
            var t = new egret.Label();
            t.fontFamily = "微软雅黑";
            t.percentHeight = 100;
            t.italic = true;
            t.text = "斜体文本";
            t.textAlign = "center";
            t.textColor = 0x727070;
            t.verticalAlign = "middle";
            t.percentWidth = 100;
            return t;
        };
        LabelScreenSkin.prototype.__8_i = function () {
            var t = new egret.Group();
            t.bottom = 50;
            t.left = 50;
            t.right = 50;
            t.top = 50;
            t.elementsContent = [this.__1_i(), this.__2_i(), this.__3_i(), this.__4_i(), this.__5_i(), this.__6_i(), this.__7_i()];
            return t;
        };
        return LabelScreenSkin;
    })(egret.Skin);
    screenContentSkins.LabelScreenSkin = LabelScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
