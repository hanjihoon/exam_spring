<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원가입</title>
</head>

<style>
div#winVP {
	position: relative;
	height: 100%;
	border: 1px solid #dfdfdf;
	margin: 10px;
}
</style>
<script>

	var winF, popW;
	var checkImgWinF, checkImgPopW;
	var randomNum;
	var forCheckImg = [ {
		url : "${root}/resources/img/lion.jpg",
		name : "사자"
	}, {
		url : "${root}/resources/img/rabbit.jpg",
		name : "토끼"
	}, {
		url : "${root}/resources/img/cat.jpg",
		name : "고양이"
	}, {
		url : "${root}/resources/img/seal.jpg",
		name : "물개"
	}, {
		url : "${root}/resources/img/hedgehog.jpg",
		name : "고슴도치"
	} ]
	
function checkAutobotFunc(){
		randomNum = Math.floor(Math.random() * 5);
		checkImgWinF = new dhtmlXWindows();
		checkImgPopW = checkImgWinF.createWindow("win1", 20,
				30, 600, 600);
		checkImgPopW.setText("AutoBot Check");
		var formObj = [ {
			type : "image",
			name : "photo",
			label : "Photo",
			imageWidth : 126,
			imageHeight : 126,
			url : forCheckImg[randomNum].url
		}, {
			type : "input",
			name : "photoName",
			label : "무슨 동물 인가요?",
			required : true
		}, {
			type : "button",
			name : "submitImgName",
			value :"OK"
		} ];
		var checkImgPopWForm = checkImgPopW.attachForm(formObj, true);
		checkImgPopWForm.attachEvent("onButtonClick", function(id){
			if(id=="submitImgName"){
				var inputVal = checkImgPopWForm.getItemValue("photoName");
				if(inputVal==forCheckImg[randomNum].name){
					checkImgPopW.close();
					alert("확인 완료!");
					localStorage.setItem("checkAutoBot", true);
				}else{
					checkImgPopW.close();
					alert("확인 실패!");
				}
			}
		})
	}

	$(document).ready(
			function() {

				winF = new dhtmlXWindows();
				winF.attachViewportTo("winVP");
				popW = winF.createWindow("win1", 100, 150, 300, 700);
				popW.button("close").hide();
				popW.button("minmax").hide();
				popW.button("park").hide();
				popW.setText("SignUp");

				winF.window("win1").centerOnScreen();
				winF.window("win1").denyMove();
				winF.window("win1").denyResize();
				var formObj = [ {
					type : "settings",
					offsetTop : 12,
					name : "connectionInfo",
					labelAlign : "left"
				}, {
					type : "input",
					name : "emID",
					label : "아이디 : ",
					required : true
				}, {
					type : "button",
					name : "checkID",
					value : "중복체크"
				}, {
					type : "password",
					name : "emPwd",
					label : "비밀번호 : ",
					required : true
				}, {
					type : "input",
					name : "emName",
					label : "이름 : ",
					required : true
				}, {
					type : "input",
					name : "dpNo",
					label : "부서 : ",
					required : true
				}, {
					type : "input",
					name : "emSal",
					label : "월급 : ",
					required : true
				}, {
					type : "input",
					name : "emAd",
					label : "주소 : ",
					required : true
				}, {
					type : "input",
					name : "emEmail",
					label : "이메일 : ",
					required : true
				}, {
					type : "input",
					name : "emPhone",
					label : "휴대폰 : ",
					required : true
				}, {
					type : "label",
					name : "admin",
					label : "관리자권한 : ",
					list : [ {
						type : "radio",
						name : "admin",
						value : "1",
						label : "예"
					}, {
						type : "radio",
						name : "admin",
						value : "0",
						label : "아니오",
						checked : true
					} ]
				}, {
					type : "block",
					blockOffset : 0,
					list : [ {
						type : "button",
						name : "AutoBotCheck",
						value : "AutoBotCheck"
					} ]
				}, {
					type : "block",
					blockOffset : 0,
					list : [ {
						type : "button",
						name : "joinBtn",
						value : "회원가입"
					}, {
						type : "newcolumn"
					}, {
						type : "button",
						name : "cancelBtn",
						value : "취소"
					}, {
						type : "newcolumn"
					}, {
						type : "button",
						name : "backBtn",
						value : "돌아가기"
					} ]
				} ];
				var form = popW.attachForm(formObj, true);

				form.attachEvent("onButtonClick", function(id) {
					if (id == "AutoBotCheck") {
						checkAutobotFunc();
					}
					if (id == "joinBtn") {
						if (form.validate()) {
							if(localStorage.getItem("checkAutoBot")){
								var aud = new AjaxUtilDx("${root}/emp/join", form);
								aud.send(callback);
								if(localStorage.getItem("checkAutoBot")){
									localStorage.removeItem("checkAutoBot");
									form.clear();
								}
							}else{
								alert("checkAutoBot을 해주셔야합니다!");
							}
							
						}
					} else if (id == "cancelBtn") {
						form.clear();
					} else if (id == "backBtn") {
						document.location.href = "${root}/path/emp/login";
					} else if (id == "checkID") {
						var aud = new AjaxUtilDx("${root}/emp/checkid", form);
						aud.send(callback);
						console.log(aud.param);
					}

				});
			})

	function callback(res) {
		if (res.errorMSG) {
			alert(res.errorMSG);
		}
		if (res.msg) {
			alert(res.msg);
		}
	}

</script>
<body>
	<div id="winVP"></div>
</body>
</html>