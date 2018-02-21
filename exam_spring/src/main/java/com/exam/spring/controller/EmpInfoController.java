package com.exam.spring.controller;

import java.util.HashMap;
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

import com.exam.spring.service.impl.EmpInfoServiceImpl;
import com.exam.spring.vo.EmployeeVo;

@Controller
@RequestMapping("/emp")
public class EmpInfoController {
	private static final Logger log = LoggerFactory.getLogger(EmpInfoController.class);

	@Autowired
	EmpInfoServiceImpl eis;

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> login(EmployeeVo em, HttpSession hs) {
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("returnMap=>{}", map);
		if (eis.login(map, em)) {
			hs.setAttribute("emp", map.get("emp"));
		}
		log.info("emp_hs=>{}",hs.getAttribute("emp"));
		return map;
	}
	
	@RequestMapping(value = "/checkid", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> checkID(EmployeeVo em, HttpSession hs) {
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("returnMap=>{}", map);
		if (eis.getEmpInfo(em)!=null) {
			hs.setAttribute("checkID", em.getEmID());
		}
		return map;
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> join(@RequestBody EmployeeVo em) {
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("insertUI=>{}", em);
		map.put("msg", "회원갑 실패닷");
		map.put("biz", false);
		if (eis.join(em) == 1) {
			map.put("msg", "회원갑 성공이닷");
			map.put("biz", true);
		} else if (eis.join(em) == 2) {
			map.put("msg", "아이디 중복입니다!");
		}
		return map;
	}
}
