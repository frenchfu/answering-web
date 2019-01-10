package com.mkyong.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.mkyong.model.BingoUnit;

@Controller
@RequestMapping("/bingo")
public class BingoController {
	
	//sessionid //id
	Map<Integer, Map<Integer,BingoUnit>> bingoMap = new HashMap<Integer, Map<Integer,BingoUnit>>();
	Map<Integer ,Boolean> canClickMap = new HashMap();
	Map<String ,Integer> cardNoMap = new HashMap();
	Map<Integer ,Boolean> goleMap = new HashMap();
	Map<Integer,BingoUnit>  adminCard = getInitAdminCard();
	Map<Integer,String>  localNameMap = new HashMap();
	
	
	private Integer[] a = new Integer[]{1,2,3,4,5};
	private Integer[] b = new Integer[]{6,7,8,9,10};
	private Integer[] c = new Integer[]{11,12,13,14,15};
	private Integer[] d = new Integer[]{16,17,18,19,20};
	private Integer[] e = new Integer[]{21,22,23,24,25};
	private Integer[] f = new Integer[]{1,6,11,16,21};
	private Integer[] g = new Integer[]{2,7,12,17,22};
	private Integer[] h = new Integer[]{3,8,13,18,23};
	private Integer[] i = new Integer[]{4,9,14,19,24};
	private Integer[] j = new Integer[]{5,10,15,20,25};
	private Integer[] k = new Integer[]{1,7,13,19,25};
	private Integer[] l = new Integer[]{5,9,13,17,21};
	private List<Integer[]> lineList = Lists.newArrayList(a,b,c,d,e,f,g,h,i,j,k,l);
	
	private Integer maxGoalNum = 5;
	private Integer goleLineNo = 3;
	
	
	// inject via application.properties
	@Value("${welcome.message:test}")
	private String message = "Hello World";
		
	
    @GetMapping("/greating")
    public String greeting(@RequestParam(name="name", required=false, defaultValue="World") String name, Model model) {
        model.addAttribute("name", name);
        return "/bingo/greating";
    }
    
    @GetMapping("/bingo")
    public String bingo(@RequestParam(name="identity", required=false, defaultValue="user") String identity, Model model) {
        model.addAttribute("identity", identity);
        return "/bingo/bingo";
    }
    
    @GetMapping("/bingoadmin")
    public String bingoadmin(@RequestParam(name="identity", required=false, defaultValue="user") String identity, Model model) {
        model.addAttribute("identity", identity);
        return "/bingo/bingoadmin";
    }
    
    @GetMapping("/getANewCard")
    @ResponseBody
    public  Map<String,Object> getANewCard(@RequestParam(name="source", required=false, defaultValue="user") String source,@RequestParam(name="localName", required=false) String localName ,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();;
    	model.addAttribute("source", source);
        System.out.println("session!!!"+session.getId());
        if(cardNoMap.get(session.getId()) == null) {
        	cardNoMap.put(session.getId(), initCardNoMap(session.getId()));
        	bingoMap.put(cardNoMap.get(session.getId()), initCard());
        }
        if(localName != null) {
            setLocalName(session,localName);
        }
        resultMap.put("goleLineNo", goleLineNo);
        resultMap.put("newCard", bingoMap.get(cardNoMap.get(session.getId())));
        resultMap.put("cardId", cardNoMap.get(session.getId()));
		return resultMap;
    }
    
    @GetMapping("/doCheckClick")
    @ResponseBody
    public  Map<String,Object> doCheckClick(@RequestParam(name="no", required=false) Integer no,@RequestParam(name="id", required=false) Integer id,@RequestParam(name="localName", required=false) String localName ,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();;
    	Integer cardId = cardNoMap.get(session.getId());
    	Map<Integer, BingoUnit> card = bingoMap.get(cardId);
        resultMap.put("isClick", canClickMap.get(no) != null && canClickMap.get(no));   
        if(canClickMap.get(no) != null && canClickMap.get(no)) {
        	card.get(id).setClick(true);
        }
        if(localName != null) {
            setLocalName(session,localName);
         }
        resultMap.put("goleLineNo", goleLineNo);
        resultMap.put("newCard", card);
        resultMap.put("cardId", cardId);
		return resultMap;
    }
    
    @GetMapping("/regeistGoal")
    @ResponseBody
    public  Map<String,Object> regeistGoal(@RequestParam(name="cardId", required=false) Integer cardId,@RequestParam(name="localName", required=false) String localName ,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();
    	boolean isGoal = false;
    	isGoal = checkIsGoal(cardId);
        resultMap.put("isGoal", isGoal);   
        if(localName != null) {
         setLocalName(session,localName);
        }
		return resultMap;
    }

	private void setLocalName(HttpSession session, String localName) {
		Integer cardId = cardNoMap.get(session.getId());
		localNameMap.put(cardId, localName);
	}

	private synchronized Integer initCardNoMap(String sessionId) {
		
		Random random = new Random();
		int index = random.nextInt(999);
		while(cardNoMap.containsValue(index)) {
			index = random.nextInt(999);
		}
		cardNoMap.put(sessionId, index);	
		return index;
	}
	
    
	private synchronized boolean checkIsGoal(Integer cardId) {	
		if(goleMap.get(cardId) != null) {
			return goleMap.get(cardId);
		} else {
			if(checkCanBingo(bingoMap.get(cardId))) {
				if(goleMap.values().size() < maxGoalNum) {
					goleMap.put(cardId, true);
					return goleMap.get(cardId);
				}else {
					return false;
				}
			}else {
				return false;
			}
		}	
	}

