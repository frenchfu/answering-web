package com.mkyong.model;

import java.util.List;

import com.google.common.collect.Lists;
import com.mkyong.common.enums.AnswerRaceType;
import com.mkyong.common.enums.QuestionType;
import com.mkyong.common.enums.YesNo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

//問題單位
@Getter
@Setter
@ToString
public class QuestionUnit {

	private String id = "";
	private String questionText;//問題內容
	private Integer answerIndex;//
	private List<String> options = Lists.newArrayList("0");//選項
	private YesNo isAnswerCorrect;//正確嗎
	private QuestionType questionType;//問題問法
	private AnswerRaceType answerRaceType;//搶答方式
	private YesNo isDone = YesNo.N;
	private Integer choiceIndex = 0;
	private ParticipantModel pricaeParticipantModel= null;
	private int pushNum = 0;//按壓次數

}
