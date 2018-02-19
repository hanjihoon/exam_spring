package com.exam.spring.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.exam.spring.vo.ColumnVO;
import com.exam.spring.vo.ConnectionInfoVo;
import com.exam.spring.vo.TableVO;

public interface ConnectionService {
	public List<ConnectionInfoVo> getConnectionInfoList(ConnectionInfoVo ci);
	public ConnectionInfoVo getConnectionInfoOne(int ciNo);
	public void getInsertConnectionInfo(Map<String,Object> rMap,ConnectionInfoVo ci);
	public void getUpdateConnectionInfo(ConnectionInfoVo ci);
	public void getDeleteConnectionInfo(int ciNo);
	public List<Map<String,Object>> getDatabaseList(HttpSession hs, int ciNo) throws Exception;
	public List<TableVO> getTableList(HttpSession hs, String dbName);
	public List<ColumnVO> getColumnList(HttpSession hs, Map<String,String> map);
	public int getUseDB(HttpSession hs, String dbname);
}
