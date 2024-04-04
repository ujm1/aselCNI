package com.aselcni.kdw.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.aselcni.kdw.dao.KdwProdPlanDao;
import com.aselcni.kdw.model.KDW_TB_ORDER;
import com.aselcni.kdw.model.KDW_TB_ORDER_ITEM;
import com.aselcni.kdw.model.TB_ITEM_PROD;
import com.aselcni.kdw.model.TB_PRODPLAN;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class KdwProdPlanServiceImpl implements KdwProdPlanService {
	
	private final KdwProdPlanDao kdwProdPlanDao;
	
	@Override
	// 생산계획 제품리스트
	public List<TB_PRODPLAN> getProdPlanList() {
		System.out.println("KdwProdPlanServiceImpl getProdPlanList Start...");
		List<TB_PRODPLAN> prodPlanList = kdwProdPlanDao.getProdPlanList();
		System.out.println("KdwProdPlanServiceImpl getProdPlanList prodPlanList.size(): " + prodPlanList.size());
		return prodPlanList;
	}
	// 생산계획 자재리스트
	@Override
	public List<TB_ITEM_PROD> getProdItemList() {
		System.out.println("KdwProdPlanServiceImpl getProdItemList Start...");
		List<TB_ITEM_PROD> prodPlanItemList = kdwProdPlanDao.getProdPlanItemList();
		System.out.println("KdwProdPlanServiceImpl getProdItemList prodPlanItemList.size(): " + prodPlanItemList.size());
		return prodPlanItemList;
	}
	// 주문번호 리스트
	@Override
	public List<KDW_TB_ORDER> getProdOrderList() {
		System.out.println("KdwProdPlanServiceImpl getProdOrderList Start...");
		List<KDW_TB_ORDER> prodPlanOrderList = kdwProdPlanDao.getprodPlanOrderList();
		System.out.println("KdwProdPlanServiceImpl getProdOrderList prodPlanOrderList.size(): " + prodPlanOrderList.size());
		return prodPlanOrderList;
	}
	// 주문번호 제품 리스트
	@Override
	public List<KDW_TB_ORDER_ITEM> getProdOrderItemList() {
		System.out.println("KdwProdPlanServiceImpl getProdOrderItemList Start...");
		List<KDW_TB_ORDER_ITEM> prodPlanOrderItemList = kdwProdPlanDao.getprodPlanOrderItemList();
		System.out.println("KdwProdPlanServiceImpl getProdOrderItemList prodPlanOrderItemList.size(): " + prodPlanOrderItemList.size());
		return prodPlanOrderItemList;
	}
}
