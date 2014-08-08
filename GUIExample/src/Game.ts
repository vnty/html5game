/**
 * Created by zilong on 2014/8/1.
 */
class Game extends egret.Group
{
    public constructor()
    {
        super();
        this.addEventListener(egret.Event.ADDED_TO_STAGE,this.onAddToStage,this);
    }

    private goodsList:any = [];
    private timeTF:egret.Label;
    private eventTF:egret.Label;
    private dayEventTF:egret.Label;
    public onAddToStage(event:egret.Event):void
    {

        var title:egret.Label = new egret.Label();
        title.text = "主界面";
        title.fontFamily = "Tahoma";
        title.textColor = 0x727070;
        title.size = 35;
        title.horizontalCenter = 0;
        title.top = 25;
        this.addElement(title);

        this.timeTF = new egret.Label;
        this.timeTF.text = "游戏天数:1";
        this.addElement(this.timeTF);

        this.eventTF = new egret.Label;
        this.eventTF.text = "今天你开开心心出门去,但是在路上被车撞了,花了10万医药费.";
        this.width = 100;
        this.height = 300;
        this.
        this.addElement(this.eventTF);


        var tab:CityTab = new CityTab;
        this.addElement(tab);

        var good:GoodsItem;
        var goodGroup:egret.Group = new egret.Group;
        this.addElement(goodGroup);
        goodGroup.y = 50;
        for(var i:number = 0; i < 4 ; i++)
        {
            good = new GoodsItem;
            good.setVo("物品");
            good.x = i * 60;
            goodGroup.addElement(good);
            this.goodsList.push(good);
        }
    }
}