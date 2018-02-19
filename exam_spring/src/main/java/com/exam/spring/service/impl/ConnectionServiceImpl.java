package com.exam.spring.service.impl;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.exam.spring.common.dbcon.DBConnector;
import com.exam.spring.dao.ConnectionDAO;
import com.exam.spring.service.ConnectionService;
import com.exam.spring.vo.ColumnVO;
import com.exam.spring.vo.ConnectionInfoVo;
import com.exam.spring.vo.TableVO;

@Service("connection.service")
public class ConnectionServiceImpl implements ConnectionService {
	
	private static final Logger log = LoggerFactory.getLogger(ConnectionServiceImpl.class);
	@Autowired
	ConnectionDAO cidao;	
	@Autowired
	private DBConnector dbc;

	@Override
	public List<ConnectionInfoVo> getConnectionInfoList(ConnectionInfoVo ci) {
		List<ConnectionInfoVo> ciList = cidao.selectConnectionInfoList(ci);
		return ciList;
	}

	@Override
	public ConnectionInfoVo getConnectionInfoOne(int ciNo) {

		return null;
	}

	@Override
	public void getInsertConnectionInfo(Map<String, Object> rMap, ConnectionInfoVo ci) {
		int result = 0;
		result = cidao.insertConnectionInfo(ci);
		if (result == 1) {
			rMap.put("msg", "추가 성공!");
		} else {
			rMap.put("msg", "추가 실패!");
		}
	}

	@Override
	public void getUpdateConnectionInfo(ConnectionInfoVo ci) {

	}

	@Override
	public void getDeleteConnectionInfo(int ciNo) {
	}

	public List<Map<String,Object>> getDatabaseList(HttpSession hs,int ciNo)throws Exception {
		ConnectionInfoVo ci = cidao.selectConnectionInfoOne(ciNo);
		dbc.setConnectionInfo(ci);
		SqlSession ss = dbc.getSqlSession();
		hs.setAttribute("sqlSession", ss);
		log.info("sqlSession=>{}",ss);
		List<Map<String,Object>> dbList = cidao.selectDatabaseList(ss);
		int idx = 0;
		for(Map<String,Object> mDb : dbList) {
			mDb.put("id", ciNo + "_" + (++idx));
			mDb.put("text", mDb.get("Database"));
			mDb.put("items", new Object[] {});
		}
		return dbList;
	}

	@Override
	public List<TableVO> getTableList(HttpSession hs, String dbName) {
		SqlSession ss = (SqlSession)hs.getAttribute("sqlSession");
		return cidao.selectTableList(ss, dbName);
	}


	@Override
	public List<ColumnVO> getColumnList(HttpSession hs, Map<String,String> map) {
		SqlSession ss = (SqlSession)hs.getAttribute("sqlSession");
		return cidao.selectColumnList(ss, map);
	}

	@Override
	public int getUseDB(HttpSession hs, String dbname) {
		
		return 0;
	}

}
