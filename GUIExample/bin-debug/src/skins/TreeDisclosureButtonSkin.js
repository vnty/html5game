var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var TreeDisclosureButtonSkin = (function (_super) {
        __extends(TreeDisclosureButtonSkin, _super);
        function TreeDisclosureButtonSkin() {
            _super.call(this);

            this.minHeight = 22;
            this.elementsContent = [this.__7_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__7", "source", "button-forward-up")
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__7", "source", "button-forward-down")
                ]),
                new egret.State("disabled", [
                    new egret.SetProperty("__7", "source", "button-forward-disabled")
                ]),
                new egret.State("upAndSelected", [
                    new egret.SetProperty("__7", "source", "button-forward-up-select")
                ]),
                new egret.State("downAndSelected", [
                    new egret.SetProperty("__7", "source", "button-forward-down-select")
                ]),
                new egret.State("disabledAndSelected", [
                    new egret.SetProperty("__7", "source", "button-forward-disabled-select")
                ])
            ];
        }
        TreeDisclosureButtonSkin.prototype.__7_i = function () {
            var t = new egret.UIAsset();
            this.__7 = t;
            t.percentHeight = 100;
            t.percentWidth = 100;
            return t;
        };
        return TreeDisclosureButtonSkin;
    })(egret.Skin);
    skins.TreeDisclosureButtonSkin = TreeDisclosureButtonSkin;
})(skins || (skins = {}));
