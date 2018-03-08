<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Korea Map</title>
<script src="https://d3js.org/d3.v3.min.js"></script>
<script src="http://d3js.org/topojson.v0.min.js"></script>
</head>


<style>
svg {
	background-color: lightskyblue;
}

.municipality {
	fill: #eee;
	stroke: #999;
}

.municipality:hover {
	fill: orange;
}
</style>

<body>

	<script>
function getList(str){
	alert(str);
}
	
	
var w = 860, h = 870; 
var proj = d3.geo.mercator()
	.center([128.0, 35.9])
	.scale(7000)
	.translate([w/2, h/2]);

var path = d3.geo.path().projection(proj);
var ids = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
var svg = d3.select("body").append("svg")
	.attr("width", w)
	.attr("height", h);
    
d3.json("/resources/map/provinces-topo-simple.json", function(error, kor) {
	var municipalities = topojson.object(kor, kor.objects['provinces-geo']);
	svg.selectAll('path').data(municipalities.geometries).enter().append('path')
	.attr('d', path)
	.attr("id", function(d) { return d.properties.name_eng; })
	.attr('class', 'municipality')
	.attr('onclick', 'getList(id)')
	.attr('style','cursor:pointer;');
    });
</script>
</body>

</html>
