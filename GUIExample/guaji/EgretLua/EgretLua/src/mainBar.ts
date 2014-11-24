class MainBar extends egret.gui.Group {
    private socket: GameSocket;

    public constructor(gameSocket: GameSocket) {
        this.socket = gameSocket;
        super();
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }

    public onAddToStage(): void {
             
        var button: egret.gui.Button = new egret.gui.Button();
        button.horizontalCenter = 0;
        button.verticalCenter = 0;
        button.label = "提升攻击力";
        button.addEventListener(egret.TouchEvent.TOUCH_TAP, this.onNpcUpAttackButtonClick, this);
        //在GUI范围内一律使用addElement等方法替代addChild等方法。
        this.addElement(button);
    }

    public onNpcUpAttackButtonClick(): void {
        this.socket.reqNPC_UpAttack();
    }
} 