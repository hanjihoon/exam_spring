package com.exam.spring.dao.impl;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.exam.spring.dao.EmpInfoDAO;
import com.exam.spring.vo.EmployeeVo;

@Repository
public class EmpInfoDAOImpl implements EmpInfoDAO {
	@Autowired
	private SqlSessionFactory ssf;

	@Override
	public EmployeeVo selectEmpInfo(EmployeeVo pEm) {
		SqlSession ss = ssf.openSession();
		EmployeeVo em = ss.selectOne("em.selectEmployee", pEm);
		ss.close();
		return em;
	}

	@Override
	public int insertEmpInfo(EmployeeVo em) {
		SqlSession ss = ssf.openSession();
		int result = ss.insert("em.insertEmployee", em);
		ss.close();
		return result;
	}

}
