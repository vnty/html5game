var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var screenContentSkins;
(function (screenContentSkins) {
    var TabBarScreenSkin = (function (_super) {
        __extends(TabBarScreenSkin, _super);
        function TabBarScreenSkin() {
            _super.call(this);

            this.elementsContent = [this.bar_i(), this.label_i()];
        }
        Object.defineProperty(TabBarScreenSkin.prototype, "skinParts", {
            get: function () {
                return TabBarScreenSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        TabBarScreenSkin.prototype.label_i = function () {
            var t = new egret.Label();
            this.label = t;
            t.fontFamily = "微软雅黑";
            t.horizontalCenter = 0;
            t.maxDisplayedLines = 1;
            t.text = "选中第1项";
            t.textColor = 0x727070;
            t.verticalCenter = -100;
            return t;
        };
        TabBarScreenSkin.prototype.bar_i = function () {
            var t = new egret.TabBar();
            this.bar = t;
            t.horizontalCenter = 0;
            t.verticalCenter = 0;
            return t;
        };
        TabBarScreenSkin._skinParts = ["bar", "label"];
        return TabBarScreenSkin;
    })(egret.Skin);
    screenContentSkins.TabBarScreenSkin = TabBarScreenSkin;
})(screenContentSkins || (screenContentSkins = {}));
