var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var AlertSkin = (function (_super) {
        __extends(AlertSkin, _super);
        function AlertSkin() {
            _super.call(this);

            this.maxWidth = 710;
            this.minHeight = 230;
            this.minWidth = 470;
            this.elementsContent = [this.__1_i(), this.titleDisplay_i(), this.contentDisplay_i(), this.__3_i()];
        }
        Object.defineProperty(AlertSkin.prototype, "skinParts", {
            get: function () {
                return AlertSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        AlertSkin.prototype.__2_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = 10;
            t.horizontalAlign = "center";
            t.paddingLeft = 20;
            t.paddingRight = 20;
            return t;
        };
        AlertSkin.prototype.__3_i = function () {
            var t = new egret.Group();
            t.bottom = 10;
            t.horizontalCenter = 0;
            t.layout = this.__2_i();
            t.elementsContent = [this.firstButton_i(), this.secondButton_i()];
            return t;
        };
        AlertSkin.prototype.contentDisplay_i = function () {
            var t = new egret.Label();
            this.contentDisplay = t;
            t.bottom = 45;
            t.fontFamily = "Tahoma";
            t.left = 1;
            t.padding = 10;
            t.right = 1;
            t.size = 22;
            t.textAlign = "center";
            t.textColor = 0x727070;
            t.top = 36;
            t.verticalAlign = "middle";
            return t;
        };
        AlertSkin.prototype.firstButton_i = function () {
            var t = new egret.Button();
            this.firstButton = t;
            t.height = 50;
            t.label = "确定";
            t.width = 115;
            return t;
        };
        AlertSkin.prototype.secondButton_i = function () {
            var t = new egret.Button();
            this.secondButton = t;
            t.height = 50;
            t.label = "取消";
            t.width = 115;
            return t;
        };
        AlertSkin.prototype.__1_i = function () {
            var t = new egret.UIAsset();
            t.percentHeight = 100;
            t.source = "alert-background";
            t.percentWidth = 100;
            return t;
        };
        AlertSkin.prototype.titleDisplay_i = function () {
            var t = new egret.Label();
            this.titleDisplay = t;
            t.fontFamily = "Tahoma";
            t.left = 5;
            t.maxDisplayedLines = 1;
            t.minHeight = 28;
            t.right = 5;
            t.size = 36;
            t.textAlign = "center";
            t.textColor = 0x727070;
            t.top = 12;
            t.verticalAlign = "middle";
            return t;
        };
        AlertSkin._skinParts = ["titleDisplay", "contentDisplay", "firstButton", "secondButton"];
        return AlertSkin;
    })(egret.Skin);
    skins.AlertSkin = AlertSkin;
})(skins || (skins = {}));
