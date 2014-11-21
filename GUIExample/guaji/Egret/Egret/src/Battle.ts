/**
 * Created by Administrator on 2014/10/14.
 */

class Battle extends egret.gui.Panel {
    public constructor() {
        super();
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    //名字，资源，等级，攻击，血量
    private gameData: Array<any> = [['若风', 'hero_003', '38', '1000', '10000']];

    //名字，资源，等级，攻击，血量
    private monsterData: Array<any> = [['血环弓箭手', '10060', '41', '500', '5000'],
        ['血环暗法师', '10061', '40', '400', '4000'],
        ['狂爪龙人', '10062', '39', '300', '3000'],
        ['尖石掠夺者', '10063', '38', '200', '2000'],
        ['尖塔蜘蛛', '10064', '37', '100', '1000']];
    private battleData: Array<number> = [];

    private unitDic: Array<UnitVo> = [];

    private onAddToStage(event: egret.Event) {
        this.skinName = ui.BattleSkin;

        var battleType: egret.gui.UIAsset = this["type"];
        battleType.source = "img_131_02";
        //this.drawBattleData();

        this.attackBtn = this["attackBtn"];
        this.addEventListener(egret.TouchEvent.TOUCH_TAP, this.btnTouchHandler, this);
        this.initBattle();
    }

    private attackBtn: egret.gui.Button;
    private btnTouchHandler(evt: egret.TouchEvent): void {
        switch (evt.target) {
            case this.attackBtn:
                console.log("attackBtn");

                var vo: UnitVo = this.unitDic[3];
                vo.hp -= 100;
                if (vo.hp < 0) vo.hp = 0;
                this.upDataRoleHp();
                this.attackEffect();
                break;
        }
    }

    //初始战斗
    private initBattle(): void {
        this.initRole();
        this.initMonster();
    }

    //初始角色
    private initRole(): void {
        var roleUI: egret.gui.SkinnableComponent;
        var vo: UnitVo;
        var index: number = 0;
        vo = new UnitVo;
        vo.uid = 0;
        vo.name = this.gameData[index][0];
        vo.res = this.gameData[index][1];
        vo.level = Number(this.gameData[index][2]);
        vo.attack = Number(this.gameData[index][3]);
        vo.hp = vo.hpMax = Number(this.gameData[index][4]);

        roleUI = this["role1"];
        this.setData(roleUI, vo);
        this.unitDic[0] = vo;
    }

    private upDataRoleHp(): void {
        var vo: UnitVo = this.unitDic[3];
        var roleUI: egret.gui.SkinnableComponent;
        roleUI = this["role3"];
        var hpBar: egret.gui.UIAsset = roleUI["hp"];
        var hpText: egret.gui.Label = roleUI["hpText"];
        hpBar.scaleX = vo.hp / vo.hpMax;
        hpText.text = vo.hp + "/" + vo.hpMax;

        var decHp: egret.gui.Label = roleUI["decHp"];
        decHp.text = "-100";
        decHp.visible = true;

        this.tw = egret.Tween.get(decHp);
        this.tw.to({ y: -17 }, 2000);
        this.tw.call(this.decHpComplete, decHp);

    }

    private decHpComplete(target: any): void {
        target.y = 17;
        target.visible = false;
    }

    private attackEffect(): void {
        var roleUI: egret.gui.SkinnableComponent;
        roleUI = this["role1"];

        var targetUI: egret.gui.SkinnableComponent;
        targetUI = this["role3"];

        var ags = { role: '1', tx: 14 };
        this.tw = egret.Tween.get(roleUI);
        this.tw.to({ x: 14 + 50 }, 300);
        this.tw.call(this.moveComplete, roleUI, ags);


        var ags = { role: '3', tx: 467 };
        this.tw = egret.Tween.get(targetUI);
        this.tw.to({ x: 467 + 25 }, 300);
        this.tw.call(this.moveComplete, targetUI, ags);

        var ags = { role: '1', tx: 14 };
        this.tw = egret.Tween.get(this['skill1']);
        this['skill1'].x = 160;
        this['skill1'].visible = true;
        this['skill1'].text = '暴风雪';
        this.tw.to({ x: 160 + 80 }, 800);
        this.tw.call(this.skillPlayComplete, this['skill1']);
    }

    private skillPlayComplete(target: any): void {
        target.visible = false;
    }

    private tw: any;
    private moveComplete(target: any, ags: any): void
    {
        var id: string = "role" + ags.role;
        var tx: number = ags.tx;
        this.tw = egret.Tween.get(target);
        this.tw.to({ x: tx }, 150);
    }
    //初始怪物
    private initMonster(): void
    {
        var roleUI: egret.gui.SkinnableComponent;
        var vo: UnitVo;
        for (var i: number = 0; i < 3; i++) {
            var index: number = Math.round(Math.random() * this.monsterData.length) - 1;
            console.debug(index + '');
            if (index == -1) index = 0;
            vo = new UnitVo;
            vo.uid = i;
            vo.name = this.monsterData[index][0];
            vo.res = this.monsterData[index][1];
            vo.level = Number(this.monsterData[index][2]);
            vo.attack = Number(this.monsterData[index][3]);
            vo.hp = vo.hpMax = Number(this.monsterData[index][4]);
            this.unitDic[3 + i] = vo;
            roleUI = this["role" + (i + 3)];
            this.setData(roleUI, vo);
        }
    }

    //设置数据 为空就隐藏
    public setData(target: egret.gui.SkinnableComponent, vo: UnitVo = null): void
    {
        if (vo == null) {
            this.visible = false;
            return;
        }
        target["data"].text = "lv:" + vo.level + '   ' + vo.name;
        target["pic"].source = vo.res;
    }

    private drawBattleData(): void
    {
        this.visible = false;
    }
}
