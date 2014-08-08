var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var TabBarSkin = (function (_super) {
        __extends(TabBarSkin, _super);
        function TabBarSkin() {
            _super.call(this);

            this.minHeight = 20;
            this.minWidth = 60;
            this.elementsContent = [this.dataGroup_i()];
        }
        Object.defineProperty(TabBarSkin.prototype, "skinParts", {
            get: function () {
                return TabBarSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        TabBarSkin.prototype.dataGroup_i = function () {
            var t = new egret.DataGroup();
            this.dataGroup = t;
            t.bottom = 0;
            t.percentHeight = 100;
            t.itemRendererSkinName = skins.ButtonSkin;
            t.top = 90;
            t.percentWidth = 100;
            t.layout = this.__1_i();
            return t;
        };
        TabBarSkin.prototype.__1_i = function () {
            var t = new egret.HorizontalLayout();
            t.gap = -1;
            t.horizontalAlign = "justify";
            t.verticalAlign = "contentJustify";
            return t;
        };
        TabBarSkin._skinParts = ["dataGroup"];
        return TabBarSkin;
    })(egret.Skin);
    skins.TabBarSkin = TabBarSkin;
})(skins || (skins = {}));
