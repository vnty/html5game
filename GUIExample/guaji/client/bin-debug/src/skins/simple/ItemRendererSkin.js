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
        var ItemRendererSkin = (function (_super) {
            __extends(ItemRendererSkin, _super);
            function ItemRendererSkin() {
                _super.call(this);
                this.height = 85;
                this.elementsContent = [this.__4_i(), this.__5_i(), this.labelDisplay_i()];
                this.states = [
                    new egret.gui.State("up", [
                        new egret.gui.SetProperty("__4", "source", "app_list_item_up_png")
                    ]),
                    new egret.gui.State("down", [
                        new egret.gui.SetProperty("__4", "source", "app_list_item_select_png"),
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0xf0f0f0)
                    ]),
                    new egret.gui.State("disabled", [
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
            ItemRendererSkin.prototype.__5_i = function () {
                var t = new egret.gui.Rect();
                t.fillAlpha = 0;
                t.height = .5;
                t.strokeAlpha = 1;
                t.strokeColor = 0x888888;
                t.strokeWeight = .5;
                t.percentWidth = 100;
                return t;
            };
            ItemRendererSkin.prototype.labelDisplay_i = function () {
                var t = new egret.gui.Label();
                this.labelDisplay = t;
                t.fontFamily = "Tahoma";
                t.left = 32;
                t.size = 24;
                t.textColor = 0x111111;
                t.verticalCenter = 0;
                return t;
            };
            ItemRendererSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                this.__4 = t;
                t.percentHeight = 100;
                t.percentWidth = 100;
                return t;
            };
            ItemRendererSkin._skinParts = ["labelDisplay"];
            return ItemRendererSkin;
        })(egret.gui.Skin);
        simple.ItemRendererSkin = ItemRendererSkin;
        ItemRendererSkin.prototype.__class__ = "simple.ItemRendererSkin";
    })(simple = skins.simple || (skins.simple = {}));
})(skins || (skins = {}));
