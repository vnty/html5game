class GameSocket 
{
   
    public constructor()
    {
     
    }

    //个人数据
    public cmd10001: number;
    //通用弹出提示
    public cmd11001: number;
    //战斗
    public cmd20001: number;
    //排行榜
    public cmd30001: number;
    //NPC 面板数据
    public cmd40001: number;
    //NPC 提升属性
    public cmd40002: number;

    //请求我的数据
    public reqMyData(): void {
        this.send(this.cmd10001, 1, 2);
    }

    //请求战斗
    public reqBattle(): void {
        this.send(this.cmd10001, 1, 2);
    }

    //请求排行榜
    public reqRank(): void {
        this.send(this.cmd10001, 1, 2);
    }

    //请求NPC 
    public reqNPC(): void {
        this.send(this.cmd40001);
    }

    //请求NPC 提升攻击力
    public reqNPC_UpAttack(): void {
        this.send(this.cmd40002, 1);
    }

    //请求NPC 提升生命值
    public reqNPC_UpHp(): void {
        this.send(this.cmd40002, 2);
    }
    private urlloader:egret.URLLoader;
    public send(id:number, ...args): void {
        this.urlloader = new egret.URLLoader();
        var urlreq:egret.URLRequest = new egret.URLRequest();

        urlreq.url = "http://127.0.0.1:5658/?cmd=" + id + "&args="+ egret.toJSON.decode(args);
        this.urlloader.load( urlreq );
        this.urlloader.addEventListener(egret.Event.COMPLETE, this.onComplete, this);
    }

    private onComplete(event:egret.Event):void
    {
         this.parseData( this.urlloader.data );
    }

    public parseData(data:string): void {
        console.log( data );
    }
}