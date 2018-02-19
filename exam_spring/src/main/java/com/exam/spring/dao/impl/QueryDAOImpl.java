package com.exam.spring.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.exam.spring.dao.QueryDAO;

@Repository("query.dao")
public class QueryDAOImpl implements QueryDAO {

	@Override
	public List<Map<String, Object>> selectQuery(String sql, SqlSession ss) {
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
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
