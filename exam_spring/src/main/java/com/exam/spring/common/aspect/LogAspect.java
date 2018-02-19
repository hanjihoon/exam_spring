package com.exam.spring.common.aspect;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.SQLSyntaxErrorException;
import java.util.HashMap;
import java.util.Map;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.codehaus.jackson.map.JsonMappingException;
import org.mybatis.spring.MyBatisSystemException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.exam.spring.dao.NaverTransDAO;

@Service
@Aspect
public class LogAspect {
	@Autowired
	NaverTransDAO ntd;
	private static final Logger log = LoggerFactory.getLogger(LogAspect.class);

	@Before("execution(* com.exam.spring.controller.*Controller.*(..))")
	public void beforeLog(JoinPoint jp) {
		log.info("@Before => {}", jp);
	}

	@Around("execution(* com.exam.spring.controller.*Controller.*(..))")
	public Object aroundLog(ProceedingJoinPoint pjp)
			throws IOException, MyBatisSystemException, SQLSyntaxErrorException, SQLException, JsonMappingException,
			com.fasterxml.jackson.databind.JsonMappingException, Exception {
		log.info("@Around begin");
		Object obj = null;
		long startTime = System.currentTimeMillis();
		try {
			obj = pjp.proceed();
		} catch (Throwable e) {
			log.error("error=>{}", e);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("errorMSG", ntd.getText(e.getMessage()));
			return map;
		}
		log.info("@Around end, RunTime : {} ms", (System.currentTimeMillis() - startTime));
		return obj;
	}

	@After("execution(* com.exam.spring.controller.*Controller.*(..))")
	public void afterLog(JoinPoint jp) {
		log.info("@After => {}", jp);
	}
}
