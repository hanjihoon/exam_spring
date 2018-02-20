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

	@RequestMapping(value = "/select", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> getQuerySelect(@RequestBody String sql, Map<String, Object> map,
			HttpSession hs) {
		log.info("{}", sql);
		if (hs.getAttribute("sqlSession") != null) {
			ArrayList<String> updateSqlList = new ArrayList<String>();
			ArrayList<String> selectSqlList = new ArrayList<String>();
			String[] sqlList = sql.split(";");
			for (String str : sqlList) {
				if (str.indexOf("select") != -1) {
					selectSqlList.add(str);
				} else {
					updateSqlList.add(str);
				}
			}
			if (selectSqlList != null) {
			List<List<Map<String, Object>>> selectLists = new ArrayList<List<Map<String, Object>>>();
			selectLists = qs.getSelectQuery(selectSqlList, hs, map);
			map.put("lists", selectLists);
			}
			if (updateSqlList != null) {
				qs.getUpdateQuery(updateSqlList, hs, map);
			}
			log.info("{}", map);
		} else {
			map.put("conMSG", "커넥션이 필요합니다!");
		}
		return map;
	}
}
