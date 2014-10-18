var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var AlertSkin = (function (_super) {
            __extends(AlertSkin, _super);
            function AlertSkin() {
                _super.call(this);

                this.maxWidth = 710;
                this.minHeight = 230;
                this.minWidth = 370;
                this.elementsContent = [this.__1_i(), this.moveArea_i(), this.contentDisplay_i(), this.__4_i()];
            }
            Object.defineProperty(AlertSkin.prototype, "skinParts", {
                get: function () {
                    return AlertSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            AlertSkin.prototype.__2_i = function () {
                var t = new egret.gui.UIAsset();
                t.percentHeight = 100;
                t.source = "panel_headeback_png";
                t.percentWidth = 100;
                return t;
            };
            AlertSkin.prototype.__3_i = function () {
                var t = new egret.gui.HorizontalLayout();
                t.gap = 10;
                t.horizontalAlign = "center";
                t.paddingLeft = 20;
                t.paddingRight = 20;
                return t;
            };
            AlertSkin.prototype.__4_i = function () {
                var t = new egret.gui.Group();
                t.bottom = 25;
                t.horizontalCenter = 0;
                t.layout = this.__3_i();
                t.elementsContent = [this.firstButton_i(), this.secondButton_i()];
                return t;
            };
            AlertSkin.prototype.closeButton_i = function () {
                var t = new egret.gui.Button();
                this.closeButton = t;
                t.right = 10;
                t.skinName = skins.simple.CloseButtonSkin;
                t.verticalCenter = 0;
                return t;
            };
            AlertSkin.prototype.contentDisplay_i = function () {
                var t = new egret.gui.Label();
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
                var t = new egret.gui.Button();
                this.firstButton = t;
                t.height = 50;
                t.label = "确定";
                t.width = 115;
                return t;
            };
            AlertSkin.prototype.moveArea_i = function () {
                var t = new egret.gui.Group();
                this.moveArea = t;
                t.height = 55;
                t.left = 3;
                t.right = 9;
                t.elementsContent = [this.__2_i(), this.titleDisplay_i(), this.closeButton_i()];
                return t;
            };
            AlertSkin.prototype.secondButton_i = function () {
                var t = new egret.gui.Button();
                this.secondButton = t;
                t.height = 50;
                t.label = "取消";
                t.width = 115;
                return t;
            };
            AlertSkin.prototype.__1_i = function () {
                var t = new egret.gui.UIAsset();
                t.percentHeight = 100;
                t.source = "panel_back_png";
                t.percentWidth = 100;
                return t;
            };
            AlertSkin.prototype.titleDisplay_i = function () {
                var t = new egret.gui.Label();
                this.titleDisplay = t;
                t.fontFamily = "Tahoma";
                t.left = 5;
                t.maxDisplayedLines = 1;
                t.minHeight = 28;
                t.right = 5;
                t.size = 26;
                t.textAlign = "center";
                t.textColor = 0x727070;
                t.verticalAlign = "middle";
                t.verticalCenter = 0;
                return t;
            };
            AlertSkin._skinParts = ["titleDisplay", "closeButton", "moveArea", "contentDisplay", "firstButton", "secondButton"];
            return AlertSkin;
        })(egret.gui.Skin);
        simple.AlertSkin = AlertSkin;
        AlertSkin.prototype.__class__ = "skins.simple.AlertSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
