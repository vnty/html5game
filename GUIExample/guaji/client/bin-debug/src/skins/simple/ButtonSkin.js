var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var ButtonSkin = (function (_super) {
            __extends(ButtonSkin, _super);
            function ButtonSkin() {
                _super.call(this);

                this.minHeight = 60;
                this.minWidth = 140;
                this.elementsContent = [this.__4_i(), this.labelDisplay_i()];
                this.states = [
                    new egret.gui.State("up", [
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0x111111)
                    ]),
                    new egret.gui.State("down", [
                        new egret.gui.SetProperty("__4", "source", "button_down_png"),
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0x222222)
                    ]),
                    new egret.gui.State("disabled", [
                        new egret.gui.SetProperty("__4", "source", "button_disabled_png"),
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0xcccccc)
                    ])
                ];
            }
            Object.defineProperty(ButtonSkin.prototype, "skinParts", {
                get: function () {
                    return ButtonSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            ButtonSkin.prototype.labelDisplay_i = function () {
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
            ButtonSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                this.__4 = t;
                t.percentHeight = 100;
                t.source = "button_normal_png";
                t.percentWidth = 100;
                return t;
            };
            ButtonSkin._skinParts = ["labelDisplay"];
            return ButtonSkin;
        })(egret.gui.Skin);
        simple.ButtonSkin = ButtonSkin;
        ButtonSkin.prototype.__class__ = "skins.simple.ButtonSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
