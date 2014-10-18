/**
 * Created by Administrator on 2014/10/14.
 */

class Battle extends egret.gui.Panel
{
    public constructor()
    {
        super();
        this.addEventListener(egret.Event.ADDED_TO_STAGE,this.onAddToStage,this);
    }
    //名字，资源，等级，攻击，血量
    private gameData:Array<any> = [['若风','3','38','1000', '10000']];

    //名字，资源，等级，攻击，血量
    private monsterData:Array<any>  = [['血环弓箭手','36','41','500', '5000'],
                                    ['血环暗法师','35','40','400', '4000'],
                                    ['狂爪龙人','34','39','300', '3000'],
                                    ['尖石掠夺者','32','38','200', '2000'],
                                    ['尖塔蜘蛛','21','37','100', '1000']];
    private battleData:Array<number> = [];

    private onAddToStage(event:egret.Event)
    {
        this.skinName = ui.BattleSkin;

        var battleType:egret.gui.UIAsset = this["type"];
        battleType.source = "img_131_02";

        var roleUI:egret.gui.SkinnableComponent;
        var roleBmp:egret.gui.UIAsset;
        var i:number;
        for(i = 0; i < 1; i++)
        {
            roleBmp = new egret.gui.UIAsset;
            roleBmp.source = 'hero_003';
            roleUI = this["role1"];
            roleBmp.x = roleUI.x;
            roleBmp.y = roleUI.y;
           //this.addElementAt(roleBmp, 0);
        }

       this.initBattle();
       //this.drawBattleData();
    }

    //初始战斗
    private initBattle():void
    {
        this.initRole();
        this.initMonster();
    }

    //初始角色
    private initRole():void
    {

    }

    //初始怪物
    private initMonster():void
    {
        var roleUI:egret.gui.SkinnableComponent;
        var vo:UnitVo;
        for(var i:number = 0; i < 3; i++)
        {
            var index:number = 0;
            vo = new UnitVo;
            vo.uid = i;
            vo.name = this.monsterData[index][0];
            vo.res = this.monsterData[index][1];
            vo.level = Number(this.monsterData[index][2]);
            vo.attack = Number(this.monsterData[index][3]);
            vo.hp = vo.hpMax = Number(this.monsterData[index][4]);
            vo.res = this.monsterData[index][1];

            roleUI = this["role" + (i + 3)];
            this.setData(roleUI, vo);
        }
    }

    //设置数据 为空就隐藏
    public setData(target:egret.gui.SkinnableComponent,vo:UnitVo = null):void
    {
        if(vo == null)
        {
            this.visible = false;
            return;
        }
        target["data"].text = "lv:" + vo.level + '   ' + vo.name;
        target["pic"].source = vo.res;
    }

    private drawBattleData():void
    {
        this.visible = false;
    }
}
