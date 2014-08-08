var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var TreeSkin = (function (_super) {
        __extends(TreeSkin, _super);
        function TreeSkin() {
            _super.call(this);

            this.elementsContent = [this.__1_i(), this.__3_i()];
        }
        Object.defineProperty(TreeSkin.prototype, "skinParts", {
            get: function () {
                return TreeSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        TreeSkin.prototype.__2_i = function () {
            var t = new egret.VerticalLayout();
            t.gap = 2;
            t.horizontalAlign = "justify";
            return t;
        };
        TreeSkin.prototype.__3_i = function () {
            var t = new egret.Scroller();
            t.percentHeight = 100;
            t.percentWidth = 100;
            t.viewport = this.dataGroup_i();
            return t;
        };
        TreeSkin.prototype.dataGroup_i = function () {
            var t = new egret.DataGroup();
            this.dataGroup = t;
            t.layout = this.__2_i();
            return t;
        };
        TreeSkin.prototype.__1_i = function () {
            var t = new egret.UIAsset();
            t.bottom = -1;
            t.left = -1;
            t.right = -1;
            t.source = "tree-bg";
            t.top = -1;
            return t;
        };
        TreeSkin._skinParts = ["dataGroup"];
        return TreeSkin;
    })(egret.Skin);
    skins.TreeSkin = TreeSkin;
})(skins || (skins = {}));
