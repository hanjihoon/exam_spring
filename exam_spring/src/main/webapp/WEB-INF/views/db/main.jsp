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
}

.my_ftr .text {
	font-family: Roboto, Arial, Helvetica;
	font-size: 14px;
	color: #404040;
	padding: 5px 10px;
	height: 70px;
	border: 1px solid #dfdfdf;
	overflow: auto;
}
</style>
<script>
var bodyLayout, dbTree,winF,popW; 
var aLay, bLay, cLay;
var bTabs, bTab1, bTab2, bTab3, bActvId;
var cTabs, cTab1, cTab2, cTab3, cActvId;
var tableInfoGrid, tableDataGrid;
var resultGrids = [];
var forDelTag = /\<\/?\w+\>/gi;
var queryInit = "Type some Query here";
var addConnectionForm;
var dbName;

function connectionListCB(res){
   dbTree = aLay.attachTreeView({
       items: res.list
   });
   dbTree.attachEvent("onDblClick",function(id){
	   var level = dbTree.getLevel(id);
      if(level==2){
     	  dbName =  dbTree.getItemText(id);
    	  var au = new AjaxUtil("${root}/connection/tables/" + dbName + "/" + id,null,"post");
          au.send(tableListCB);
		  logMsg(dbName);
		  $("#resultMSG").scrollTop($("#resultMSG")[0].scrollHeight);
      }else if(level==3){
    	    var pId= dbTree.getParentId(id);
			dbName = dbTree.getItemText(pId);
			var text = dbTree.getItemText(id);
			var tableName = text.substring(0,text.indexOf(":"));
			var au = new AjaxUtil("${root}/connection/columns/" + dbName + "/" + tableName,null,"post");
			au.send(columnListCB);
			var sql = "select * from "+tableName;
	   		var auFQ = new AjaxUtilFQ("${root}/query/",sql,null,"post");
			auFQ.send(tableDataDB);
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

function logMsg(str){
	$("#resultMSG").append("<br><em><b>use "+str+"</em></b>;");
}

function tableDataDB(res){
	if(res.selectLists){
		tableInfoGrid = bTabs.tabs("tableData").attachGrid();
		var columns = res.selectLists[0][0];
		var headerStr = "";
		var colTypeStr = "";
		var headerStyle = [];
		for(var key in columns){
			if(key=="id") continue;
			headerStr += key + ",";
			colTypeStr += "ro,";
			headerStyle.push("color:blue;");
		}
		headerStr = headerStr.substr(0, headerStr.length-1);
		colTypeStr = colTypeStr.substr(0, colTypeStr.length-1);
        tableInfoGrid.setColumnIds(headerStr);
		tableInfoGrid.setHeader(headerStr,"marker",headerStyle);
		tableInfoGrid.setColTypes(colTypeStr);
        tableInfoGrid.init();
		tableInfoGrid.parse({data:res.selectLists[0]},"js");
		console.log(res);
	}
}
	
function columnListCB(res){
	if(res.list){
		tableInfoGrid = bTabs.tabs("tableInfo").attachGrid();
		var columns = res.list[0];
		var headerStr = "";
		var colTypeStr = "";
		var headerStyle = [];
		for(var key in columns){
			if(key=="id") continue;
			headerStr += key + ",";
			colTypeStr += "ro,";
			headerStyle.push("color:blue;");
		}
		headerStr = headerStr.substr(0, headerStr.length-1);
		colTypeStr = colTypeStr.substr(0, colTypeStr.length-1);
        tableInfoGrid.setColumnIds(headerStr);
		tableInfoGrid.setHeader(headerStr,null,headerStyle);
		tableInfoGrid.setColTypes(colTypeStr);	
        tableInfoGrid.init();
		tableInfoGrid.parse({data:res.list},"js");
		console.log(res);
	}
}

function querySelectCB(res){
	console.log("?");
	if(res.errorMsg){
		alert(res.errorMSG);
	}
	
	if(res.conMSG){
		alert(res.conMSG);
	}

	var cTabbar = cLay.attachTabbar();
	if(res.selectLists){
		var key;
		for(key in res.selectLists){
			var list = res.selectLists[key]
			cTabbar.addTab("result"+key,res.resultTableName[key]);
			idx = resultGrids.length;
			resultGrids[key]=cTabbar.tabs("result"+key).attachGrid();
			var columns = list[0];
			var headerStr = "";
			var colTypeStr = "";
			var headerStyle = [];
			for (var colId of Object.keys(columns)) {
				if(colId=="id") continue;
				headerStr += colId + ",";
				colTypeStr += "ro,";
				headerStyle.push("color:blue;text-align:center;");
			}
			headerStr = headerStr.substr(0, headerStr.length-1);
			colTypeStr = colTypeStr.substr(0, colTypeStr.length-1);
			resultGrids[key].setColumnIds(headerStr);
			resultGrids[key].setHeader(headerStr,null,headerStyle);
			resultGrids[key].setColTypes(colTypeStr);
			resultGrids[key].init();
			resultGrids[key].parse({data:list},"js");
		}
		cTabbar.tabs("result0").setActive();
	}
	for(var sql of res.sqlMsg){
		logMsg(sql);
	}
		logMsg(res.logMsg);
		$("#resultMSG").scrollTop($("#resultMSG")[0].scrollHeight);
	}

function addConnectionCB(xhr,res){
	var res = JSON.parse(res);
    alert(res.msg);
    addConnectionForm.clear();
}

function runQuery(sql){
	sql = sql.replace(forDelTag," ");
	var auFQ = new AjaxUtilFQ("${root}/query/",sql,null,"post");
	auFQ.send(querySelectCB);
}

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
	         var au = new AjaxUtil("${root}/connection/db_list/" + rowId,null,"post");
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
	
   var bTabsQueryEditor = bTabs.tabs("sql").attachEditor({
	   content: queryInit
	   });
   var bTabsQueryToolbar = bTabs.tabs("sql").attachToolbar();
   bTabsQueryToolbar.addButton("run",1,"RUN");
   bTabsQueryToolbar.addButton("clear",2,"CLEAR");
   bTabsQueryToolbar.attachEvent("onClick",function(id){
	      if(id=="run"){
	    	var sql = bTabsQueryEditor.getContent()
	    	runQuery(sql);
	         
	      }else if(id=="clear"){
	    	  bTabsQueryEditor.setContent("");
	      }
	   })
   bTabsQueryEditor.attachEvent("onAccess", function(eventName, evObj){
	    if (eventName == "keydown") {
		   	if(evObj.which==120 && evObj.ctrlKey && evObj.shiftKey && bActvId=="sql"){
		   		var sql = bTabsQueryEditor.getContent();
		   		runQuery(sql);
		   	}
	    }
	    if (eventName == "focus"){
	   		var content = bTabsQueryEditor.getContent();
	   		if(content==queryInit){
	   			bTabsQueryEditor.setContent("");
	   		}
	   	}
	    if (eventName == "keydown"){
	    	if(evObj.which==32){
	    		var str = "SELECT JOIN HOST REPEAT SERIALIZABLE REPLACE AT SCHEDULE RETURNS STARTS MASTER SSL CA\r\n" + 
	    		" NCHAR                                                                                                                                                                                           \r\n" + 
	    		"	   COLUMNS                                                                                                                                                                                          \r\n" + 
	    		"	   COMPLETION                                                                                                                                                                                          WORK                                                                                                                                                                                             \r\n" + 
	    		"	   DATETIME                                                                                                                                                                                           MODE                                                                                                                                                                                               OPEN                                                                                                                                                                                               INTEGER                                                                                                                                                                                            ESCAPE                                                                                                                                                                                             VALUE                                                                                                                                                                                              MASTER_SSL_VERIFY_SERVER_CERT                                                                                                                                                                      SQL_BIG_RESULT                                                                                                                                                                                     DROP                                                                                                                                                                                               GEOMETRYCOLLECTIONFROMWKB                                                                                                                                                                          EVENTS                                                                                                                                                                                             MONTH                                                                                                                                                                                              PROFILES                                                                                                                                                                                           DUPLICATE                                                                                                                                                                                          REPLICATION                                                                                                                                                                                        UNLOCK                                                                                                                                                                                             INNODB                                                                                                                                                                                            YEAR_MONTH                                                                                                                                                                                         SUBJECT                                                                                                                                                                                            PREPARE                                                                                                                                                                                            LOCK                                                                                                                                                                                               NDB                                                                                                                                                                                                CHECK                                                                                                                                                                                              FULL                                                                                                                                                                                               INT4                                                                                                                                                                                               BY                                                                                                                                                                                                 NO                                                                                                                                                                                                 MINUTE                                                                                                                                                                                             PARTITION                                                                                                                                                                                          DATA                                                                                                                                                                                               DAY                                                                                                                                                                                                SHARE                                                                                                                                                                                              REAL                                                                                                                                                                                               SEPARATOR                                                                                                                                                                                          MESSAGE_TEXT                                                                                                                                                                                       MASTER_HEARTBEAT_PERIOD                                                                                                                                                                            DELETE                                                                                                                                                                                             ON                                                                                                                                                                                                 COLUMN_NAME                                                                                                                                                                                        CONNECTION                                                                                                                                                                                         CLOSE                                                                                                                                                                                              X509                                                                                                                                                                                               USE                                                                                                                                                                                                SUBCLASS_ORIGIN                                                                                                                                                                                    WHERE                                                                                                                                                                                              PRIVILEGES                                                                                                                                                                                         SPATIAL                                                                                                                                                                                            EVENT                                                                                                                                                                                              SUPER                                                                                                                                                                                              SQL_BUFFER_RESULT                                                                                                                                                                                  IGNORE                                                                                                                                                                                             SHA2                                                                                                                                                                                               QUICK                                                                                                                                                                                              SIGNED                                                                                                                                                                                             OFFLINE                                                                                                                                                                                            SECURITY                                                                                                                                                                                           AUTOEXTEND_SIZE                                                                                                                                                                                    NDBCLUSTER                                                                                                                                                                                         POLYGONFROMWKB                                                                                                                                                                                     FALSE                                                                                                                                                                                              LEVEL                                                                                                                                                                                              FORCE                                                                                                                                                                                              BINARY                                                                                                                                                                                             TO                                                                                                                                                                                                 CHANGE                                                                                                                                                                                             CURRENT_USER                                                                                                                                                                                       HOUR_MINUTE                                                                                                                                                                                        UPDATE                                                                                                                                                                                             PRESERVE                                                                                                                                                                                           TABLE_NAME                                                                                                                                                                                         INTO                                                                                                                                                                                               FEDERATED                                                                                                                                                                                          VARYING                                                                                                                                                                                            MAX_SIZE                                                                                                                                                                                           HOUR_SECOND                                                                                                                                                                                        VARIABLE                                                                                                                                                                                           ROLLBACK                                                                                                                                                                                           PROCEDURE                                                                                                                                                                                          TIMESTAMP                                                                                                                                                                                         IMPORT                                                                                                                                                                                             AGAINST                                                                                                                                                                                            CHECKSUM                                                                                                                                                                                           COUNT                                                                                                                                                                                              LONGBINARY                                                                                                                                                                                         THEN                                                                                                                                                                                               INSERT                                                                                                                                                                                             ENGINES                                                                                                                                                                                            HANDLER                                                                                                                                                                                            PORT                                                                                                                                                                                               DAY_SECOND                                                                                                                                                                                         EXISTS                                                                                                                                                                                             MUTEX                                                                                                                                                                                              HELP_DATE                                                                                                                                                                                          RELEASE                                                                                                                                                                                            BOOLEAN                                                                                                                                                                                            MOD                                                                                                                                                                                                DEFAULT                                                                                                                                                                                            TYPE                                                                                                                                                                                               NO_WRITE_TO_BINLOG                                                                                                                                                                                 OPTIMIZE                                                                                                                                                                                           SQLSTATE                                                                                                                                                                                           RESET                                                                                                                                                                                              CLASS_ORIGIN                                                                                                                                                                                       INSTALL                                                                                                                                                                                            ITERATE                                                                                                                                                                                            DO                                                                                                                                                                                                 BIGINT                                                                                                                                                                                             SET                                                                                                                                                                                                ISSUER                                                                                                                                                                                             DATE                                                                                                                                                                                               STATUS                                                                                                                                                                                             FULLTEXT                                                                                                                                                                                           COMMENT                                                                                                                                                                                            MASTER_CONNECT_RETRY                                                                                                                                                                               INNER                                                                                                                                                                                              RELAYLOG                                                                                                                                                                                           STOP                                                                                                                                                                                               MASTER_LOG_FILE                                                                                                                                                                                    MRG_MYISAM                                                                                                                                                                                         PRECISION                                                                                                                                                                                          REQUIRE                                                                                                                                                                                            TRAILING                                                                                                                                                                                           PARTITIONS                                                                                                                                                                                         LONG                                                                                                                                                                                               OPTION                                                                                                                                                                                             REORGANIZE                                                                                                                                                                                         ELSE                                                                                                                                                                                               DEALLOCATE                                                                                                                                                                                         IO_THREAD                                                                                                                                                                                          CASE                                                                                                                                                                                               CIPHER                                                                                                                                                                                             CONTINUE                                                                                                                                                                                           FROM                                                                                                                                                                                               READ                                                                                                                                                                                               LEFT                                                                                                                                                                                               ELSEIF                                                                                                                                                                                             MINUTE_SECOND                                                                                                                                                                                      COMPACT                                                                                                                                                                                            DEC                                                                                                                                                                                                FOR                                                                                                                                                                                                WARNINGS                                                                                                                                                                                           MIN_ROWS                                                                                                                                                                                           STRING                                                                                                                                                                                             CONDITION                                                                                                                                                                                          ENCLOSED                                                                                                                                                                                           FUNCTION                                                                                                                                                                                           AGGREGATE                                                                                                                                                                                          FIELDS                                                                                                                                                                                             INT3                                                                                                                                                                                               ARCHIVE                                                                                                                                                                                            AVG_ROW_LENGTH                                                                                                                                                                                     ADD                                                                                                                                                                                                KILL                                                                                                                                                                                               FLOAT4                                                                                                                                                                                             TABLESPACE                                                                                                                                                                                         VIEW                                                                                                                                                                                               REPEATABLE                                                                                                                                                                                         INFILE                                                                                                                                                                                             HELP_VERSION                                                                                                                                                                                       ORDER                                                                                                                                                                                              USING                                                                                                                                                                                              CONSTRAINT_CATALOG                                                                                                                                                                                 MIDDLEINT                                                                                                                                                                                          GRANT                                                                                                                                                                                              UNSIGNED                                                                                                                                                                                           DECIMAL                                                                                                                                                                                            GEOMETRYFROMTEXT                                                                                                                                                                                   INDEXES                                                                                                                                                                                            FOREIGN                                                                                                                                                                                            CACHE                                                                                                                                                                                              HOSTS                                                                                                                                                                                              MYSQL_ERRNO                                                                                                                                                                                        COMMIT                                                                                                                                                                                             SCHEMAS                                                                                                                                                                                            LEADING                                                                                                                                                                                            SNAPSHOT                                                                                                                                                                                           CONSTRAINT_NAME                                                                                                                                                                                    DECLARE                                                                                                                                                                                            LOAD                                                                                                                                                                                               SQL_CACHE                                                                                                                                                                                          CONVERT                                                                                                                                                                                            DYNAMIC                                                                                                                                                                                            COLLATE                                                                                                                                                                                            POLYGONFROMTEXT                                                                                                                                                                                    BYTE                                                                                                                                                                                               GLOBAL                                                                                                                                                                                             LINESTRINGFROMWKB                                                                                                                                                                                  WHEN                                                                                                                                                                                               HAVING                                                                                                                                                                                             AS                                                                                                                                                                                                 STARTING                                                                                                                                                                                           RELOAD                                                                                                                                                                                             AUTOCOMMIT                                                                                                                                                                                         REVOKE                                                                                                                                                                                             GRANTS                                                                                                                                                                                             OUTER                                                                                                                                                                                              CURSOR_NAME                                                                                                                                                                                        FLOOR                                                                                                                                                                                              EXPLAIN                                                                                                                                                                                            WITH                                                                                                                                                                                               AFTER                                                                                                                                                                                              STD                                                                                                                                                                                                CSV                                                                                                                                                                                                DISABLE                                                                                                                                                                                            UNINSTALL                                                                                                                                                                                          OUTFILE                                                                                                                                                                                            LOW_PRIORITY                                                                                                                                                                                       FILE                                                                                                                                                                                               NODEGROUP                                                                                                                                                                                          SCHEMA                                                                                                                                                                                             SONAME                                                                                                                                                                                             POW                                                                                                                                                                                                DUAL                                                                                                                                                                                               MULTIPOINTFROMWKB                                                                                                                                                                                  INDEX                                                                                                                                                                                              MULTIPOINTFROMTEXT                                                                                                                                                                                 DEFINER                                                                                                                                                                                            MASTER_BIND                                                                                                                                                                                        REMOVE                                                                                                                                                                                             EXTENDED                                                                                                                                                                                           MULTILINESTRINGFROMWKB                                                                                                                                                                             CROSS                                                                                                                                                                                              CONTRIBUTORS                                                                                                                                                                                       NATIONAL                                                                                                                                                                                           GROUP                                                                                                                                                                                              SHA                                                                                                                                                                                                ONLINE                                                                                                                                                                                             UNDO                                                                                                                                                                                               IGNORE_SERVER_IDS                                                                                                                                                                                  ZEROFILL                                                                                                                                                                                           CLIENT                                                                                                                                                                                             MASTER_PASSWORD                                                                                                                                                                                    OWNER                                                                                                                                                                                              RELAY_LOG_FILE                                                                                                                                                                                     TRUE                                                                                                                                                                                               CHARACTER                                                                                                                                                                                          MASTER_USER                                                                                                                                                                                        SCHEMA_NAME                                                                                                                                                                                        TABLE                                                                                                                                                                                              ENGINE                                                                                                                                                                                             INSERT_METHOD                                                                                                                                                                                      CASCADE                                                                                                                                                                                           RELAY_LOG_POS                                                                                                                                                                                    SQL_CALC_FOUND_ROWS                                                                                                                                                                              UNION                                                                                                                                                                                             MYISAM                                                                                                                                                                                            LEAVE                                                                                                                                                                                             MODIFY                                                                                                                                                                                            MATCH                                                                                                                                                                                             MASTER_LOG_POS                                                                                                                                                                                    DISTINCTROW                                                                                                                                                                                     	  DESC                                                                                                                                                                                            \r\n" + 
	    		"	  TIME        \r\n" + 
	    		"	  NUMERIC                                                                                                                                                                                          \r\n" + 
	    		"	  EXPANSION                                                                                                                                                                                          CODE                                                                                                                                                                                             \r\n" + 
	    		"	  CURSOR\r\n" + 
	    		"";
	    		var pattern = /\w+/ig;
	    		var arr = str.match(pattern);
	    		var forLastStr = /\w+$/i;
	    		var content = bTabsQueryEditor.getContent();
	    		var lastContent = content.match(forLastStr);
	    		lastContent = lastContent[0];
	    		if(arr.indexOf(lastContent)!=-1 || arr.indexOf(lastContent.toUpperCase())!=-1){
	    			bTabsQueryEditor.setContent(content.replace(lastContent,"<font color=\"blue\">"+ lastContent +"</font>"));
	    			bTabsQueryEditor._focus;
	    		}
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
   addConnectionForm = popW.attachForm(formObj,true);
   popW.hide();
   
   addConnectionForm.attachEvent("onButtonClick",function(id){
      if(id=="saveBtn"){
         if(addConnectionForm.validate()){
        	 addConnectionForm.send("${root}/connection/insert", "post", addConnectionCB);
         }
      }else if(id=="cancelBtn"){
    	  addConnectionForm.clear();
      }
   });
})
	
$(document).ready(function(){
	$("#header").hide(); 
	})
	
	
	
	</script>
<body>
	<div id="footDiv" class="my_ftr">
		<div id="resultMSG" class="text">
			<em><b>LOG</b></em>
		</div>
	</div>
</body>
</html>