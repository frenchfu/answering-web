<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-sweetalert/1.0.1/sweetalert.min.css">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" integrity="sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB" crossorigin="anonymous">


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<title>Insert title here</title>
</head>
<style type="text/css"> 
body { 
    background-color:#FFF; 
    color:black; 
    font-size:20px; 
    font-family:"Lucida Grande",Verdana,Arial,Helvetica,sans-serif; 
    } 
h1,th { 
    font-family:Georgia, "Times New Roman", Times, serif; 
    } 
h1{ 
    font-size:28px; 
    } 
table { 
    border-collapse:collapse; 
    } 
th , td { 
    padding:10px; 
    border:2px solid #666; 
    text-align:center; 
    width:20% 
    } 
#free, .pickedBG {
    background-color: #f66; 
} 
 
.winningBG { 
    background-image: url(images/redFlash.gif); 
} 
</style> 
<body background="https://i.imgur.com/esrWEO7.jpg">
	<div class="container"  align="center" id="pageHome" >
		<h2>問答管理者畫面</h2>
		<div class="form-group"  >
			  <label for="localName">請選擇要執行的功能</label>
			  <button type="button" onclick="openPage('pageNextQuestion')" class="btn btn-primary">選擇下一道題目</button>
			  <button type="button" onclick="openPage('pageMonitor')" class="btn btn-success">監控畫面</button><br/><br/>
			  
			  <button type="button" onclick="openPage('pagePlayType')" class="btn btn-info">選擇玩法</button>
			  <button type="button" onclick="openPage('pageReset')" class="btn btn-warning">全部重置</button>
		</div>
		<div id="currentQuestionDiv"></div>
		<div id="answerRaceTypeDiv"></div>
		<div id="nowStatusDiv" style="color: #0000FF"></div>
		<button type="button" onclick="goQuection()" class="btn btn-danger">開始這一RUN</button>
	</div>
	<div class="form-group" style="display: none;" align="center" id="pageNextQuestion" >
	  <h2>選擇下一道題目</h2>
	  <div id="questionListDiv">
	  </div>
	  <button type="button" onclick="openPage('pageHome')" class="btn btn-primary">返回</button>
	</div>
	<div class="form-group" style="display: none;" align="center" id="pageMonitor" >
	  <h2>監控畫面</h2>
		<button type="button" onclick="endQuection()" class="btn btn-danger">結束這一RUN</button><br/><br/>
	  <div id="monitorDiv">
	  
	  </div>
	  <button type="button" onclick="pickARandomP('')" class="btn btn-primary">隨機抓一個人</button>
	  <button type="button" onclick="openPage('pageHome')" class="btn btn-primary">返回</button>
	</div>
	<div class="form-group"  style="display: none;" align="center" id="pagePlayType" >
	  <h2>選擇玩法</h2>
	  <div >
	  	<button type="button" onclick="setAnswerRaceType('CLICK_END_LESS','不停的按')" class="btn btn-danger">不停的按</button><br/><br/>
	  	<button type="button" onclick="setAnswerRaceType('CLICK_TO_CLEAR_NUM','突然出現的BUTTEN 同時')" class="btn btn-success">突然出現的BUTTEN 同時</button><br/><br/>
	  	<button type="button" onclick="setAnswerRaceType('SUNNDELY_SHOW_SYNC','突然出現的BUTTEN 不同時')" class="btn btn-info">突然出現的BUTTEN 不同時</button><br/><br/>
	  	<button type="button" onclick="setAnswerRaceType('MATH_CALCULETE','計算題')" class="btn btn-warning">計算題</button><br/><br/>
	  	<button type="button" onclick="setAnswerRaceType('JUST_FASTST','最快答題者')" class="btn btn-success">最快答題者</button><br/><br/>
	  	<button type="button" onclick="setAnswerRaceType('RANDOM_PICK','隨機挑選')" class="btn btn-info">隨機挑選</button><br/><br/><br/>
	  </div>
	  <button type="button" onclick="openPage('pageHome')" class="btn btn-primary">返回</button>
	</div>
	<div class="form-group" style="display: none;" align="center" id="pageReset" >
	  <h2>全部重置</h2>
	  <div >
	  	<button type="button" onclick="reSetAll()" class="btn btn-warning">全部重置</button>
	  	<button type="button" onclick="openPage('pageHome')" class="btn btn-primary">返回</button>
	  </div>
	</div>		
