<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<title>스마트 제조 시스템</title>

<!-- Favicons -->
<link href="assets/img/favicon.png" rel="icon">

<!-- Google Fonts -->
<link href="https://fonts.gstatic.com" rel="preconnect">
<link
	href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
	rel="stylesheet"
>

<!-- Vendor CSS Files -->
<link href="assets/vendor/bootstrap/css/bootstrap.min.css"
	rel="stylesheet"
>
<link href="assets/vendor/bootstrap-icons/bootstrap-icons.css"
	rel="stylesheet"
>
<link href="assets/vendor/boxicons/css/boxicons.min.css"
	rel="stylesheet"
>
<link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
<link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
<link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

<!-- CSS File -->
<link href="assets/css/style.css" rel="stylesheet" type="text/css">
<link href="assets/css/jtu/jtuProdItemRegistry.css" rel="stylesheet"
	type="text/css"
>

<!-- Script -->
<script defer src="assets/js/main.js"></script>
<script src="https://kit.fontawesome.com/0b22ed6a9d.js"
	crossorigin="anonymous"
></script>
<script src="assets/js/jquery-3.7.1.min.js"></script>

<script type="text/javascript">
	//modal 예상수량-실제수량=불량수량
	$(document).ready(
			function() {
				// RegiModal에 대한 설정
				setupModalQty("#expectedQtyRegiModal", "#actualQtyRegiModal",
						"#defectiveQtyRegiModal");

				// EditModal에 대한 설정
				setupModalQty("#expectedQtyEditModal", "#actualQtyEditModal",
						"#defectiveQtyEditModal");
			});

	function setupModalQty(expectedQtySelector, actualQtySelector,
			defectiveQtySelector) {
		// expectedQty, actualQty 값이 변경될 때마다 defectiveQty를 업데이트
		$(expectedQtySelector + ", " + actualQtySelector)
				.on(
						"input",
						function() {
							let expectedQty = parseInt($(expectedQtySelector)
									.val()) || 0;
							let actualQty = parseInt($(actualQtySelector).val()) || 0;
							let defectiveQty = expectedQty - actualQty;
							$(defectiveQtySelector).val(defectiveQty);
						});

		// defectiveQty 값이 변경될 때마다 actualQty를 업데이트
		$(defectiveQtySelector).on("input", function() {
			let expectedQty = parseInt($(expectedQtySelector).val()) || 0;
			let defectiveQty = parseInt($(this).val()) || 0;
			let actualQty = expectedQty - defectiveQty;
			$(actualQtySelector).val(actualQty);
		});
	}

	//닫기 버튼 클릭시 modal 입력 내용 클리어
	$(document).ready(function() {
		$('button[data-bs-dismiss="modal"]').on('click', function() {
			modalContentClear();
		});
	});
	//닫기 버튼 클릭시 modal 입력 내용 클리어
	function modalContentClear() {
		$('#workProdNoRegiModal').text("생산 지시 번호를 선택");
		$(".modal-content input").val('');
		$(".modal-content textarea").val('');
	}

	//dropdown 기능 
	$(document).ready(function() {
		$('#workProdNoEditModal').dropdown();
		$('#workProdNoRegiModal').dropdown();

		$(document).ready(function() {
			$('.dropdown-menu a').on('click', function() {
				var selectedValue = $(this).attr('data-value');
				$('#workProdNoRegiModal').text(selectedValue);
			});
		});

		//조회 테이블 행 클릭시 modal 수정창으로 이동 
		$('tr[data-bs-toggle="modal"]').on('click', function() {
			let prodNo = $(this).find('td:nth-child(2)').text();
			$('#workProdNoEditModal').val(prodNo);
		});
	});

	//시작 날짜와 종료 날짜 논리 일관성
	$(document).ready(function() {
		$('#startDate').on('input', function() {
			let startDate = $('#startDate').val();
			let endDate = $('#endDate').val();

			// 시작 날짜가 종료 날짜보다 뒤에 있는 경우
			if (startDate > endDate) {
				// 시작 날짜를 종료 날짜와 동일하게 설정합니다.
				$('#startDate').val(endDate);
			}

		});

		$('#endDate').on('input', function() {
			let startDate = $('#startDate').val();
			let endDate = $('#endDate').val();

			// 시작 날짜가 종료 날짜보다 뒤에 있는 경우
			if (startDate > endDate) {
				// 시작 날짜를 종료 날짜와 동일하게 설정
				$('#endDate').val(startDate);
			}
		});
	});

	// 좌우 버튼 누를 때마다 날짜 7일 단위로 바뀜
	$(document).ready(function() {
		$('#dateRightBtn').click(function() {
			dateShift('right');
		});

		$('#dateLeftBtn').click(function() {
			dateShift('left');
		});
	});

	// 날짜 조정 함수
	function dateShift(direction) {
		let startDateVal = $('#startDate').val();
		let endDateVal = $('#endDate').val();

		// Date 객체로 변환
		let startDate = new Date(startDateVal);
		let endDate = new Date(endDateVal);

		// 방향에 따라 날짜를 조정
		if (direction === 'right') {
			startDate.setDate(startDate.getDate() + 7);
			endDate.setDate(endDate.getDate() + 7);
		} else if (direction === 'left') {
			startDate.setDate(startDate.getDate() - 7);
			endDate.setDate(endDate.getDate() - 7);
		}

		// 새로운 날짜를 입력 필드에 설정
		$('#startDate').val(startDate.toISOString().slice(0, 10));
		$('#endDate').val(endDate.toISOString().slice(0, 10));
	}

	$(document).ready(function() {
		adjustMarquee();
		$(window).on('resize', adjustMarquee);

		// 모달이 완전히 보여진 후에 실행
		$('#workProdRegiModal').on('shown.bs.modal', adjustMarquee);
		$('#prodItemEditModal').on('shown.bs.modal', adjustMarquee);
	});

	function adjustMarquee() {
		$('.label-marquee').each(function() {
			const label = $(this); // 현재 label
			const text = label.find('.moving-text'); // 현재 label 내의 .moving-text

			// 조건을 검사하여 애니메이션을 적용하거나 제거
			if (text.width() > label.width()) {
				text.addClass('moving-animation'); // 너비가 label보다 클 경우, 애니메이션 클래스 추가
			} else {
				text.removeClass('moving-animation'); // 그렇지 않다면, 애니메이션 클래스 제거
			}
		});
	}
