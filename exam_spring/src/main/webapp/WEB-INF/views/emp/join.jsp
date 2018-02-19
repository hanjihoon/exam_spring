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
	$(document).ready(function() {
		winF = new dhtmlXWindows();
		winF.attachViewportTo("winVP");
		popW = winF.createWindow("win1", 100, 150, 270, 700);
		popW.button("close").hide();
		popW.button("minmax").hide();
		popW.button("park").hide();
		popW.setText("Login");

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
			if (id == "joinBtn") {
				if (form.validate()) {
					var aud = new AjaxUtilDx("${root}/emp/join", form);
					console.log(aud.param);
					aud.send(callback);
				}
			} else if (id == "cancelBtn") {
				form.clear();
			} else if (id == "backBtn") {
				document.location.href = "${root}/path/emp/login";
			} else if (id == "checkID") {
				var aud = new AjaxUtilDx("${root}/emp/checkid", form);
				console.log(aud.param);
			}
		});
	})

	function callback(res) {
		console.log(res);
	}

	function setPopW(onOff) {
		if (onOff) {
			popW.show();
			return;
		}
		popW.hide();
	}
</script>
<body>
	<div id="winVP"></div>
</body>
</html>