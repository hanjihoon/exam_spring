package com.exam.spring.dao;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;

import com.exam.spring.vo.ColumnVO;
import com.exam.spring.vo.ConnectionInfoVo;
import com.exam.spring.vo.TableVO;

public interface ConnectionDAO {
	public List<ConnectionInfoVo> selectConnectionInfoList(ConnectionInfoVo ci);
	public ConnectionInfoVo selectConnectionInfoOne(int ciNo);
	public int insertConnectionInfo(ConnectionInfoVo ci);
	public int updateConnectionInfo(ConnectionInfoVo ci);
	public int deleteConnectionInfo(int ciNo);
	public List<Map<String,Object>> selectDatabaseList(SqlSession ss) throws Exception;
	public List<TableVO> selectTableList(SqlSession ss, String dbName);
	public List<ColumnVO> selectColumnList(SqlSession ss, Map<String,String> map);
	public int useDB(SqlSession ss, String dbname);
}
