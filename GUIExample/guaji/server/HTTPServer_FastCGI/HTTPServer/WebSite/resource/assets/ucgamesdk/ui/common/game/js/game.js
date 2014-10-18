S.SSCL.Games=Backbone.Collection.extend({model:S.SSMO.Game,initialize:function(){_.bindAll(this,"parse")},parse:function(e){return e.data}});S.SSCT.Game=Backbone.Controller.extend({initialize:function(){_.bindAll(this)},validate:function(e,s){this.validModel=S.SSCT.GetHandler("Model","ValidCode"),this.validModel.on("error",_.bind(function(e,a){s.error(a.msg||a),this.validModel.off("error")},this));var a=this.validModel.set({alphaCode:e});a&&this.validModel.validCode({alphaCode:e},{success:s.success,error:function(e,a){console.log("resp",a),s.error(a.msg)}})},getGameInfo:function(e){if(null==this.gameId){var s=S.sdkBase.request(S.sdkBase.servType.COMMON,S.sdkBase.actions.GET_GAME_INFO);s&&s.success?(this.gameId=s.data.gameId,this.gameInfo=s.data,e&&e.success&&e.success.apply(this,[s.data])):e&&e.error&&e.error.apply(this,[s])}else _.isUndefined(e)||_.isUndefined(e.success)||!_.isFunction(e.success)||e.success.apply(this,[this.gameInfo])},getOptnTestGameInfo:function(e){S.SSCT.GetHandler("Model","Game").getOptnTestGameInfo({success:function(s,a){e.success(a.data)},error:function(s,a){e.error(a.data)},quiet:!0})}});S.SSMO.Game=Backbone.Model.extend({initialize:function(){_.bindAll(this)},getOptnTestGameInfo:function(e){this.url=S.sdkBase.servType.SDKSERVER+"/"+S.sdkBase.actions.CALL_SDK_SERVER+"/"+rConfig.apis.GET_OPENTEST_GAME_INFO,this.fetch(e)},parse:function(e){return e.data}});S.SSMO.ValidCode=Backbone.Model.extend({initialize:function(){_.bindAll(this),this.url=S.sdkBase.servType.SDKSERVER+"/"+S.sdkBase.actions.CALL_SDK_SERVER+"/"+rConfig.apis.VALID_CODE},validate:function(e){if(!this.isRequest){if(_.isUndefined(e.alphaCode)&&_.isEmpty(e.alphaCode))return"激活码不能为空";if(6!=e.alphaCode.length||e.alphaCode.match(/[^a-z0-9A-Z]+/))return"请输入正确的激活码"}this.isRequest=!1},validCode:function(e,i){this.save(e,i)},parse:function(e){return this.isRequest=!0,e.data}});S.SSVW.Game=Backbone.View.extend({el:"#gameContainer",events:{"onclick #bbsLink":"linkToBBS","onclick #gameCenterLink":"linkToGameCenter","onclick #confirmValidCode":"doConfirm","onclick #exitValidCode":"doExit","onclick #clearCode":"flushInpt","onclick #clearValidCode":"clearValidCode","onclick #validCode":"_inputFocuse","focusout #validCode":"hideClrPass","onclick #toUserCenterLink":"gotoUserCenter","onclick #gotoValidCodeCenter":"gotoValidCodeCenter"},config:{VALID_CODE_ROUTE:"#!game/testWidthCode/[code]"},isRandom:null,initialize:function(){_.bindAll(this),this.gameController=S.SSCT.GetHandler("Controller","Game")},notOpen:function(){S.SCEV.Proxy.trigger(S.SCEV.EventType.PRE_ROUTE,{enterPage:sdk.Log.businesses.PAGE_GAME,enterBusiness:["notOpen"]});var e=this.$el.find("#gameNotOpenMsg"),i="openTestGameMsg",o="";this.gameController.getOptnTestGameInfo(this.gameController.callBackMix(function(n){"B"!=n.status||_.isUndefined(n.message)||_.isEmpty(n.message)?o=ucf.Cache.get(i,!0):(o=n.message,ucf.Cache.set(i,o,3600,!0)),_.isEmpty(o)||e.html(o),e.show()},function(){o=ucf.Cache.get(i,!0),_.isEmpty(o)||e.html(o),e.show()})),S.global.isThirdParty&&(_.isUndefined(S.global.thirdParty.game.bbsInVisibile)||1!=S.global.thirdParty.game.bbsInVisibile||(this.$el.find("#gameNotOpenBbs").hide(),this.$el.find("#gameNotOpenBbsTips").hide()),_.isUndefined(S.global.thirdParty.game.codeCenterInVisibile)||1!=S.global.thirdParty.game.codeCenterInVisibile||(this.$el.find("#gameNotOpenCodecenter").hide(),this.$el.find("#gameNotOpenCodecenterTips").hide()))},validCode:function(e){S.SCEV.Proxy.trigger(S.SCEV.EventType.PRE_ROUTE,{enterPage:sdk.Log.businesses.PAGE_GAME,enterBusiness:["validateCode"]}),this.isRandom=_.isUndefined(e)||_.isEmpty(e)?"false":e,this.changeClrPass(),this.initLogoutBtn()},testWidthCode:function(e){_.isEmpty(e)||"[code]"===e||$("#validCode").val(e),this.validCode.call(this)},doConfirm:function(){var e=this,i=this.$el.find("#validCode").val(),o=S.SSCT.GetHandler("Controller","User"),n=this.$el.find("#confirmValidCode");n.attr("disabled","disabled"),n.attr("data-disabled","true").addClass("ui-disabled"),this.gameController.validate(i,this.gameController.callBackMix(function(e,i){o.notifyCp({code:i.code,msg:i.msg},o.callBackMix(o.sdkExit))},function(i){e._showErrorMsg(i,"#validCodeNoticeBox"),n.removeAttr("disabled"),n.attr("data-disabled","").removeClass("ui-disabled")}))},doExit:function(){S.Log.pageClose(),S.SSCT.GetHandler("Controller","User").sdkExit()},flushInpt:function(){_.isUndefined(this.noticeBar)||_.isEmpty(this.noticeBar)||sdk.common.ui.NoticeBox.hide(this.noticeBar,null,"slide"),this.$el.find("#validCode").val("")},clearValidCode:function(){this.$el.find("#validCode").val(""),this.changeClrPass()},changeClrPass:function(){_.isEmpty($("#validCode").val())?this.$el.find("#clearValidCode").hide():this.$el.find("#clearValidCode").show()},hideClrPass:function(){this.$el.find("#clearValidCode").hide()},initLogoutBtn:function(){S.SCEV.Proxy.trigger(S.SCEV.EventType.SDK_REMOVE_WIN_EVENT,{eventName:"bridgeTopBtnClicked"}),S.SCEV.Proxy.trigger(S.SCEV.EventType.SDK_WINDOW_EVENT,{eventName:"bridgeTopBtnClicked",handler:function(e){"logout"==e.action&&(S.sdkBase.request(S.sdkBase.servType.LOGIN,S.sdkBase.actions.LOGOUT),S.SSCT.GetHandler("Controller","User").sdkExit())}})},linkToBBS:function(){sdk.Log.pageEnter(sdk.Log.businesses.PAGE_GAME,["bbsClick"]),sdk.Log.pageClose(sdk.Log.businesses.PAGE_GAME,["bbsClick"]),sdk.PageCache.set("sdk_redirect_out",1),S.global.isThirdParty?window.location.href=S.global.thirdParty.bbs.link:S.Url.redirect("../bbs/bbs.html")},linkToGameCenter:function(){sdk.Log.pageClose(sdk.Log.businesses.PAGE_GAME,["notOpen"]),sdk.Log.pageEnter(sdk.Log.businesses.PAGE_GAME,["gameCenter"]),S.Url.redirect(eConfig.gameCenter)},_inputFocuse:function(){this.changeClrPass()},_showErrorMsg:function(e,i,o){S.SSCT.GetHandler("Controller","General").sendClientMsg(e),o&&o.apply()},gotoUserCenter:function(){sdk.Log.click(sdk.Log.businesses.PAGE_USER,["h5_ValidCode_to_UserCenter_l"]),S.Url.redirect("../user/user.html#!user")},gotoValidCodeCenter:function(){function e(e,i,o,t,r,d){var l=[];l.push("from="+e),l.push("caller="+i),l.push("version="+o),l.push("gameId="+t),l.push("sid="+r),"Test"===n&&l.push("callback="+encodeURIComponent(window.location.href.replace(window.location.hash,"")+s.config.VALID_CODE_ROUTE)),S.Url.redirect(eConfig.validCodeCenterUrl+"?"+l.join("&")+d)}function i(e){S.SSCT.GetHandler("Controller","User").getCurUserInfo({success:e,error:o})}function o(e){e&&s._showErrorMsg(e.msg||e)}var n=this.$el.find("#gotoValidCodeCenter").data("source"),t=this.$el.find("#gotoValidCodeCenter").data("from");if(sdk.Log.click(sdk.Log.businesses.PAGE_USER,["h5_Code_p",n]),S.global.isThirdParty)return this.gameController.getGameInfo({success:function(e){var i=e.gameId,o=e.channelId;window.location.href=S.global.thirdParty.codeCenter.link+"?"+"gameid="+i+"&channelid="+o},error:function(e){s._showErrorMsg(e.msg)}}),void 0;var s=this,r=new RegExp("(^|\\?|&)from=([^&]*)(\\s|&|$)","i");if(r.test(location.href)){var d=unescape(RegExp.$2.replace(/\+/g," "));-1!=d.indexOf("#")&&(d=d.substr(0,d.indexOf("#"))),d.length>0&&(t=d)}this.gameController.getGameInfo({success:function(o){var s=o.gameId;i(function(i){var o=S.global.version;e(t,"sdk",o,s,i.sid,"#!codeCenter/"+n)})},error:function(e){s._showErrorMsg(e.msg)}})}});