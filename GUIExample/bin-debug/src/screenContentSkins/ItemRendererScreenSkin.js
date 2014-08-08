var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var ItemRendererScreenSkin = (function (_super) {
        __extends(ItemRendererScreenSkin, _super);
        function ItemRendererScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.list_i()];
        }
        Object.defineProperty(ItemRendererScreenSkin.prototype, "skinParts", {
            get: function () {
                return ItemRendererScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        ItemRendererScreenSkin.prototype.list_i = function () {
            var t = new egret.List();
            this.list = t;
            t.percentHeight = 100;
            t.itemRenderer = new egret.ClassFactory(CustomItemRender);
            t.itemRendererSkinName = skins.CustomItemRendererSkin;
            t.percentWidth = 100;
            return t;
        };
        ItemRendererScreenSkin._skinParts = ["list"];
        return ItemRendererScreenSkin;
    })(egret.Skin);
    screenContentSkins.ItemRendererScreenSkin = ItemRendererScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
