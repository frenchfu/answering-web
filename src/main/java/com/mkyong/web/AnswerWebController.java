package com.mkyong.web;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.mkyong.QuestionService;
import com.mkyong.common.enums.AnswerRaceType;
import com.mkyong.common.enums.YesNo;
import com.mkyong.model.AdminModel;
import com.mkyong.model.ParticipantModel;
import com.mkyong.model.QuestionUnit;

@Controller
@RequestMapping("/answer-web")
public class AnswerWebController {
	
	
	Map<String,ParticipantModel> participantModelMap = Maps.newHashMap();
	Map<String,Integer> pidMap = Maps.newHashMap();
	Map<Integer,String> localNameMap = Maps.newHashMap();
	int publicShowTime = 0;
	AdminModel adminModel = new AdminModel();
	QuestionUnit questionUnitGoing = new QuestionUnit();
	String nowStatus = "WAIT_GO";//WAIT_END
	
	List<QuestionUnit> questionUnitList = Lists.newArrayList();
	
    @PostConstruct
    public void initQuestions() throws IOException {
       
		String tempExcelName ="excel/題目表.xls";
		String filePath = "classpath:/"+tempExcelName;
	    InputStream sampleFile = new DefaultResourceLoader().getResource(filePath).getInputStream();
	    questionUnitList = new QuestionService().scanQuectionExcelObject(sampleFile);
    	
    }
	
    @PostMapping("get-sync-participant-obj")
    @ResponseBody
    public Map<String,Object> getAndSyncParticipantObj(@RequestBody ParticipantModel requestParticipantModel,HttpSession session) {
    	Map<String, Object> resultMap = new HashMap();
        ParticipantModel participantModel = null;
        if(participantModelMap.get(session.getId()) != null) {
        	participantModel = participantModelMap.get(session.getId());
        	if(requestParticipantModel.getCurrentQuestion() != null) {
        		participantModel.setCurrentQuestion(requestParticipantModel.getCurrentQuestion());
        	}  	
        	resultMap.put("participantModel", participantModel);
        }
        return resultMap;
    }
    
	
	@PostMapping("do-submit-answer")
	@ResponseBody
    public Map<String,Object> doSubmitAnswer(@RequestBody ParticipantModel requestParticipantModel,HttpSession session) throws InterruptedException {
		Map<String, Object> resultMap = new HashMap();
		ParticipantModel participantModel = participantModelMap.get(session.getId());
		if(requestParticipantModel.getIsCorrect() == YesNo.Y) {
			participantModel.setCorrectNum(participantModel.getCorrectNum() + 1);
			doChoiceWhoCanGetPriceLogic(participantModel,requestParticipantModel);
		}
		if(requestParticipantModel.getCurrentQuestion().getChoiceIndex() >0){
			switch (requestParticipantModel.getCurrentQuestion().getChoiceIndex()) {
			case 1:	
				adminModel.setInaAnswerACounter(adminModel.getInaAnswerACounter() + 1);
				break;
			case 2:	
				adminModel.setInaAnswerBCounter(adminModel.getInaAnswerBCounter() + 1);
				break;
			case 3:	
				adminModel.setInaAnswerCCounter(adminModel.getInaAnswerACounter() + 1);
				break;
			case 4:	
				adminModel.setInaAnswerDCounter(adminModel.getInaAnswerACounter() + 1);
				break;
			default:
				break;
			}
		}
		
		resultMap.put("participantModel", participantModel);
		return resultMap;
	}

	@GetMapping("/answer-web-login")//http://localhost:8080/answer-web/answer-web-login  http://192.168.5.67:8080/answer-web/answer-web-login
    public String bingo(@RequestParam(name="identity", required=false, defaultValue="user") String identity, Model model) {
        model.addAttribute("identity", identity);
        return "/answer-web/user-page";
    }
	
	@GetMapping("/get-my-participantmodel")
	@ResponseBody
	public  Map<String,Object> getMyParticipantModel(@RequestParam(name="source", required=false, defaultValue="user") String source,@RequestParam(name="localName", required=false) String localName ,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();
        ParticipantModel participantModel = null;
        if(participantModelMap.get(session.getId()) != null) {
        	participantModel = participantModelMap.get(session.getId());
        	resultMap.put("participantModel", participantModel);
        }
        return resultMap;
    }
	
