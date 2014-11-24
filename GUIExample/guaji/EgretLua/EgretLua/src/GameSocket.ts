class GameSocket 
{

    public constructor() {

    }


    //个人数据
    public cmd10001: number = 10001;
    //通用弹出提示
    public cmd11001: number = 11001;
    //战斗
    public cmd20001: number = 20001;
    //排行榜
    public cmd30001: number = 30001;
    //NPC 面板数据
    public cmd40001: number = 40001;
    //NPC 提升属性
    public cmd40002: number = 40002;

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
    private urlloader: egret.URLLoader;
    public send(id: number, ...args): void {
        this.urlloader = new egret.URLLoader();
        var urlreq: egret.URLRequest = new egret.URLRequest();
        var msg: any = {};
        
        var myDate = new Date();

        msg.cmd = id;
        msg.user = "vnty";
        msg.time = myDate.getTimezoneOffset() + (Math.random() * 1000);
        msg.args = args;
        var test: string = JSON.stringify(msg);

        //访问不了是跨域问题，要不把服务器放在同一个域下，要不调低本地安全要求
        urlreq.url = "http://192.168.1.102:5658/" + test;
        //urlreq.url = "http://baidu.com";
        this.urlloader.load(urlreq);
        this.urlloader.addEventListener(egret.Event.COMPLETE, this.onComplete, this);
    }

    private listerDic: any = {};

    public regLister(cmd: number, fun: Function, thisObject: any): void {
        var arr: any[] = this.listerDic[cmd];
        if (arr == null) {
            arr = []
            this.listerDic[cmd] = arr;
        }
        arr.push(  { obj: thisObject, fun: fun }  );
    }

    public removeLister(cmd: number, fun: Function): void {
        var arr: any[] = this.listerDic[cmd];
        if (arr == null) return;
        delete arr.shift();
    }

    public notify(cmd, args): void {
        var arr: any[] = this.listerDic[cmd];
        if (arr == null) return;
        var funData: any;
        for (var key in arr)
        {
            funData = arr[key];
            funData.fun.call(funData.obj, args);
        }
    }

    private onComplete(event:egret.Event):void
    {
         this.parseData(this.urlloader.data);
    }

    private parseData(data: string): void {
        var obj: any = JSON.parse(data);
        console.log(obj.cmd);
        console.log(obj.user);
        this.notify(obj.cmd, obj.args);
    }
}