var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var ListScreenSkin = (function (_super) {
        __extends(ListScreenSkin, _super);
        function ListScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.list_i()];
        }
        Object.defineProperty(ListScreenSkin.prototype, "skinParts", {
            get: function () {
                return ListScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        ListScreenSkin.prototype.list_i = function () {
            var t = new egret.List();
            this.list = t;
            t.percentHeight = 100;
            t.itemRendererSkinName = skins.ItemRendererSkin;
            t.percentWidth = 100;
            return t;
        };
        ListScreenSkin._skinParts = ["list"];
        return ListScreenSkin;
    })(egret.Skin);
    screenContentSkins.ListScreenSkin = ListScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
