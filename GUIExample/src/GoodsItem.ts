/**
 * Created by Administrator on 2014/8/1.
 */
class GoodsItem extends egret.Group
{
    private btn:egret.Button;
    public constructor()
    {
        super();
        this.width = 30;
        this.height = 30;
        this.onAddToStage();
    }

    public onAddToStage():void
    {
        this.btn = new egret.Button;
        this.btn.label = "测试";
        this.btn.width = 60;
        this.btn.height = 35;
        this.addElement(this.btn);
    }

    public setVo(goodsName:string):void
    {
        this.btn.label = goodsName;
    }
}