</body>
</html>
<script type="text/javascript">

var baseUrl = '<c:url value="/answer-web/"/>';


var adminObj = {
		questionList:null,
		currentQuestion:null,
		answerRaceType:null,
		answerRaceTypeText:null,
		nowStatus:null,
		stepCount:0
		};

	
$( document ).ready(function() {
	syncAdminObj();
});

window.setInterval(syncAdminObj, 3000); //每三秒更新狀態


function openPage(pageName){
	
	$("div[id^='page']" ).each(function(){
		var obj = $(this);
		console.log(obj.prop("id"));
		if(obj.prop("id") == pageName){
			obj.show();
		}else{
			obj.hide();
		}
	});
	
}

function reSetAll(){
	
	swal({
		title: "確定全部重置嗎？", 
		  text: "全場遊戲紀錄會被清空重新開始！", 
		  icon: "warning",
		  buttons: true,
		  dangerMode: true,
		})
		.then((willDelete) => {
		  if (willDelete) {
			  
			  
			  swal({
					  title: "最後一次 確認 真的真的 確定全部重置嗎？", 
					  text: "全場遊戲紀錄會被清空重新開始！", 
					  icon: "warning",
					  buttons: true,
					  dangerMode: true,
					})
					.then((willDelete2) => {
					  if (willDelete2) {
							$.ajax({
						        type: "GET",
						        async: false,
						        url: baseUrl+"admin-reset-all-game",
						        success: function(data){
						          if(!!data){
						             if(data.result == "DONE"){
						            	 swal("重置完成"," ","success");
						            	 adminObj = data.adminObj;		
						            	 loadAdminObjToHtml();
						            	 openPage('pageHome');
						             }else{
						            	 swal("故障了 確認網路再試一次"," ","error");
						             }
						          }else{
						        	  swal("故障了 確認網路再試一次"," ","error");
						          }
						     },
						    	error: function() {
						    		swal("故障了 確認網路再試一次"," ","error");
						    	}
							});
					  } else {
					    swal("取消了");
					  }
					});
		  } else {
		    swal("取消了");
		  }
		});
}

function openQ(qid){
	swal({
		title: "確定下一道問題是:"+qid+" 嗎?", 
		  text: adminObj.questionList[qid].questionText, 
		  icon: "warning",
		  buttons: true,
		  dangerMode: true,
		})
		.then((willDelete) => {
		  if (willDelete) {
			  adminObj.currentQuestion = adminObj.questionList[qid];
			  var syncArray = ["currentQuestion"];
			  syncAdminObj(syncArray);
			  swal("設定好了");
		  } else {
		    swal("取消了");
		  }
		});
}

function setAnswerRaceType(code,text){
	
	adminObj.answerRaceType = code;
	adminObj.answerRaceTypeText =text;
	var syncArray = ["answerRaceType","answerRaceTypeText"];
	syncAdminObj(syncArray);
	swal("設定好了");
	
}

function loadQuestionsStatus(){
	var html = "";
	adminObj.questionList.forEach(function(element) {
		  if(!!element.id){
			  isDone = "Y" == element.isDone?" disabled":"";
			  classType = "Y" == element.isDone?"btn-danger":"btn-warning";
			  html += "<button type=\"button\" onclick=\"openQ('"+element.id+"')\" class=\""+classType+"\" "+isDone+" >"+element.id+":"+element.questionText+"</button><br/><br/>";
		  }
	});
	$("#questionListDiv").html(html);
	
}

function goQuection(){//還沒END 不能開始
	
	if(adminObj.nowStatus != "WAIT_GO"){
		swal("還沒結束目前這道問題喔!!");
	}else{
		
		swal({
			title: "確定開始這一RUN嗎?", 
			  text: "問題"+adminObj.currentQuestion.id+":"+adminObj.currentQuestion.questionText, 
			  icon: "warning",
			  buttons: true,
			  dangerMode: true,
			})
			.then((willDelete) => {
			  if (willDelete) {
					$.ajax({
				        type: "GET",
				        async: false,
				        url: baseUrl+"go-question-process",
				        success: function(data){
				          if(!!data){
				        	 adminObj = data.adminObj;
			             	 loadAdminObjToHtml();
			             	 swal("開始了");
				          	if(!!data.message){
				          		swal(data.message);
				          	}
				          }
				     }});
			  } else {
			    swal("取消了");
			  }
			});
	}
}


