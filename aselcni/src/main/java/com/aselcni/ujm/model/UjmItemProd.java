package com.aselcni.ujm.model;

import lombok.Data;

@Data
public class UjmItemProd { //생산계획투입품
	private String prodplan_no; //생산계획번호, PK, fk
	private String item_cd; //품목CD, fk
	private int    in_qty; //투입수량
}