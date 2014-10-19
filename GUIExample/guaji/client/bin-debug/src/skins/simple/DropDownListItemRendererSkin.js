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
        var DropDownListItemRendererSkin = (function (_super) {
            __extends(DropDownListItemRendererSkin, _super);
            function DropDownListItemRendererSkin() {
                _super.call(this);
                this.height = 40;
                this.elementsContent = [this.__4_i(), this.__5_i(), this.labelDisplay_i()];
                this.states = [
                    new egret.gui.State("up", [
                    ]),
                    new egret.gui.State("down", [
                        new egret.gui.SetProperty("__4", "source", "app_list_item_select_png"),
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0xf0f0f0)
                    ]),
                    new egret.gui.State("disabled", [
                    ])
                ];
            }
            Object.defineProperty(DropDownListItemRendererSkin.prototype, "skinParts", {
                get: function () {
                    return DropDownListItemRendererSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            DropDownListItemRendererSkin.prototype.__5_i = function () {
                var t = new egret.gui.UIAsset();
                t.height = 1;
                t.source = "app_list_item_cutlline_png";
                t.percentWidth = 100;
                return t;
            };
            DropDownListItemRendererSkin.prototype.labelDisplay_i = function () {
                var t = new egret.gui.Label();
                this.labelDisplay = t;
                t.fontFamily = "Tahoma";
                t.left = 32;
                t.size = 24;
                t.textColor = 0x111111;
                t.verticalCenter = 0;
                return t;
            };
            DropDownListItemRendererSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                this.__4 = t;
                t.percentHeight = 100;
                t.source = "app_list_item_up_png";
                t.percentWidth = 100;
                return t;
            };
            DropDownListItemRendererSkin._skinParts = ["labelDisplay"];
            return DropDownListItemRendererSkin;
        })(egret.gui.Skin);
        simple.DropDownListItemRendererSkin = DropDownListItemRendererSkin;
        DropDownListItemRendererSkin.prototype.__class__ = "simple.DropDownListItemRendererSkin";
    })(simple = skins.simple || (skins.simple = {}));
})(skins || (skins = {}));
