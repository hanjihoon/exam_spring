/**
 * 
 */

function pageMove(param){
	if(param){
		document.getElementById("urlStr").value = param;
		$("#urlForm").submit();
	}else{
		alert("url을 입력해주세요.");
	}
}

function urlSubmit(f){
	return true;
}

var AjaxUtilDx = function (url, dxObj, type, dataType){
	if(!url){
		alert("url정보가 없습니다.");
		return null;
	}
	this.url = url;
	var initData = {};
	
	if(dxObj && dxObj instanceof window.dhtmlXForm){
		var value = dxObj.getFormData();
		this.param = JSON.stringify(value);
	}else if(dxObj && dxObj instanceof dhtmlXGridObject ){
		var rowId = dxObj.getSelectedRowId();
		var colCnt = dxObj.getColumnCount();
		for(var i=0;i<colCnt;i++){
			var name = dxObj.getColumnId(i);
			var value = dxObj.cells(rowId, i).getValue();
			initData[name] = value;
		}
		this.param = JSON.stringify(initData);
	}
	
	this.type = type?type:"POST";
	this.dataType = dataType?dataType:"json";
	this.callbackSuccess = function(json){
    	var url = json.url;
    	var data = json.data;
    	var msg = json.msg;
    	if(msg){
    		alert(msg);
    	}
    	if(url){
        	pageMove(url);
    	}
	}
	
	this.setCallbackSuccess = function(callback){
		this.callbackSuccess = callback;
	}
	
	this.send = function(callback){
		if(callback){
			this.callbackSuccess = callback;
		}
		$.ajax({ 
	        type     : this.type
	    ,   url      : this.url
	    ,   dataType : this.dataType 
	    ,   beforeSend: function(xhr) {
	        xhr.setRequestHeader("Accept", "application/json");
	        xhr.setRequestHeader("Content-Type", "application/json");
	    }
	    ,   data     : this.param
	    ,   success : this.callbackSuccess
	    ,   error : function(xhr, status, e) {
		    	alert("에러 : "+e);
		},
		done : function(e) {
		}
		});
	}
}
var AjaxUtil = function (url, params, type, dataType){
	if(!url){
		alert("url정보가 없습니다.");
		return null;
	}
	this.url = url;
	
	var initData = {}	
	this.param = JSON.stringify(initData);
	if(params){
		var paramArr = params.split(",");

		var data = {};
		for(var i=0,max=paramArr.length;i<max;i++){
			var objType =  paramArr[i].split("_")[0];
			var objName = paramArr[i].split("_")[1];
			
			if(objType=="it"){
				data[objName] = $("input[name=" + objName +"]").val();
			}else if(objType=="s"){
				data[objName] = $("select[name=" + objName +"]").val();
			}
		}
		this.param = JSON.stringify(data);
		alert(this.param);
	}
	this.type = type?type:"POST";
	this.dataType = dataType?dataType:"json";
	this.callbackSuccess = function(json){
    	var url = json.url;
    	var data = json.data;
    	var msg = json.msg;
    	if(msg){
    		alert(msg);
    	}
    	if(url){
        	pageMove(url);
    	}
	}
	
	this.setCallbackSuccess = function(callback){
		this.callbackSuccess = callback;
	}
	
	this.send = function(callback){
		if(callback){
			this.callbackSuccess = callback;			
		}
		$.ajax({ 
	        type     : this.type
	    ,   url      : this.url
	    ,   dataType : this.dataType 
	    ,   beforeSend: function(xhr) {
	        xhr.setRequestHeader("Accept", "application/json");
	        xhr.setRequestHeader("Content-Type", "application/json");
	    }
	    ,   data     : encodeURIComponent(this.param)
	    ,   success : this.callbackSuccess
	    ,   error : function(xhr, status, e) {
	    	
		    	alert("에러 : "+e);
		},
		done : function(e) {
		}
		});
	}
}

var AjaxUtilFQ = function (url, params, type, dataType){
	if(!url){
		alert("url정보가 없습니다.");
		return null;
	}
	this.url = url;
	
	var initData = {}	
	this.param = JSON.stringify(initData);
	if(params){
		this.param = params;
	}
	this.type = type?type:"POST";
	this.dataType = dataType?dataType:"json";
	this.callbackSuccess = function(json){
    	var url = json.url;
    	var data = json.data;
    	var msg = json.msg;
    	if(msg){
    		alert(msg);
    	}
    	if(url){
        	pageMove(url);
    	}
	}
	
	this.setCallbackSuccess = function(callback){
		this.callbackSuccess = callback;
	}
	
	this.send = function(callback){
		if(callback){
			this.callbackSuccess=callback;
			this.callbackSuccess = function (res){
				if(res.errorMSG){
					alert(res.errorMSG);
					return;
				}
				callback(res);
			}
		}
		$.ajax({ 
	        type     : this.type
	    ,   url      : this.url
	    ,   header:{
	    	"Accept":"application/json",
	    	"Content-Type":"application/json; charset=UTF-8"
	    }
	    ,   beforeSend: function(xhr) {
	        xhr.setRequestHeader("Accept", "application/json");
	        xhr.setRequestHeader("Content-Type", "application/json; charset=utf-8");
	    }
	    ,   data     : this.param
	    ,   success : this.callbackSuccess
	    ,   error : function(xhr, status, e) {
		    	alert("에러 : "+e+" " +xhr);
		},
		done : function(e) {
		}
		});
	}
}


function mdel(mid){
	if(confirm("삭제하시겠습니까?")){
		$("#mode").val("del");
		$("#userid").val(mid);
		var au = new AjaxUtil("/user/userlistaction","it_mode,it_userid");
		au.setCallbackSuccess(returnDel);
		au.send();
	}
}
function returnDel(list){
	var url = list.url;
	var data = list.data;
	var msg = list.msg;
	alert(msg);
	pageMove(url);
}
function sess_chg(ids, vals){
	if(confirm("권한을 설정하시겠습니까?")){
		$("#userid").val(ids);
		$("#role").val(vals);
		var au = new AjaxUtil("/exam/user/sessionRegi","userid,role");
		au.setCallbackSuccess(returnSession);
		au.send();
	}
}
function returnSession(result){
	var url = result.url;
	alert("설정되었습니다.");
	pageMove(url);
}

/*
 * dhtmlx 커스터 마이징
 */
dhtmlXCellObject.prototype.hideAll = function(){
   this.button("close").hide();
   this.button("minmax").hide();
   this.button("park").hide();
}

dhtmlXWindows.prototype.center = function(){
   this.window("win1").centerOnScreen();
   this.window("win1").denyMove();
   this.window("win1").denyResize();
}
