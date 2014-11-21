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


    public send(id:number, ...args): void {

    }

    public parseData(): void {

    }
}