package com.aselcni.ujm.service;

import java.util.List;

import com.aselcni.ujm.model.UjmOrderInfoToInsertDto;
import com.aselcni.ujm.model.UjmOrderNoDto;
import com.aselcni.ujm.model.UjmOutitem;
import com.aselcni.ujm.model.UjmOutitemParent;

public interface UjmOutitemService {

	int ujmTotalOutitemCnt();

	List<UjmOutitem> ujmListOutitem(UjmOutitem outitem);

	int ujmInsertOutitem(UjmOutitemParent insertData, String userId);

	int ujmInsertOutitemItem(UjmOutitemParent insertData);

	String ujmSetOutitemNo(String outitem_no);

}
