/*
뷰 (VIEW)
- SELECT 문을 저장할 수 있는 객체
- 가상 테이블 (실제 데이터가 담겨져있는것은 아니다 => 논리적인 테이블 이라고 함)
- DML(INSERT, UPDATE, DELETE)작업이 가능 (단, 일부만)

* 사용목적
- 편리성 : SELECT 문의 복잡도 완화
- 보안성 : 테이블의 특정 열을 노출하고 싶지 않은 경우
*/

-- '한국' 에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
-- '러시아' 에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
-- '일본' 에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '러시아';

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME = '일본';

/*
1. VIEW 생성 방법
[표현식]
CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
AS 서브쿼리
[WITH CHECK OPTION]
[WITH READ ONLY];

* VIEW 옵션들
- OR REPLACE : 뷰 생성시 기존에 중복된 이름의 뷰가 없다면 새로이 뷰를 생성하고, 기존에 중복된 이름의 뷰가 있다면 해당 뷰를 변경(갱신) 하는 옵션
- FORCE : 서브쿼리에 기술된 테이블이 존재하지 않는 테이블이어도 뷰가 생성된다.
- NOFORCE : 서브쿼리에 기술된 테이블이 존재해야만 뷰가 생성된다. (기본값)
- WITH CHECK OPTION : 서브 쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생 시킨다.
- WITH READ ONLY : 뷰에 대해 조회만 가능하다. (DML 수행 불가 SELECT만 가능해짐)
*/

-- 뷰 생성 권한 부여 (관리자 계정으로 권한 부여하기!)
GRANT CREATE VIEW TO KH;

-- 뷰 생성
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN LOCATION ON (LOCAL_CODE = LOCATION_ID)
JOIN NATIONAL USING (NATIONAL_CODE);

-- 가상의 테이블로 실제 데이터가 담겨있는것은 아님!
SELECT *
FROM VW_EMPLOYEE;

-- 참고사항 : 접속한 계정이 가지고 있는 VIEW에 대한 정보를 조회하는 뷰 테이블
SELECT *
FROM USER_VIEWS;

-- 아래 3가지 뷰 사용해서 조회해보기
-- '한국' 에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
-- '러시아' 에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
-- '일본' 에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회

SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '한국';

SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '러시아';

SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '일본';

/*
뷰 컬럼에 별칭 부여
- 서브쿼리에 SELECT 절에 함수식이나 산술연산식이 기술되어 있을 경우 반드시 별칭을 지정해야 VIEW 생성이 가능하다
*/

-- 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회하기
SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자') "성별", EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근속년수"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

-- 1) 서브쿼리에서 별칭 부여하기
-- 위 내용 뷰 (VW_EMP_JOB) 로 정의해서 만들어보기
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자') "성별", EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근속년수"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

SELECT *
FROM VW_EMP_JOB;

-- 뷰 삭제
DROP VIEW VW_EMP_JOB;

-- 2) 뷰 생성 시 모든 컬럼에 별칭을 부여하는 방법
-- 2번 방법의 단점은 모든 컬럼에 별칭을 부여해야 한다는점이다
CREATE OR REPLACE VIEW VW_EMP_JOB("사번", "사원명", "직급명", "성별", "근무년수")
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자') , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

SELECT *
FROM VW_EMP_JOB;

-- 성별이 남자인 사원의 사원명, 직급명
SELECT 사원명, 직급명
FROM VW_EMP_JOB
WHERE 성별 = 남;

-- 근무년수가 20년 이상인 사원 조회
SELECT *
FROM VW_EMP_JOB
WHERE 근무년수 > 20;

/*
VIEW를 이용해서 DML(INSERT, UPDATE, DELETE) 사용 가능
- 뷰를 통해서 조작하게 되면 실제 데이터가 담겨있는 베이스테이블에 반영된다
*/
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
   FROM JOB;
   
SELECT *
FROM VW_JOB;
-- VIEW : 논리적인 테이블 (실제 데이터가 담겨있진 않음)
SELECT *
FROM JOB;
-- 베이스 테이블 (실제 데이터가 담겨져 있음)

-- 뷰를 통한 INSERT
INSERT INTO VW_JOB VALUES('J8', '인턴');

-- 뷰를 통한 UPDATE
-- JOB_CODE 가 J8 인 JOB_NAME 을 알바 로 변경하기
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

-- 뷰를 통한 DELETE
DELETE
FROM VW_JOB
WHERE JOB_CODE = 'J8';

DROP VIEW VW_JOB;

/*
DML 구문으로 VIEW 조작이 불가능한 경우
1. 뷰 정의에 포함되지 않는 컬럼을 조작하는 경우
2. 뷰에 포함되지 않는 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우
3. 산술표현식 또는 함수식으로 정의된 경우
4. 그룹함수나 GRUOP BY 절을 포함한 경우
5. DISTINCT 구문이 포함된 경우
6. JOIN을 이용해서 여러 테이블을 연결한 경우
*/

-- 1. 뷰 정의에 포함되지 않는 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE
   FROM JOB;
   
-- INSERT
-- JOB_CODE 는 값이 있지만 JOB_NAME 은 값이 없어서 오류 발생함
INSERT INTO VW_JOB VALUES('J8', '인턴');
-- JOB_CODE 값만 입력해서 뷰로도 INSERT 정상 입력됨
INSERT INTO VW_JOB VALUES('J8');

