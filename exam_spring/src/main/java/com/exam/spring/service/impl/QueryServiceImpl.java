package com.exam.spring.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.exam.spring.dao.QueryDAO;
import com.exam.spring.service.QueryService;

@Service("query.service")
public class QueryServiceImpl implements QueryService {
	@Autowired
	QueryDAO qdao;

	@Override
	public List<List<Map<String, Object>>> getSelectQuery(ArrayList<String> sql, HttpSession hs,
			Map<String, Object> rMap) {
		SqlSession ss = (SqlSession) hs.getAttribute("sqlSession");
		List<List<Map<String, Object>>> qrLists = new ArrayList<List<Map<String, Object>>>();
		for (String str : sql) {
			qrLists.add(qdao.selectQuery(str, ss));
		}
		int index = 0;
		for (List<Map<String, Object>> qrList : qrLists) {
			for (Map<String, Object> map : qrList) {
				map.put("id", ++index);
			}
		}
		return qrLists;
	}

	@Override
	public int getUpdateQuery(ArrayList<String> sql, HttpSession hs, Map<String, Object> rMap) {
		SqlSession ss = (SqlSession) hs.getAttribute("sqlSession");
		int result = 0;
		for (String str : sql) {
			result += qdao.updateQuery(str, ss);
		}
		return result;
	}
}
