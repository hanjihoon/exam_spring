package com.exam.spring.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.exam.spring.dao.EmpInfoDAO;
import com.exam.spring.service.EmpInfoService;
import com.exam.spring.vo.EmployeeVo;

@Service
public class EmpInfoServiceImpl implements EmpInfoService {
	@Autowired
	private EmpInfoDAO emdao;

	@Override
	public boolean login(Map<String, Object> rMap, EmployeeVo em) {
		em = emdao.selectEmpInfo(em);
		rMap.put("msg", "아이디 혹은 비밀번호를 확인해주세요");
		rMap.put("biz", false);
		if (em != null) {
			rMap.put("msg", em.getEmName() + "님 로그인에 성공하셨습니다.");
			rMap.put("biz", true);
			rMap.put("emp", em);
			return true;
		}
		return false;
	}

	@Override
	public int join(EmployeeVo em) {
		EmployeeVo pEm = new EmployeeVo();
		pEm.setEmID(em.getEmID());
		if (emdao.selectEmpInfo(pEm) != null) {
			return 2;
		}
		return emdao.insertEmpInfo(em);
	}

	@Override
	public EmployeeVo getEmpInfo(EmployeeVo em) {
		return emdao.selectEmpInfo(em);
	}

}
