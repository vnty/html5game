/**
 * Created by Administrator on 2014/8/2.
 */
class CityTab extends egret.Group
{
    public constructor()
    {
        super();
        this.addEventListener(egret.Event.ADDED_TO_STAGE,this.onAddToStage,this);
    }

    public onAddToStage(event:egret.Event):void
    {
        var btn:egret.Button = new egret.Button;
        var i:number;
        for( i = 0; i < GlobalData.city.length; i++)
        {
            btn = new egret.Button;
            btn.label = GlobalData.city[i];
            btn.width = 80;
            btn.height = 35;
            btn.x = i * 80;
            this.addElement(btn);
        }
    }
}