	private boolean checkCanBingo(Map<Integer, BingoUnit> map) {
		int counter = 0;
		for(Integer[] lineItem :  lineList) {
			if(checkUnit(lineItem,map)) {
				counter++;
			}
		}
		if(counter >= goleLineNo) {
			return true;
		}
		return false;
	}

	private boolean checkUnit(Integer[] lineItem, Map<Integer, BingoUnit> map) {
		boolean result = false;
    	for(int i = 0 ; i < 5 ; i++){
    		result = map.get(lineItem[i]).isClick() && canClickMap.get(map.get(lineItem[i]).getNo()) != null && canClickMap.get(map.get(lineItem[i]).getNo());
    		if(!result){
    			break;
    		}
    	}
    	return result;
	}

	private Map<Integer, BingoUnit> initCard() {	
		Map<Integer, BingoUnit> result = new HashMap<>();
		
		int intarray[] = new int[]{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25};
		
		for(int i = 0 ; i < 25 ; i++) {//洗牌法
			Random random = new Random();
			int index = random.nextInt(25);
			 //交換 i 跟index的原素
			 int tmp = intarray[index];
			 intarray[index] = intarray[i];
			 intarray[i] = tmp;
		}
		
		for(int i = 1 ; i < 26 ; i++) {
			BingoUnit unit = new BingoUnit();
			unit.setId(i);
			unit.setNo(intarray[i-1]);
			unit.setCanClick(canClickMap.get(unit.getNo()) != null && canClickMap.get(unit.getNo()) );
			unit.setClick(false);
			result.put(i, unit);
		}
		
		return result;
	}
	
    @GetMapping("/getAdminMap")
    @ResponseBody
    public  Map<String,Object> getAdminMap(@RequestParam(name="source", required=false, defaultValue="user") String source,HttpSession session, Model model) {	
    	Map<String, Object> resultMap = new HashMap();
        resultMap.put("adminCard", adminCard);
        resultMap.put("maxGoalNum", maxGoalNum);
        resultMap.put("newgoleLineNo", goleLineNo);
		return resultMap;
    }
    
    @GetMapping("/checkGoalMap")
    @ResponseBody
    public  Map<String,Object> checkGoalMap(@RequestParam(name="source", required=false, defaultValue="user") String source,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();
    	String goldStr = "";
    	String point = "";
    	for (Integer cardId :goleMap.keySet()) {
    		goldStr += point + "[編號:"+cardId+"暱稱:"+(localNameMap.get(cardId) == null ?"":localNameMap.get(cardId))+"}";
    	}
        resultMap.put("goldStr", goldStr);       
		return resultMap;
    }
	
	@GetMapping("/setCanClick")
    @ResponseBody
    public  Map<String,Object> setCanClick(@RequestParam(name="no", required=false) Integer no,  @RequestParam(name="todo", required=false) Boolean todo,HttpSession session, Model model) {    	
    	Map<String, Object> resultMap = new HashMap();
    	BingoUnit td = adminCard.get(no);
    	td.setClick(todo);
    	td.setCanClick(todo);
    	resultMap.put("adminCard", adminCard);       
    	canClickMap.put(no, todo);
		return resultMap;
    }
	
    @GetMapping("/initAllGame")
    @ResponseBody
    public  Map<String,Object> initAllGame(@RequestParam(name="source", required=false, defaultValue="user") String source,HttpSession session, Model model) {
    	
    	Map<String, Object> resultMap = new HashMap();
    	adminCard =  getInitAdminCard();
    	bingoMap = new HashMap<Integer, Map<Integer,BingoUnit>>();
    	canClickMap = new HashMap();
    	cardNoMap = new HashMap();
    	goleMap = new HashMap();
    	localNameMap = new HashMap();
        resultMap.put("adminCard", adminCard);       
		return resultMap;
    }

    @GetMapping("/setting")
    @ResponseBody
    public  Map<String,Object> setting(@RequestParam(name="newmaxGoalNum", required=false) Integer newmaxGoalNum,@RequestParam(name="newgoleLineNo", required=false) Integer newgoleLineNo,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();
    	this.maxGoalNum = newmaxGoalNum == null ? maxGoalNum:newmaxGoalNum;
    	this.goleLineNo = newgoleLineNo == null ? goleLineNo:newgoleLineNo;
    	System.out.println("maxGoalNum"+maxGoalNum);
    	System.out.println("goleLineNo"+goleLineNo);
		return resultMap;
    }

	private Map<Integer, BingoUnit> getInitAdminCard() {
		Map<Integer, BingoUnit> result = new HashMap<>();
		for(int i = 1 ; i < 26 ; i++) {
			BingoUnit unit = new BingoUnit();
			unit.setId(i);
			unit.setNo(i);
			unit.setCanClick(false);
			unit.setClick(false);
			result.put(i, unit);
		}
		return result;
	}
    
    

}