</script>


</head>

<body>

	<!-- ======= Header ======= -->
	<%@ include file="../header.jsp"%>

	<!-- ======= Sidebar ======= -->
	<%@ include file="../asidebar.jsp"%>

	<!-- End Sidebar-->

	<main id="main" class="main">

		<div class="pagetitle">
			<h1>생산 실적 조회</h1>
			<nav>
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="#">생산 관리</a></li>
					<li class="breadcrumb-item active">생산 실적 조회</li>
				</ol>
			</nav>
		</div>
		<!-- End Page Title -->
		<div class="card">
			<section class="section dashboard">



				<!--등록  버튼  -->

					<div class="col-sm-1 text-end" style="margin-left: auto;">
						<button id="regiModalBtn" type="button"
							class="btn btn-outline-primary" data-bs-toggle="modal"
							data-bs-target="#workProdRegiModal"
						>등록</button>
					</div>
	



				<div
					style="display: flex; align-items: center; justify-content: center; gap: 20px; margin: 20px 50px;"
				>

					<button id="dateLeftBtn" type="button" class="btn btn-primary">
						<i class="bi bi-caret-left-fill"></i>
					</button>
					<div>
						<label for="start"></label> <input type="date"
							class="prodItemDate" id="startDate" value="2024-03-01"
						>&nbsp;&nbsp;~&nbsp;&nbsp;<label for="end"></label> <input
							type="date" class="prodItemDate" id="endDate" value="2024-03-07"
						>
					</div>

					<button id="dateRightBtn" type="button" class="btn btn-primary">
						<i class="bi bi-caret-right-fill"></i>
					</button>
				</div>

				<table class="table table-hover">
					<thead>
						<tr>
							<th scope="col">생산 완료 일자</th>
							<th scope="col">등록된 생산 지시 번호</th>
							<th scope="col">제품명</th>
							<th scope="col">예정 수량</th>
							<th scope="col">불량 수량</th>
						</tr>
					</thead>
					<tbody>
						<tr data-bs-toggle="modal" data-bs-target="#prodItemEditModal">
							<th scope="row">2024-04-12</th>
							<td>WPR202404120001</td>
							<td>불닭</td>
							<td>28</td>
							<td>4</td>

						</tr>
						<tr data-bs-toggle="modal" data-bs-target="#prodItemEditModal">
							<th scope="row">2024-04-13</th>
							<td>WPR202404120002</td>
							<td>참깨</td>
							<td>35</td>
							<td>6</td>
						</tr>
					</tbody>
				</table>



				<!-- Start workProdRegiModal ----m1-->
				<div class="modal fade" id="workProdRegiModal" tabindex="-1"
					style="display: none;" aria-hidden="true"
				>
					<div class="modal-dialog modal-dialog-centered modal-xl">
						<div class="modal-content">
							<div class="modal-header">
								<h1 class="modal-title">생산 실적 등록</h1>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"
								></button>
							</div>
							<div class="modal-body">

								<!-- Start modal body -->
								<form>

									<div class="row mb-3">
										<label class="col-sm-2 col-form-label">생산 지시 번호</label>
										<div class="d-flex justify-content-between col-sm-10">

											<button class="btn btn-secondary dropdown-toggle col-sm-4"
												type="button" id="workProdNoRegiModal"
												data-bs-toggle="dropdown" aria-haspopup="true"
												aria-expanded="false"
											>생산 지시 번호 선택</button>
											<ul class="dropdown-menu col-sm-3"
												aria-labelledby="workProdNoRegiModal"
											>
												<li><a class="dropdown-item" href="#"
													data-value="WPR202404110001"
												>WPR202404110001</a></li>
												<li><a class="dropdown-item" href="#"
													data-value="WPR202404110002"
												>WPR202404110002</a></li>
												<li><a class="dropdown-item" href="#"
													data-value="WPR202404110003"
												>WPR202404110003</a></li>
												<li><a class="dropdown-item" href="#"
													data-value="WPR202404110004"
												>WPR202404110004</a></li>
											</ul>

											<label for="prodEndDateRegiModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											><span class="moving-text">생산 완료 일자</span></label>
											<div class="col-sm-5">
												<input id="prodEndDateRegiModal" type="date"
													class="form-control" value="2024-04-12" required
												>
											</div>

										</div>
									</div>

									<div class="row mb-3">
										<label for="empRegiModal"
											class="col-sm-2 col-form-label label-marquee"
										> <span class="moving-text">생산 실적 담당자</span></label>
										<div class="d-flex justify-content-between col-sm-10">
											<div class="col-sm-4">
												<input id="empRegiModal" type="text" class="form-control"
													value="김씨(kim)" readonly
												>
											</div>


											<label for="modifyDateRegiModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											> <span class="moving-text">생산 실적 등록일</span>
											</label>
											<div class="col-sm-5">
												<input id="modifyDateRegiModal" type="date"
													class="form-control" value="2024-04-15" readonly
												>
											</div>
										</div>
									</div>


									<div class="row mb-3">
										<label for="prodItemWHRegiModal"
											class="col-sm-2 col-form-label label-marquee"
										><span class="moving-text">입고 창고 이름</span></label>
										<div class="col-sm-10">
											<input id="prodItemWHRegiModal" type="text"
												class="form-control" readonly
												value="서울특별시 마포구 신촌로 176 창고(CAWH01)"
											>
										</div>
									</div>


									<div class="row mb-3">
										<label for="itemNameRegiModal" class="col-sm-2 col-form-label">제품명</label>

										<div class="d-flex justify-content-between col-sm-10">
											<div class="col-sm-4">
												<input id="itemNameRegiModal" type="text"
													class="form-control" value="붉닭라면(buldak001)" readonly
												>
											</div>


											<label for="expectedQtyRegiModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											><span class="moving-text">예정 생산 수량</span></label>
											<div class="col-sm-5">
												<input id="expectedQtyRegiModal" type="number"
													class="form-control" readonly value="50000"
												>
											</div>
										</div>
									</div>

									<div class="row mb-3">
										<label for="actualQtyRegiModal"
											class="col-sm-2 col-form-label label-marquee"
										><span class="moving-text">실제 생산 수량</span></label>

										<div class="d-flex justify-content-between col-sm-10">
											<div class="col-sm-4">
												<input id="actualQtyRegiModal" type="number"
													class="form-control" required value="49990"
												>
											</div>
											<label for="defectiveQtyRegiModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											><span class="moving-text">불량 생산 수량</span></label>
											<div class="col-sm-5">
												<input id="defectiveQtyRegiModal" type="number"
													class="form-control" required
												>
											</div>
										</div>
									</div>

									<div class="row mb-3">
										<label for="defectiveLogRegiModal"
											class="col-sm-2 col-form-label"
										><span class="moving-text">불량 내역</span></label>
										<div class="col-sm-10">
											<textarea id="defectiveLogRegiModal" class="form-control"
												style="height: 100px"
											>불닭이 너무매움</textarea>
										</div>
									</div>

									<div class="row mb-3">
										<label for="remarkRegiModal" class="col-sm-2 col-form-label">비고</label>
										<div class="col-sm-10">
											<textarea id="remarkRegiModal" class="form-control"
												style="height: 100px"
											>비고 비었음</textarea>
										</div>
									</div>

								</form>

							</div>
							<!-- End modal body -->

							<div class="modal-footer">
								<button type="button" class="btn btn-secondary"
									data-bs-dismiss="modal"
								>닫기</button>
								<button type="button" class="btn btn-primary">등록</button>
							</div>
						</div>
					</div>
				</div>
				<!-- End modal -->




				<!-- Start prodItemEditModal------------m2-------------------->
				<div class="modal fade" id="prodItemEditModal" tabindex="-1"
					style="display: none;" aria-hidden="true"
				>
					<div class="modal-dialog modal-dialog-centered modal-xl">
						<div class="modal-content">
							<div class="modal-header">
								<h1 class="modal-title">생산 실적 상세</h1>
								<button type="button" class="btn-close" data-bs-dismiss="modal"
									aria-label="Close"
								></button>
							</div>
							<div class="modal-body">

								<!-- Start modal body -->
								<form>
									<div class="row mb-3">
										<label class="col-sm-2 col-form-label label-marquee"><span
											class="moving-text"
										>생산 지시 번호</span></label>
										<div class="d-flex justify-content-between col-sm-10">
											<div class="col-sm-4">
												<input type="text" class="form-control"
													id="workProdNoEditModal" value="생산 지시 번호" readonly
												>
											</div>

											<label for="prodEndDateEditModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											><span class="moving-text">생산 완료 일자</span></label>
											<div class="col-sm-5">
												<input id="prodEndDateEditModal" type="date"
													class="form-control" value="2024-04-12" required
												>
											</div>

										</div>
									</div>

									<div class="row mb-3">
										<label for="empEditModal"
											class="col-sm-2 col-form-label label-marquee"
										> <span class="moving-text">생산 실적 담당자</span></label>
										<div class="d-flex justify-content-between col-sm-10">
											<div class="col-sm-4">
												<input id="empEditModal" type="text" class="form-control"
													value="김씨(kim)" readonly
												>
											</div>


											<label for="modifyDateEditModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											> <span class="moving-text">생산 실적 등록일</span>
											</label>
											<div class="col-sm-5">
												<input id="modifyDateEditModal" type="date"
													class="form-control" value="2024-04-15" readonly
												>
											</div>
										</div>
									</div>


									<div class="row mb-3">
										<label for="prodItemWHEditModal"
											class="col-sm-2 col-form-label label-marquee"
										><span class="moving-text">입고 창고 이름</span></label>
										<div class="col-sm-10">
											<input id="prodItemWHEditModal" type="text"
												class="form-control" readonly
												value="서울특별시 마포구 신촌로 176 창고(CAWH01)"
											>
										</div>
									</div>


									<div class="row mb-3">
										<label for="itemNameEditModal" class="col-sm-2 col-form-label">제품명</label>

										<div class="d-flex justify-content-between col-sm-10">
											<div class="col-sm-4">
												<input id="itemNameEditModal" type="text"
													class="form-control" value="붉닭라면(buldak001)" readonly
												>
											</div>


											<label for="expectedQtyEditModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											><span class="moving-text">예정 생산 수량</span></label>
											<div class="col-sm-5">
												<input id="expectedQtyEditModal" type="number"
													class="form-control" readonly value="50000"
												>
											</div>
										</div>
									</div>

									<div class="row mb-3">
										<label for="actualQtyEditModal"
											class="col-sm-2 col-form-label label-marquee"
										><span class="moving-text">실제 생산 수량</span></label>

										<div class="d-flex justify-content-between col-sm-10">
											<div class="col-sm-4">
												<input id="actualQtyEditModal" type="number"
													class="form-control" required value="49990"
												>
											</div>
											<label for="defectiveQtyEditModal"
												class="col-sm-2 col-form-label text-end label-marquee"
											><span class="moving-text">불량 생산 수량</span></label>
											<div class="col-sm-5">
												<input id="defectiveQtyEditModal" type="number"
													class="form-control" required
												>
											</div>
										</div>
									</div>

									<div class="row mb-3">
										<label for="defectiveLogEditModal"
											class="col-sm-2 col-form-label"
										><span class="moving-text">불량 내역</span></label>
										<div class="col-sm-10">
											<textarea id="defectiveLogEditModal" class="form-control"
												style="height: 100px"
											>불닭이 너무매움</textarea>
										</div>
									</div>

									<div class="row mb-3">
										<label for="remarkEditModal" class="col-sm-2 col-form-label">비고</label>
										<div class="col-sm-10">
											<textarea id="remarkEditModal" class="form-control"
												style="height: 100px"
											>비고 비었음</textarea>
										</div>
									</div>

								</form>

							</div>
							<!-- End modal body -->

							<div class="modal-footer">
								<button type="button" class="btn btn-secondary"
									data-bs-dismiss="modal"
								>닫기</button>
								<button type="button" class="btn btn-primary">삭제</button>
								<button type="button" class="btn btn-primary">수정</button>
							</div>
						</div>
					</div>
				</div>
				<!-- End modal -->


			</section>
		</div>
	</main>
	<!-- End #main -->

	<!-- ======= Footer ======= -->
	<%@ include file="../footer.jsp"%>
	<!-- End Footer -->

	<a href="#"
		class="back-to-top d-flex align-items-center justify-content-center"
	><i class="bi bi-arrow-up-short"></i></a>

	<!-- Vendor JS Files -->
	<script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
	<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="assets/vendor/chart.js/chart.umd.js"></script>
	<script src="assets/vendor/echarts/echarts.min.js"></script>
	<script src="assets/vendor/quill/quill.min.js"></script>
	<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
	<script src="assets/vendor/tinymce/tinymce.min.js"></script>
	<script src="assets/vendor/php-email-form/validate.js"></script>


</body>

</html>