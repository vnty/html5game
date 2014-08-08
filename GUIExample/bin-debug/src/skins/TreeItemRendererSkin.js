var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var TreeItemRendererSkin = (function (_super) {
        __extends(TreeItemRendererSkin, _super);
        function TreeItemRendererSkin() {
            _super.call(this);

            this.minHeight = 22;
            this.elementsContent = [this.contentGroup_i()];
        }
        Object.defineProperty(TreeItemRendererSkin.prototype, "skinParts", {
            get: function () {
                return TreeItemRendererSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        TreeItemRendererSkin.prototype.contentGroup_i = function () {
            var t = new egret.Group();
            this.contentGroup = t;
            t.bottom = 0;
            t.top = 0;
            t.layout = this.__1_i();
            t.elementsContent = [this.disclosureButton_i(), this.iconDisplay_i(), this.labelDisplay_i()];
            return t;
        };
        TreeItemRendererSkin.prototype.disclosureButton_i = function () {
            var t = new egret.ToggleButton();
            this.disclosureButton = t;
            t.skinName = skins.TreeDisclosureButtonSkin;
            t.verticalCenter = 0;
            return t;
        };
        TreeItemRendererSkin.prototype.iconDisplay_i = function () {
            var t = new egret.UIAsset();
            this.iconDisplay = t;
            return t;
        };
        TreeItemRendererSkin.prototype.labelDisplay_i = function () {
            var t = new egret.Label();
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
        TreeItemRendererSkin.prototype.__1_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = 1;
            t.verticalAlign = "middle";
            return t;
        };
        TreeItemRendererSkin._skinParts = ["disclosureButton", "iconDisplay", "labelDisplay", "contentGroup"];
        return TreeItemRendererSkin;
    })(egret.Skin);
    skins.TreeItemRendererSkin = TreeItemRendererSkin;
})(skins || (skins = {}));
