package com.mkyong.model;

import java.util.List;

import com.google.common.collect.Lists;
import com.mkyong.common.enums.AnswerRaceType;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

//管理者
@Getter
@Setter
@ToString
public class AdminModel {

	private List<QuestionUnit> questionList = Lists.newArrayList();
	private QuestionUnit currentQuestion;
	private AnswerRaceType answerRaceType = AnswerRaceType.JUST_FASTST;
	private String answerRaceTypeText = "最快答題者";
	private int stepCount = 1;
	private String nowStatus = "WAIT_GO";//"WAIT_END"
	private int totalMamber = 0;
	private ParticipantModel randomParticipant;
	
	private int inaAnswerACounter = 0;
	private int inaAnswerBCounter = 0;
	private int inaAnswerCCounter = 0;
	private int inaAnswerDCounter = 0;
	private int inaAnswerECounter = 0;
	private int inaAnswerFCounter = 0;
	
	public void setpPlus() {
		stepCount++;
	}
	
	public void reSetAnswerCounter() {
		inaAnswerACounter = 0;
		inaAnswerBCounter = 0;
		inaAnswerCCounter = 0;
		inaAnswerDCounter = 0;
		inaAnswerECounter = 0;
		inaAnswerFCounter = 0;
	}

}
