package com.mkyong.model;


public class BingoUnit {
	
	private int id; //所在位置
	private int no; //號碼
	private boolean canClick;//admin 認證可點壓
	private boolean isClick;//被使用者點壓
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public boolean isCanClick() {
		return canClick;
	}
	public void setCanClick(boolean canClick) {
		this.canClick = canClick;
	}
	public boolean isClick() {
		return isClick;
	}
	public void setClick(boolean isClick) {
		this.isClick = isClick;
	}
	
}
