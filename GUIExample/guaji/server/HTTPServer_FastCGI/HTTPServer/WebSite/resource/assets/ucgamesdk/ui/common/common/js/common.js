var sdk={common:{base:{},hooks:{},events:{},ui:{},utils:{}},system:{collections:{},controllers:{},models:{},routes:{},views:{}}},S=sdk;S.SCHK=S.common.hooks,S.SCEV=S.common.events,S.SCUI=S.common.ui,S.SCUT=S.common.utils,S.SSRO=S.system.routes,S.SSCL=S.system.collections,S.SSCT=S.system.controllers,S.SSMO=S.system.models,S.SSVW=S.system.views,function(e){e.initRoutes=function(i){e.SCEV.Proxy.trigger(e.SCEV.EventType.SDK_INIT_ROUTE,i)},e.initSdkBase=function(){e.sdkBase=new sdkBase},e.initView=function(i){e.SCEV.Proxy.trigger(e.SCEV.EventType.SDK_INIT_VIEW,i)},e.initSync=function(){e.SCEV.Proxy.trigger(e.SCEV.EventType.SDK_INIT_SYNC)},e.initTouch=function(){e.SCEV.Proxy.trigger(e.SCEV.EventType.SDK_INIT_TOUCH)},e.initHooks=function(){_.isUndefined(sdk.common.hooks.request)||e.sdkBase.hooks.extend("request",sdk.common.hooks.request)},e.initHeader=function(){sdk.SdkHeader.init()},e.initHandler=function(){e.SSCT.GetHandler=function(i,n){var s=i+"Ins",t="";switch(e.SSCT.handler=e.SSCT.handler||{},e.SSCT.handler[s]=e.SSCT.handler[s]||{},i){case"Collection":t="SSCL";break;case"Model":t="SSMO";break;case"View":t="SSVW";break;case"Controller":t="SSCT"}return console.log("hn:"+s+" na:"+t+" name "+n),e.SSCT.handler[s][n]||(e.SSCT.handler[s][n]=new e[t][n]),e.SSCT.handler[s][n]}},e.initGlobal=function(){e.global=e.global||{};var i,n,s=function(e,i){if(!e||!i)return!1;var n=e.split("."),s=i.split(".");if(n.length<3||3>s)return!1;var t=100*parseInt(n[0])+10*parseInt(n[1])+parseInt(n[2]),a=100*parseInt(s[0])+10*parseInt(s[1])+parseInt(s[2]);return t>a?1:t==a?0:-1},t=new sdkBase,a=t.request(t.servType.COMMON,t.actions.GET_SDK_INFO);a.success&&(i=a.data.ve,n=a.data.uiStyle),i=i||"2.0.0",n=n||rConfig.SDK_UI.DEFAULT,e.global.versionCompare=s,e.global.version=i,e.global.ui=n,e.global.isThirdParty=!1,e.global.thirdParty=null;var o=t.request(e.sdkBase.servType.COMMON,e.sdkBase.actions.GET_GAME_INFO);o&&o.success&&!_.isUndefined(o.data)&&!_.isUndefined(o.data.resFlag)&&(_.isUndefined(rConfig.thirdParty[o.data.resFlag])||(e.global.thirdParty=rConfig.thirdParty[o.data.resFlag],e.global.isThirdParty=!0))},e.initializer=function(i){e.initSdkBase(),e.initHooks(),e.initSync(),e.initGlobal(),e.initTouch(),e.initHeader(),e.initHandler(),e.initView(i),e.initRoutes(i)}}(sdk);var rConfig={user:{usernameFilter:/([^a-z0-9A-Z\u0080-\uFFFF]+)/,passwordFilter:/([^0-9A-Za-z]+)/,accountFilter:/^[0-9]*$/,emailAccountFilter:/^([\w]+([\w-\.+]*[\w-]+)?)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/,mobileFilter:/^[0-9]*$/,showUserNickLen:7,defaultGameName:"游戏账号"},feedBackCls:"ui-feed",hasFeedBack:["ui-lbtn","ui-lblur","ui-pwdbtn","ui-fbtn","li-r-btn","li-l-btn","ui-valid","QsBoxFeed","splitPage","ui-rebtn","postTitle","replyNum","seach_a","ui-dkli","lo_btn","input_login","Qsel","Qseld","input_reg"],blockFeedBack:["ui-disable"],apis:{PAY:"pay.page.wap.create",ALIPAY:"pay.page.wap.create",GET_PAY_WAY:"pay.charge.config.payway",CARD_PAY:"pay.charge.card.pay",UDPAY:"pay.charge.up.pay",PAY_WAY_USAGE:"pay.charge.config.paywayUsage",UPOINT_BALANCE:"pay.upiont.up.queryBalance",USER_DETAIL:"ucid.sns.detaiInfo",VALID_CODE:"ucid.user.verifyAlpha",USER_BASEINFO:"account.getUserBasicInfoByUid",USER_DETAIL:"account.getUserDetailInfoByUid",UPDATE_NICKNAME:"account.updateUserNameByUid",UPDATE_USER_DETAIL:"account.updateUserDetailByUid",GET_ACCOUNT_INFO:"ucid.account.getAccountInfoByLoginName",RECENT_GAMES:"ucid.sns.gameHistory",UPDATE_PASSWORD:"ucid.user.changePassword",PAY_HISTORY:"pay.order.query",VIP_INFO:"ucid.vip.info",IS_VIP:"ucid.vip.isVip",SEND_MSG_TO_MOBILE:"test.sendMsg",BIND_MOBILE:"text.bindMobile",SECURITY_QUESTION:"ucid.account.getPasswordQuestion",VALIDATE_ANSWER:"ucid.account.verifyPasswordQuestion",RESET_PASSWORD:"ucid.account.resetPasswordByPasswordQuestion",QUERY_HISTORY:"ucid.user.ucidHistory",GET_GAMENOTICE:"msg.notice.list",GET_OPENTEST_GAME_INFO:"opentest.game.get",UCID_ACCOUNT_QUERYSECURESTATE:"ucid.account.querySecureState",UCID_ACCOUNT_SENDMOBILESMSCODE:"ucid.account.sendMobileSmsCode",UCID_ACCOUNT_BINDMOBILEBYSMSCODE:"ucid.account.bindMobileBySmsCode",UCID_ACCOUNT_CHECKISBINDED:"ucid.account.queryUidByMobi",UCID_ACCOUNT_SETPASSWORDQUESTION:"ucid.account.setPasswordQuestion",UCID_ACCOUNT_GETSECURESTATE:"ucid.account.getSecureState",PAYCENTER_UPOINT_AUTOLOGIN:"paycenter.upoint.autoLogin",U_PAY_PAGE:"h5Recharge",AUTH_CAPTCHA_GETCAPTCHA:"auth.captcha.getCaptcha"},models:{USER:"user",GAME:"game",PAY:"pay",BBS:"bbs",GENERAL:"general"},defaultActions:{sso:"login",user:"userInfo",pay:"render",bbs:"index"},businessCache:["payHistory"],ACCOUNT_TYPE:{UC:0,GAME:1,QQ:301},SMSContent:{CMCC:"cmcc",UNICOM:"unicom",cmcc:{dstAddr:"1065755551134",text:"04"},unicom:{dstAddr:"106900584",text:"04"}},VERSIONS:{AUTO_LOGIN_VERSION:"2.3.5",LOGIN_WIDGET_VERSION:"2.4.0",SECURITY_VERSION:"2.4.2",PHONENUMBER_LOGIN_VERSION:"3.2.0",STAT_OPTIMIZATION_VERSION:"3.3.8",FLOAT_WINDOW_VERSION:"3.4.5"},SECURITY_TYPE:{SECURITY:1,UNSECURITY:0},SDK_UI:{DEFAULT:"standard",SAMPLE:"simple",STANDARD:"standard",LOGIN_WIDGET:"loginwidget"},thirdParty:{SYB:{resFlag:"SYB",name:"手游吧",login:{headerLogo:"../common/sdk_images/jc_logo.png"},bbs:{link:"http://sdk.g.uc.cn/public/syb/transitbbs.html",visibile:!0},codeCenter:{link:"http://sdk.g.uc.cn/public/syb/transitcodecenter.html",visibile:!0},game:{notOpenMsg:"该游戏尚未开服，您可以："},agreement:{companyName:"广州谊游",fullCompanyName:"广州谊游网络科技",accountName:"手游吧"},feedback:{phoneCode:"020",phoneNum:"37029130",inVisibile:!1},findPassword:{smsCostsTipsName:"手游吧"},userCenter:{account:{inVisibile:!1},updatePassword:{inVisibile:!1},bbs:{inVisibile:!1},bottomTips:{inVisibile:!1}}},TY:{resFlag:"TY",name:"",login:{headerLogo:"",headerTitle:"账号登录"},bbs:{link:""},codeCenter:{link:""},feedback:{phoneCode:"",phoneNum:"",inVisibile:!0},findPassword:{smsCostsTipsName:"我们"},game:{notOpenMsg:"该游戏尚未开服。",bbsInVisibile:!0,codeCenterInVisibile:!0},agreement:{companyName:"本公司",fullCompanyName:"通用渠道公司",accountName:""},userCenter:{account:{inVisibile:!1},updatePassword:{inVisibile:!1},bbs:{inVisibile:!0},bottomTips:{inVisibile:!0}}}}};S.SCEV.EventType=S.SCEV.EventType||{},_.extend(S.SCEV.EventType,{SDK_INIT_FINISH:"sdkInitFinish",SDK_INIT_SYNC:"sdkInitSync",SDK_INIT_TOUCH:"sdkInitTouch",PRE_ROUTE:"preRoute",SDK_INIT_VIEW:"sdkInitView",SDK_INIT_ROUTE:"sdkInitRoute",SDK_WINDOW_EVENT:"listenEvent",SDK_REMOVE_WIN_EVENT:"removeEvent"});S.SCEV.Handler=S.SCEV.Handler||{},function(e){e.handlers={},e.viewInstance=e.viewInstance||{},e.sdkInitSync=function(e,n){Backbone.sync=function(e,s,r){var t,i,o;if(_.isUndefined(s.url))throw new Error('A "url" property or function must be specified');if(_.isUndefined(r.success))throw new Error('A "success" property or function must be specified');if(o=r.success,i=r.error||function(){},t=s.url.split("/"),_.isEmpty(t[0])||_.isEmpty(t[1]))return i(s,{success:!1,msg:"请求地址错误"}),!1;if(n=_.isUndefined(r.data)||_.isEmpty(r.data)?{}:r.data,_.isEmpty(n)&&s&&("create"==e||"update"==e)&&(n=s.toJSON()),t[0]==S.sdkBase.servType.SDKSERVER&&t[1]==S.sdkBase.actions.CALL_SDK_SERVER){if(_.isUndefined(t[2])||_.isEmpty(t[2]))return i(s,{success:!1,msg:"请求地址错误"}),!1;n.api=t[2]}S.sdkBase.request(t[0],t[1],n,o,i,!0,30,r)}},e.sdkInitTouch=function(){_.extend(Backbone.View.prototype,Backbone.Events,{delegateEvents:function(e){sdk.VirtualEvent.delegateEvents(e,this)},undelegateEvents:function(){sdk.VirtualEvent.undelegateEvents(this)}})},e.preRoute=function(e,n){document.removeEventListener("hidekeyboard"),_.isUndefined(n)||_.isEmpty(n)||_.isUndefined(n.enterPage)||sdk.Log.pageEnter(n.enterPage,n.enterBusiness),console.log("add hide key board event"),document.addEventListener("hidekeyboard",function(){console.log("key board event fire"),document.body.scrollTop=0})},e.listenEvent=function(n,s){var r=s&&s.eventName?s.eventName:null;if(!r)throw new Error("Wrong EventType ：["+r+"]");var t=s&&s.handler?s.handler:function(){};e.handlers[r]=e.handlers[r]||[],e.handlers[r].push(t),document.addEventListener(r,t)},e.removeEvent=function(n,s){var r=s&&s.eventName?s.eventName:null;if(!r)throw new Error("Wrong EventType ：["+r+"]");e.handlers[r]&&(_.each(e.handlers[r],function(e){document.removeEventListener(r,e)}),e.handlers[r]=[])},e.sdkInitView=function(n,s){var r,t=S.SSVW,i=e.viewInstance;switch(S.SSCT.handler?"":S.SSCT.handler={},S.SSCT.handler.ViewIns?"":S.SSCT.handler.ViewIns={},r=S.SSCT.handler.ViewIns,s){case"user":i.user=new t.User,i.sso=new t.Sso,i.register=new t.Register,i.vip=new t.Vip,i.secrecy=new t.Secrecy,i.findPassword=new t.FindPassword,r.User=i.user,r.Sso=i.sso,r.Register=i.register,r.Vip=i.vip,r.Secrecy=i.secrecy,r.FindPassword=i.findPassword;break;case"game":i.game=new t.Game,r.Game=i.game;break;case"general":i.general=new t.General,r.General=i.general}},e.sdkInitRoute=function(n,s){switch(S.SSRO,s){case"user":Route.routeInit("User");break;case"game":Route.routeInit("Game")}var r=e.viewInstance;window.Route&&Route.register("sdk",function(e,n){var t=s,i=n,o=model=i.shift(),a=i.shift();"user"==s&&(t="sso","user"===model&&"register"===a&&(model="register",a="rapidReg")),o=model=model?model:t;var d=rConfig.defaultActions[o];a=a?a:d,console.log("[request from : "+e+"]   --->  [model : "+model+"] [realModel : "+o+"]  [action:"+a+"]   [params:"+i.toString()+"]"),r[model]&&r[model][a]&&r[model][a].apply(this,i)})}}(S.SCEV.Handler);sdk.common.events.Handler=sdk.common.events.Handler||{},function(n){n.sdkInitFinish=function(){}}(sdk.common.events.Handler);S.SCEV.Proxy=S.SCEV.Proxy||{},function(n){_.extend(n,Backbone.Events),n.bind("all",function(n){var t=S.SCEV.Handler;return _.isEmpty(n)||t[n]&&_.isFunction(t[n])&&t[n].apply(this,arguments),this})}(S.SCEV.Proxy);sdk.common.hooks.request=sdk.common.hooks.request||{loadingEl:{},isLoading:!1,initialize:function(){_.bindAll(this)},start:function(i){!this.isLoading&&i.isAsyn&&(_.isUndefined(i.option)||_.isUndefined(i.option.quiet)||!1===i.option.quiet)&&(this.isLoading=!0,this.loadingEl[i.id]=S.common.ui.NoticeBox.loading())},success:function(i){this.loadingEl[i.id]&&setTimeout($.proxy(function(){S.common.ui.NoticeBox.hide(this.loadingEl[i.id],null,"remove"),this.loadingEl[i.id]=null,this.isLoading=!1},this),1)},fail:function(i){this.loadingEl[i.id]&&setTimeout($.proxy(function(){S.common.ui.NoticeBox.hide(this.loadingEl[i.id],null,"remove"),this.loadingEl[i.id]=null,this.isLoading=!1},this),1)},timeout:function(i){this.loadingEl[i.id]&&setTimeout($.proxy(function(){S.common.ui.NoticeBox.hide(this.loadingEl[i.id],null,"remove"),this.loadingEl[i.id]=null,this.isLoading=!1},this),1)}};sdk.common.ui.Mask=sdk.common.ui.Mask||{},function(o){var i=!1,e=null,t={bgColor:"#000",opacity:"0",zIndex:190,showType:"fade"};o.showTime=0,o.isFading=!1,o.setup=function(o){_.extend(t,o)},o.show=function(s,n,a){o.showTime+=1;var d,c,l=t.opacity,u="absolute",f=s&&s.showType?s.showType:t.showType,w="fadeIn",h=200,p=function(){$(window).on("resize",function(){d=ucf.utils.Body.getPageSize(),e.css({width:d[2],height:d[3]})}),$(window).on("scroll",function(){c=ucf.utils.Body.getPageScroll(),console.log("page scroll : "+c[1]),e.css({top:c[1],left:c[0]})}),$(window).on("touchmove",function(o){o.preventDefault()})};switch(n=n?function(){p(),n()}:p,f){case"show":w="show",h=0}if(s&&_.isNumber(s.opacity)&&(l=s.opacity,delete s.opacity),i){if(!o.isFading){d=ucf.utils.Body.getPageSize(),c=ucf.utils.Body.getPageScroll();var y={width:d[2],height:d[3],top:c[1]>0?c[1]:"0",left:c[0]>0?c[0]:"0"};return(_.isString(l)||l>0)&&(y.opacity=l),e.css(y),e[w]("fast"),n&&_.delay(n,h),void 0}e.remove(),e=null,o.showTime=0,o.isFading=!1,i=!1}return _.extend(t,s),_.isEmpty(e)&&(_.isUndefined(a)?$("body").append('<div id="bodyMask"></div>'):($(a).append('<div id="bodyMask"></div>'),u="relative"),e=$("#bodyMask"),e.css({backgroundColor:t.bgColor,top:"0",left:"0",position:"absolute",zIndex:t.zIndex,opacity:l,"-webkit-tap-highlight-color":"rgba(0, 0, 0, 0)"})),d=ucf.utils.Body.getPageSize(),c=ucf.utils.Body.getPageScroll(),e.css({width:d[2],height:d[3],top:c[1]>0?c[1]:"0",left:c[0]>0?c[0]:"0",opacity:l}),i=!0,e[w]("fast"),n&&_.delay(n,h),e},o.setOpacity=function(o){_.isEmpty(e)||e.css("opacity",o)},o.remove=function(i){if(!_.isEmpty(e)&&(o.showTime-=1,o.showTime<=0)){o.showTime=0;var t="fadeOut",s=200;switch(i){case"remove":t="hide",s=0}o.isFading=!0,e[t]("fast"),_.delay(function(){o.isFading=!1,$(window).off("resize"),$(window).off("scroll"),$(window).off("touchmove")},s)}}}(sdk.common.ui.Mask);sdk.common.ui.MsgBox=sdk.common.ui.MsgBox||{},function(o){var e="Msg",n=!1,i={height:"auto",width:"86%",zIndex:200};o.setup=function(o){_.extend(i,o)},o.alert=function(e,n){o.show(e,n)},o.confirm=function(e,n){o.show(e,n,"confirm")},o.show=function(c,t,s,a){if(!_.isEmpty(c)){switch(a=_.isBoolean(a)?a:!0,s=null!=s?s:"default",t=_.isEmpty(t)?{}:t,ucf.effect.Touch,s){case"confirm":e="Confirm";break;default:e="Msg"}a&&sdk.common.ui.Mask.show({opacity:.3}),$box=$("#ui"+e+"Box"),$box.length<=0&&($("body").append($("#"+e+"Box-tpl").html()),$box=$("#ui"+e+"Box"),$box.css("zIndex",i.zIndex)),$("#ui"+e+"BoxContent").html(c),$box.height(i.height),$box.width(i.width),$box.fadeIn(50),$box.UcEffects().moveTo("center","center"),$boxConfirm=$box.find("#ui"+e+"BoxConfirm"),$boxCancel=$box.find("#ui"+e+"BoxCancel"),$boxConfirm.removeClass("btnClick-none"),$boxCancel.removeClass("btnClick-none");var l=function(){t.confirmName?$boxConfirm.val(t.confirmName):$boxConfirm.val("确定"),$boxConfirm.length>=1&&($boxConfirm.off("click"),$boxConfirm.on("click",function(){$boxConfirm.addClass("btnClick-none"),o.remove(),_.isEmpty(t)||!_.isUndefined(t.callBack)&&_.isFunction(t.callBack)&&t.callBack()})),$boxCancel.length>=1&&(t.cancelName?$boxCancel.val(t.cancelName):$boxCancel.val("取消"),$boxCancel.off("click"),$boxCancel.on("click",function(){$boxCancel.addClass("btnClick-none"),o.remove(),_.isEmpty(t)||!_.isUndefined(t.cancel)&&_.isFunction(t.cancel)&&t.cancel()}))};l(),$(":focus").blur(),$(window).on("resize",o.onResize),$(window).on("scroll",o.onScroll),S.sdkBase.request(S.sdkBase.servType.APP,S.sdkBase.actions.OVERRIDE_BACK_BTN,{override:!0}),document.addEventListener("backbutton",o.remove),n=!0}},o.remove=function(){$("#ui"+e+"Box").fadeOut(50),sdk.common.ui.Mask.remove(),n=!1,$(window).off("resize"),$(window).off("scroll"),S.sdkBase.request(S.sdkBase.servType.APP,S.sdkBase.actions.OVERRIDE_BACK_BTN,{override:!1}),document.removeEventListener("backbutton",o.remove)},o.onResize=function(){n&&($("#ui"+e+"Box").height(i.height),$("#ui"+e+"Box").css("width",""),$("#ui"+e+"Box").width(i.width),$("#ui"+e+"Box").UcEffects().moveTo("center"))},o.onScroll=function(){n&&$("#ui"+e+"Box").UcEffects().moveTo("center")}}(sdk.common.ui.MsgBox);sdk.common.ui.NoticeBox=sdk.common.ui.NoticeBox||{},function(t){var e=[],i=!1,s=0,o={},n={zIndex:199,hideTime:3,okCls:"noticeOk",errorCls:"noticeError",loadingWidth:40},a='<div id="<%=noticeId%>" class="<%=addCls%>"><p class="item ms-tc"><span<% if(noticeCls) { %> class="<%=noticeCls%>"<% } %>><%=msg%></span></p></div>',r=function(t){t=t||document;var e=$("a",t),i=$("input",t),s=$("select",t);_.each(e,function(t){$(t).addClass("btnClick-none")}),_.each(i,function(t){$(t).addClass("btnClick-none")}),_.each(s,function(t){$(t).addClass("ms-ni")})},l=function(t){t=t||document;var e=$("a",t),i=$("input",t),s=$("select",t);_.each(e,function(t){$(t).removeClass("btnClick-none")}),_.each(i,function(t){$(t).removeClass("btnClick-none")}),_.each(s,function(t){$(t).removeClass("ms-ni")})},c=function(e,s,o,a,r,l,c){var d=e.el;!1!==o&&(i=!0);var h="fadeIn",u="fade";switch(r){case"slide":h="slideDown";break;case"show":h="show",u="show"}c=c||{},l&&S.common.ui.Mask.show({opacity:c.maskOpacity,showType:u}),s=_.isNull(s)||_.isUndefined(s)?!0:s,s?(d[h]("fast"),_.isNumber(s)?_.delay(function(){t.hide(e,a)},1e3*s):_.delay(function(){t.hide(e,a)},1e3*n.hideTime)):d[h]("fast",a)},d=function(t,e){this.height=t||16,this.rgbColorArray=null!=e&&3==e.length?e:[32,56,14],this.canvasElem=document.createElement("canvas"),this.rotation=0,this.intervalId=null,this.isRunning=!1};d.prototype.draw=function(){this.rotation<0&&(this.rotation=-this.rotation),this.rotation%=12;var t=this.height,e=this.canvasElem;e.setAttribute("width",this.height),e.setAttribute("height",this.height);var i=e.getContext("2d"),s=2*-Math.PI/12;i.save(),i.clearRect(0,0,t,t),i.translate(t/2,t/2);for(var o=t/10,n=t/5,a=0;12>a;a++){i.save(),i.rotate(a*s);var r=(12-(a+this.rotation)%12)/12;i.fillStyle="rgba("+this.rgbColorArray[0]+","+this.rgbColorArray[1]+","+this.rgbColorArray[2]+","+r+")",i.fillRect(-o/2,n,o,n),i.restore()}return i.restore(),this.rotation++,this.rotation%=12,e},d.prototype.rotate=function(){var t=this;this.intervalId=window.setInterval(function(){t.draw()},50)},d.prototype.stop=function(){window.clearInterval(this.intervalId)},t.setup=function(t){_.extend(n,t)},t.ok=function(e,i){return t.show(e,"ok","ui-sucont",!0,null,{position:"center",callback:i})},t.error=function(e,i){return t.show(e,"error","ui-sucont",!0,null,{position:"center",callback:i})},t.popError=function(e,i,s){return a='<span class="ms-fl red" id="<%=noticeId%>"><%=msg%></span>',t.show(e,"error","",!1,i,{showMask:!1,showType:"slide",callback:s})},t.loading=function(e,i){param=e?{msg:e}:null;var s=S.global.versionCompare(S.global.version,rConfig.VERSIONS.AUTO_LOGIN_VERSION);if(s!==!1&&s>=0)return S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.LOADING_INDICATOR_SHOW,param,null,null,!0,null,{quiet:!0}),!0;t.loadingBox=new d(n.loadingWidth,[119,119,119]),t.loadingBox.draw(),t.loadingBox.rotate();var o=n.loadingWidth;"loading_text"===e&&(o=100);var a=t.loadingBox.canvasElem,r=t.show(e,"loading","",!1,null,{position:"center",callback:i,width:o,height:n.loadingWidth,showType:"show"});return r.el.html(a),"loading_text"===e&&($(a).css({display:"block",position:"relative",margin:"auto"}),r.el.append('<div style="color:#C2C2C2;font-size:14px;text-align:center;">努力激活中...</div>')),r},t.show=function(t,l,d,h,u,p){r();var g={};g.msg=t;var f="";g.addCls=d,p=p||{},s++;var v=s;switch(g.noticeId="noticeContainer"+v,l){case"ok":g.noticeCls=n.okCls,p.maskOpacity=.3;break;case"error":g.noticeCls=n.errorCls,p.maskOpacity=.3;break;case"loading":f='<div id="<%=noticeId%>"></div>',p.maskOpacity="0"}_.isEmpty(f)&&(f=a);var m=template.compile("",f),w=m(g),k="";if(_.isEmpty(u)){if(sdk.EC.hideInput(),$("body").append(w),k=$("#"+g.noticeId),p.width&&k.width(p.width),p.height&&k.height(p.height),k.css("zIndex",n.zIndex),(""==k.css("position")||"static"==k.css("position"))&&k.css("position","absolute"),p.position){var y=function(){var t={paddingLeft:{type:"width",count:1},paddingRight:{type:"width",count:1},paddingTop:{type:"height",count:1},paddingBottom:{type:"height",count:1},border:{count:2}},e=p.width?p.width:parseInt(k.width()),i=p.height?p.height:parseInt(k.height());_.each(t,function(t,s){t.value=k.css(s)?parseInt(k.css(s)):0,t.value=isNaN(t.value)?0:t.value,"width"==t.type?e+=t.value*t.count:"height"==t.type?i+=t.value*t.count:(e+=t.value*t.count,i+=t.value*t.count)});var s=ucf.utils.Body.getPosition(e,i,p.position),o=ucf.utils.Body.getPageScroll();(""==k.css("top")||"auto"==k.css("top"))&&k.css("top",s[3]+o[1]),(""==k.css("left")||"auto"==k.css("left"))&&k.css("left",s[2]+o[0])};y(),$(window).on("resize",function(){k.css("top",""),k.css("left",""),y()}),$(window).on("scroll",function(){k.css("top",""),k.css("left",""),y()})}}else u.prepend(w),k=$("#"+g.noticeId),p.width&&k.width(p.width),p.height&&k.height(p.height);k.hide();var C=_.isEmpty(u),I=p.callback?p.callback:null,b=_.isUndefined(p.showMask)?!0:p.showMask,O=_.isUndefined(p.showType)?"fade":p.showType,E={id:v,el:k};if(o[v]={showMask:!0},i&&C){for(var S=[],N=0;N<arguments.length;N++)S.push(arguments[N]);return e.push({id:v,el:k,args:S}),E}return c(E,h,C,I,O,b,p),E},t.hide=function(s,n,a){l();var r=S.global.versionCompare(S.global.version,rConfig.VERSIONS.AUTO_LOGIN_VERSION);if(r!==!1&&r>=0&&S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.HIDE_LOADING_INDICATOR,null,null,null,!0,null,{quiet:!0}),s&&"object"==typeof s){var d=s.el,h=s.id;if(d&&d.length>=1){var u="fadeOut",p="fade",g=200;switch(a){case"slide":u="slideUp";break;case"remove":u="remove",p="remove",g=1}d[u]("fast"),_.delay(function(){$(window).off("resize"),$(window).off("scroll"),o[h]&&o[h].showMask&&S.common.ui.Mask.remove(p),_.isEmpty(t.loadingBox)||t.loadingBox.stop(),sdk.EC.showInput(),i=!1;var s=e.shift();if(n&&n.apply(),s){var a=!_.isEmpty(s.args[5])&&s.args[5].callback?s.args[5].callback:null,r=_.isEmpty(s.args[5])||_.isUndefined(s.args[5].showMask)?!0:s.args[5].showMask,l=_.isEmpty(s.args[5])||_.isUndefined(s.args[5].showType)?"fade":s.args[5].showType;c({id:s.id,el:s.el},s.args[3],_.isEmpty(s.args[4]),a,l,r,s.args[5])}},g)}}}}(sdk.common.ui.NoticeBox);sdk.SdkHeader=sdk.common.ui.SdkHeader=sdk.common.ui.SdkHeader||{},function(e){e.oriHeaderVer="2.0.1",e.useNewHeaderVer=10,e.showHeader=!0,e.init=function(){var r=function(e,r){if(!e)return!1;if(!r)return!1;var s=e.split("."),n=r.split(".");if(s.length<3||3>n)return!1;var a=100*parseInt(s[0])+10*parseInt(s[1])+parseInt(s[2]),d=100*parseInt(n[0])+10*parseInt(n[1])+parseInt(n[2]);return a>d?1:a==d?0:-1},s=r(S.sdkBase.sdkVersion(),e.oriHeaderVer);!1!==s?0>=s&&(e.showHeader=!1):e.showHeader=!1},e.show=function(r){e.showHeader&&S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.SET_UI_STYLE,{topBar:{text:r}})},e.hide=function(){}}(sdk.common.ui.SdkHeader);sdk.common.ui.Tab=sdk.common.ui.Tab||{},function(o){o.switching=function(o,s,e,i){var n=$(o+">"+s);n.on(e,function(){for(var s=0;s<n.length;s++)n[s]==this?(n.eq(s).addClass(i).removeClass("off"),$(o+"_"+s).show()):(n.eq(s).removeClass(i),$(o+"_"+s).hide())})},o.switchTo=function(o,s,e,i){e=e||"li",i=i||"current";for(var n=$(o+">"+e),a=0;a<n.length;a++)a==s?(n.eq(a).addClass(i).removeClass("off"),$(o+"_"+a).show()):(n.eq(a).removeClass(i),$(o+"_"+a).hide())},o.click=function(o,s,e,i){var n=$(s+">"+e);if(n.length>0){n.removeClass(i);for(var a=0;a<n.length;a++)n[a].id==o[0].id?$(s+"_"+a).show():$(s+"_"+a).hide()}o.addClass(i)}}(sdk.common.ui.Tab);sdk.common.ui.Umbrella=sdk.common.ui.Umbrella||{},function(l){l.icon_umbrella=$("#icon_umbrella"),l.umbrella_box=$("#umbrella_box"),l.animate=null,l.state={post:"show",reply:"show"},l.type="post",l.operation={post:"#makeNewReply",reply:"#makeNewPost"},l.init=function(e){e=e||"post",l.type=e,l.icon_umbrella=$("#icon_umbrella"),l.umbrella_box=$("#umbrella_box"),"show"!=l.state[e]&&(l.icon_umbrella.removeClass("icon_parasol"),l.icon_umbrella.addClass("icon_umbrella"),l.umbrella_box.width("0px"),l.umbrella_box.hide()),l.icon_umbrella.on("click",l.toggle),$(l.operation[e]).remove()},l.toggle=function(){l.icon_umbrella=$("#icon_umbrella"),l.umbrella_box=$("#umbrella_box"),l.icon_umbrella.hasClass("icon_umbrella")?l.slideshow():l.slidehide()},l.slideshow=function(){l.state[l.type]="show",clearInterval(l.animate),l.icon_umbrella.addClass("icon_parasol"),l.icon_umbrella.removeClass("icon_umbrella"),l.umbrella_box.show(),l.animate=setInterval(function(){var e=parseInt(l.umbrella_box.width());200>e?0==e?l.umbrella_box.width(30):l.umbrella_box.width(e+30):(l.umbrella_box.width(220),clearInterval(l.animate))},30)},l.slidehide=function(){l.state[l.type]="hide",clearInterval(l.animate),l.icon_umbrella.removeClass("icon_parasol"),l.icon_umbrella.addClass("icon_umbrella"),l.animate=setInterval(function(){l.umbrella_box.show();var e=parseInt(l.umbrella_box.width());e>30?l.umbrella_box.width(e-30):(l.umbrella_box.width("0px"),l.umbrella_box.hide(),l.icon_umbrella.show(),clearInterval(l.animate))},30)}}(sdk.common.ui.Umbrella);sdk.EC=sdk.common.utils.ElementControl=sdk.common.utils.ElementControl||{},function(t){t.showInput=function(){$("[type=text],[type=password],textarea").css("visibility","visible")},t.hideInput=function(){$("[type=text],[type=password],textarea").css("visibility","hidden")}}(sdk.EC);sdk.Log=sdk.common.utils.Log=sdk.common.utils.Log||{},function(s){s.businesses={PAGE_USER:"page.user",PAGE_GAME:"page.game",PAGE_PAY:"page.pay",PAGE_GENERAL:"page.general",PAGE_BBS:"page.bbs"},s.steps={ENTER:"enter",CLOSE:"close"},s.currBusiness="",s.pageEnter=function(e,n){if(_.isUndefined(e)||_.indexOf(_.values(s.businesses),e)<0)throw"log.js : business is not correct!";var i="";_.isUndefined(n)||_.isEmpty(n)||_.each(n,function(s){i+="."+s}),s.debug("page Enter:"+e+"|"+e+i),s.currBusiness=e+i;var u=e+i;setTimeout(function(){S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.STAT,{business:u,step:s.steps.ENTER},null,null,null,null,{quiet:!0})},0)},s.pageClose=function(){if(!_.isEmpty(s.currBusiness)){var e=s.currBusiness;s.debug("page Close:"+e),setTimeout(function(){S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.STAT,{business:e,step:s.steps.CLOSE},null,null,null,null,{quiet:!0})},0)}},s.click=function(e,n,i){if(_.isUndefined(e)||_.indexOf(_.values(s.businesses),e)<0)throw"log.js : business is not correct!";(_.isUndefined(i)||!_.isBoolean(i))&&(i=!1);var u="";_.isUndefined(n)||_.isEmpty(n)||_.each(n,function(s){u+="."+s}),s.debug("page Enter:"+e+"|"+e+u);var l=e+u;setTimeout(function(){var e=S.global.versionCompare(S.global.version,"3.4.5"),n=S.global.versionCompare(S.global.version,"3.3.8"),u=S.global.versionCompare(S.global.version,"3.4.0");e!==!1&&e>=0||n!==!1&&n>=0&&u!==!1&&-1==u?S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.STAT,{business:l,step:"",instant:i,action:"click"},null,null,null,null,{quiet:!0}):(S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.STAT,{business:l,step:s.steps.ENTER,instant:i},null,null,null,null,{quiet:!0}),S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.STAT,{business:l,step:s.steps.CLOSE,instant:i},null,null,null,null,{quiet:!0}))},0)},s.debug=function(s){console.log(s)},s.info=function(){},s.warn=function(){},s.error=function(){}}(sdk.Log);sdk.PageCache=sdk.common.utils.PageCache=sdk.common.utils.PageCache||{},function(e){e.get=function(e){var s=S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.GET_PAGE_PARAMS,{key:e});return s},e.set=function(e,s){S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.SET_PAGE_PARAMS,{key:e,value:s})},e.del=function(e){S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.SET_PAGE_PARAMS,{key:e})}}(sdk.PageCache);sdk.Url=sdk.common.utils.Url=sdk.common.utils.Url||{},function(o){o.staticImg=function(){},o.redirect=function(o){console.log("url redirect:"+o),S.Log.pageClose(),window.location.href=o},o.back=function(){S.Log.pageClose(),S.sdkBase.request(S.sdkBase.servType.APP,S.sdkBase.actions.HISTORY_BACK)},o.reload=function(){window.location.reload()},o.location={},o.location.route=function(o){window.location.hash=o,S.Log.pageClose(),S.sdkBase.request(S.sdkBase.servType.APP,S.sdkBase.actions.URL_HASH_CHANGE)},o.getQueryStringArgs=function(){var o=window.location.search.length>0?location.search.substr(1):"",e={},n=o.length?o.split("&"):[],s=null,t=null,l=null,i=0,c=n.length;for(i=0;c>i;i++)s=n[i].split("="),t=decodeURIComponent(s[0]),l=decodeURIComponent(s[1]),t.length&&(e[t]=l);return e}}(sdk.Url);sdk.VirtualEvent=sdk.common.utils.VirtualEvent=sdk.common.utils.VirtualEvent||{},function(e){var t=ucf.effect.Touch;e.click=function(e,n,o,a,c){o=_.isUndefined(o)?{}:o,a=_.isUndefined(a)||_.isEmpty(a)?"":a;var i,s=!1,u=!1,d=0,l=0;if(t.isTouchDevice())var f="touchstart"+a,v="touchmove"+a,r="touchend"+a;else var f="mousedown"+a,v="mousemove"+a,r="mouseup"+a;var h={start:{eventName:f,method:function(e){s=!0,u=!0,i=this;var n=!1;if(_.each(rConfig.hasFeedBack,function(e){"true"!==$(i).attr("data-disabled")&&($(i).hasClass(e)||"feed"==$(i).attr("data-btnFeed"))&&(n=!0)}),_.each(rConfig.blockFeedBack,function(e){$(i).hasClass(e)&&(n=!1)}),n&&$(i).addClass(rConfig.feedBackCls),t.isTouchDevice())var o=e.touches[0];else var o=e;d=o.clientX,l=o.clientY}},move:{eventName:v,method:function(e){if(u){if($(document).height()<=$(window).height()&&e.preventDefault(),t.isTouchDevice())var n=e.touches[0];else var n=e;(Math.abs(n.clientX-d)>5||Math.abs(n.clientY-l)>5)&&(s=!1)}}},up:{eventName:r,method:function(e){if(u){if("true"===$(this).attr("data-disabled"))return;$(this).hasClass(rConfig.feedBackCls)&&$(this).removeClass(rConfig.feedBackCls),$(document).height()<=$(window).height()&&e.preventDefault(),s&&n(e,this,o),s=!1,u=!1}},docMethod:function(){s||$("."+rConfig.feedBackCls).removeClass(rConfig.feedBackCls)}}};_.isUndefined(c)||_.isEmpty(c)?($(e).on.apply($(e),[h.start.eventName,h.start.method]),$(e).on.apply($(e),[h.move.eventName,h.move.method]),$(e).on.apply($(e),[h.up.eventName,h.up.method]),$(document).on.apply($(document),[h.up.eventName,h.up.docMethod])):($(e).on.apply($(e),[h.start.eventName,c,h.start.method]),$(e).on.apply($(e),[h.move.eventName,c,h.move.method]),$(e).on.apply($(e),[h.up.eventName,c,h.up.method]),$(document).on.apply($(document),[h.up.eventName,h.up.docMethod]))},e.offClick=function(e){if(t.isTouchDevice())var n="touchstart",o="touchmove",a="touchend";else var n="mousedown",o="mousemove",a="mouseup";$(e).off(n),$(e).off(o),$(e).off(a)},e.delegateEvents=function(t,n,o){var a=function(e,t){return e&&e[t]?_.isFunction(e[t])?e[t]():e[t]:null},c=/^(\S+)\s*(.*)$/;if(t||(t=a(n,"events"))){n.undelegateEvents();for(var i in t){var s=t[i];if(!_.isUndefined(o)&&_.isFunction(o)){var u=function(e){return function(){o(e)}}(s);s=u}if(_.isFunction(s)||(s=n[t[i]]),!s)throw new Error('Method "'+t[i]+'" does not exist');var d=i.match(c),l=d[1],f=d[2];switch(s=_.bind(s,n),l){case"click":case"touch":""===f?e.click(n.$el,s,null,".delegateEvents"+n.cid):e.click(n.$el,s,null,".delegateEvents"+n.cid,f);break;case"start":case"move":case"up":""===f?ucf.effect.Touch.on(l,n.$el,s,!0,null,".delegateEvents"+n.cid):ucf.effect.Touch.on(l,n.$el,s,!0,null,".delegateEvents"+n.cid,f);break;case"onclick":l="click",l+=".delegateEvents"+n.cid,""===f?n.$el.on(l,s):n.$el.on(l,f,s);break;default:l+=".delegateEvents"+n.cid,""===f?n.$el.on(l,s):n.$el.on(l,f,s)}}}},e.undelegateEvents=function(e){e.$el.off(".delegateEvents"+e.cid)}}(sdk.VirtualEvent);