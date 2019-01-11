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
	<div class="container" id="loginDiv" align="center" >
	  <h2>答題卡</h2>
	  <form>
		<div class="form-group">
		  <label for="localName">輸入 您的大名或是暱稱:</label>
		  <input type="text" class="form-control" id="localName" name="localName"><button type="button" onclick="checkNamesAndDoJoin()" class="btn btn-primary">點我提交 並取得參賽資格</button>
		</div>
	   </form>
	</div>
	<div class="container" id="answerDiv" style="display: none;" align="center">
	  <h2>答題卡 <span id="counterSpan"></span></h2>
	  <div >
	  	<h1><label >卡號:<span id="cardId"></span></label></h1>
	  	<h1><label >大名:<span id="localNameP"></span></label></h1>
	  </div>
	  
	  <div class="form-group" align="center">
	  	<div id="playTytle"></div>
	  	<div id="answerBody">
	  	
	  	
	  	</div>
		<button type="button"  id="next" onclick="getQuestions()" class="btn btn-primary">當主持人說開始時點我</button>
		<!--  <button type="button"  id="counter" onclick="counterPlus()" class="btn btn-primary">點點樂</button> <button type="button"  id="counter2" onclick="counterPlus()" class="btn btn-primary">點點樂2</button>-->
	  </div>
	  
	  
	</div>	
</body>
</html>
<script type="text/javascript">

var participantModel = null;
var counter = 0;

var baseUrl = '<c:url value="/answer-web/"/>';
	
$( document ).ready(function() {
  
	getParticipantModel();
	
});


function checkNamesAndDoJoin(){
	
	var name = $("#localName").val();
	if($.trim(name) == ''){
		swal("請先輸入你的暱稱或姓名", " ","error");
	}else if(!!!isNaN($.trim(name))){
		swal("請不要偷懶 不接受都是數字的數字人喔", " ","error");
	}else{
		$.ajax({
	        type: "GET",
	        async: false,
	        url: baseUrl+"join-a-participant?localName="+$.trim(name),
	        success: function(data){
	          if(!!data){
	             if(!!data.participantModel){
	            	 participantModel = data.participantModel;
	            	 toAnswerMode();
	             }
	          }
	     }});
	}
	
}

function getParticipantModel(){
	
	$.ajax({
        type: "GET",
        async: false,
        url: baseUrl+"get-my-participantmodel",
        success: function(data){
          if(!!data){
             if(!!data.participantModel){
            	 participantModel = data.participantModel;
            	 toAnswerMode();
            	 loadQuestion(null);
             }
          }
     }});
	
}

function toAnswerMode(){//進入答題卡
	$("#loginDiv").hide();
	$("#answerDiv").show();
	$("#cardId").text(participantModel.id);
	$("#localNameP").text(participantModel.localName);
}

function getQuestions(){
	
	$.ajax({
        type: "GET",
        async: false,
        url: baseUrl+"get-questions",
        success: function(data){
          if(!!data || !!data.participantModel){
        	  if("Y" != data.participantModel.isStart){
        		  swal("還沒開始喔 請不要想偷跑~~"," ","warning")
        	  }else if( data.participantModel.currentQuestion.id == participantModel.currentQuestion.id){
        		  swal("這題還沒結束喔  等待主持人宣布下一題開始吧"," ","warning")
        	  } else{
        		  participantModel = data.participantModel;
        		  loadQuestion();
        		  $("#next").text("下一題");
        	  }
          }else{
        	  swal("連線失敗了 要不要檢查一下網路?"," ","error");
          }
     	},
     	error: function(){
			swal("連線失敗了 要不要檢查一下網路?"," ","error");
		}
	
	});
}

/**
 	CLICK_END_LESS,//不停的按
	CLICK_TO_CLEAR_NUM,//按到一個次數 50次
	SUNNDELY_SHOW_SYNC,//突然出現的BUTTEN 同時
	SUNNDELY_SHOW_UN_SYNC,//突然出現的BUTTEN 不同時
	MATH_CALCULETE,//計算題
	JUST_FASTST,//最快答題者
	RANDOM_PICK,//隨機挑選
 */
