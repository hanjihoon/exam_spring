<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Double Calendar</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<link rel="stylesheet" type="text/css" href="../../../codebase/fonts/font_roboto/roboto.css"/>
	<link rel="stylesheet" type="text/css" href="../../../codebase/dhtmlx.css"/>
	<script src="../../../codebase/dhtmlx.js"></script>
	<script>
		var myCalendar;
		function doOnLoad() {
			myCalendar = new dhtmlXDoubleCalendar("calendarHere");
			myCalendar.setDateFormat("%Y-%m-%d");
			myCalendar.setDates("2012-08-07","2012-08-23");
			myCalendar.show();
		}
	</script>
</head>
<body onload="doOnLoad();">
	<div id="calendarHere" style="position:relative;height:350px;"></div>
</body>
</html>