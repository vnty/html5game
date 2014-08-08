/**
* Copyright (c) 2014,Egret-Labs.org
* All rights reserved.
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the Egret-Labs.org nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY EGRET-LABS.ORG AND CONTRIBUTORS "AS IS" AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL EGRET-LABS.ORG AND CONTRIBUTORS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var GUIExplorer = (function (_super) {
    __extends(GUIExplorer, _super);
    function GUIExplorer() {
        _super.call(this);
        //声明一个变量,引用反射的类，否则不能被加入编译列表。
        this.classDependency = [
            AlertScreen, ButtonScreen, ItemRendererScreen, LabelScreen,
            LayoutScreen, ListScreen, ProgressBarScreen, ScrollerScreen, SliderScreen, TabBarScreen, TogglesScreen, TreeScreen];
        this.classInstanceCache = {};
        this.addEventListener(egret.Event.ADDED_TO_STAGE, this.onAddToStage, this);
    }
    GUIExplorer.prototype.onAddToStage = function (event) {
        //注入自定义的素材解析器
        egret.Injector.mapClass("egret.IAssetAdapter", AssetAdapter);

        //注入自定义的皮肤解析器
        egret.Injector.mapClass("egret.ISkinAdapter", SkinAdapter);

        //启动RES资源加载模块
        RES.addEventListener(RES.ResourceEvent.GROUP_COMPLETE, this.onGroupComp, this);
        RES.loadConfig("resource/resource.json", "resource/");
        RES.loadGroup("preload");
    };

    GUIExplorer.prototype.onGroupComp = function (event) {
        if (event.groupName == "preload") {
            this.createExporer();
        }
    };

    GUIExplorer.prototype.createExporer = function () {
        var btn = new egret.Button;
        btn.addEventListener(egret.TouchEvent.TOUCH_TAP, this.BtnClick, this);
        btn.label = "进入游戏";
        this.addChild(btn);
        return;

        //实例化GUI根容器
        var uiStage = new egret.UIStage();
        this.uiStage = uiStage;
        this.addChild(uiStage);

        var asset = new egret.UIAsset();
        asset.source = "main_bg";
        asset.percentHeight = asset.percentWidth = 100;
        asset.fillMode = egret.BitmapFillMode.REPEAT;
        uiStage.addElement(asset);

        var asset = new egret.UIAsset();
        asset.source = "header-background";
        asset.fillMode = egret.BitmapFillMode.REPEAT;
        asset.percentWidth = 100;
        asset.height = 90;
        uiStage.addElement(asset);

        this.mainContainer = new egret.Group();
        this.mainContainer.percentWidth = 100;
        this.mainContainer.percentHeight = 100;
        uiStage.addElement(this.mainContainer);

        var title = new egret.Label();
        title.text = "Egret GUI && WebSocket";
        title.fontFamily = "Tahoma";
        title.textColor = 0x727070;
        title.size = 35;
        title.horizontalCenter = 0;
        title.top = 25;
        this.mainContainer.addElement(title);

        var list = new egret.List();
        this.mainList = list;
        list.skinName = "skins.ListSkin";
        list.itemRendererSkinName = "skins.ScreenItemRendererSkin";
        list.percentWidth = 100;
        list.top = 90;
        list.bottom = 0;
        this.mainContainer.addElement(list);

        var screens = RES.getRes("screens");
        list.dataProvider = new egret.ArrayCollection(screens);
        list.addEventListener(egret.ListEvent.ITEM_CLICK, this.onItemClick, this);
        uiStage.validateNow();
        // localStorage.setItem
    };

    GUIExplorer.prototype.BtnClick = function (e) {
        if (this.panel == null) {
            this.panel = new Game;
        }

        this.addChild(this.panel);
    };

    GUIExplorer.prototype.onItemClick = function (event) {
        if (this.currentScreen)
            return;
        var uiStage = this.uiStage;
        egret.Tween.get(this.mainContainer).to({ x: -uiStage.width }, 500, egret.Ease.sineInOut).call(this.hideMainContainer, this);

        var className = event.item + "Screen";

        // this.socket.send("测试下" + className);
        var clazz;
        if (egret.hasDefinition(className)) {
            clazz = egret.getDefinitionByName(className);

            var screen;

            //缓存一下，免得反复重复创建
            if (this.classInstanceCache.hasOwnProperty(className)) {
                screen = this.classInstanceCache[className];
            } else {
                var screen = new GUIScreen();
                var screenContent = new clazz();
                screenContent.percentHeight = 100;
                screenContent.percentWidth = 100;
                screen.addElement(screenContent);
                this.classInstanceCache[className] = screen;
            }

            screen.title = event.item;
            this.currentScreen = screen;
            screen.addEventListener("goBack", this.onGoBack, this);
            uiStage.addElement(screen);
            screen.x = uiStage.width;
            egret.Tween.get(screen).to({ x: 0 }, 500, egret.Ease.sineInOut);
        }
    };

    GUIExplorer.prototype.hideMainContainer = function () {
        this.uiStage.removeElement(this.mainContainer);
    };

    GUIExplorer.prototype.hideScreen = function () {
        this.uiStage.removeElement(this.currentScreen);
        this.currentScreen.removeEventListener("goBack", this.onGoBack, this);
        this.currentScreen = null;
    };

    GUIExplorer.prototype.onGoBack = function (event) {
        this.mainList.selectedIndex = -1;
        var uiStage = this.uiStage;
        uiStage.addElement(this.mainContainer);
        egret.Tween.get(this.mainContainer).to({ x: 0 }, 500, egret.Ease.sineInOut);
        egret.Tween.get(this.currentScreen).to({ x: uiStage.width }, 500, egret.Ease.sineInOut).call(this.hideScreen, this);
    };
    return GUIExplorer;
})(egret.DisplayObjectContainer);
