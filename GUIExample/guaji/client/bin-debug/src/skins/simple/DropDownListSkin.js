var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var skins;
(function (skins) {
    (function (simple) {
        var DropDownListSkin = (function (_super) {
            __extends(DropDownListSkin, _super);
            function DropDownListSkin() {
                _super.call(this);

                this.elementsContent = [this.openButton_i(), this.labelDisplay_i(), this.popUp_i()];
                this.states = [
                    new egret.gui.State("normal", [
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0x111111)
                    ]),
                    new egret.gui.State("open", [
                        new egret.gui.SetProperty("labelDisplay", "textColor", 0x222222),
                        new egret.gui.SetProperty("popUp", "displayPopUp", true)
                    ]),
                    new egret.gui.State("disabled", [])
                ];
            }
            Object.defineProperty(DropDownListSkin.prototype, "skinParts", {
                get: function () {
                    return DropDownListSkin._skinParts;
                },
                enumerable: true,
                configurable: true
            });
            DropDownListSkin.prototype.dataGroup_i = function () {
                var t = new egret.gui.DataGroup();
                this.dataGroup = t;
                t.percentHeight = 100;
                t.itemRendererSkinName = skins.simple.DropDownListItemRendererSkin;
                t.percentWidth = 100;
                t.layout = this.__4_i();
                return t;
            };
            DropDownListSkin.prototype.dropDown_i = function () {
                var t = new egret.gui.Group();
                this.dropDown = t;
                t.height = 400;
                t.visible = true;
                t.elementsContent = [this.scroller_i()];
                return t;
            };
            DropDownListSkin.prototype.labelDisplay_i = function () {
                var t = new egret.gui.Label();
                this.labelDisplay = t;
                t.paddingLeft = 10;
                t.touchChildren = false;
                t.touchEnabled = false;
                t.verticalAlign = "middle";
                t.verticalCenter = 0;
                return t;
            };
            DropDownListSkin.prototype.openButton_i = function () {
                var t = new egret.gui.Button();
                this.openButton = t;
                t.percentHeight = 100;
                t.skinName = skins.simple.DropDownListOpenButtonSkin;
                t.percentWidth = 100;
                return t;
            };
            DropDownListSkin.prototype.popUp_i = function () {
                var t = new egret.gui.PopUpAnchor();
                this.popUp = t;
                t.displayPopUp = false;
                t.percentHeight = 100;
                t.popUpPosition = "below";
                t.popUpWidthMatchesAnchorWidth = true;
                t.percentWidth = 100;
                t.popUp = this.dropDown_i();
                return t;
            };
            DropDownListSkin.prototype.scroller_i = function () {
                var t = new egret.gui.Scroller();
                this.scroller = t;
                t.percentHeight = 100;
                t.percentWidth = 100;
                t.viewport = this.dataGroup_i();
                return t;
            };
            DropDownListSkin.prototype.__4_i = function () {
                var t = new egret.gui.VerticalLayout();
                t.gap = 0;
                t.horizontalAlign = "justify";
                return t;
            };
            DropDownListSkin._skinParts = ["openButton", "labelDisplay", "dataGroup", "scroller", "dropDown", "popUp"];
            return DropDownListSkin;
        })(egret.gui.Skin);
        simple.DropDownListSkin = DropDownListSkin;
        DropDownListSkin.prototype.__class__ = "skins.simple.DropDownListSkin";
    })(skins.simple || (skins.simple = {}));
    var simple = skins.simple;
})(skins || (skins = {}));
