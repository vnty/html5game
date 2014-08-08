var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var TreeScreenSkin = (function (_super) {
        __extends(TreeScreenSkin, _super);
        function TreeScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.tree_i()];
        }
        Object.defineProperty(TreeScreenSkin.prototype, "skinParts", {
            get: function () {
                return TreeScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        TreeScreenSkin.prototype.tree_i = function () {
            var t = new egret.Tree();
            this.tree = t;
            t.height = 200;
            t.horizontalCenter = 0;
            t.itemRendererSkinName = skins.TreeItemRendererSkin;
            t.labelField = "name";
            t.verticalCenter = 0;
            t.width = 190;
            return t;
        };
        TreeScreenSkin._skinParts = ["tree"];
        return TreeScreenSkin;
    })(egret.Skin);
    screenContentSkins.TreeScreenSkin = TreeScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
