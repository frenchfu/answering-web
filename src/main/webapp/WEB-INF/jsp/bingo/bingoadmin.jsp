<%@ page language="java" contentType="text/html; charset=BIG5" pageEncoding="BIG5"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
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
<script type="text/javascript"> 


	var a = [1,2,3,4,5];
	var b = [6,7,8,9,10];
	var c = [11,12,13,14,15];
	var d = [16,17,18,19,20];
	var e = [21,22,23,24,25];
	var f = [1,6,11,16,21];
	var g = [2,7,12,17,22];
	var h = [3,8,13,18,23];
	var i = [4,9,14,19,24];
	var j = [5,10,15,20,25];
	var k = [1,7,13,19,25];
	var l = [5,9,13,17,21];
	var lineArray = [a,b,c,d,e,f,g,h,i,j,k,l];
	var myCard = null;
	var cardId = null;
	var goleLineNo = 3;
	var isGole = false;
    var maxGoalNum = 5;
    var goleLineNo = 3;
	
	window.setInterval(getAdminMap,2000);
	
	
    
	function getAdminMap(){
		console.log(144);
		$.get("<c:url value='getAdminMap' />",
    		    {
    				source: "getAdminMap"
    		    },
    		    function(data, status){
    		    	myCard = data.adminCard;
     		       	
     		       	goleLineNo = data.goleLineNo;
     		        scanMap(myCard);
     		        if(maxGoalNum != data.maxGoalNum){
     		        	maxGoalNum = data.maxGoalNum;
     		        	$("#maxGoalNum").val(maxGoalNum);
     		        }
     		        if(goleLineNo != data.goleLineNo){
     		        	goleLineNo = data.goleLineNo;
     		        	$("#goleLineNo").val(goleLineNo);
     		        }
     		        
    		     });	
	}
	
	function checkGoalMap(){
		$.get("<c:url value='checkGoalMap' />",
    		    {
    				source: "checkGoalMap"
    		    },
    		    function(data, status){
    		        if(!!data && !!data.goldStr){
    		        	var str = "";
    		        	alert("中獎名單:"+data.goldStr);
    		        	$("#h1").text("中獎名單:"+goldStr);    		        	
    		        }
    		     });
	}
    
    function scanMap(map){
    	for (var i = 1; i < 26 ; i++){
    		$("#bin"+i).text(map[i].no);
    		if(!!map[i].click){
    			$("#bin"+i).css("background-color", "red");
    		}else{
    			$("#bin"+i).css("background-color", "white");
    		} 		
    	}	
    }
    
    
    function setCanClick(obj){
    	var no = $("#"+obj.id).text();
    	$.get("<c:url value='setCanClick' />",
    		    {
    				no: no,
    				todo: !!!myCard[no].click
    				
    		    },
    		    function(data, status){		    	
    		        myCard = data.adminCard;
    		        scanMap(myCard);
    		     });
    }
    
    function initAllGame(){
    	
    	var sure = confirm("確定要開始一場新遊戲嗎 全部都會重來喔");
    	if(sure){
    		var sureAgain = confirm("真的要確定要開始一場新遊戲嗎 真的全部都會重來喔");
    		if(sureAgain){
    			$.get("<c:url value='initAllGame' />",
    	    		    {
    	    				source: "initAllGame"
    	    		    },
    	    		    function(data, status){ 		        
    	    		    	myCard = data.adminCard;
    	     		        scanMap(myCard);
    	     		       alert("重置完畢");
    	    		     }); 			
    		}
    	}

    }
    

    
    function setMaxGoalNum() {
    	var newMaxGoalNumvar = $("#maxGoalNum").val();
    	if(isNaN(newMaxGoalNumvar)){
    		$("#maxGoalNum").val(maxGoalNum);
    	}else{
	    	maxGoalNum = newMaxGoalNumvar;
	    	setting();
    	}
    }
    
    var maxGoalNum = 5;
    var goleLineNo = 3;
    
    function setGoleLineNo(){
    	var newGoleLineNo = $("#goleLineNo").val();
    	if(isNaN(newGoleLineNo)){
    		$("#goleLineNo").val(goleLineNo);
    	}else{
	    	goleLineNo = newGoleLineNo;
	    	setting();
    	}
    }
    	
    function setting(){
    	$.get("<c:url value='setting' />",
    		    {
    				newmaxGoalNum: maxGoalNum,
    				newgoleLineNo: goleLineNo
    		    },
    		    function(data, status){
					//
    		     });	
    }
    

    
    
</script> 
<body>
<center> 
<p  id="initP" "><a href="javascript: void(0)" id="reload"  onclick="initAllGame();">起始一場遊戲</a></p> 
<h1 id ="h1">幸福賓果卡 管理者介面</h1>
<h1 id ="h2">中獎名單</h1> 
<table> 
    <tr> 
        <th>B</th> 
        <th>I</th> 
        <th>N</th> 
        <th>G</th> 
        <th>O</th> 
    </tr>     
    <tr> 
        <td id="bin1" onClick="setCanClick(this);">1</td> 
        <td id="bin2" onClick="setCanClick(this);">2</td> 
        <td id="bin3" onClick="setCanClick(this);">3</td> 
        <td id="bin4" onClick="setCanClick(this);">4</td> 
        <td id="bin5" onClick="setCanClick(this);">5</td> 
    </tr> 
    <tr> 
        <td id="bin6" onClick="setCanClick(this);">6</td> 
        <td id="bin7" onClick="setCanClick(this);">7</td> 
        <td id="bin8" onClick="setCanClick(this);">8</td> 
        <td id="bin9" onClick="setCanClick(this);">9</td> 
        <td id="bin10" onClick="setCanClick(this);">10</td> 
    </tr> 
    <tr> 
        <td id="bin11" onClick="setCanClick(this);">11</td> 
        <td id="bin12" onClick="setCanClick(this);">12</td> 
        <td id="bin13" onClick="setCanClick(this);">13</td> 
        <td id="bin14" onClick="setCanClick(this);">14</td> 
        <td id="bin15" onClick="setCanClick(this);">15</td> 
    </tr> 
    <tr> 
        <td id="bin16" onClick="setCanClick(this);">16</td> 
        <td id="bin17" onClick="setCanClick(this);">17</td> 
        <td id="bin18" onClick="setCanClick(this);">18</td> 
        <td id="bin19" onClick="setCanClick(this);">19</td> 
        <td id="bin20" onClick="setCanClick(this);">20</td> 
    </tr> 
    <tr> 
        <td id="bin21" onClick="setCanClick(this);">21</td> 
        <td id="bin22" onClick="setCanClick(this);">22</td> 
        <td id="bin23" onClick="setCanClick(this);">23</td> 
        <td id="bin24" onClick="setCanClick(this);">24</td> 
        <td id="bin25" onClick="setCanClick(this);">25</td> 
    </tr>     
</table>
<p  id="initP"><a href="javascript: void(0)" id="reload"  onclick="checkGoalMap();">檢查中獎命單</a></p>
設定中獎人數<input type="text" id="maxGoalNum"   value="5" />
設定中獎連線數<input type="text"  id="goleLineNo" value="3" /><input type="button" onclick="setMaxGoalNum();setGoleLineNo();"  value="提交設定"/>
</center>
</body>
</html>