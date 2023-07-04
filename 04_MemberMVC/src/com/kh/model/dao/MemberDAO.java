package com.kh.model.dao;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import com.kh.model.vo.Member;

import config.ServerInfo;

/*
 dao 란?
 Database Access Object 의 약자로 디비에 접근하는 로직 (일명 비지니스 로직) 을 담고 있는 객체 
 */

public class MemberDAO implements MemberDAOTemplate {
	
private Properties p = new Properties();
	
	public MemberDAO() {
		try {
			p.load(new FileInputStream("src/config/jdbc.properties"));
			Class.forName(ServerInfo.DRIVER_NAME);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	public Connection getConnect() throws SQLException {
		return DriverManager.getConnection(ServerInfo.URL, ServerInfo.USER, ServerInfo.PASSWORD);
	}
	
	public void closeAll(PreparedStatement st, Connection conn) throws SQLException {
		st.close();
		conn.close();
	}
	
	public void closeAll(ResultSet rs, PreparedStatement st, Connection conn) throws SQLException {
		rs.close();
		closeAll(st, conn);
	}
	
	public void registerMember(Member vo) throws SQLException { // 멤버등록
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("registerMember"));
		st.setString(1, vo.getId());
		st.setString(2, vo.getPassword());
		st.setString(3, vo.getName());
		st.executeUpdate();
		closeAll(st, conn);
	}
	
	public void updatePassword(Member vo) throws SQLException { // 비번변경
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("updatePassword"));
		st.setString(1, vo.getPassword());
		st.setString(2, vo.getId());
		st.executeUpdate();
		closeAll(st, conn);
	}
	
	public void updateName(Member vo) throws SQLException { // 이름변경
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("updateName"));
		st.setString(1, vo.getName());
		st.setString(2, vo.getId());
		st.executeUpdate();
		closeAll(st, conn);
	}
	
	public Member getMember(String id) throws SQLException { // 멤버 조회
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("getMember"));
		st.setString(1, id);
		ResultSet rs = st.executeQuery();
		Member m = null;
		if(rs.next()) {
			m = new Member(id, rs.getString("password"), rs.getString("name"));
		}
		closeAll(rs, st, conn);
		return m;
	}
	
	public Member login(Member vo) throws SQLException { // 로그인
		Connection conn = getConnect();
		PreparedStatement st = conn.prepareStatement(p.getProperty("login"));
		st.setString(1, vo.getId());
		st.setString(2, vo.getPassword());
		ResultSet rs = st.executeQuery();
		Member m = null;
		if(rs.next()) {
			m = new Member(rs.getString("id"), rs.getString("password"), rs.getString("name"));
		}
		closeAll(rs, st, conn);
		return m;
	}

}
