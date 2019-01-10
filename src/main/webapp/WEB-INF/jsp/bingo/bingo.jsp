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
	var isGole = false;
	var goleLineNo = 3;
     
    //重制一張賓果卡
    function getANewCard(){	
    	$.get("<c:url value='getANewCard' />",
    		    {
    				source: "getANewCard",
    				localName:$("#localName").val()
    		    },
    		    function(data, status){
    		        if(!!data && !!data.newCard ){
    		        	scanMap(data.newCard);
    		        }
    		        $("#h1").text("幸福賓果卡   卡號:"+data.cardId);
    		        $("#initP").hide();
    		        $("#checkCanBingoP").show();
    		        myCard = data.newCard;
    		        cardId = data.cardId;
    		        goleLineNo = data.goleLineNo;
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
    
    function doCheckClick(obj){
    	
    	var no = $("#"+obj.id).text();
    	var id = (obj.id+"").replace("bin","");
    	$.get("<c:url value='doCheckClick' />",
    		    {
    				no: no,
    				id: id,
    				localName:$("#localName").val()
    		    },
    		    function(data, status){
    		    	if(!!data.isClick){
    		    		$("#bin"+i).css("background-color", "red");
    		    	}else{
    		    		alert("這個號碼還沒開放喔~~~不要亂按~~");
    		    	}   	
    		        myCard = data.newCard;
    		        cardId = data.cardId;
    		        goleLineNo = data.goleLineNo;
    		        scanMap(myCard);
    		        $("#h1").text("幸福賓果卡   卡號:"+data.cardId);
    		     });
    	
    }
    
    function checkCanBingo(){
    	if(!!myCard){
        	var lineNo = 0;
        	for(var i = 0 ; i < 12 ; i++   ){
        		if(checkUnit(lineArray[i],myCard)){
        			lineNo++;
        		}
        	}    
        	if(lineNo >= goleLineNo) {
        		
            	$.get("<c:url value='regeistGoal' />",
            		    {
            				cardId: cardId,
            				localName:(!!$("#localName").val() ?$("#localName").val():"")
            		    },
            		    function(data, status){
            		        if(!!data && !!data.isGoal ){
            	        		alert("恭喜你率先完成賓果連線了!~~準備領獎吧");
            	        		isGole = true;
            		        }else{
            	        		alert("抱歉 別人比你先按下了賓果 名額已經被搶空了 Q_Q");
            		        }
            		     });	
        	}else{
        		alert("還沒完成規定的連線數目喔 給點耐心");
        	}
    	}
    }
    
    function checkUnit(line,card){
    	var result = false;
    	for(var i = 0 ; i < 5 ; i++){
    		result = !!card[line[i]].click;
    		if(!result){
    			break;
    		}
    	}
    	return result;
    }
    
    
    
</script> 
<body>
<center> 
<h1 id ="h1">幸福賓果卡</h1> 
您的大名或是暱稱<input id="localName" /> 
<table> 
    <tr> 
        <th>B</th> 
        <th>I</th> 
        <th>N</th> 
        <th>G</th> 
        <th>O</th> 
    </tr>     
    <tr> 
        <td id="bin1" style="background-color: red;"   onClick="doCheckClick(this);" >1</td> 
        <td id="bin2" onClick="doCheckClick(this);" >2</td> 
        <td id="bin3" onClick="doCheckClick(this);" >3</td> 
        <td id="bin4" onClick="doCheckClick(this);" >4</td> 
        <td id="bin5" onClick="doCheckClick(this);" >5</td> 
    </tr> 
    <tr> 
        <td id="bin6" onClick="doCheckClick(this);">6</td> 
        <td id="bin7" style="background-color: red;" onClick="doCheckClick(this);">7</td> 
        <td id="bin8" onClick="doCheckClick(this);">8</td> 
        <td id="bin9" onClick="doCheckClick(this);">9</td> 
        <td id="bin10" onClick="doCheckClick(this);">10</td> 
    </tr> 
    <tr> 
        <td id="bin11" onClick="doCheckClick(this);" >11</td> 
        <td id="bin12" onClick="doCheckClick(this);" >12</td> 
        <td id="bin13" onClick="doCheckClick(this);" style="background-color: red;">13</td> 
        <td id="bin14" onClick="doCheckClick(this);" >14</td> 
        <td id="bin15" onClick="doCheckClick(this);" >15</td> 
    </tr> 
    <tr> 
        <td id="bin16" onClick="doCheckClick(this);" >16</td> 
        <td id="bin17" onClick="doCheckClick(this);" >17</td> 
        <td id="bin18" onClick="doCheckClick(this);" >18</td> 
        <td id="bin19" onClick="doCheckClick(this);"  style="background-color: red;">19</td> 
        <td id="bin20" onClick="doCheckClick(this);" >20</td> 
    </tr> 
    <tr> 
        <td id="bin21" onClick="doCheckClick(this);" >21</td> 
        <td id="bin22" onClick="doCheckClick(this);" >22</td> 
        <td id="bin23" onClick="doCheckClick(this);" >23</td> 
        <td id="bin24" onClick="doCheckClick(this);" >24</td> 
        <td id="bin25" onClick="doCheckClick(this);"  style="background-color: red;">25</td> 
    </tr>     
</table>
<p  id="initP"><a href="javascript: void(0)" id="reload"  onclick="getANewCard();">取得一張賓果卡</a></p> 
<p  id="checkCanBingoP" ><a href="javascript: void(0)" id="checkCanBingo"  onclick="checkCanBingo();">賓果了!!</a></p> 
</center>
</body>
</html>