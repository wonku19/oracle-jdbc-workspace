 CREATE TABLE TEST (
    TID NUMBER
 );
 -- 관리자 페이지(11_DLC_관리자계정 에서 권한을 주석3번으로 권한을 부여해줘서 정상적으로 TEST테이블이 생성됨
 
 SELECT *
 FROM TEST;
 
 INSERT INTO TEST VALUES(1);
 
 -- 관리자페이지 주석 5, 7번으로 조회 부여 및 회수
 SELECT * 
 FROM KH.EMPLOYEE;

-- 다른 페이지(KH.DEPARTMENT) 에 데이터를 삽입하기 위해 관리자 페이지에서 주석 6번으로 권한을 부여해서 정상 삽입이 가능해짐
INSERT INTO KH.DEPARTMENT(DEPT_ID, DEPT_TITLE, LOCATION_ID)
VALUES('D0', '개발부', 'L1');

-- 관리자 페이지 주석7번으로 조회권한 부여
SELECT *
FROM KH.DEPARTMENT;