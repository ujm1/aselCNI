package com.aselcni.ujm.model;

import lombok.Data;

@Data
public class UjmOrder { //주문
	private String order_no; //주문번호, PK
	private String order_dt; //주문일자
	private String cust_cd; //거래처CD(고객사), fk
	private String cust_emp; //담당자명(거래처)
	private String remark; //비고
	private String order_emp_id; //주문담당자ID
	private String order_update; //주문수정일
	private int    order_delete_chk; //주문삭제여부
	private int    outitem_end_chk; //출고완료여부
}
