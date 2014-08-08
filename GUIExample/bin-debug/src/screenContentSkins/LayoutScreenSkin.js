var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var LayoutScreenSkin = (function (_super) {
        __extends(LayoutScreenSkin, _super);
        function LayoutScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.__4_i()];
        }
        Object.defineProperty(LayoutScreenSkin.prototype, "skinParts", {
            get: function () {
                return LayoutScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        LayoutScreenSkin.prototype.__2_i = function () {
            var t = new egret.Group();
            t.bottom = 5;
            t.left = 5;
            t.right = 5;
            t.top = 5;
            t.elementsContent = [this.panel_i()];
            return t;
        };
        LayoutScreenSkin.prototype.__3_i = function () {
            var t = new egret.Group();
            t.horizontalCenter = 0;
            t.verticalCenter = 0;
            t.elementsContent = [this.__1_i(), this.__2_i(), this.vleftLine_i(), this.vMiddleLine_i(), this.vRightLine_i(), this.hTopLine_i(), this.hMiddleLine_i(), this.hBottomLine_i()];
            return t;
        };
        LayoutScreenSkin.prototype.__4_i = function () {
            var t = new egret.Group();
            t.horizontalCenter = 0;
            t.verticalCenter = 0;
            t.elementsContent = [this.__3_i(), this.topCheck_i(), this.topLeftCheck_i(), this.topRightCheck_i(), this.leftChcek_i(), this.leftTopCheck_i(), this.leftBottomCheck_i()];
            return t;
        };
        LayoutScreenSkin.prototype.hBottomLine_i = function () {
            var t = new egret.Rect();
            this.hBottomLine = t;
            t.bottom = 5;
            t.fillColor = 0x707070;
            t.height = 1;
            t.left = 3;
            t.right = 3;
            t.visible = false;
            return t;
        };
        LayoutScreenSkin.prototype.hMiddleLine_i = function () {
            var t = new egret.Rect();
            this.hMiddleLine = t;
            t.fillColor = 0x707070;
            t.height = 1;
            t.left = 3;
            t.right = 3;
            t.verticalCenter = 0;
            t.visible = false;
            return t;
        };
        LayoutScreenSkin.prototype.hTopLine_i = function () {
            var t = new egret.Rect();
            this.hTopLine = t;
            t.fillColor = 0x707070;
            t.height = 1;
            t.left = 3;
            t.right = 3;
            t.top = 5;
            t.visible = false;
            return t;
        };
        LayoutScreenSkin.prototype.leftBottomCheck_i = function () {
            var t = new egret.CheckBox();
            this.leftBottomCheck = t;
            t.bottom = 0;
            t.left = -50;
            return t;
        };
        LayoutScreenSkin.prototype.leftChcek_i = function () {
            var t = new egret.CheckBox();
            this.leftChcek = t;
            t.left = -50;
            t.verticalCenter = 0;
            return t;
        };
        LayoutScreenSkin.prototype.leftTopCheck_i = function () {
            var t = new egret.CheckBox();
            this.leftTopCheck = t;
            t.left = -50;
            t.top = 0;
            return t;
        };
        LayoutScreenSkin.prototype.panel_i = function () {
            var t = new egret.UIAsset();
            this.panel = t;
            t.height = 200;
            t.source = "alert-background";
            t.width = 200;
            t.x = 50;
            t.y = 50;
            return t;
        };
        LayoutScreenSkin.prototype.__1_i = function () {
            var t = new egret.UIAsset();
            t.height = 400;
            t.source = "area-bg";
            t.width = 400;
            return t;
        };
        LayoutScreenSkin.prototype.topCheck_i = function () {
            var t = new egret.CheckBox();
            this.topCheck = t;
            t.horizontalCenter = 0;
            t.top = -50;
            return t;
        };
        LayoutScreenSkin.prototype.topLeftCheck_i = function () {
            var t = new egret.CheckBox();
            this.topLeftCheck = t;
            t.left = 0;
            t.top = -50;
            return t;
        };
        LayoutScreenSkin.prototype.topRightCheck_i = function () {
            var t = new egret.CheckBox();
            this.topRightCheck = t;
            t.right = 0;
            t.top = -50;
            return t;
        };
        LayoutScreenSkin.prototype.vMiddleLine_i = function () {
            var t = new egret.Rect();
            this.vMiddleLine = t;
            t.bottom = 3;
            t.fillColor = 0x707070;
            t.horizontalCenter = 0;
            t.top = 3;
            t.visible = false;
            t.width = 1;
            return t;
        };
        LayoutScreenSkin.prototype.vRightLine_i = function () {
            var t = new egret.Rect();
            this.vRightLine = t;
            t.bottom = 3;
            t.fillColor = 0x707070;
            t.right = 5;
            t.top = 3;
            t.visible = false;
            t.width = 1;
            return t;
        };
        LayoutScreenSkin.prototype.vleftLine_i = function () {
            var t = new egret.Rect();
            this.vleftLine = t;
            t.bottom = 3;
            t.fillColor = 0x707070;
            t.left = 5;
            t.top = 3;
            t.visible = false;
            t.width = 1;
            return t;
        };
        LayoutScreenSkin._skinParts = ["panel", "vleftLine", "vMiddleLine", "vRightLine", "hTopLine", "hMiddleLine", "hBottomLine", "topCheck", "topLeftCheck", "topRightCheck", "leftChcek", "leftTopCheck", "leftBottomCheck"];
        return LayoutScreenSkin;
    })(egret.Skin);
    screenContentSkins.LayoutScreenSkin = LayoutScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