function loadQuestion(inputQuestion){
	
	var currentQuestion = !!inputQuestion?inputQuestion: !!participantModel?participantModel.currentQuestion:null;
	
	if(!!currentQuestion){
		if(currentQuestion.answerRaceType == "JUST_FASTST"){
			load_JUST_FASTST(currentQuestion);
			$("#next").text("下一題");
		}
	}
}

var idNumArray = ["","A","B","C","D","E","F","G"];

function load_JUST_FASTST(question){
	
	$("#playTytle").text("越快送出正確答案 得獎機會越大喔~~~");
	
	var html = "";
	for(var i = 1 ; i < question.options.length; i++){
		var option = question.options[i];
		html += "<button id=\"q_"+i+"\" type=\"button\" onclick=\"choiceQ("+i+")\" class=\"btn btn-warning\" >"+idNumArray[i]+":"+option+"</button><br/><br/>";
	}
	$("#answerBody").html(html);
	if(participantModel.currentQuestion.choiceIndex != 0){
		choiceQ(participantModel.currentQuestion.choiceIndex,"AUTO");
	}
	
}

function choiceQ(index,ctype){
	
	if("AUTO" != ctype){
		
		swal({
			title: "確定選擇的答案是:"+idNumArray[index]+" 嗎?", 
			  text: participantModel.currentQuestion.options[index], 
			  icon: "warning",
			  buttons: true,
			  dangerMode: true,
			})
			.then((willDelete) => {
			  if (willDelete) {
				 		  
				  $("button[id^='q_']" ).each(function(){
						var obj = $(this);
						console.log(obj);
						obj.prop('disabled', true);
						obj.prop("class","btn");
					});	  
				  
				  $("#q_"+index).prop("class","btn-danger");
				  $("#q_"+participantModel.currentQuestion.answerIndex).prop("class","btn-success");	  
				  participantModel.currentQuestion.choiceIndex = index;
				  
				  var syncArray = ["currentQuestion"];
				  syncParticipantModel(syncArray);
				  
				   if(index == participantModel.currentQuestion.answerIndex){
						  swal("正確答案 恭喜");
						  participantModel.isCorrect = "Y";
						  participantModel.canSubmit = "Y";
						  submitAnswer();
					}else{
						  swal("答錯了  Q_Q");
						  submitAnswer();
					 }

				 
			  } else {
				  

			  }
			});
		
	}else{
		
		$("button[id^='q_']" ).each(function(){
			var obj = $(this);
			console.log(obj);
			obj.prop('disabled', true);
			obj.prop("class","btn");
		});
	  $("#q_"+index).prop("class","btn-danger");
	  $("#q_"+participantModel.currentQuestion.answerIndex).prop("class","btn-success");	  
	  participantModel.currentQuestion.choiceIndex = index;
	  
	}
	
	
}

function syncParticipantModel (syncArray){//同步  ParticipantModel
	
	var jsdata = {
			currentQuestion:null
	};
	if(!!syncArray){
		if(syncArray.includes("currentQuestion")) {//
			jsdata.currentQuestion = participantModel.currentQuestion;
		}
		if(syncArray.includes("isCorrect")){
			jsdata.isCorrect = participantModel.isCorrect;
		}
	}

	$.ajax({
        type: "POST",
        dataType: 'json',
        data:JSON.stringify(jsdata),
        contentType: "application/json",
        url: baseUrl+"get-sync-participant-obj",
        success: function(data){
          if(!!data){
             if(!!data.participantModel){
            	 if(participantModel.currentQuestion.id != data.participantModel.currentQuestion.id){
            		 loadQuestion();
            	 }
             }
             participantModel = data.participantModel;
          }
     }});

}

function submitAnswer(){

		$.ajax({
	        type: "POST",
	        dataType: 'json',
	        data:JSON.stringify(participantModel),
	        contentType: "application/json",
	        url: baseUrl+"do-submit-answer",
	        success: function(data){
	          if(!!data){
	             if(!!data.participantModel){
		             participantModel = data.participantModel;
		             checkIsMe();
	             }
	          }
	     }});	
}

function checkIsMe(){
	
	if(participantModel.id == participantModel.currentQuestion.pricaeParticipantModel.id){
		swal("恭喜您得獎了~~等待主持人的呼喚吧~~~");
	}else{
		swal("可惜您沒被選上 沒關係 下一題再贏回來吧!!");
	}

}

function counterPlus(){
	counter++;
	$("#counterSpan").text(counter);
}


</script> 