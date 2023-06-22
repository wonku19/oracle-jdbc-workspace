/*
JOIN
- 두개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
- 조회 결과는 하나의 결과물(RESULT SET) 으로 나옴
- 관계형 데이터 베이스는 최소한의 데이터로 각각의 테이블에 담고 있음 (중복을 최소화 하기 위해 최대한 쪼개서 관리)
  EX) 부서 데이터는 부서 테이블, 사원에 대한 데이터는 사원 테이블, 직급에 대한 데이터는 직급 테이블 ....
      만약 어떤 사원이 어떤 부서에 속해있는지 부서명과 같이 조회하고 싶다면?
      만약 어떤 사원이 어떤 직급인지 직급명과 같이 조회하고 싶다면?
  => 즉 관계형 데이터베이스에서 SQL문을 이용한 테이블 간에 '관계' 를 맺어 원하는 데이터를 조회하는 방법
- 크게 '오라클 구문' 과 'ANSI 구문' 으로 나뉜다
- ANSI(미국국립표준협회 = 산업표준을 제정하는 단체) : 다른 DBMS에서도 사용이 가능하다
*/
/*
1. 오라클 - 등가 조인(EQUAL JOIN) / ANSI - 내부조인(INNER JOIN / NATURAL JOIN)
- 연결시키는 컬럼의 값이 일치하는 행들만 조인되서 조회한다 (일치하는 값이 없는 행은 조회가 안된다)

1) 오라클 전용 구문
SELECT 컬럼, 컬럼, ...., 컬럼
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼명 = 테이블2.컬럼명;
- FROM 절에 조회하고자 하는 테이블들을 콤마로 구분하여 나열한다 (2개 이상도 가능)
- WHERE 절에 매칭 시킬 컬럼명에 대한 조건 제시

2) ANSI 표준 구문
SELECT 컬럼, 컬럼, ..., 컬럼
FROM 테이블1
JOIN 테이블2 ON (테이블1.컬럼명 = 테이블2.컬럼명)
- FROM 절에서 기준이 되는 테이블을 기술한다
- JOIN 절에서 같이 조회하고자 하는 테이블을 기술 후 매칭 시킬 컬럼에 대한 조건을 기술한다 (USING 구문과 ON 구문 둘중 하나를 사용한다)
- 연결에 사용하려는 컬럼명이 같은 경우 ON 구문 대신에 USING(컬럼명) 구문을 사용한다
*/

-- 1) 연결할 두 컬럼명이 다른 경우
-- 사번, 사원명, 부서코드, 부서명을 같이 조회
-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결할 두 컬럼명이 같은 경우
-- 사번, 사원명, 직급코드, 직급명
-->> 오라클 구문
-->> 해결방법1) 테이블명을 이용한 처리방법
SELECT EMP_ID, EMP_NAME, JOB.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
-->> 해결방법2) 테이블에 별칭을 부여해서 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-->> ANSI 구문
-->> 해결방법1) 테이블명 또는 별칭을 이용해서 하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);
-->> 해결방법2) JOIN USING 구문 사용방법 (두 컬럼명이 일치할때만)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 자연조인(NATURAL JOIN) : 각 테이블마다 동일한 컬럼이 한 개만 존재할 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- 직급이 대리인 사원의 사번, 이름, 직급명, 급여 조회
-->> 자연조인 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE JOB_NAME = '대리';
-->> 오라클 구문 별칭 X
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE AND JOB_NAME = '대리';
-->> 오라클 구문 별칭 O
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND JOB_NAME = '대리';
-- 오라클 구문에서 AND 사용 시 꼭 JOIN 이후에 사용해야 한다
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

-- 실습문제 --
-- 1. 부서가 인사관리부인 사원들의 사번, 이름, 보너스 조회
-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE = '인사관리부';
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

-- 2. DEPARTMENT와 LOCATION을 참고해서 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
-->> 오라클 구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;
-->> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명
-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND BONUS IS NOT NULL;
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE BONUS IS NOT NULL;

-- 4. 부서가 총무부가 아닌 사원들이 사원명, 급여, 조회
-->> 오라클 구문
SELECT EMP_NAME, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID AND DEPT_TITLE != '총무부';
-->> ANSI 구문
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '총무부';