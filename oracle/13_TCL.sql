/*
TCL (TRANSACTION CONTROL LANGUAGE)
- 트랜잭션을 제어하는 언어
- 데이텁메이스는 데이터의 변경 사항 (UNSERT, UPDATE, DELETE)들을 묶어서 하나의 트랜잭션에 담아서 처리한다

트랜잭션 (TRANSACTION)
- 하나의 논리적인 작업 단위
EX) ATM기에서 현금을 출력
    1. 카드 삽입
    2. 메뉴 선택
    3. 금액 확인 및 인증
    4. 실제 계좌에서 금액만큼 인출
    5. 현금 인출
    6. 완료
- 각각의 업무들을 묶어서 하나의 작업 단위로 만드는 것을 트랜잭션이라고 한다

COMMIT
- 모든 작업들을 정상적으로 처리하겠다고 확정하는 구문

ROLLBACK
- 모든 작업들을 취소하겠다고 확정하는 구문
  (마지막 COMMIT 시점으로 돌아간다.)
  
SAVEPOINT
- 저장점을 지정하고 ROLLBACK 진행 시 전체 작업을 ROLLBACK 하는것이 아닌 SAVEPOINT 까지의 일부만 롤백 한다.

[표현법]
SAVEPOINT 포인트명;
...
ROLLBACK TO 포인트명;
*/

CREATE TABLE EMP_TEST
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT *
FROM EMP_TEST;

-- EMP_TEST 테이블에서 EMP_ID가 213, 218인 사원 삭제하기
DELETE FROM EMP_TEST
WHERE EMP_ID IN (213, 218);

-- 두개의 행이 삭제된 시점에서 SAVEPOINT 지정
SAVEPOINT SP1;

-- EMP_TEST 테이블에서 EMP_ID가 200인 사원 삭제
DELETE FROM EMP_TEST
WHERE EMP_ID = 200;

-- 213, 218 사원은 삭제되어있고 200은 복구됨
ROLLBACK TO SP1;

SELECT *
FROM EMP_TEST;

-- EMP_TEST 테이블에서 EMP_ID가 202인 사원 삭제
DELETE FROM EMP_TEST
WHERE EMP_ID = 202;

-- DDL구문 (CREATE) 을 실행하는 순간 기존 메모리 버퍼에 임시저장된 변경사항들이 무조건 DB에 반영된다
CREATE TABLE TEST (
    TID NUMBER
);

-- DDL 구문이 실행되었기 때문에 롤백해도 삭제한 202 사원이 복구되지 않음
ROLLBACK;

SELECT *
FROM EMP_TEST;

-- JDBC --
CREATE TABLE CUSTOMER (
    NAME VARCHAR2(20),
    AGE NUMBER,
    ADDRESS VARCHAR2(100)
);

SELECT *
FROM CUSTOMER;

CREATE TABLE BANK(
    NAME VARCHAR2(20),
    BANKNAME VARCHAR2(40),
    BALANCE NUMBER
);

INSERT INTO BANK VALUES('김도경', '국민은행', 1000000);
INSERT INTO BANK VALUES('김민소', '신한은행', 500000);

SELECT *
FROM BANK;

COMMIT;