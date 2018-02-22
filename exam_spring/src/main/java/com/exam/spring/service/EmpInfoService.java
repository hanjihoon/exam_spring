package com.exam.spring.service;

import java.util.Map;

import com.exam.spring.vo.EmployeeVo;

public interface EmpInfoService {
	public boolean login(EmployeeVo em);
	public EmployeeVo getEmpInfo(EmployeeVo em);
	public int join(EmployeeVo em);
}
