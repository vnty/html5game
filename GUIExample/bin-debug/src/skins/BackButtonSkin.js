var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var BackButtonSkin = (function (_super) {
        __extends(BackButtonSkin, _super);
        function BackButtonSkin() {
            _super.call(this);

            this.height = 60;
            this.minWidth = 140;
            this.elementsContent = [this.__4_i(), this.labelDisplay_i()];
            this.states = [
                new egret.State("up", [
                    new egret.SetProperty("__4", "source", "button-back-up")
                ]),
                new egret.State("down", [
                    new egret.SetProperty("__4", "source", "button-back-down")
                ]),
                new egret.State("disabled", [
                    new egret.SetProperty("__4", "source", "button-back-disabled")
                ])
            ];
        }
        Object.defineProperty(BackButtonSkin.prototype, "skinParts", {
            get: function () {
                return BackButtonSkin._skinParts;
            },
            enumerable: true,
            configurable: true
        });
        BackButtonSkin.prototype.labelDisplay_i = function () {
            var t = new egret.Label();
            this.labelDisplay = t;
            t.bottom = 12;
            t.fontFamily = "Tahoma";
            t.left = 18;
            t.right = 4;
            t.size = 20;
            t.textAlign = "center";
            t.textColor = 0x1e7465;
            t.top = 8;
            t.verticalAlign = "middle";
            return t;
        };
        BackButtonSkin.prototype.__4_i = function () {
            var t = new egret.UIAsset();
            this.__4 = t;
            t.percentHeight = 100;
            t.percentWidth = 100;
            return t;
        };
        BackButtonSkin._skinParts = ["labelDisplay"];
        return BackButtonSkin;
    })(egret.Skin);
    skins.BackButtonSkin = BackButtonSkin;
})(skins || (skins = {}));
