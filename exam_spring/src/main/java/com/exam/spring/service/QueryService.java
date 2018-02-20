package com.exam.spring.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

public interface QueryService {
	public List<List<Map<String, Object>>> getSelectQuery(ArrayList<String> sql, HttpSession hs, Map<String, Object> rMap);

	public int getUpdateQuery(ArrayList<String> sql, HttpSession hs, Map<String, Object> rMap);
}
