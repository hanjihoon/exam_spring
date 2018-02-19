package com.exam.spring.dao.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.exam.spring.dao.ConnectionDAO;
import com.exam.spring.vo.ColumnVO;
import com.exam.spring.vo.ConnectionInfoVo;
import com.exam.spring.vo.TableVO;

@Repository("connection.dao")
public class ConnectionDAOImpl implements ConnectionDAO {

	@Autowired
	private SqlSessionFactory ssf;

	@Override
	public List<ConnectionInfoVo> selectConnectionInfoList(ConnectionInfoVo ci) {
		SqlSession ss = ssf.openSession();
		List<ConnectionInfoVo> conList = ss.selectList("con.selectConnectionInfoList", ci);
		ss.close();
		return conList;
	}

	@Override
	public ConnectionInfoVo selectConnectionInfoOne(int ciNo) {
		SqlSession ss = ssf.openSession();
		ConnectionInfoVo ci = ss.selectOne("con.selectConnectionInfoWithCiNo", ciNo);
		ss.close();
		return ci;
	}

	@Override
	public int insertConnectionInfo(ConnectionInfoVo ci) {
		int result = 0;
		SqlSession ss = ssf.openSession();
		result = ss.insert("con.insertConnectionInfo", ci);
		ss.close();
		return result;
	}

	@Override
	public int updateConnectionInfo(ConnectionInfoVo ci) {

		return 0;
	}

	@Override
	public int deleteConnectionInfo(int ciNo) {

		return 0;
	}

	@Override
	public List<Map<String, Object>> selectDatabaseList(SqlSession ss) throws Exception {
		return ss.selectList("con.selectDatabases");
	}


	@Override
	public List<TableVO> selectTableList(SqlSession ss,String dbName) {
		List<TableVO> result = null;
		result = ss.selectList("con.selectTable",dbName);
		return result;
	}

	@Override
	public List<ColumnVO> selectColumnList(SqlSession ss,Map<String,String> map) {
		return ss.selectList("con.selectColumn",map);
	}

	@Override
	public int useDB(SqlSession ss, String dbname) {
		
		return ss.update("con.userDB",dbname);
	}

}
