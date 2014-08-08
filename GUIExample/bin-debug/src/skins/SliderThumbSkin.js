var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var SliderThumbSkin = (function (_super) {
        __extends(SliderThumbSkin, _super);
        function SliderThumbSkin() {
            _super.call(this);

            this.height = 0;
            this.width = 0;
            this.elementsContent = [this.__4_i()];
            this.states = [
                new egret.State("up", []),
                new egret.State("down", []),
                new egret.State("disabled", [])
            ];
        }
        SliderThumbSkin.prototype.__4_i = function () {
            var t = new egret.UIAsset();
            t.source = "page-indicator-selected";
            t.x = -9;
            t.y = -9;
            return t;
        };
        return SliderThumbSkin;
    })(egret.Skin);
    skins.SliderThumbSkin = SliderThumbSkin;
})(skins || (skins = {}));
