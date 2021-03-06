<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<html lang="ko">
<head>
	<jsp:include page="info/resources.jsp"/> <%--css,img,script등 정적자원 --%>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode;
                document.getElementById("sample4_roadAddress").value = roadAddr;
                document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("sample4_extraAddress").value = '';
                }

                var guideTextBox = document.getElementById("guide");
                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                    guideTextBox.style.display = 'block';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                    guideTextBox.style.display = 'block';
                } else {
                    guideTextBox.innerHTML = '';
                    guideTextBox.style.display = 'none';
                }
            }
        }).open();
    }
</script>
</head>
<body>
	<div class="wrapper">
		<!-- 사이드바 -->
		<jsp:include page="info/sidebar.jsp" />
		<%--사이드바 --%>

		<div class="main-panel">
			<!-- header(nav) -->
			<nav class="navbar navbar-expand-lg " color-on-scroll="500">
				<div class="container-fluid">
					<a class="navbar-brand" href="#pablo"> 사원 관리 </a>
					<jsp:include page="info/header.jsp" />
					<%--헤더(네비) --%>

					<!-- 본문 시작 -->
					<div class="content">
						<div class="container-fluid">
							<div class="row">
								<div class="col-md-12">
									<div class="card">
										<div class="card-header">
											<h4 class="card-title">직원 회원가입</h4>
										</div>
										<div class="card-body">
											<form action="${pageContext.request.contextPath}/admin/employee/signUp_ok" method="post">
												<input type="hidden" name="empNo" value="${empNo}">
												<input type="hidden" name="name" value="${empName}">
											
												<div class="row">
													<div class="col-md-4">
														<div class="form-group">
															<label>이름</label><span id="nameChk"></span>
															<text id="user_name" class="form-control" placeholder="이름" >${empName}</text>
														</div>
													</div>
													<div class="col-md-4">
														<div class="form-group">
															<label>닉네임</label><span id="nickChk"></span>
															<input type="text" id="user_nick" name="nickname"class="form-control" placeholder="이름" >
														</div>
													</div>
													<div class="col-md-4">
														<div class="form-group">
															<label>아이디</label><span id="idChk"></span>
															<input type="text" id="user_id" class="form-control" name="id" placeholder="<c:if test="${empty emp.empId}">미발급 상태입니다.</c:if>" value="<c:if test="${!empty emp.empId}">${emp.empId}</c:if>">
														</div>
													</div>
													

												</div>

												<div class="row">
													<div class="col-md-6">
														<div class="form-group">
															<label>비밀번호</label><span id="pwChk"></span>
															<input type="password" id="password" class="form-control" name="password" placeholder="비밀번호" value="">
														</div>
													</div>
													<div class="col-md-6">
														<div class="form-group">
															<label>비밀번호 확인</label><span id="pwChk2"></span>
															<input type="password" id="password_check" class="form-control" name="password2" placeholder="비밀번호 확인" value="">
														</div>
													</div>
													
													
												</div>
												<div class="row">
													<div class="col-md-3">
														<div class="form-group">
															<label>이메일</label><span id="emailChk"></span>
															<input type="email" class="form-control" id="user_email" name="email" placeholder="example@abcde.fgh" value="">
														</div>
													</div>
													<div class="col-md-2" style="margin-top: 30px;">
														<div class="form-group">
															<input type="button" value="인증번호 전송">
															<!-- 이메일 인증 -->
															<br>
														</div>
													</div>
													<div class="col-md-3">
														<div class="form-group">
															<label>인증번호 입력</label>
															<input type="text" class="form-control" placeholder="인증번호">
														</div>
													</div>

													<div class="col-md-1" style="margin-top: 30px;">
														<div class="form-group">
															<input type="button" value="인증번호 확인">
															<br />
														</div>
													</div>
												</div>


												<div class="row">
													<div class="col-md-3">
														<div class="form-group">
															<label>전화번호</label>
															<input type="text" name="tel" id="user_phone" class="form-control" placeholder="(예시:- 하이픈 없이 입력해주세요)" />
														</div>
													</div>
													<div class="col-md-2" >
														<div class="form-group">
															<label style="text-align: right;">성별</label>
															<div class="form-control" style="border: 0 solid; text-align: center;">
																<input type="radio" name="gender" value="M">
																남자
																<input type="radio" name="gender" value="F">
																여자
															</div>
														</div>
													</div>
													<div class="col-md-3">
														<div class="form-group">
															<label>우편 번호</label>
															<input type="text" name="postcode" id="sample4_postcode" class="form-control" placeholder="우편 번호" />
														</div>
													</div>
													<div class="col-md-3" style="margin-top: 30px;">
														<div class="form-group">
															<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기">
															<br>
														</div>
													</div>
												</div>
												<div class="row">
													<div class="col-md-6">
														<div class="form-group">
															<label>도로명 주소</label>
															<input type="text" name="roadAddr" id="sample4_roadAddress" class="form-control" placeholder="도로명 주소">
														</div>
													</div>

													<div class="col-md-6">
														<div class="form-group">
															<label>지번 주소</label>
															<input type="text" name="jibunAddr" id="sample4_jibunAddress" class="form-control" placeholder="지번 주소">
														</div>
													</div>
												</div>
												<!-- span태그가 없으면 팝업창이 종료되지 않습니다. -->
												<span id="guide" style="color: #999; display: none"></span>
												<div class="row">
													<div class="col-md-12">
														<div class="form-group">
															<label>참고 주소</label>
															<input type="text" name="extraAddr" id="sample4_extraAddress" class="form-control" placeholder="참고 주소" />
														</div>
													</div>
												</div>
												<div class="row">
													<div class="col-md-12">
														<div class="form-group">
															<label>상세 주소</label>
															<input type="text" name="detailAddr" id="sample4_detailAddress" class="form-control" placeholder="상세 주소" />
														</div>
													</div>
												</div>

												<button type="submit" class="btn btn-flat pull-right" style="background-color: #212b52; border: 1px solid #212b52; color: white;">등록</button>
												<div class="clearfix"></div>
											</form>
										</div>
									</div>
								</div>

							</div>
						</div>
					</div>
					<!-- 본문 끝 -->

					<!-- footer -->
					<jsp:include page="info/footer.jsp" />
					<%--푸터 --%>

				</div>
		</div>
