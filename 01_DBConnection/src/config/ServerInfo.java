package config;

public interface ServerInfo {
	
	/*
	 디비 서버 정보에 상수값으로 구성된 인터페이스 
	 */

	String DRIVER_NAME = "oracle.jdbc.driver.OracleDriver";
	String URL = "jdbc:oracle:thin:@localhost:1521:xe";
	String USER = "kh";
	String PASSWORD = "kh";
	
}
