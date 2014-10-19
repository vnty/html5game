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
        var TreeItemRendererSkin = (function (_super) {
            __extends(TreeItemRendererSkin, _super);
            function TreeItemRendererSkin() {
                _super.call(this);
                this.minHeight = 22;
                this.elementsContent = [this.contentGroup_i()];
                this.states = [
                    new egret.gui.State("up", [
                    ]),
                    new egret.gui.State("down", [
                    ]),
                    new egret.gui.State("disabled", [
                    ])
                ];
            }
            Object.defineProperty(TreeItemRendererSkin.prototype, "skinParts", {
                get: function () {
                    return TreeItemRendererSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            TreeItemRendererSkin.prototype.contentGroup_i = function () {
                var t = new egret.gui.Group();
                this.contentGroup = t;
                t.bottom = 0;
                t.top = 0;
                t.layout = this.__4_i();
                t.elementsContent = [this.disclosureButton_i(), this.iconDisplay_i(), this.labelDisplay_i()];
                return t;
            };
            TreeItemRendererSkin.prototype.disclosureButton_i = function () {
                var t = new egret.gui.ToggleButton();
                this.disclosureButton = t;
                t.skinName = skins.simple.TreeDisclosureButtonSkin;
                t.verticalCenter = 0;
                return t;
            };
            TreeItemRendererSkin.prototype.iconDisplay_i = function () {
                var t = new egret.gui.UIAsset();
                this.iconDisplay = t;
                t.height = 24;
                t.width = 24;
                return t;
            };
            TreeItemRendererSkin.prototype.labelDisplay_i = function () {
                var t = new egret.gui.Label();
                this.labelDisplay = t;
                t.bottom = 3;
                t.fontFamily = "Tahoma";
                t.left = 5;
                t.maxDisplayedLines = 1;
                t.right = 5;
                t.textAlign = "center";
                t.textColor = 0x707070;
                t.top = 3;
                t.verticalAlign = "middle";
                return t;
            };
            TreeItemRendererSkin.prototype.__4_i = function () {
                var t = new egret.gui.HorizontalLayout();
                t.gap = 1;
                t.verticalAlign = "middle";
                return t;
            };
            TreeItemRendererSkin._skinParts = ["disclosureButton", "iconDisplay", "labelDisplay", "contentGroup"];
            return TreeItemRendererSkin;
        })(egret.gui.Skin);
        simple.TreeItemRendererSkin = TreeItemRendererSkin;
        TreeItemRendererSkin.prototype.__class__ = "simple.TreeItemRendererSkin";
    })(simple = skins.simple || (skins.simple = {}));
})(skins || (skins = {}));