</body>
<script>
//start JQuery
$(function() {
	
	const getIdCheck= RegExp(/^[a-zA-Z0-9]{4,14}$/);
	const getPwCheck= RegExp(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/);
	const getName= RegExp(/^[가-힣]+$/);
	const getMail = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
	const getPhone = RegExp(/^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/);
	let chk1 = false, chk2 = false, chk3 = false, chk4 = false, chk5 = false; chk6 = false;
	
	//회원가입 검증~~
	//ID 입력값 검증.
	$('#user_id').on('keyup', function() {
		if($("#user_id").val() === ""){
			$('#user_id').css("background-color", "pink");
			$('#idChk').html('<b style="font-size:14px;color:red;">[아이디는 필수 정보에요!]</b>');
			chk1 = false;
		}
		
		//아이디 유효성검사
		else if(!getIdCheck.test($("#user_id").val())){
			$('#user_id').css("background-color", "pink");
			$('#idChk').html('<b style="font-size:14px;color:red;">[영문자,숫자 4-14자]</b>');	  
			chk1 = false;
		} 
		//ID 중복확인 비동기 처리
		else {
			//ID 중복확인 비동기 통신
			const id = $(this).val();
			console.log(id);
			
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/member/checkId",	
				headers: {
	                "Content-Type": "application/json"
	            },
				dataType: "text",
				data: id,
				success: function(result) {
					if(result === "OK") {
						$("#user_id").css("background-color", "aqua");
						$("#idChk").html("<b style='font-size:14px; color:green;'>[아이디는 사용 가능!]</b>");						
						chk1 = true;
					} else {
						$("#user_id").css("background-color", "pink");
						$("#idChk").html("<b style='font-size:14px; color:red;'>[아이디가 중복됨!]</b>");						
						chk1 = false;
					}
				},
				error: function() {
					console.log("통신 실패!");
				}
			});
		}
	});
	
	$('#user_email').on('keyup', function() {
		if($("#user_email").val() === ""){
			$('#user_email').css("background-color", "pink");
			$('#emailChk').html('<b style="font-size:14px;color:red;">[이메일는 필수 정보에요!]</b>');
			chk5 = false;
		}
		
		//이메일 유효성검사
		else if(!getMail.test($("#user_email").val())){
			$('#user_email').css("background-color", "pink");
			$('#emailChk').html('<b style="font-size:14px;color:red;">[영문자,숫자 4-14자]</b>');	  
			chk5 = false;
		} 
		//EMAIL 중복확인 비동기 처리
		else {
			//ID 중복확인 비동기 통신
			const email = $(this).val();
			console.log(email);
			
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/member/checkEmail",	
				headers: {
	                "Content-Type": "application/json"
	            },
				dataType: "text",
				data: email,
				success: function(result) {
					if(result === "OK") {
						$("#user_email").css("background-color", "aqua");
						$("#emailChk").html("<b style='font-size:14px; color:green;'>[이메일는 사용 가능!]</b>");						
						chk5 = true;
					} else {
						$("#user_email").css("background-color", "pink");
						$("#emailChk").html("<b style='font-size:14px; color:red;'>[이메일이 중복됨!]</b>");						
						chk5 = false;
					}
				},
				error: function() {
					console.log("통신 실패!");
				}
			});
		}
	});
	
	//전화번호 입력값 검증.
	$('#user_phone').on('keyup', function() {
		if($("#user_phone").val() === ""){
			$('#user_phone').css("background-color", "pink");
			$('#phoneChk').html('<b style="font-size:14px;color:red;">[전화번호는 필수 정보에요!]</b>');
			chk6 = false;
		}
		
		//전화번호 유효성검사
		else if(!getPhone.test($("#user_phone").val())){
			$('#user_phone').css("background-color", "pink");
			$('#phoneChk').html('<b style="font-size:14px;color:red;">[예시:010-0000-0000]</b>');	  
			chk6 = false;
		} 
		//전화번호 중복확인 비동기 처리
		else {
			//전화번호 중복확인 비동기 통신
			const phone = $(this).val();
			console.log(phone);
			
			$.ajax({
				type: "POST",
				url: "${pageContext.request.contextPath}/member/checkPhone",	
				headers: {
	                "Content-Type": "application/json"
	            },
				dataType: "text",
				data: phone,
				success: function(result) {
					if(result === "OK") {
						$("#user_phone").css("background-color", "aqua");
						$("#phoneChk").html("<b style='font-size:14px; color:green;'>[전화번호는 사용 가능!]</b>");						
						chk6 = true;
					} else {
						$("#user_phone").css("background-color", "pink");
						$("#phoneChk").html("<b style='font-size:14px; color:red;'>[전화번호가 중복됨!]</b>");						
						chk6 = false;
					}
				},
				error: function() {
					console.log("통신 실패!");
				}
			});
		}
	});
	
	//패스워드 입력값 검증.
	$('#password').on('keydown', function() {
		//비밀번호 공백 확인
		if($("#password").val() === ""){
		    $('#password').css("background-color", "pink");
			$('#pwChk').html('<b style="font-size:14px;color:red;">[패스워드는 필수정보!]</b>');
			chk2 = false;
		}		         
		//비밀번호 유효성검사
		else if(!getPwCheck.test($("#password").val()) || $("#password").val().length < 8){
		    $('#password').css("background-color", "pink");
			$('#pwChk').html('<b style="font-size:14px;color:red;">[특수문자 포함 8자이상]</b>');
			chk2 = false;
		} else {
			$('#password').css("background-color", "aqua");
			$('#pwChk').html('<b style="font-size:14px;color:green;">[√]</b>');
			chk2 = true;
		}
		
	});
	
	//패스워드 확인란 입력값 검증.
	$('#password_check').on('keyup', function() {
		//비밀번호 확인란 공백 확인
		if($("#password_check").val() === ""){
		    $('#password_check').css("background-color", "pink");
			$('#pwChk2').html('<b style="font-size:14px;color:red;">[패스워드확인은 필수정보!]</b>');
			chk3 = false;
		}		         
		//비밀번호 확인란 유효성검사
		else if($("#password").val() != $("#password_check").val()){
		    $('#password_check').css("background-color", "pink");
			$('#pwChk2').html('<b style="font-size:14px;color:red;">[위에랑 똑같이!!]</b>');
			chk3 = false;
		} else {
			$('#password_check').css("background-color", "aqua");
			$('#pwChk2').html('<b style="font-size:14px;color:green;">[√]</b>');
			chk3 = true;
		}
		
	});
	
	//이름 입력값 검증.
	$('#user_name').on('keyup', function() {
		//이름값 공백 확인
		if($("#user_name").val() === ""){
		    $('#user_name').css("background-color", "pink");
			$('#nameChk').html('<b style="font-size:14px;color:red;">[이름은 필수정보!]</b>');
			chk4 = false;
		}		         
		//이름값 유효성검사
		else if(!getName.test($("#user_name").val())){
		    $('#user_name').css("background-color", "pink");
			$('#nameChk').html('<b style="font-size:14px;color:red;">[이름은 한글로 ~]</b>');
			chk4 = false;
		} else {
			$('#user_name').css("background-color", "aqua");
			$('#nameChk').html('<b style="font-size:14px;color:green;">[참 잘했어요]</b>');
			chk4 = true;
		}
		
	});
	
	
	
	/* $('#signup-btn').click(function(e) {
		if(chk1 && chk2 && chk3 && chk4) {
			//아이디 정보
			const id = $("#user_id").val();
			console.log("id: " + id);
			//패스워드 정보
			const pw = $("#password").val();
			console.log("pw: " + pw);
			//이름 정보
			const name = $("#user_name").val();
			console.log("name: " + name);
			
			const user = {
				account: id,
				password: pw,
				name: name
			};
			
			//클라이언트에서 서버와 통신하는 ajax함수(비동기 통신) 
			$.ajax({
				type: "POST", //서버에 전송하는 HTTP요청 방식
				url: "/controller/member/signUp_ok", //서버 요청 URI
				headers: {
					"Content-Type": "application/json"
				}, //요청 헤더 정보
				dataType: "text", //응답받을 데이터의 형태
				data: JSON.stringify(user), //서버로 전송할 데이터
				success: function(result) { //함수의 매개변수는 통신성공시의 데이터가 저장될 곳.
					console.log("통신 성공!: " + result);
					if(result === "joinSuccess") {
						alert("회원가입에 성공했습니다!");
						location.href="/";
					} else {
						alert("회원가입에 실패했습니다!");
					}
				}, //통신 성공시 처리할 내용들을 함수 내부에 작성.
				error: function() {
					console.log("통신 실패!");
				} //통신 실패 시 처리할 내용들을 함수 내부에 작성.
			});
		
		} else {
			alert('입력정보를 다시 확인하세요.');			
		}
	}); */
	
	///////////////////////////////////////////////////////////////////////////////////////////
	
	//로그인 검증~~
	//ID 입력값 검증.
	$('#signInId').on('keyup', function() {
		if($("#signInId").val() == ""){
			$('#signInId').css("background-color", "pink");
			$('#idCheck').html('<b style="font-size:14px;color:red;">[아이디는 필수!]</b>');
			chk1 = false;
		}		
		
		//아이디 유효성검사
		else if(!getIdCheck.test($("#signInId").val())){
			$('#signInId').css("background-color", "pink");
			$('#idCheck').html('<b style="font-size:14px;color:red;">[영문자,숫자 4-14자~]</b>');	  
			chk1 = false;
		} else {
			$('#signInId').css("background-color", "aqua");
			$('#idCheck').html('<b style="font-size:14px;color:green;">[참 잘했어요]</b>');
			chk1 = true;
		}
	});
	
	//패스워드 입력값 검증.
	$('#signInPw').on('keyup', function() {
		//비밀번호 공백 확인
		if($("#signInPw").val() === ""){
		    $('#signInPw').css("background-color", "pink");
			$('#pwCheck').html('<b style="font-size:14px;color:red;">[패스워드는 필수!]</b>');
			chk2 = false;
		}		         
		//비밀번호 유효성검사
		else if(!getPwCheck.test($("#signInPw").val()) || $("#signInPw").val().length < 8){
		    $('#signInPw').css("background-color", "pink");
			$('#pwCheck').html('<b style="font-size:14px;color:red;">[특수문자 포함 8자이상]</b>');
			chk2 = false;
		} else {
			$('#signInPw').css("background-color", "aqua");
			$('#pwCheck').html('<b style="font-size:14px;color:green;">[참 잘했어요]</b>');
			chk2 = true;
		}
		
	});
	
	//로그인 버튼 클릭 이벤트
	$("#signIn-btn").click(function(){
		if(chk1 && ch2){
			//ajax통신으로 서버에서 값 받아오기 
			const id= $('#signInId').val();
			const pw= $('#signInPw').val();
			
			console.log("id: "+id);
			console.log("pw: "+pw);
			
			const userInfo = {
					account : id,
					password : pw
			};
			$.ajax({
				type:"POST",
				url: "/controller/member/signUp_ok",
				headers:{
					"Content-Type": "application/json"
				},
				data:JSON.stringify(userInfo),
				dataType:"text",
				success:function(data){
					console.log("result:"+data);
					
				}
			});
		}else{
			alert("입력정보를 다시 확인하세요!");
		}
	})
	
});
</script>
</html>