	@GetMapping("get-questions")
	@ResponseBody
	public  Map<String,Object> getQuestions(@RequestParam(name="source", required=false, defaultValue="user") String source,HttpSession session, Model model) throws IllegalAccessException, InvocationTargetException {
    	Map<String, Object> resultMap = new HashMap();
        ParticipantModel participantModel = null;
        
        if(participantModelMap.get(session.getId()) != null) {
        	participantModel = participantModelMap.get(session.getId());
        }
        
        if(nowStatus.equals("WAIT_END")  ) {
        	
        	if(!participantModel.getCurrentQuestion().getId().equals(questionUnitGoing.getId())) {
        		
            	participantModel.setIsStart(YesNo.Y);
            	QuestionUnit qunit = new QuestionUnit();
            	BeanUtils.copyProperties(qunit,questionUnitGoing);
            	participantModel.setCurrentQuestion(qunit);
            	if(questionUnitGoing.getAnswerRaceType() == AnswerRaceType.SUNNDELY_SHOW_UN_SYNC) {
            		participantModel.setShowTime((int)(Math.random()*20+1));
            		if(participantModel.getShowTime() <5) {
            			participantModel.setShowTime((int)(Math.random()*1000000+1));
            		}
            	}else if(questionUnitGoing.getAnswerRaceType() == AnswerRaceType.SUNNDELY_SHOW_SYNC) {
            		participantModel.setShowTime(publicShowTime);
            	}
        		
        		
        	}
        	
        }else {
        	
        	participantModel.setIsStart(YesNo.N);
        
        }
        resultMap.put("participantModel", participantModel);
        return resultMap;
    }
	
	@GetMapping("/join-a-participant")
    @ResponseBody
    public  Map<String,Object> joinAparticipant(@RequestParam(name="source", required=false, defaultValue="user") String source,@RequestParam(name="localName", required=false) String localName ,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();
    	model.addAttribute("source", source);
        ParticipantModel participantModel = null;
        if(participantModelMap.get(session.getId()) == null) {
        	participantModelMap.put(session.getId(), getInitParticipantModel(session.getId()));
        	participantModel = participantModelMap.get(session.getId());
        }
        if(localName != null) {
            setLocalName(session,localName);
            participantModel.setLocalName(localName);
        }
        resultMap.put("participantModel", participantModel);
        return resultMap;
    }
	
	
	
	private void setLocalName(HttpSession session, String localName) {
		Integer pId = pidMap.get(session.getId());
		localNameMap.put(pId, localName);
	}
	
	
	
	private synchronized Integer initCardNoMap(String sessionId) {
		
		Random random = new Random();
		int index = random.nextInt(999);
		while(pidMap.containsValue(index)) {
			index = random.nextInt(999);
		}
		pidMap.put(sessionId, index);	
		return index;
		
	}
	
	private ParticipantModel getInitParticipantModel(String sessionId) {
		ParticipantModel result = new ParticipantModel();
		initCardNoMap(sessionId);
		result.setId(pidMap.get(sessionId));
		return  result;
	}
	
	
	@GetMapping("admin-login")
	public String adminLogin() {
		return "/answer-web/admin-page-control-question";
	}
	
	@GetMapping("/get-question-list")
	@ResponseBody
	public  Map<String,Object> getQuestionList(@RequestParam(name="source", required=false, defaultValue="user") String source,@RequestParam(name="localName", required=false) String localName ,HttpSession session, Model model) {
    	Map<String, Object> resultMap = new HashMap();
        resultMap.put("questionList", questionUnitList);
        return resultMap;
    }
	
	@GetMapping("admin-reset-all-game")
	@ResponseBody
    public  Map<String,Object> adminResetAllGame() throws IOException {
		Map<String, Object> resultMap = new HashMap();
		
		participantModelMap = Maps.newHashMap();
		pidMap = Maps.newHashMap();
		localNameMap = Maps.newHashMap();
		adminModel = new AdminModel();
		this.initQuestions();
		adminModel.setQuestionList(questionUnitList);
		resultMap.put("result", "DONE");
		resultMap.put("adminObj", adminModel);
		
		return resultMap;
	}
	
	@PostMapping("get-sync-admin-obj")
	@ResponseBody
    public synchronized Map<String,Object> getAndSyncAdminObj(@RequestBody AdminModel requestAdminModel) {
		
		Map<String, Object> resultMap = new HashMap();
		if(requestAdminModel.getCurrentQuestion() != null) {
			adminModel.setCurrentQuestion(requestAdminModel.getCurrentQuestion());
			adminModel.setStepCount(adminModel.getStepCount()+1);
		}
		if(requestAdminModel.getAnswerRaceType() != null) {
			adminModel.setAnswerRaceType(requestAdminModel.getAnswerRaceType());
			adminModel.setStepCount(adminModel.getStepCount()+1);
		}
		if(requestAdminModel.getAnswerRaceTypeText() != null) {
			adminModel.setAnswerRaceTypeText(requestAdminModel.getAnswerRaceTypeText());
			adminModel.setStepCount(adminModel.getStepCount()+1);
		}
		if(adminModel.getQuestionList().isEmpty()) {
			adminModel.setQuestionList(questionUnitList);
		}
		if(adminModel.getCurrentQuestion() == null) {
			adminModel.setCurrentQuestion(questionUnitList.get(1));
		}
		adminModel.setTotalMamber(participantModelMap.size());//參加人數

		
		resultMap.put("adminObj", adminModel);
		return resultMap;
	}
	
