var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var ItemRendererSkin = (function (_super) {
        __extends(ItemRendererSkin, _super);
        function ItemRendererSkin() {
            _super.call(this);

            this.height = 85;
            this.elementsContent = [this.__3_i(), this.labelDisplay_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__3", "source", "list-item-up"),
                    new egret.SetProperty("labelDisplay", "textColor", 0x727070)
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__3", "source", "list-item-selected"),
                    new egret.SetProperty("labelDisplay", "textColor", 0xeeedec)
                ])
            ];
        }
        Object.defineProperty(ItemRendererSkin.prototype, "skinParts", {
            get: function () {
                return ItemRendererSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        ItemRendererSkin.prototype.labelDisplay_i = function () {
            var t = new egret.Label();
            this.labelDisplay = t;
            t.fontFamily = "Tahoma";
            t.left = 32;
            t.size = 26;
            t.verticalCenter = 0;
            return t;
        };
        ItemRendererSkin.prototype.__3_i = function () {
            var t = new egret.UIAsset();
            this.__3 = t;
            t.percentHeight = 100;
            t.percentWidth = 100;
            return t;
        };
        ItemRendererSkin._skinParts = ["labelDisplay"];
        return ItemRendererSkin;
    })(egret.Skin);
    skins.ItemRendererSkin = ItemRendererSkin;
})(skins || (skins = {}));
