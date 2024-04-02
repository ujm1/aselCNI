package com.aselcni.psa.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.aselcni.psa.model.ProdPlan;
import com.aselcni.psa.model.WorkProd;
import com.aselcni.psa.service.PsaWorkProdService;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class PsaWorkProdController {

	private final PsaWorkProdService psaService;
	
	// 생산지시 메인 페이지
	@RequestMapping(value = "workprod")
//	@RequestMapping(value = "workprod/{prodplan_dt}")
	public String workprod(HttpServletRequest request, ProdPlan prodPlan, WorkProd workProd, Model model) {
//		public String workprod(@PathVariable String prodplan_dt, ProdPlan prodPlan, WorkProd workProd, Model model) {
		
		System.out.println("psa 생산지시 메인 페이지 시작!");

		// 생산지시일을 오늘날짜로 세팅
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String today = dateFormat.format(new Date());
		System.out.println("today Format: " + today);
		
		prodPlan.setProdplan_dt(today);
		workProd.setWorkprod_dt(today);
		
		
		
		// form tag에서 얻어온 생산시작일자를 ProdPlan과 WorkProd의 생산시작일자로 세팅
//		String prodplan_dt = request.getParameter("prodplan_dt");
//		System.out.println("prodplan_dt: " + prodplan_dt);
//		prodPlan.setProdplan_dt(prodplan_dt);
//		workProd.setWorkprod_dt(prodplan_dt);
		
		
		
		// 로그인 유저아이디(담당자) 억지로 세팅
//		String user_id = "psa";
//		prodPlan.setProdplan_emp_id(user_id);
		
		
		// 셀렉트도 프로시저로 해야하는데 파라미터 없는 프로시저도 가능함
		
		// 지시 대기중인 생산계획 리스트 조회
		// 파라미터로 생산일자? 오늘날짜로?
		List<ProdPlan> planList = psaService.getPlanList(prodPlan);
		System.out.println("ProdPlan List: " + planList);
		model.addAttribute("planList", planList);
		
		// 등록된 생산지시내역 리스트 조회
		// 파라미터로 뭘 넣어야함? 생산시작일자? 오늘날짜로?
		List<WorkProd> workList = psaService.getWorkList(workProd);
		model.addAttribute("workList", workList);
		
		// 등록된 지시내역의 생산지시번호별 상세내용
		WorkProd insertedWorkProd = new WorkProd();
		// 생산일자가 오늘 날짜인 목록들에 생산지시번호도 세팅해줌
		insertedWorkProd.setWorkprod_no(workProd.getWorkprod_no());
		WorkProd selectedWorkProd = psaService.selectWorkProd(insertedWorkProd);
		model.addAttribute("workProd", selectedWorkProd);
		
		
		// 생산지시 등록 모달 내용
		// 해당 생산계획번호에 맞는 정보 조회
//		ProdPlan prodPlan2 = new ProdPlan();
//		prodPlan2.setProdplan_no(prodPlan.getProdplan_no());
		
		
		return "psa/workprod";
		
	}
	
	// 생산지시 등록
	@RequestMapping(value = "workprodInsert")
	public void workprodInsert(@ModelAttribute WorkProd workProd) {
		
		// insert into TB_WORKPROD
//		psaService.workProdInsert(workProd);
		System.out.println("생산지시 등록 완료");
		
	}
	
	// 투입품 등록
//	@RequestMapping(value = "addItems")
	
	
}