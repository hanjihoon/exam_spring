package com.exam.spring.controller;

import java.util.ArrayList;
import java.util.HashMap;
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

import com.exam.spring.service.impl.EmpInfoServiceImpl;
import com.exam.spring.vo.EmployeeVo;

@Controller
@RequestMapping("/emp")
public class EmpInfoController {
	private static final Logger log = LoggerFactory.getLogger(EmpInfoController.class);
	List<Integer> loginFailedCheck = new ArrayList<Integer>();
	@Autowired
	EmpInfoServiceImpl eis;

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> login(EmployeeVo em, HttpSession hs) {
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("returnMap=>{}", map);
		map.put("msg", "아이디 혹은 비밀번호를 확인해주세요");
		map.put("biz", false);
		hs.setAttribute("loginFailedCheck", loginFailedCheck);
		if (eis.login(em)) {
			hs.setAttribute("emp", map.get("emp"));
			map.put("msg", em.getEmName() + "님 로그인에 성공하셨습니다.");
			map.put("biz", true);
			map.put("emp", em);
		} else {
			if (loginFailedCheck.size() < 5) {
				loginFailedCheck.add(1);
			}
		}
		log.info("loginFailedCheck=>{}", hs.getAttribute("loginFailedCheck"));
		log.info("emp_hs=>{}", hs.getAttribute("emp"));
		return map;
	}

	@RequestMapping(value = "/checkid", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> checkID(EmployeeVo em, HttpSession hs) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (eis.getEmpInfo(em) != null) {
			hs.setAttribute("checkId", 0);
			map.put("msg", "아이디가 중복됩니다.");
		} else {
			hs.setAttribute("checkId", 1);
			map.put("msg", "사용가능한 아이디입니다.");
		}
		return map;
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> join(@RequestBody EmployeeVo em, HttpSession hs) {
		Map<String, Object> map = new HashMap<String, Object>();
		log.info("insertUI=>{}", em);
		if (hs.getAttribute("checkId") != null) {
			map.put("msg", "회원 가입 실패");
			map.put("biz", false);
			if (eis.join(em) == 1) {
				map.put("msg", "회원 가입 성공");
				map.put("biz", true);
			} else if (eis.join(em) == 2) {
				map.put("msg", "아이디 중복입니다!");
			}
		} else {
			map.put("msg", "아이디 중복체크를 해주세요!");
		}
		return map;
	}
}
