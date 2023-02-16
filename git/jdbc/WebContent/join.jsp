<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
	<form action="joinAction.member" name="joinForm" method="post">
		<div>
			<input type="text" name="memberIdentification" placeholder="아이디">
			<p id="result"></p>
		</div>
		<div>
			<input type="text" name="memberPassword" placeholder="비밀번호">
		</div>
		<!-- class명 또는 id명은 예약어를 사용하지 말자! -->
		<input id="finish" type="button" value="완료">
	</form>		
</body>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
<script>

	globalThis.check = false; // global으로 check 재사용할 수 있게 

	let dom = (function(){
		function changeResult(result){
			const $p = $("#result");
			result = JSON.parse(result);
			
			if(!result.check){
				check = true;
				$p.css("color", "blue");
				$p.text("사용 가능한 아이디입니다.")
			}else{
				check = false;
				$p.css("color", "red");
				$p.text("중복된 아이디입니다.")
			}
		}
		
		return {changeResult: changeResult};
	})();
	
	let service = (function(){
		function checkId(callback){
			$.ajax({
				url: "${pageContext.request.contextPath}/checkIdAction.member",
				data: {"memberIdentification": $("input[name='memberIdentification']").val()},
				success: function(result){
					if(callback){
						callback(result);
					}
				}
			});
		}
		
		return {checkId: checkId};
	})();
	
	$("input[name='memberIdentification']").on("blur", function(){
		globalThis.check = false;
		service.checkId(dom.changeResult);
	});

	$("#finish").on("click", function(){
		const $identification = $("input[name='memberIdentification']"); // 화면에서 아이디를 입력받는 위치 
		const $password = $("input[name='memberPassword']"); // 화면 에서 비밀번호를 입력 위치
		
		if(!$identification.val()){  // 화면에서 아이디를 입력받은 값
			return;
		}
		
		if(!$password.val()){ // 화면에서 비밀번호를 입력 받은 값
			return;
		}
		
		if(!globalThis.check) { //check 를
			return;
		}
		
		$password.val(btoa($password.val()));
		
		joinForm.submit();
	});
</script>
</html>








