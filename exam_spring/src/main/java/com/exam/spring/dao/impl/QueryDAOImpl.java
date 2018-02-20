package com.exam.spring.dao.impl;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.exam.spring.dao.QueryDAO;

@Repository("query.dao")
public class QueryDAOImpl implements QueryDAO {

	@Override
	public List<Map<String, Object>> selectQuery(String sql, SqlSession ss) {
		List<Map<String, Object>> result = new LinkedList<Map<String, Object>>();
		result = ss.selectList("query.select", sql);
		return result;
	}

	@Override
	public int updateQuery(String sql, SqlSession ss) {
		int result = 0;
		result = ss.update("query.update", sql);
		return result;
	}

}
