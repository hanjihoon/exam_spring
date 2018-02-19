package com.exam.spring.vo;

import org.springframework.stereotype.Component;

@Component
public class EmployeeVo {
	private int emNo;
	private String emName;
	private String emID;
	private String emPwd;
	private int dpNo;
	private String emAd;
	private String emEmail;
	private String emPhone;
	private String emReg;
	private String emSal;
	private int admin;

	

	public int getEmNo() {
		return emNo;
	}



	public void setEmNo(int emNo) {
		this.emNo = emNo;
	}



	public String getEmName() {
		return emName;
	}



	public void setEmName(String emName) {
		this.emName = emName;
	}



	public String getEmID() {
		return emID;
	}



	public void setEmID(String emID) {
		this.emID = emID;
	}



	public String getEmPwd() {
		return emPwd;
	}



	public void setEmPwd(String emPwd) {
		this.emPwd = emPwd;
	}



	public int getDpNo() {
		return dpNo;
	}



	public void setDpNo(int dpNo) {
		this.dpNo = dpNo;
	}



	public String getEmAd() {
		return emAd;
	}



	public void setEmAd(String emAd) {
		this.emAd = emAd;
	}



	public String getEmEmail() {
		return emEmail;
	}



	public void setEmEmail(String emEmail) {
		this.emEmail = emEmail;
	}



	public String getEmPhone() {
		return emPhone;
	}



	public void setEmPhone(String emPhone) {
		this.emPhone = emPhone;
	}



	public String getEmReg() {
		return emReg;
	}



	public void setEmReg(String emReg) {
		this.emReg = emReg;
	}



	public String getEmSal() {
		return emSal;
	}



	public void setEmSal(String emSal) {
		this.emSal = emSal;
	}



	public int getAdmin() {
		return admin;
	}



	public void setAdmin(int admin) {
		this.admin = admin;
	}



	@Override
	public String toString() {
		return "EmployeeVo [emNo=" + emNo + ", emName=" + emName + ", emID=" + emID + ", emPwd=" + emPwd + ", dpNo="
				+ dpNo + ", emAd=" + emAd + ", emEmail=" + emEmail + ", emPhone=" + emPhone + ", emReg=" + emReg
				+ ", emSal=" + emSal + ", admin=" + admin + "]";
	}
}
