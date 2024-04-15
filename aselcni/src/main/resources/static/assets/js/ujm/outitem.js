
$(document).ready(function () {
  //닫기 버튼 클릭시 modal 입력 내용 클리어

    $('button[data-bs-dismiss="modal"]').on(
      "click", //닫기버튼 누르면
      function () {
        modalContentClear(); //아래
      }
    );
  //닫기 버튼 클릭시 modal 입력 내용 클리어
  function modalContentClear() {
    $(".modal-content input").val("");
    $(".modal-content textarea").val("");
    $('#detail_outitem_item_list tbody').empty();
  }

  //날짜
  //시작 날짜와 종료 날짜 논리 일관성
    $("#startDate").on("input", function () {
      let startDate = $("#startDate").val();
      let endDate = $("#endDate").val();

      // 시작 날짜가 종료 날짜보다 뒤에 있는 경우
      if (startDate > endDate) {
        // 시작 날짜를 종료 날짜와 동일하게 설정
        $("#startDate").val(endDate);
      }
    });

    $("#endDate").on("input", function () {
      let startDate = $("#startDate").val();
      let endDate = $("#endDate").val();

      // 시작 날짜가 종료 날짜보다 뒤에 있는 경우
      if (startDate > endDate) {
        // 시작 날짜를 종료 날짜와 동일하게 설정
        $("#endDate").val(startDate);
      }
    });


  // 좌우 버튼 누를 때마다 날짜 7일 단위로 바뀜
    $("#dateRightBtn").click(function () {
      dateShift("right");
    });

    $("#dateLeftBtn").click(function () {
      dateShift("left");
    });

  // 날짜 조정 함수
  function dateShift(direction) {
    let startDateVal = $("#startDate").val();
    let endDateVal = $("#endDate").val();

    // Date 객체로 변환
    let startDate = new Date(startDateVal);
    let endDate = new Date(endDateVal);

    // 방향에 따라 날짜를 조정
    if (direction === "right") {
      startDate.setDate(startDate.getDate() + 7);
      endDate.setDate(endDate.getDate() + 7);
    } else if (direction === "left") {
      startDate.setDate(startDate.getDate() - 7);
      endDate.setDate(endDate.getDate() - 7);
    }

    // 새로운 날짜를 입력 필드에 설정
    $("#startDate").val(startDate.toISOString().slice(0, 10));
    $("#endDate").val(endDate.toISOString().slice(0, 10));
  }







     //등록버튼 눌렀을 때..
    $("#outitem_insert_btn").click(function(){ 



      //주문번호와 그에 해당하는 제품명(item_nm), 수량(qty), 기업명(cust_nm)을 주문품목과 주문 테이블에서 가져옴
     
      $.ajax({
          url: 'ujmGetOrderNo',
          type: 'GET',
          dataType: 'json',
          success: function(response) {
            console.log(response);
              var selectBox = $('#selectOrderNo'); //주문번호 select 부분 id , 안에 option이 있음
              selectBox.empty();
              
              $.each(response, function(index, item) { //리스트의 각각의 객체를 item으로 명명 
                  selectBox.append('<option value="' + item.order_no + '">' + 
                  item.order_no + ': ' +
                  item.customer_name + ' - ' + item.items + '</option>');
              });
          },
          error: function(xhr, status, error) {
              console.error(error);
          }
      });



  });


  
 //주문번호 셀렉트박스 눌렀을 때 : 선택한 주문번호에 대한 정보들 컨트롤러로 가져오기 위함
 $("#selectOrderNo").click(function(){ 
  var selectOrderNo = $('#selectOrderNo').val();
  $('#insertOrderNo').val(selectOrderNo); //form에 넣을 주문번호


  //주문번호와 그에 해당하는 주문일자, 매입처이름, 주문상태, 주문납기일을 조인해 가져옴
  $.ajax({
      url: 'ujmGetOrderInfoFromOrderNo',
      type: 'GET',
      data: { order_no: selectOrderNo },
      success: function(orderInfo) {
        console.log(orderInfo); //orderInfo 객체 자체
  
        $('#orderInfo_order_dt').val(orderInfo.order_dt);
        $('#orderInfo_order_dt').html(orderInfo.order_dt);   //주문일자

        $('.orderInfo_cust_nm').val(orderInfo.cust_nm); //매입처, 표시부분과 input hidden 둘다
        $('#orderInfo_cust_nm').html(orderInfo.cust_nm); //매입처 표시 부분

        $('#orderInfo_order_status_chk').val(orderInfo.order_status_chk);  //주문상태

        if(orderInfo.order_status_chk==0) {
        $('#orderInfo_order_status_chk').html('미출고');
        } else if(orderInfo.order_status_chk==2) {
          $('#orderInfo_order_status_chk').html('일부 출고');
        }
        
        $('#orderInfo_order_end_dt').val(orderInfo.order_end_dt); //주문납기일
        $('#orderInfo_order_end_dt').html(orderInfo.order_end_dt);

      
      
      }, 
      error: function(xhr, status, error) {
          console.error(error);
      }
   });



  //주문번호와 그에 해당하는 제품명(item_nm), 수량(qty), 기업명(cust_nm)을 주문품목과 주문 테이블에서 가져옴
  $.ajax({
    url: 'ujmGetOrderItem',
    type: 'GET',
    data: { order_no: selectOrderNo },
    success: function(response) {
      console.log('주문품목조회'+response);  

      $('#outitem_item_list tbody').empty();
      
      $.each(response, function(index, item) { /* 각각의 주문품목 */
        var checkbox = $('<input>').attr({
            type: 'checkbox',
            name: 'selectedItems',
            value: item.item_cd,
            'data-qty': item.qty
        });

        var insertQtyInput = $('<input>').attr({
            type: 'number',
            class: 'insertQty form-control',
            name: 'insert_qty',
            min: 1, 
            max: item.stock, 
            value: 1 
        }).on('change', function() {
          var qtyValue = parseInt($(this).val()); // 입력된 값
          var maxQty = parseInt($(this).attr('max')); //재고 
          var minQty = parseInt($(this).attr('min')); 
          console.log('qtyValue'+qtyValue);
          console.log('maxQty'+maxQty);
          console.log('minQty'+minQty);
          console.log('remain_qty'+item.remain_qty);

          console.log(Boolean(qtyValue > maxQty));
          console.log(Boolean(qtyValue >item.remain_qty));
          console.log(Boolean(qtyValue < minQty));
          console.log(Boolean(isNaN(qtyValue)));

          $(this).val(qtyValue); 
          $(this).closest('tr').find('input[type="checkbox"]').data('qty', qtyValue);
          
          if (qtyValue > maxQty ||qtyValue >item.remain_qty || qtyValue < minQty || isNaN(qtyValue)) {
            $('#insertOutitemBtn').prop('disabled', true); //출고버튼 비활성화
          } else {
            $('#insertOutitemBtn').prop('disabled', false);
          };
          
           
        });
        
        $('#outitem_item_list tbody').append(
            $('<tr>').append(
                $('<td>').append(checkbox),
                $('<td>').text(item.item_nm),
                $('<td>').text(item.stock),
                $('<td>').text(item.qty),
                $('<td>').text(item.remain_qty),
                $('<td>').append(insertQtyInput),
            )
        );
      });

    }, 
    error: function(xhr, status, error) {
        console.error(error);
    }
  });


}); //selectBox

  $('#insertOutitemBtn').click(function(e){ //출고등록 버튼(form) 누르면
    e.preventDefault(); // 기본 이벤트 동작 방지

    // 현재 날짜 생성
    var now = new Date();
    var year = now.getFullYear();
    var month = (now.getMonth() + 1).toString();
    if(month.length===1) {month="0"+month;} //1월-9월일 경우 01 - 09로 변경

    var day = now.getDate();
    var currentDate = year + "-" + month + "-" + day; // ex 2024-04-07
    console.log(currentDate);
    
    var outitemDt = $('#insert_outitem_dt').val(); //출고일자 : 달력으로 선택
    var orderDt=  $('#orderInfo_order_dt').val() //주문일자 : 주문번호 선택시 자동으로 가져와 보여줌
    console.log(outitemDt);
    console.log(orderDt);

    // 날짜 형식 문자열에서 '-' 제거한 숫자값 계산
    var currentDateValue = Number(currentDate.replace(/-/g, ''));
    var outitemDtValue = Number(outitemDt.replace(/-/g, ''));
    var orderDtValue =  Number(orderDt.replace(/-/g, ''));

  // 현재 날짜와 outitem_dt 비교
  if (outitemDtValue >= currentDateValue && outitemDtValue>=orderDtValue) { //출고일자가 현재시간 및 주문일자보다 같거나 늦어야함
    //이 조건 만족할 경우에만 출고등록 진행....
    
    // form으로 제출할 outitem데이터들
    var insertOutitemData = {
        outitem_no : outitemDt, //일단 2024-04-07 그대로 보내고, OUT2404070001..으로의 변환은 자바에서, seq_no와 같이.
        order_no: $('#insertOrderNo').val(),
        outitem_dt: $('#insert_outitem_dt').val(),
        cust_emp: $('#insert_cust_emp').val(),
        remark: $('#insert_remark').val()
    };

    console.log(insertOutitemData);

    // 선택된 주문품목 -> 출고품목으로 : 출고품목 테이블에 insert
    var selectedItems = [];
    $('input[name="selectedItems"]:checked').each(function() {
        var itemCd = $(this).val();
        var qty = $(this).data('qty');
        selectedItems.push({ item_cd: itemCd, qty: qty });
    });

    console.log(selectedItems);

    // 데이터 조합
    var insertData = {
        outitemData: insertOutitemData,
        selectedItems: selectedItems
    };

    console.log(insertData);

    // 조합한 insertData를 서버로 전송
    $.ajax({
        url: 'insertOutitem',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(insertData),
        success: function(response){
            alert('출고 등록 완료.');
            $(".modal-content input").val("");
            $(".modal-content textarea").val("");
        }
    });

  } else {
    alert("출고 날짜가 정상적으로 설정되지 않았습니다.");
        }
  });





/* 조회 */

    //메인화면 테이블 행 클릭시 modal 수정창으로 이동
    $('tr[data-bs-toggle="modal"]').on("click", function () {

      //초기화
      $(".modal-content input").val("");
      $(".modal-content textarea").val("");
      $('#detail_outitem_item_list tbody').empty();
      

      let outitemNo = $(this).find("td:nth-child(1)").text(); //출고번호
      $("#detail_outitem_no").html(outitemNo);

      let orderNo = $(this).find("td:nth-child(3)").text(); //주문번호
      $("#detail_order_no").html(orderNo);

      let orderDt = $(this).find("td:nth-child(4)").text(); //주문일자
      $("#detail_order_dt").html(orderDt);

      let outitemDt = $(this).find("td:nth-child(6)").text(); //출고일자
      $("#detail_outitem_dt").html(outitemDt);

      let custNm = $(this).find("td:nth-child(7)").text(); //매입처
      $("#detail_cust_nm").html(custNm);

      let orderStatusChk = $(this).find("td:nth-child(9)").text(); //주문 상태
      $("#detail_order_status_chk").html(orderStatusChk);

      let orderEndDt = $(this).find("td:nth-child(5)").text(); //주문 마감일(납기일)
      $("#detail_order_end_dt").html(orderEndDt);


      /* ajax로 그외 것, 출고한 품목들 가져오기 */
      $.ajax({
        url: 'ujmGetOutitemDetail',
        type: 'GET',
        data: { order_no: orderNo, outitem_no: outitemNo},
        success: function(response) {
          console.log(response);
 
          
          $.each(response, function(index, item) { /* 각각의 주문품목 */

          let custEmp = item.cust_emp; //상대 담당자
          $("#detail_cust_emp").html(custEmp);
    
          let remark = item.remark; //비고
          $("#detail_remark").html(remark);



            var checkbox = $('<input>').attr({
                type: 'checkbox',
                name: 'selectedItems',
                value: item.item_cd,
                'data-qty': item.qty
            });

            var updateQtyInput = $('<input>').attr({
                type: 'number',
                class: 'updateQty form-control',
                name: 'update_qty',
                min: 0, 
                max: item.stock, 
                value: item.outitem_qty ,
                readonly: 'readonly'
            }).on('change', function() {
              var qtyValue = parseInt($(this).val()); // 입력된 값
              var maxQty = parseInt($(this).attr('max')); //재고 
              var minQty = parseInt($(this).attr('min')); //0
              console.log('qtyValue:'+qtyValue);
              console.log('maxQty:'+maxQty);
              console.log('minQty:'+minQty);
              console.log('remain_qty:'+item.remain_qty);

              console.log(Boolean(qtyValue > maxQty));
              console.log(Boolean(qtyValue >item.remain_qty));
              console.log(Boolean(qtyValue < minQty));
              console.log(Boolean(isNaN(qtyValue)));

              $(this).val(qtyValue); 
              $(this).closest('tr').find('input[type="checkbox"]').data('qty', qtyValue);
              
              if (qtyValue > maxQty ||qtyValue >item.remain_qty || qtyValue < minQty || isNaN(qtyValue)) {
                $('#updateOutitemSubmitBtn').prop('disabled', false); 
              } else {
                $('#updateOutitemSubmitBtn').prop('disabled', true);
              };
              
              
            });
            
            $('#detail_outitem_item_list tbody').append(
                $('<tr>').append(
                    $('<td>').append(checkbox),
                    $('<td>').text(item.item_nm),
                    $('<td>').text(item.stock),
                    $('<td>').text(item.qty),
                    $('<td>').text(item.remain_qty),
                    $('<td>').append(updateQtyInput),
                )
            );
          });



            
        },
        error: function(xhr, status, error) {
            console.error(error);
        }

    }); //ajax


    // 수정하기 버튼 클릭시
    $("#updateOutitemBtn").on("click", function (e) {
      e.preventDefault(); // 기본 이벤트 동작 방지

      $(".modal-content input").val("");
      $(".modal-content textarea").val("");
      $('#detail_outitem_item_list tbody').empty();

      $('.modal-body .updateQty').each(function() {
        $(this).removeAttr('readonly');
      });

      $('#updateOutitemBtn').hide();
      

      var $row = $(this).closest("tr");
      var $outitemDtInput = $row.find("#detail_outitem_dt");

      
      // 출고일자 달력으로 변경가능하게
      $outitemDtInput.replaceWith('<input type="date" class="form-control" id="detail_outitem_dt"'
      +' name="outitem_dt" style="width: 200px;" required="required"/>');


      // 현재 날짜 생성
      var now = new Date();
      var year = now.getFullYear();
      var month = (now.getMonth() + 1).toString();
      if(month.length===1) {month="0"+month;} //1월-9월일 경우 01 - 09로 변경
  
      var day = now.getDate();
      var currentDate = year + "-" + month + "-" + day; // ex 2024-04-07
      console.log(currentDate);
      console.log(outitemDt);
      console.log(orderDt);
  
      // 날짜 형식 문자열에서 '-' 제거한 숫자값 계산
      var currentDateValue = Number(currentDate.replace(/-/g, ''));
      var outitemDtValue = Number(outitemDt.replace(/-/g, ''));
      var orderDtValue =  Number(orderDt.replace(/-/g, ''));

      if (outitemDtValue >= currentDateValue && outitemDtValue>=orderDtValue) { //출고일자가 현재시간 및 주문일자보다 같거나 늦어야함
        $("#updateOutitemSubmitBtn").removeAttr("hidden");
      } else {
        $('#updateOutitemSubmitBtn').prop('disabled', true);
      }


  });

  //수정 완료
  $('#updateOutitemSubmitBtn').click(function(e){ //수정 완료 버튼 누르면
      

    $('#updateOutitemBtn').show();
    
      
    // form으로 제출할 outitem데이터들
    var insertOutitemData = {
        outitem_no : outitemDt, //일단 2024-04-07 그대로 보내고, OUT2404070001..으로의 변환은 자바에서, seq_no와 같이.
        order_no: $('#insertOrderNo').val(),
        outitem_dt: $('#insert_outitem_dt').val(),
        cust_emp: $('#insert_cust_emp').val(),
        remark: $('#insert_remark').val()
    };

    console.log(insertOutitemData);

    // 선택된 주문품목 -> 출고품목으로 : 출고품목 테이블에 insert
    var selectedItems = [];
    $('input[name="selectedItems"]:checked').each(function() {
        var itemCd = $(this).val();
        var qty = $(this).data('qty');
        selectedItems.push({ item_cd: itemCd, qty: qty });
    });

    console.log(selectedItems);

    // 데이터 조합
    var insertData = {
        outitemData: insertOutitemData,
        selectedItems: selectedItems
    };

    console.log(insertData);

    // 조합한 insertData를 서버로 전송
    $.ajax({
        url: 'insertOutitem',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(insertData),
        success: function(response){
            alert('출고 등록 완료.');
            $(".modal-content input").val("");
            $(".modal-content textarea").val("");
        }
    });



  













  }) //수정완료


    }); //조회





}); //끝


