var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/**
* Created by Administrator on 2014/8/2.
*/
var CityTab = (function (_super) {
    __extends(CityTab, _super);
    function CityTab() {
        _super.call(this);
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    CityTab.prototype.onAddToStage = function (event) {
        var btn = new egret.Button;
        var i;
        for (i = 0; i < GlobalData.city.length; i++) {
            btn = new egret.Button;
            btn.label = GlobalData.city[i];
            btn.width = 80;
            btn.height = 35;
            btn.x = i * 80;
            this.addElement(btn);
        }
    };
    return CityTab;
})(egret.Group);
