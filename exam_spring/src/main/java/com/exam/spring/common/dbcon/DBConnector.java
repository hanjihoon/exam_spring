package com.exam.spring.common.dbcon;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Repository;

import com.exam.spring.vo.ConnectionInfoVo;

@Repository
public class DBConnector {
	private BasicDataSource bds;
	private SqlSessionFactoryBean ssf;
	
	public void setConnectionInfo(ConnectionInfoVo ci)throws Exception {
		bds = new BasicDataSource();
		bds.setDriverClassName("org.mariadb.jdbc.Driver");
		String url = "jdbc:mysql://" + ci.getCiUrl() + ":" + ci.getCiPort() + "/" + ci.getCiDatabase();
		bds.setUrl(url);
		bds.setUsername(ci.getCiUser());
		bds.setPassword(ci.getCiPwd());
		ssf = new SqlSessionFactoryBean();
		ssf.setDataSource(bds);
		ssf.setConfigLocation(new ClassPathResource("/conf/custom-mybatis-conf.xml"));
	}
	
	public SqlSession getSqlSession() throws Exception{
		return ssf.getObject().openSession();
	}
}
