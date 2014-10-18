var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var TreeSkin = (function (_super) {
            __extends(TreeSkin, _super);
            function TreeSkin() {
                _super.call(this);

                this.elementsContent = [this.__4_i()];
                this.states = [
                    new egret.gui.State("normal", []),
                    new egret.gui.State("disabled", [])
                ];
            }
            Object.defineProperty(TreeSkin.prototype, "skinParts", {
                get: function () {
                    return TreeSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            TreeSkin.prototype.__4_i = function () {
                var t = new egret.gui.Scroller();
                t.percentHeight = 100;
                t.percentWidth = 100;
                t.viewport = this.dataGroup_i();
                return t;
            };
            TreeSkin.prototype.dataGroup_i = function () {
                var t = new egret.gui.DataGroup();
                this.dataGroup = t;
                t.itemRendererSkinName = skins.simple.TreeItemRendererSkin;
                t.layout = this.__3_i();
                return t;
            };
            TreeSkin.prototype.__3_i = function () {
                var t = new egret.gui.VerticalLayout();
                t.gap = 2;
                t.horizontalAlign = "justify";
                return t;
            };
            TreeSkin._skinParts = ["dataGroup"];
            return TreeSkin;
        })(egret.gui.Skin);
        simple.TreeSkin = TreeSkin;
        TreeSkin.prototype.__class__ = "skins.simple.TreeSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
