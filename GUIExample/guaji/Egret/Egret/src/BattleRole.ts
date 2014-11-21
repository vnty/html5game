/**
 * Created by Administrator on 2014/10/15.
 */
class BattleRole extends egret.gui.SkinnableComponent
{
    public constructor()
    {
        super();
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }

    //数据标签
    private dataLabel:egret.gui.Label;
    //头像
    private pic:egret.gui.UIAsset;

    private onAddToStage(event:egret.Event)
    {
        this.skinName = ui.BattleSkin;

        this.dataLabel = this['data'];
        this.pic = this['pic'];
    }

    //设置数据 为空就隐藏
    public setData(vo:UnitVo = null):void
    {
        if(vo == null)
        {
            this.visible = false;
            return;
        }
        this.dataLabel.text = "lv:" + vo.level + '   ' + vo.name;
        this.pic.source = vo.res;
    }
}