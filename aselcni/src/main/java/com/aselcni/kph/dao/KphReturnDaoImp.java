package com.aselcni.kph.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.aselcni.kph.model.KphOutItem;
import com.aselcni.kph.model.KphOutItemItem;
import com.aselcni.kph.model.KphReturn;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class KphReturnDaoImp implements KphReturnDao {

	private final SqlSession session;
	private final PlatformTransactionManager transactionManager;
	
	@Override
	public List<KphOutItem> outItemList(KphOutItem kphOutItem) {
		return session.selectList("KphOutItemList", kphOutItem);
	}
	
	@Override
	public List<KphOutItemItem> outItemItemList(KphOutItem outItem) {
		return session.selectList("KphOutItemItemList", outItem);
	}
	
	@Override
	public void returnAdd(KphReturn kphReturn) {
		session.insert("KphReturnAdd", kphReturn);
	}
	
	@Override
	public int totalReturnCount(KphReturn kphReturn) {
		return session.selectOne("KphTotalReturnCount", kphReturn);
	}

}