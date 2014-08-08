var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/**
* Created by Administrator on 2014/8/2.
*/
var GlobalData = (function (_super) {
    __extends(GlobalData, _super);
    function GlobalData() {
        _super.call(this);
    }
    GlobalData.city = ["广州", "深圳", "上海", "北京", "香港", "德国", "美国"];
    return GlobalData;
})(egret.Group);
