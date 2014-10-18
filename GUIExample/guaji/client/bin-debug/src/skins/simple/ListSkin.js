var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var ListSkin = (function (_super) {
            __extends(ListSkin, _super);
            function ListSkin() {
                _super.call(this);

                this.elementsContent = [this.__4_i()];
                this.states = [
                    new egret.gui.State("normal", []),
                    new egret.gui.State("disabled", [])
                ];
            }
            Object.defineProperty(ListSkin.prototype, "skinParts", {
                get: function () {
                    return ListSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            ListSkin.prototype.__4_i = function () {
                var t = new egret.gui.Scroller();
                t.percentHeight = 100;
                t.horizontalScrollPolicy = "off";
                t.percentWidth = 100;
                t.viewport = this.dataGroup_i();
                return t;
            };
            ListSkin.prototype.dataGroup_i = function () {
                var t = new egret.gui.DataGroup();
                this.dataGroup = t;
                t.layout = this.__3_i();
                return t;
            };
            ListSkin.prototype.__3_i = function () {
                var t = new egret.gui.VerticalLayout();
                t.gap = 0;
                t.horizontalAlign = "contentJustify";
                return t;
            };
            ListSkin._skinParts = ["dataGroup"];
            return ListSkin;
        })(egret.gui.Skin);
        simple.ListSkin = ListSkin;
        ListSkin.prototype.__class__ = "skins.simple.ListSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
