var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var MainBar = (function (_super) {
    __extends(MainBar, _super);
    function MainBar(gameSocket) {
        this.socket = gameSocket;
        _super.call(this);
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    MainBar.prototype.onAddToStage = function () {
        var button = new egret.gui.Button();
        button.horizontalCenter = 0;
        button.verticalCenter = 0;
        button.label = "提升攻击力";
        button.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onNpcUpAttackButtonClick, this);

        //在GUI范围内一律使用addElement等方法替代addChild等方法。
        this.addElement(button);
    };

    MainBar.prototype.onNpcUpAttackButtonClick = function () {
        this.socket.reqNPC_UpAttack();
    };
    return MainBar;
})(egret.gui.Group);
//# sourceMappingURL=mainBar.js.map
