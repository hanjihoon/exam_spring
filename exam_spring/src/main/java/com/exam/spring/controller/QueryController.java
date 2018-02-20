package com.exam.spring.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.exam.spring.service.QueryService;

@Controller
@RequestMapping("/query")
public class QueryController {
	private static final Logger log = LoggerFactory.getLogger(QueryController.class);
	@Autowired
	QueryService qs;

	@RequestMapping(value = "/", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> getQuerySelect(@RequestBody String sql, Map<String, Object> map,
			HttpSession hs) {
		log.info("{}", sql);
		if (hs.getAttribute("sqlSession") != null) {
			int updateResult = 0;
			int selectResult = 0;
			int sumResult = 0;
			ArrayList<String> updateSqlList = new ArrayList<String>();
			ArrayList<String> selectSqlList = new ArrayList<String>();
			String[] sqlList = sql.trim().split(";");
			for (String str : sqlList) {
				if (str.indexOf("select") != -1) {
					selectSqlList.add(str);
				} else {
					updateSqlList.add(str);
				}
			}
			if (selectSqlList.size() > 0) {
				List<List<Map<String, Object>>> selectLists = new ArrayList<List<Map<String, Object>>>();
				selectLists = qs.getSelectQuery(selectSqlList, hs, map);
				for (List<Map<String, Object>> list : selectLists) {
					selectResult += list.size();
				}
				sumResult += selectLists.size();
				map.put("lists", selectLists);
			}
			if (updateSqlList.size() > 0) {
				updateResult = qs.getUpdateQuery(updateSqlList, hs, map);
				sumResult += updateSqlList.size();
			}
			map.put("sqlMsg", sqlList);
			map.put("logMsg", "/* Affected rows: " + updateResult + " 찾은 행: " + selectResult + " 경고: 0 지속 시간 "
					+ sumResult + "*/");
			log.info("{}", map);
		} else {
			map.put("conMSG", "커넥션이 필요합니다!");
		}
		return map;
	}
}
