package com.aselcni.ujm.model;

import lombok.Data;

@Data
public class UjmProc { //출고품목
	private String order_no; //주문번호, PK, fk
	private String item_no; //품목CD, PK, fk
	private String outitem_no; //출고번호, fk
	private int    qty; //수량
}
