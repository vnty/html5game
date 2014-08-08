var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var ListSkin = (function (_super) {
        __extends(ListSkin, _super);
        function ListSkin() {
            _super.call(this);

            this.elementsContent = [this.__2_i()];
        }
        Object.defineProperty(ListSkin.prototype, "skinParts", {
            get: function () {
                return ListSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        ListSkin.prototype.__2_i = function () {
            var t = new egret.Scroller();
            t.percentHeight = 100;
            t.percentWidth = 100;
            t.viewport = this.dataGroup_i();
            return t;
        };
        ListSkin.prototype.dataGroup_i = function () {
            var t = new egret.DataGroup();
            this.dataGroup = t;
            t.layout = this.__1_i();
            return t;
        };
        ListSkin.prototype.__1_i = function () {
            var t = new egret.VerticalLayout();
            t.gap = 0;
            t.horizontalAlign = "justify";
            return t;
        };
        ListSkin._skinParts = ["dataGroup"];
        return ListSkin;
    })(egret.Skin);
    skins.ListSkin = ListSkin;
})(skins || (skins = {}));