-- UPDATE
-- 뷰에 JOB_NAME 이 없어서 오류 발생
UPDATE VW_JOB SET JOB_NAME = '인턴'
WHERE JOB_CODE = 'J7';
-- JOB_CODE를 뷰가 가지고 있어서 UPDATE 정상 입력됨
UPDATE VW_JOB SET JOB_CODE = 'J0'
WHERE JOB_CODE = 'J8';

-- DELETE
-- 뷰에 JOB_NAME 이 없어서 오류 발생
DELETE FROM VW_JOB
WHERE JOB_NAME = '사원';
-- JOB_CODE를 뷰가 가지고 있어서 DELETE 정상 입력됨
DELETE FROM VW_JOB
WHERE JOB_CODE = 'J0';

-- 2. 뷰에 포함되지 않는 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약조건이 지정된 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME
FROM JOB;

-- INSERT
-- JOB_CODE에 NOT NULL 조건이 있고 INSERT에 JOB_CODE에 대한 입력값이 없어서 오류 발생됨
INSERT INTO VW_JOB VALUES('인턴');

-- UPDATE
-- 정상 입력됨
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_NAME = '사원';

-- DELETE
-- 정상 입력됨
-- 삭제할 값이 다른곳에서 쓰이고 있으면 안될 수 있음
DELETE FROM VW_JOB
WHERE JOB_NAME = '사원';

-- 3. 산술표현식 또는 함수식으로 정의된 경우
CREATE OR REPLACE VIEW VW_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 "연봉"
FROM EMPLOYEE;

-- INSERT
-- 산술 연산으로 정의된 컬럼은 데이터 삽입 불가능
-- 연봉이 산술표현식 (SALALRY*12) 이기 때문에 오류 발생됨
INSERT INTO VW_EMP_SAL VALUES(400, '홍길동', 3000000, 36000000);

INSERT INTO VW_EMP_SAL(EMP_ID, EMP_NAME, SALARY) 
VALUES(400, '홍길동', 3000000);

SELECT *
FROM EMPLOYEE;

-- UPDATE
-- 200번 사원의 연봉을 8000 만원으로
-- 연봉 컬럼은 산술표현식이기 때문에 오류 발생됨
UPDATE VW_EMP_SAL
SET 연봉 = 80000000
WHERE EMP_ID = 200;

-- 200번 사원의 급여를 700 만원으로 
-- 산술연산과 무관한 컬럼은 데이터 변경 가능
UPDATE VW_EMP_SAL
SET SALARY = 7000000
WHERE EMP_ID = 200;

ALTER TABLE EMPLOYEE MODIFY EMP_NO NULL;

ROLLBACK;

-- DELETE
-- 정상 삭제됨
DELETE
FROM VW_EMP_SAL
WHERE 연봉 = 72000000;

-- 4. 그룹함수나 GRUOP BY 절을 포함한 경우
-- 부서별 급여의 합계, 평균을 조회 -> VIEW : VW_GROUPDEPT
SELECT DEPT_CODE, SUM(SALARY), FLOOR(AVG(NVL(SALARY, 0)))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

CREATE OR REPLACE VIEW VW_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) "합계", FLOOR(AVG(NVL(SALARY, 0))) "평균"
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- INSERT
-- 에러 발생됨
INSERT INTO VW_GROUPDEPT VALUES('D3', 8000000, 4000000);

-- UPDATE
-- 에러 발생됨
UPDATE VW_GROUPDEPT
SET 합계 = 8000000
WHERE DEPT_CODE = 'D1';

-- DELETE
-- 에러 발생됨
DELETE
FROM VW_GROUPDEPT
WHERE 합계 = 5210000;

-- 5. DISTINCT 구문이 포함된 경우
CREATE OR REPLACE VIEW VW_DT_JOB
AS SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

SELECT *
FROM VW_DT_JOB;

-- INSERT
-- 에러 발생
INSERT INTO VW_DT_JOB VALUES('J8');

-- UPDATE
-- 에러 발생
UPDATE VW_DT_JOB
SET JOB_CODE = 'J8'
WHERE JOB_CODE = 'J7';

-- DELETE
-- 에러 발생
DELETE FROM VW_DT_JOB
WHERE JOB_CODE = 'J4';

-- 6. JOIN을 이용해서 여러 테이블을 연결한 경우
-- 사원들의 사번, 사원명, 부서명 조회 --> VW_JOINEMP
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

CREATE OR REPLACE VIEW VW_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- INSERT
-- 에러발생
INSERT INTO VW_JOINEMP VALUES(500, '조세오', '총무부');
-- JOIN된 DEPARTMENT 테이블의 값이 아닌 다른값은 INSERT 됨
INSERT INTO VW_JOINEMP(EMP_ID, EMP_NAME) VALUES(500, '조세오');

-- UPDATE
-- JOIN된 테이블이 아닌 테이블의 입력값은 UPDATE됨
UPDATE VW_JOINEMP
SET EMP_NAME = '서동일'
WHERE EMP_ID = 200;
-- JOIN된 테이블에 대한 UPDATE는 에러 발생됨
UPDATE VW_JOINEMP
SET DEPT_TITLE = '회계부'
WHERE EMP_ID = 200;

-- DELETE 
-- DELETE 는 JOIN된 테이블도 삭제 처리됨
DELETE
FROM VW_JOINEMP
WHERE EMP_ID = 200;

DELETE 
FROM VW_JOINEMP
WHERE DEPT_TITLE = '총무부';

ROLLBACK;
