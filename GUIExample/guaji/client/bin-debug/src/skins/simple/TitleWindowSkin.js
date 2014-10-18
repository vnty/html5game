var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var TitleWindowSkin = (function (_super) {
            __extends(TitleWindowSkin, _super);
            function TitleWindowSkin() {
                _super.call(this);

                this.maxWidth = 710;
                this.minHeight = 230;
                this.minWidth = 470;
                this.elementsContent = [this.__3_i(), this.moveArea_i(), this.contentGroup_i()];
                this.states = [
                    new egret.gui.State("normal", []),
                    new egret.gui.State("disabled", [])
                ];
            }
            Object.defineProperty(TitleWindowSkin.prototype, "skinParts", {
                get: function () {
                    return TitleWindowSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            TitleWindowSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                t.bottom = -4;
                t.left = -3;
                t.right = -3;
                t.source = "panel_headeback_png";
                t.top = -2;
                return t;
            };
            TitleWindowSkin.prototype.closeButton_i = function () {
                var t = new egret.gui.Button();
                this.closeButton = t;
                t.right = 10;
                t.skinName = skins.simple.CloseButtonSkin;
                t.verticalCenter = 0;
                return t;
            };
            TitleWindowSkin.prototype.contentGroup_i = function () {
                var t = new egret.gui.Group();
                this.contentGroup = t;
                t.bottom = 0;
                t.clipAndEnableScrolling = true;
                t.top = 51;
                t.percentWidth = 100;
                return t;
            };
            TitleWindowSkin.prototype.moveArea_i = function () {
                var t = new egret.gui.Group();
                this.moveArea = t;
                t.height = 50;
                t.left = 0;
                t.right = 0;
                t.elementsContent = [this.__4_i(), this.titleDisplay_i(), this.closeButton_i()];
                return t;
            };
            TitleWindowSkin.prototype.__3_i = function () {
                var t = new egret.gui.UIAsset();
                t.bottom = -10;
                t.left = -4;
                t.right = -10;
                t.source = "panel_back_png";
                t.top = -4;
                return t;
            };
            TitleWindowSkin.prototype.titleDisplay_i = function () {
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
            TitleWindowSkin._skinParts = ["titleDisplay", "closeButton", "moveArea", "contentGroup"];
            return TitleWindowSkin;
        })(egret.gui.Skin);
        simple.TitleWindowSkin = TitleWindowSkin;
        TitleWindowSkin.prototype.__class__ = "skins.simple.TitleWindowSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
