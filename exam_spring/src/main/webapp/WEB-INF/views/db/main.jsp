<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<style>
html, body {
	width: 100%; /*provides the correct work of a full-screen layout*/
	height: 100%; /*provides the correct work of a full-screen layout*/
	overflow: hidden; /*hides the default body's space*/
	margin: 0px; /*hides the body's scrolls*/
}

div.controls {
	margin: 0px 10px;
	font-size: 14px;
	font-family: Tahoma;
	color: #404040;
	height: 80px;
}

.my_ftr {
	background-color: white;
	padding-top: 9px;
	overflow: scroll
}

.my_ftr .text {
	font-family: Roboto, Arial, Helvetica;
	font-size: 14px;
	color: #404040;
	padding: 5px 10px;
	height: 70px;
	border: 1px solid #dfdfdf;
}
</style>
<script>
var bodyLayout, dbTree,winF,popW; 
var aLay, bLay, cLay;
var bTabs, bTab1, bTab2, bTab3, bActvId;
var cTabs, cTab1, cTab2, cTab3, cActvId;
var tableInfoGrid;
var resultGrids = [];
var select, sql, logList;
var forDelTag = /\<\/?\w+\>/gi;
function connectionListCB(res){
   dbTree = aLay.attachTreeView({
       items: res.list
   });
   dbTree.attachEvent("onDblClick",function(id){
	   var level = dbTree.getLevel(id);
      if(level==2){
     	  var text =  dbTree.getItemText(id);
    	  var au = new AjaxUtil("${root}/connection/tables/" + text + "/" + id,null,"get");
          au.send(tableListCB);
      }else if(level==3){
    	    var pId= dbTree.getParentId(id);
			var dbName = dbTree.getItemText(pId);
			var text = dbTree.getItemText(id);
			var tableName = text.substring(0,text.indexOf(":"));
			var au = new AjaxUtil("${root}/connection/columns/" + dbName + "/" + tableName,null,"get");
			au.send(columnListCB);
      }
   });
}
function dbListCB(res){
	   console.log(res);
	   if(res.error){
	      alert(res.error);
	      return;
	   }
	   var parentId = res.parentId;
	   for(var db of res.list){
	      var id = db.id;
	      var text = db.text;
	      dbTree.addItem(id, text, parentId);
	   }
	   dbTree.openItem(parentId);
	}
function tableListCB(res){
	   var parentId = res.parentId;
	   var i=1;
	   for(var table of res.list){
	      var id = parentId + "_" + i++;
	      var text = table.tableName;
	      if(table.tableComment!=""){
	         text += "[" + table.tableComment + "]";
	      }
	      text += ":("+ table.tableSize + "KB)"; 
	      dbTree.addItem(id, text, parentId);
	   }
	   dbTree.openItem(parentId);
	}
	
function columnListCB(res){
	if(res.list){
		tableInfoGrid = bTabs.tabs("tableInfo").attachGrid();
		var columns = res.list[0];
		var headerStr = "";
		var colTypeStr = "";
		for(var key in columns){
			if(key=="id") continue;
			headerStr += key + ",";
			colTypeStr += "ro,";
		}
		headerStr = headerStr.substr(0, headerStr.length-1);
		colTypeStr = colTypeStr.substr(0, colTypeStr.length-1);
        tableInfoGrid.setColumnIds(headerStr);
		tableInfoGrid.setHeader(headerStr);
		tableInfoGrid.setColTypes(colTypeStr);
        tableInfoGrid.init();
		tableInfoGrid.parse({data:res.list},"js");
		console.log(res);
	}
}

function querySelectCB(res){
	
	if(res.errorMsg){
		alert(res.errorMSG);
	}
	if(res.conMSG){
		alert(res.conMSG);
	}
	var cTabbar = cLay.attachTabbar();
	if(res.lists){
		var key;
		for(key in res.lists){
			var list = res.lists[key]
			cTabbar.addTab("result"+key,"결과#"+key);
			idx = resultGrids.length;
			resultGrids[key]=cTabbar.tabs("result"+key).attachGrid();
			var columns = list[0];
			var headerStr = "";
			var colTypeStr = "";
			for (var colId of Object.keys(columns)) {
				if(colId=="id") continue;
				headerStr += colId + ",";
				colTypeStr += "ro,";
			}
			headerStr = headerStr.substr(0, headerStr.length-1);
			colTypeStr = colTypeStr.substr(0, colTypeStr.length-1);
			resultGrids[key].setColumnIds(headerStr);
			resultGrids[key].setHeader(headerStr);
			resultGrids[key].setColTypes(colTypeStr);
			resultGrids[key].init();
			resultGrids[key].parse({data:list},"js");
		}
		cTabbar.tabs("result"+key).setActive();
	}
	$("#resultMSG").append("<br><em><b>"+res.selectMsg+"</b></em>");
	$("#resultMSG").append("<br><em><b>"+res.updateMsg+"</b></em>");
		console.log(res);
	}


