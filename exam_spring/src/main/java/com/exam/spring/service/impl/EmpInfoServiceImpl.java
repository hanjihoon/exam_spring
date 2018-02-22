package com.exam.spring.service.impl;

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
	public boolean login(EmployeeVo em) {
		em = emdao.selectEmpInfo(em);
		if (em != null) {
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
