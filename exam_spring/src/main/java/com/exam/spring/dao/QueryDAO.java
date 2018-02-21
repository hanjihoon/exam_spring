package com.exam.spring.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

public interface QueryDAO {

	public List<Map<String, Object>> selectQuery(String sql, SqlSession ss);

	public int updateQuery(String sql, SqlSession ss);

}
