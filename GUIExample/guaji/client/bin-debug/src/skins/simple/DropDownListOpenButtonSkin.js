var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var DropDownListOpenButtonSkin = (function (_super) {
            __extends(DropDownListOpenButtonSkin, _super);
            function DropDownListOpenButtonSkin() {
                _super.call(this);

                this.height = 60;
                this.minWidth = 140;
                this.elementsContent = [this.__4_i(), this.__5_i()];
                this.states = [
                    new egret.gui.State("up", [
                        new egret.gui.SetProperty("__5", "source", "dropdownlist_arrow_up_png")
                    ]),
                    new egret.gui.State("down", [
                        new egret.gui.SetProperty("__4", "source", "DropDownListButtonSkin_down_png"),
                        new egret.gui.SetProperty("__5", "source", "dropdownlist_arrow_down_png")
                    ]),
                    new egret.gui.State("disabled", [])
                ];
            }
            DropDownListOpenButtonSkin.prototype.__4_i = function () {
                var t = new egret.gui.UIAsset();
                this.__4 = t;
                t.percentHeight = 100;
                t.source = "DropDownListButtonSkin_up_png";
                t.percentWidth = 100;
                return t;
            };
            DropDownListOpenButtonSkin.prototype.__5_i = function () {
                var t = new egret.gui.UIAsset();
                this.__5 = t;
                t.right = 4;
                t.verticalCenter = 0;
                return t;
            };
            return DropDownListOpenButtonSkin;
        })(egret.gui.Skin);
        simple.DropDownListOpenButtonSkin = DropDownListOpenButtonSkin;
        DropDownListOpenButtonSkin.prototype.__class__ = "skins.simple.DropDownListOpenButtonSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
