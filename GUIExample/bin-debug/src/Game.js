var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/**
* Created by zilong on 2014/8/1.
*/
var Game = (function (_super) {
    __extends(Game, _super);
    function Game() {
        _super.call(this);
        this.goodsList = [];
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    Game.prototype.onAddToStage = function (event) {
        var title = new egret.Label();
        title.text = "主界面";
        title.fontFamily = "Tahoma";
        title.textColor = 0x727070;
        title.size = 35;
        title.horizontalCenter = 0;
        title.top = 25;
        this.addElement(title);

        var tab = new CityTab;
        this.addElement(tab);

        var good;
        var goodGroup = new egret.Group;
        this.addElement(goodGroup);
        goodGroup.y = 50;
        for (var i = 0; i < 4; i++) {
            good = new GoodsItem;
            good.setVo("物品");
            good.x = i * 60;
            goodGroup.addElement(good);
            this.goodsList.push(good);
        }
    };
    return Game;
})(egret.Group);
