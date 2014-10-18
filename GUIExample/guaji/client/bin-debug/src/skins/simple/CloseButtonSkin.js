var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var CloseButtonSkin = (function (_super) {
            __extends(CloseButtonSkin, _super);
            function CloseButtonSkin() {
                _super.call(this);

                this.elementsContent = [this.__4_i(), this.labelDisplay_i()];
                this.states = [
                    new egret.gui.State("up", [
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0x111111)
                    ]),
                    new egret.gui.State("down", [
                        new egret.gui.SetProperty("__4", "source", "closebtn_down_png"),
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0x222222)
                    ]),
                    new egret.gui.State("disabled", [
                        new egret.gui.SetProperty("__4", "source", "closebtn_disabled_png"),
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0xcccccc)
                    ])
                ];
            }
            Object.defineProperty(CloseButtonSkin.prototype, "skinParts", {
                get: function () {
                    return CloseButtonSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            CloseButtonSkin.prototype.labelDisplay_i = function () {
                var t = new egret.gui.Label();
                this.labelDisplay = t;
                t.bottom = 12;
                t.fontFamily = "Tahoma";
                t.left = 10;
                t.right = 10;
                t.size = 20;
                t.textAlign = "center";
                t.top = 8;
                t.verticalAlign = "middle";
                return t;
            };
            CloseButtonSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                this.__4 = t;
                t.percentHeight = 100;
                t.source = "closebtn_up_png";
                t.percentWidth = 100;
                return t;
            };
            CloseButtonSkin._skinParts = ["labelDisplay"];
            return CloseButtonSkin;
        })(egret.gui.Skin);
        simple.CloseButtonSkin = CloseButtonSkin;
        CloseButtonSkin.prototype.__class__ = "skins.simple.CloseButtonSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
