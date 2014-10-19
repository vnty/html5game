var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    var simple;
    (function (simple) {
        var ToggleSwitchSkin = (function (_super) {
            __extends(ToggleSwitchSkin, _super);
            function ToggleSwitchSkin() {
                _super.call(this);
                this.elementsContent = [this.__7_i(), this.__8_i(), this.__9_i(), this.__10_i(), this.__11_i(), this.__12_i()];
                this.states = [
                    new egret.gui.State("up", [
                        new egret.gui.SetProperty("__7", "visible", true),
                        new egret.gui.SetProperty("__8", "visible", true),
                        new egret.gui.SetProperty("__9", "visible", true)
                    ]),
                    new egret.gui.State("down", [
                        new egret.gui.SetProperty("__7", "visible", true),
                        new egret.gui.SetProperty("__8", "visible", true),
                        new egret.gui.SetProperty("__9", "visible", true)
                    ]),
                    new egret.gui.State("disabled", [
                        new egret.gui.SetProperty("__7", "visible", true),
                        new egret.gui.SetProperty("__8", "visible", true),
                        new egret.gui.SetProperty("__9", "visible", true)
                    ]),
                    new egret.gui.State("upAndSelected", [
                        new egret.gui.SetProperty("__10", "visible", true),
                        new egret.gui.SetProperty("__11", "visible", true),
                        new egret.gui.SetProperty("__12", "visible", true)
                    ]),
                    new egret.gui.State("downAndSelected", [
                        new egret.gui.SetProperty("__10", "visible", true),
                        new egret.gui.SetProperty("__11", "visible", true),
                        new egret.gui.SetProperty("__12", "visible", true)
                    ]),
                    new egret.gui.State("disabledAndSelected", [
                        new egret.gui.SetProperty("__10", "visible", true),
                        new egret.gui.SetProperty("__11", "visible", true),
                        new egret.gui.SetProperty("__12", "visible", true)
                    ])
                ];
            }
            ToggleSwitchSkin.prototype.__10_i = function () {
                var t = new egret.gui.UIAsset();
                this.__10 = t;
                t.source = "onoffbutton_on_track_png";
                t.visible = false;
                return t;
            };
            ToggleSwitchSkin.prototype.__11_i = function () {
                var t = new egret.gui.UIAsset();
                this.__11 = t;
                t.right = 1;
                t.source = "onoffbutton_on_thumb_png";
                t.verticalCenter = 0;
                t.visible = false;
                return t;
            };
            ToggleSwitchSkin.prototype.__12_i = function () {
                var t = new egret.gui.UIAsset();
                this.__12 = t;
                t.left = 15;
                t.source = "onoffbutton_on_label_png";
                t.verticalCenter = 0;
                t.visible = false;
                return t;
            };
            ToggleSwitchSkin.prototype.__7_i = function () {
                var t = new egret.gui.UIAsset();
                this.__7 = t;
                t.source = "onoffbutton_off_track_png";
                t.visible = false;
                return t;
            };
            ToggleSwitchSkin.prototype.__8_i = function () {
                var t = new egret.gui.UIAsset();
                this.__8 = t;
                t.left = 1;
                t.source = "onoffbutton_off_thumb_png";
                t.verticalCenter = 0;
                t.visible = false;
                return t;
            };
            ToggleSwitchSkin.prototype.__9_i = function () {
                var t = new egret.gui.UIAsset();
                this.__9 = t;
                t.right = 15;
                t.source = "onoffbutton_off_label_png";
                t.verticalCenter = 0;
                t.visible = false;
                return t;
            };
            return ToggleSwitchSkin;
        })(egret.gui.Skin);
        simple.ToggleSwitchSkin = ToggleSwitchSkin;
        ToggleSwitchSkin.prototype.__class__ = "simple.ToggleSwitchSkin";
    })(simple = skins.simple || (skins.simple = {}));
})(skins || (skins = {}));
