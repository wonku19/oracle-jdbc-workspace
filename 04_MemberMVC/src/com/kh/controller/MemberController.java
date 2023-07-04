package com.kh.controller;

import java.sql.SQLException;

import com.kh.model.dao.MemberDAO;
import com.kh.model.vo.Member;

public class MemberController {

	private MemberDAO dao = new MemberDAO();
	
	public boolean joinMembership(Member m) {
		
		// controller에서 try~catch!
		// id가 없다면 회원가입 후 true 반환
		// 없다면 false 값 반환
	
			return false;	
		
		
	}
	
	public String login(String id, String password) {

		// 로그인 성공하면 이름 반환
//		// 실패하면 null 반환
		
		
		
		return null;
	}
	
	public boolean changePassword(String id, String oldPw, String newPw) {

		// 로그인 했을 때 null이 아닌 경우
		// 비밀번호 변경 후 true 반환, 아니라면 false 반환
		
		return false;
	}
	
	public void changeName(String id, String name) {
		
	}
	
}