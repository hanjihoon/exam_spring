package com.exam.spring.vo;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

@Component
public class ConnectionInfoVo {
	private int	ciNo;
	private String ciName;
	private String ciUrl;
	private int ciPort;
	private String ciDatabase;
	private String ciUser;
	private String ciPwd;
	private String ciEtc;
	private String emID;
	private String id;
	private String text;
	private Object[] items;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public Object[] getItems() {
		return items;
	}
	public void setItems(Object[] items) {
		this.items = items;
	}
	public String getEmID() {
		return emID;
	}
	public void setEmID(String emID) {
		this.emID = emID;
	}
	private List<Map<String,Object>> database;
	
	
	public List<Map<String, Object>> getDatabase() {
		return database;
	}
	public void setDatabase(List<Map<String, Object>> database) {
		this.database = database;
	}
	public int getCiNo() {
		return ciNo;
	}
	public void setCiNo(int ciNo) {
		this.ciNo = ciNo;
	}
	public String getCiName() {
		return ciName;
	}
	public void setCiName(String ciName) {
		this.ciName = ciName;
	}
	public String getCiUrl() {
		return ciUrl;
	}
	public void setCiUrl(String ciUrl) {
		this.ciUrl = ciUrl;
	}
	public int getCiPort() {
		return ciPort;
	}
	public void setCiPort(int ciPort) {
		this.ciPort = ciPort;
	}
	public String getCiDatabase() {
		return ciDatabase;
	}
	public void setCiDatabase(String ciDatabase) {
		this.ciDatabase = ciDatabase;
	}
	public String getCiUser() {
		return ciUser;
	}
	public void setCiUser(String ciUser) {
		this.ciUser = ciUser;
	}
	public String getCiPwd() {
		return ciPwd;
	}
	public void setCiPwd(String ciPwd) {
		this.ciPwd = ciPwd;
	}
	public String getCiEtc() {
		return ciEtc;
	}
	public void setCiEtc(String ciEtc) {
		this.ciEtc = ciEtc;
	}
	@Override
	public String toString() {
		return "ConnectionInfoVo [ciNo=" + ciNo + ", ciName=" + ciName + ", ciUrl=" + ciUrl + ", ciPort=" + ciPort
				+ ", ciDatabase=" + ciDatabase + ", ciUser=" + ciUser + ", ciPwd=" + ciPwd + ", ciEtc=" + ciEtc
				+ ", emId=" + emID + ", id=" + id + ", text=" + text + ", items=" + Arrays.toString(items)
				+ ", database=" + database + "]";
	}
	
}
