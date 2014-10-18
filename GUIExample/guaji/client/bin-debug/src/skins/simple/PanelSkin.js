var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var PanelSkin = (function (_super) {
            __extends(PanelSkin, _super);
            function PanelSkin() {
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
            Object.defineProperty(PanelSkin.prototype, "skinParts", {
                get: function () {
                    return PanelSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            PanelSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                t.bottom = -4;
                t.left = -2;
                t.right = -2;
                t.source = "panel_headeback_png";
                t.top = -2;
                return t;
            };
            PanelSkin.prototype.contentGroup_i = function () {
                var t = new egret.gui.Group();
                this.contentGroup = t;
                t.bottom = 0;
                t.clipAndEnableScrolling = true;
                t.top = 50;
                t.percentWidth = 100;
                return t;
            };
            PanelSkin.prototype.moveArea_i = function () {
                var t = new egret.gui.Group();
                this.moveArea = t;
                t.height = 50;
                t.left = 0;
                t.right = 0;
                t.elementsContent = [this.__4_i(), this.titleDisplay_i()];
                return t;
            };
            PanelSkin.prototype.__3_i = function () {
                var t = new egret.gui.UIAsset();
                t.bottom = -10;
                t.left = -4;
                t.right = -10;
                t.source = "panel_back_png";
                t.top = -4;
                return t;
            };
            PanelSkin.prototype.titleDisplay_i = function () {
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
            PanelSkin._skinParts = ["titleDisplay", "moveArea", "contentGroup"];
            return PanelSkin;
        })(egret.gui.Skin);
        simple.PanelSkin = PanelSkin;
        PanelSkin.prototype.__class__ = "skins.simple.PanelSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
