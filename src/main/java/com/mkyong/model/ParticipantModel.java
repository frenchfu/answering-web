package com.mkyong.model;

import java.util.List;

import com.google.common.collect.Lists;
import com.mkyong.common.enums.YesNo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

//參與者
@Getter
@Setter
@ToString
public class ParticipantModel {

	private Integer id;
	private String sessionId;
	private String localName;
	private int correctNum = 0; //答對數
	private List<AnswerUnit> answerUnits = Lists.newArrayList();
	private List<QuestionUnit> questionUnits = Lists.newArrayList();
	private YesNo isStart;
	private QuestionUnit currentQuestion = new QuestionUnit();
	private int showTime = 0;
	private String currentQid;//現在問題的ID
	private int step = 0;
	private YesNo canSubmit = YesNo.N;
	private YesNo isCorrect = YesNo.N;
	private YesNo hasGetPirce = YesNo.N;
	
	public void stepPlus() {
		step++;
	}
	
}
