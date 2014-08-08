var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/**
* Created by Administrator on 2014/8/1.
*/
var GoodsItem = (function (_super) {
    __extends(GoodsItem, _super);
    function GoodsItem() {
        _super.call(this);
        this.width = 30;
        this.height = 30;
        this.onAddToStage();
    }
    GoodsItem.prototype.onAddToStage = function () {
        this.btn = new egret.Button;
        this.btn.label = "测试";
        this.btn.width = 60;
        this.btn.height = 35;
        this.addElement(this.btn);
    };

    GoodsItem.prototype.setVo = function (goodsName) {
        this.btn.label = goodsName;
    };
    return GoodsItem;
})(egret.Group);
