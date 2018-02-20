package com.exam.spring.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.exam.spring.service.ConnectionService;
import com.exam.spring.vo.ColumnVO;
import com.exam.spring.vo.ConnectionInfoVo;
import com.exam.spring.vo.EmployeeVo;
import com.exam.spring.vo.TableVO;

@Controller
@RequestMapping("/connection")
public class ConnectionInfoController {
	private static final Logger log = LoggerFactory.getLogger(ConnectionInfoController.class);
	@Autowired
	ConnectionService cis;

	@Autowired
	ObjectMapper om;
	
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> getConnectionInfoList(@RequestParam Map<String, Object> map,
			HttpSession hs) {
		EmployeeVo em = new EmployeeVo();
		if (hs.getAttribute("emp") != null) {
			em = (EmployeeVo) hs.getAttribute("emp");
		} else {
			em.setEmID("sujang45");
		}
		ConnectionInfoVo ci = new ConnectionInfoVo();
		ci.setEmID(em.getEmID());
		List<ConnectionInfoVo> ciList = cis.getConnectionInfoList(ci);
		map.put("list", ciList);
		return map;
	}
	
	@RequestMapping(value="/db_list/{ciNo}", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getDatabaseList(@PathVariable("ciNo") int ciNo,
			Map<String,Object> map,HttpSession hs) {
		List<Map<String, Object>> dbList;
		try {
			dbList = cis.getDatabaseList(hs, ciNo);
			map.put("list", dbList);
			map.put("parentId", ciNo);
		} catch (Exception e) {
			map.put("error",e.getMessage());
			log.error("db connection error =>{}",e);
		}
		return map;
	}

	@RequestMapping(value="/insert", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> insertConnectionInfo(@Valid ConnectionInfoVo ci, Map<String,Object> map) {
		log.info("ci=>{}",ci);
		cis.getInsertConnectionInfo(map, ci);
		return map;
	}
	@RequestMapping(value="/tables/{dbName}/{parentId}", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getTabeList(
			@PathVariable("dbName")String dbName, 
			@PathVariable("parentId")String parentId,
			HttpSession hs,
			Map<String,Object> map) {
		log.info("useDB=>{}",cis.getUseDB(hs, dbName));
		log.info("dbName=>{}",dbName);
		List<TableVO> tableList = cis.getTableList(hs, dbName);
		map.put("list", tableList);
		map.put("parentId", parentId);
		return map;
	}

	@RequestMapping(value="/columns/{dbName}/{tableName}", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getColumnList(
			@PathVariable("dbName")String dbName, 
			@PathVariable("tableName")String tableName,
			HttpSession hs,
			Map<String,Object> map) {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("dbName", dbName);
		pMap.put("tableName", tableName);
		log.info("{}",pMap);
		List<ColumnVO> columnList = cis.getColumnList(hs, pMap);
		map.put("list", columnList);
		log.info("{}",columnList);
		return map;
	}
	
	@RequestMapping(value="/tabledata", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getTableDataList(
			@PathVariable("dbName")String dbName, 
			@PathVariable("tableName")String tableName,
			HttpSession hs,
			Map<String,Object> map) {
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("dbName", dbName);
		pMap.put("tableName", tableName);
		log.info("{}",pMap);
		List<ColumnVO> columnList = cis.getColumnList(hs, pMap);
		map.put("list", columnList);
		log.info("{}",columnList);
		return map;
	}
	
}
