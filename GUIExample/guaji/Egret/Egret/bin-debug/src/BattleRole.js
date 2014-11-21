var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/**
* Created by Administrator on 2014/10/15.
*/
var BattleRole = (function (_super) {
    __extends(BattleRole, _super);
    function BattleRole() {
        _super.call(this);
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    BattleRole.prototype.onAddToStage = function (event) {
        this.skinName = ui.BattleSkin;

        this.dataLabel = this['data'];
        this.pic = this['pic'];
    };

    //设置数据 为空就隐藏
    BattleRole.prototype.setData = function (vo) {
        if (typeof vo === "undefined") { vo = null; }
        if (vo == null) {
            this.visible = false;
            return;
        }
        this.dataLabel.text = "lv:" + vo.level + '   ' + vo.name;
        this.pic.source = vo.res;
    };
    return BattleRole;
})(egret.gui.SkinnableComponent);
//# sourceMappingURL=BattleRole.js.map
