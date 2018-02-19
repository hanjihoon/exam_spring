package com.exam.spring.dao;

import com.exam.spring.vo.EmployeeVo;

public interface EmpInfoDAO {
	public EmployeeVo selectEmpInfo(EmployeeVo em);
	public int insertEmpInfo(EmployeeVo em);
}