function endQuection(){//還沒有答對者 不可 END
	
	if(adminObj.nowStatus != "WAIT_END"){
		swal("還沒開始這一RUN喔!!");
	}else{
		
		swal({
			title: "確定結束這一道題目嗎?", 
			  text: " ", 
			  icon: "warning",
			  buttons: true,
			  dangerMode: true,
			})
			.then((willDelete) => {
			  if (willDelete) {
				  $.ajax({
				        type: "GET",
				        async: false,
				        url: baseUrl+"stop-question-process",
				        success: function(data){
				          if(!!data){
				        	 adminObj = data.adminObj;
			             	 loadAdminObjToHtml();
			             	 swal("結束完成")
				          	if(!!data.message){
				          		swal(data.message);
				          	}
				          }
				     }});  
			  } else {
			    swal("取消了");
			  }
			});
	}	
}



function syncAdminObj(syncArray){
	
	var jsdata = {
			questionList:null,
			currentQuestion:null,
			answerRaceType:null,
			answerRaceTypeText:null,
			nowStatus:null,
			stepCount:0	
	};
	if(!!syncArray){
		if(syncArray.includes("answerRaceType")) { //"answerRaceType","answerRaceTypeText"];"currentQuestion"
			jsdata.answerRaceType = adminObj.answerRaceType;
		}
		if(syncArray.includes("answerRaceTypeText")) {
			jsdata.answerRaceTypeText = adminObj.answerRaceTypeText;
		}
		if(syncArray.includes("currentQuestion")) {
			jsdata.currentQuestion = adminObj.currentQuestion;
		}
	}
	console.log(jsdata);
	$.ajax({
        type: "POST",
        dataType: 'json',
        data:JSON.stringify(jsdata),
        contentType: "application/json",
        url: baseUrl+"get-sync-admin-obj",
        success: function(data){
          if(!!data){
             if(!!data.adminObj){
            	 if(data.adminObj.stepCount > adminObj.stepCount || data.adminObj.stepCount == 0){//重置或更新
                	 adminObj = data.adminObj;
                	 loadAdminObjToHtml();
            	 }
             }
          }
     }});
}

function loadAdminObjToHtml(){
	
	loadQuestionsStatus();
	$("#answerRaceTypeDiv").text("玩法:"+adminObj.answerRaceTypeText);
	$("#currentQuestionDiv").text("下一道題目為:"+adminObj.currentQuestion.id+":"+adminObj.currentQuestion.questionText);
	$("#nowStatusDiv").text("狀態:"+(adminObj.nowStatus == "WAIT_END" ?"作答中":"等待下一題開始"));
	
	var monitorHeml = "";
	if(!!adminObj.randomParticipant && !!adminObj.randomParticipant.id){
		monitorHeml += "<h1>隨機挑選 ID:"+adminObj.randomParticipant.id+"</h1><br/>";
		monitorHeml += "<h1>隨機挑選 姓名:"+adminObj.randomParticipant.localName+"</h1><br/>";
	}
	if(!!adminObj.currentQuestion && !!adminObj.currentQuestion.pricaeParticipantModel){		
		monitorHeml += "<h1>得獎者ID:"+adminObj.currentQuestion.pricaeParticipantModel.id+"</h1><br/>";
		monitorHeml += "<h1>得獎者名稱:"+adminObj.currentQuestion.pricaeParticipantModel.localName+"</h1><br/>";
	}
	if(!!adminObj.inaAnswerACounter || inaAnswerBCounter || inaAnswerCCounter || inaAnswerDCounter){		
		monitorHeml += "<h1>選A人數:"+adminObj.inaAnswerACounter+"</h1><br/>";
		monitorHeml += "<h1>選B人數:"+adminObj.inaAnswerBCounter+"</h1><br/>";
		monitorHeml += "<h1>選C人數:"+adminObj.inaAnswerCCounter+"</h1><br/>";
		monitorHeml += "<h1>選D人數:"+adminObj.inaAnswerDCounter+"</h1><br/>";
	}
	$("#monitorDiv").html(monitorHeml);
	
}

function pickARandomP(){
	
	$.ajax({
        type: "GET",
        async: false,
        url: baseUrl+"pick-a-random-p",
        success: function(data){
          if(!!data){
        	 adminObj = data.adminObj;
         	 loadAdminObjToHtml();
          	if(!!data.message){
          		swal(data.message);
          	}
          }
     }});  
	
	
}


</script> 