function addConnectionCB(res){
   console.log(res.msg);
}

/* function queryEvent(sql){
	select = /select/gi;
	if(select.test(sql)){
		var auFQ = new AjaxUtilFQ("${root}/query/select/",sql,null,"post");
		auFQ.send(querySelectCB);
	}else{
		var auFQ = new AjaxUtilFQ("${root}/query/update/",sql,null,"post");
		auFQ.send(queryUpdateCB);
	}
} */
dhtmlxEvent(window,"load",function(){
	bodyLayout = new dhtmlXLayoutObject(document.body,"3L");
	logFoot = bodyLayout.attachFooter("footDiv");
	aLay = bodyLayout.cells("a");
	aLay.setWidth(300);
	aLay.setText("Connection Info List");
	var aToolbar = aLay.attachToolbar();
	aToolbar.addButton("addcon",1,"add Connector");
	aToolbar.addButton("condb",2,"Connection");
	aToolbar.attachEvent("onClick",function(id){
	      if(id=="condb"){
	         var rowId =dbTree.getSelectedId();
	         if(!rowId){
	            alert("접속할 커넥션을 선택해주세요.");
	            return;
	         }
	         var au = new AjaxUtil("${root}/connection/db_list/" + rowId,null,"get");
	         au.send(dbListCB); 
	      }else if(id=="addcon"){
	         popW.show();
	      }
	   })
	   
	bTabs = bodyLayout.cells("b").attachTabbar({
       align:              "left",        
       skin:               "dhx_skyblue",  
       close_button:       true,           
       hrefmode:           "ajax",         
       arrows_mode:        "auto",
       
	 	    tabs: [
		        {
		            id:      "tableInfo",     
		            text:    "TABLE INFO",   
		            width:   null,     
		            index:   1,    
		            active:  true,   
		            enabled: true, 
		            close:   false
		        },
		        {
		        	id:      "tableData",      
		            text:    "TABLE DATA",    
		            width:   null,      
		            index:   2,     
		            active:  true,    
		            enabled: true,    
		            close:   false
		        },
		        {
		        	id:      "sql",      
			            text:    "QUERY",  
			            width:   null,     
			            index:   3,     
			            active:  true,      
			            enabled: true,     
			            close:   true,
	   }
		    ]
	});
	
   var qEditor = bTabs.tabs("sql").attachEditor({
	   content:"Type some Query here",
	   });
   qEditor.attachEvent("onAccess", function(eventName, evObj){
	    if (eventName == "keydown") {
		   	bActvId = bTabs.getActiveTab();
		   	if(evObj.which==120 && evObj.ctrlKey && evObj.shiftKey && bActvId=="sql"){
		   		sql = qEditor.getContent().replace(forDelTag,"");
		   		var auFQ = new AjaxUtilFQ("${root}/query/select/",sql,null,"post");
				auFQ.send(querySelectCB);
		   	}
	    }
	});
	cLay = bodyLayout.cells("c");
	cLay.setText("ResultSet");
   var au = new AjaxUtil("${root}/connection/list",null,"POST");
   au.send(connectionListCB); 

   winF = new dhtmlXWindows();
   popW = winF.createWindow("win1",20,30,320,300);
   //popW.hide(); 
   popW.setText("Add Connection Info"); 
   var formObj = [
              {type:"settings", offsetTop:12,name:"connectionInfo",labelAlign:"left"},
            {type:"input",name:"ciName", label:"커넥션이름",required:true},
            {type:"input",name:"ciUrl", label:"접속URL",required:true},
            {type:"input",name:"ciPort", label:"PORT번호",validate:"ValidInteger",required:true},
            {type:"input",name:"ciDatabase", label:"데이터베이스",required:true},
            {type:"input",name:"ciUser", label:"유저ID",required:true},
            {type:"password",name:"ciPwd", label:"비밀번호",required:true},
            {type:"input",name:"ciEtc", label:"설명"},
            {type: "block", blockOffset: 0, list: [
               {type: "button", name:"saveBtn",value: "저장"},
               {type: "newcolumn"},
               {type: "button", name:"cancelBtn",value: "취소"}
            ]}
      ];
   var form = popW.attachForm(formObj,true);
   popW.hide();
   
   form.attachEvent("onButtonClick",function(id){
      if(id=="saveBtn"){
         if(form.validate()){
            form.send("${root}/connection/insert", "post",0.);
         }
      }else if(id=="cancelBtn"){
         form.clear();
      }
   });
})
	
$(document).ready(function(){
	$("#header").hide();
	
});

</script>
<body>
	<div id="footDiv" class="my_ftr">
		<div id="resultMSG" class="text">
			<em><b>LOG</b></em>
		</div>
	</div>
</body>
</html>