	@GetMapping("go-question-process")
	@ResponseBody
    public synchronized Map<String,Object> goQuestionProcess() throws IllegalAccessException, InvocationTargetException {
		Map<String, Object> resultMap = new HashMap();
		
		if(adminModel.getNowStatus().equals("WAIT_GO")) {
			
			if(adminModel.getCurrentQuestion().getIsDone() == YesNo.Y) {
				resultMap.put("message", "不能開始 因為這一題已經問過了 換一題吧");
			}else {
				
				questionUnitGoing = new QuestionUnit();
				BeanUtils.copyProperties(questionUnitGoing ,adminModel.getCurrentQuestion());
				questionUnitGoing.setAnswerRaceType(adminModel.getAnswerRaceType());
				
				if(questionUnitGoing.getAnswerRaceType() == AnswerRaceType.SUNNDELY_SHOW_SYNC) {
					publicShowTime = (int)(Math.random()*15+1);
				}
				
				adminModel.reSetAnswerCounter();
				adminModel.setNowStatus("WAIT_END");
				nowStatus = "WAIT_END";
				adminModel.setpPlus();
				
			}

		}else {
			resultMap.put("message", "不能開始 因為還沒結束這一RUN");
		}
		resultMap.put("adminObj", adminModel);
		
		return resultMap;
	}
	
	@GetMapping("stop-question-process")
	@ResponseBody
    public synchronized Map<String,Object> stopQuestionProcess() throws IllegalAccessException, InvocationTargetException {
		Map<String, Object> resultMap = new HashMap();
		
		if(adminModel.getNowStatus().equals("WAIT_END")) {
			
			questionUnitGoing.setIsDone(YesNo.Y);
			adminModel.getQuestionList().forEach(q->{
				q.getId();
				if(q.getId().equals(questionUnitGoing.getId())) {
					q.setIsDone(YesNo.Y);
				}
			});
			adminModel.setCurrentQuestion(questionUnitGoing);
			adminModel.setNowStatus("WAIT_GO");
			nowStatus = "WAIT_GO";
			adminModel.setpPlus();
			
		}else {
			resultMap.put("message", "不能結束  因為還沒開始這一RUN 或是還沒出現答對者");
		}
		resultMap.put("adminObj", adminModel);
		
		return resultMap;
	}

    private void doChoiceWhoCanGetPriceLogic(ParticipantModel participantModel,ParticipantModel requestParticipantModel) throws InterruptedException {
		
    	if(questionUnitGoing.getAnswerRaceType() == AnswerRaceType.JUST_FASTST) {
    		if(participantModel.getHasGetPirce() == YesNo.Y) {//得過獎的人 WAIT 2.5秒
    			Thread.currentThread().sleep(10000);
    		}
    		doGetFirstPrice(participantModel);
    	}	
    	
    	
    	if(questionUnitGoing.getPricaeParticipantModel().getId() == participantModel.getId()) {//設定得過獎了
    		participantModel.setHasGetPirce(YesNo.Y);
    	}
    	participantModel.getCurrentQuestion().setPricaeParticipantModel(questionUnitGoing.getPricaeParticipantModel());//將獲獎人資料回傳給餐與者
		
	}

	private synchronized void doGetFirstPrice(ParticipantModel participantModel) {//最快點壓答案的人
		
		if(questionUnitGoing.getPricaeParticipantModel() == null) {
			questionUnitGoing.setPricaeParticipantModel(new ParticipantModel());
			questionUnitGoing.getPricaeParticipantModel().setLocalName(participantModel.getLocalName());
			questionUnitGoing.getPricaeParticipantModel().setId(participantModel.getId());
			adminModel.getCurrentQuestion().setPricaeParticipantModel(questionUnitGoing.getPricaeParticipantModel());
			adminModel.setpPlus();
		}
		
	}
	
	
	@GetMapping("pick-a-random-p")
	@ResponseBody
    public synchronized Map<String,Object> pickARandomP() throws IllegalAccessException, InvocationTargetException {
		Map<String, Object> resultMap = new HashMap();
		
		List<ParticipantModel> lists = Lists.newArrayList(participantModelMap.values());
		if(lists.isEmpty()) {
			resultMap.put("message", "還沒有參加者");
		}else {			
			int index = (int)(Math.random()*lists.size()+1 -1);//1~comptypeList SIZE
			ParticipantModel randomP = lists.get(index);
			adminModel.setRandomParticipant(randomP);
			adminModel.setpPlus();
		}
		resultMap.put("adminObj", adminModel);
		return resultMap;
		
	}
	
	

}
