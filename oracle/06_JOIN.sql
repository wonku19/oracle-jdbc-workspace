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

/*
2. 오라클 - 포괄 조인 / ANSI - 외부조인 (OUTER JOIN)
- 두 테이블 간의 JOIN시 일치하지 않은 행도 포함시켜서 조회가 가능
- 단, 반드시 기준이 되는 테이블(컬럼)을 지정해야 한다.
  (LEFT, RIGHT, FULL, (+))
*/

-- 사원명, 부서명, 급여, 연봉 조회
-- 부서배치가 아직 안된 사원 2명에 대한 정보는 조회가 안됨
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼쪽에 기술된 테이블을 기준으로 JOIN
-- 부서배치를 받지 않았던 2명의 사원 정보도 조회가 됨 
-->> ANSI 구문
-- SELECT 에 기재된 왼쪽 테이블(EMP_NAME)이 기준이 된다
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-->> 오라클 구문
-- 기준으로 삼고자 하는 테이블의 반대편 테이블의 컬럼 뒤에 (+) 붙이기
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블을 기준으로 JOIN
-->> ANSI 구문
-- SELECT 에 기재된 오른쪽 테이블(DEPT_TITLE)이 기준이 된다
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE 
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-->> 오라클 구문
-- 기준으로 삼고자 하는 테이블의 반대편 테이블의 컬럼 뒤에 (+) 붙이기
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회 할 수 있음
-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE 
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
-->> 오라클 구문 (에러 발생! 오라클 구문으로는 FULL JOIN 안됨!)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);

/*
3. 비등가 조인(NON EQUAL JOIN)
매칭시킬 컬럼에 대한 조건 작성 시 '='(등호) 를 사용하지 않는 조건문
값의 범위에 포함되는 행들을 연결하는 방식
ANSI 구문으로는 JOIN ON으로만 사용 가능 / USING은 사용 불가
*/

-- 사원명, 급여, 급여레벨
SELECT EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT SAL_LEVEL, MIN_SAL, MAX_SAL
FROM SAL_GRADE;

-->> ANSI 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);
-->> 오라클 구문
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

/*
4. 자체 조인(SELF JOIN)
- 같은 테이블을 다시 한번 조인하는 경우 (자기 자신과 조인)
*/

-- 사원사번, 사원명, 사원부서코드, 사수사번, 사수명, 사수부서코드
SELECT *
FROM EMPLOYEE;
-->> 오라클 구문
SELECT E.EMP_ID "사원사번", E.EMP_NAME "사원명", E.DEPT_CODE "사원부서코드", M.EMP_ID "사수사번", M.EMP_NAME "사수명", M.DEPT_CODE "사수부서코드"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);
-->> ANSI 구문
SELECT E.EMP_ID "사원사번", E.EMP_NAME "사원명", E.DEPT_CODE "사원부서코드", M.EMP_ID "사수사번", M.EMP_NAME "사수명", M.DEPT_CODE "사수부서코드"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

/*
5. 카테시안곱(CARTESION PRODUCT) / 교차 조인(CROSS JOIN)
- 조인되는 모든 테이블의 각 행들이 서로서로 모두 매핑된 데이터가 검색된다. (곱집합)
- 두 테이블의 행들이 모두 곱해진 행들의 조합이 출력
  -> 방대한 데이터 출력으로 과부하의 위험이 있음
*/
-->> ANSI 구문
-- 사원명 23명, 부서 9개 2개가 곱해져서 사원명당 부서명이 크로스되어 207개가 조회됨
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT
ORDER BY EMP_NAME;
-->> 오라클 구문
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
ORDER BY EMP_NAME;

/*
6. 다중 JOIN
- 여러개의 테이블을 조인하는 경우
*/
-- 사번, 사원명, 부서명, 직급명
-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING(JOB_CODE);
-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE;

-- 사번, 사원명, 부서명, 지역명 조회하기
-->> ANSI 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "지역명"
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
-->> 오라클 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "지역명"
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID AND LOCATION_ID = LOCAL_CODE;

-- 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
-- (모든 테이블 다 조인)
-- >> ANSI 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명", JOB_NAME "직급명", LOCAL_NAME "지역명", NATIONAL_NAME "국가명", SAL_LEVEL "급여등급"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);
-- >> 오라클 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", DEPT_TITLE "부서명", JOB_NAME "직급명", LOCAL_NAME "지역명", NATIONAL_NAME "국가명", SAL_LEVEL "급여등급"
FROM EMPLOYEE E, DEPARTMENT D, JOB J, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID 
  AND E.JOB_CODE = J.JOB_CODE 
  AND D.LOCATION_ID = L.LOCAL_CODE 
  AND L.NATIONAL_CODE = N.NATIONAL_CODE 
  AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;


-- 실습문제
-- 1. 직급이 대리이면서 ASIA 지역에 근무하는 직원들의 사번, 직원명, 직급명, 부서명, 근무지역, 급여를 조회
-->> ANSI 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역", SALARY "급여"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE '%ASIA%';
-->> 오라클 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역", SALARY "급여"
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE JOB_NAME = '대리' 
  AND LOCAL_NAME LIKE '%ASIA%' 
  AND E.JOB_CODE = J.JOB_CODE 
  AND E.DEPT_CODE = D.DEPT_ID 
  AND D.LOCATION_ID = L.LOCAL_CODE;

-- 2. 70년생이면서 여자, 성이 전씨인 직원의 직원명, 주민번호, 부서명, 직급명 조회
-->> ANSI 구문
SELECT EMP_NAME "사원명", EMP_NO "사원 주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE EMP_NAME LIKE '전%' AND SUBSTR(EMP_NO, 8, 1) = 2 AND EMP_NO LIKE '7%';
-->> 오라클 구문
SELECT EMP_NAME "사원명", EMP_NO "사원 주민번호", DEPT_TITLE "부서명", JOB_NAME "직급명"
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE EMP_NAME LIKE '전%' 
  AND SUBSTR(EMP_NO, 8, 1) = 2 
  AND EMP_NO LIKE '7%' 
  AND E.DEPT_CODE = D.DEPT_ID 
  AND E.JOB_CODE = J.JOB_CODE;

-- 3. 보너스를 받는 직원들의 직원명, 보너스, 연봉, 부서명, 근무지역을 조회 단 부서코드가 없어도 출력되어야함
-->> ANSI 구문
SELECT EMP_NAME "사원명", BONUS "보너스", SALARY*12 "연봉", DEPT_TITLE "부서명", LOCAL_NAME "근무지역"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
WHERE BONUS IS NOT NULL;

-->> 오라클 구문
SELECT EMP_NAME "사원명", BONUS "보너스", SALARY*12 "연봉", DEPT_TITLE "부서명", LOCAL_NAME "근무지역"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE BONUS IS NOT NULL 
  AND E.DEPT_CODE = D.DEPT_ID(+)
  AND D.LOCATION_ID = L.LOCAL_CODE(+);

-- 4. 한국과 일본에서 근무하는 직원들의 직원명, 부서명, 근무지역, 근무국가 조회
-->> ANSI 구문
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역", NATIONAL_NAME "근무 국가"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국', '일본');

-->> 오라클 구문
SELECT EMP_NAME "사원명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역", NATIONAL_NAME "근무 국가"
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID 
  AND D.LOCATION_ID = L.LOCAL_CODE 
  AND L.NATIONAL_CODE = N.NATIONAL_CODE 
  AND NATIONAL_NAME IN ('한국', '일본');

-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균급여(정수처리) 를 조회 단 부서배치가 안된 사원들의 평균도 같이 나오게
-->> ANSI 구문
SELECT DEPT_TITLE, ROUND(AVG(NVL(SALARY,0))) "평균급여"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY DEPT_TITLE;

-->> 오라클 구문
SELECT DEPT_TITLE "부서명", ROUND(AVG(NVL(SALARY,0))) "평균급여"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+)
GROUP BY DEPT_TITLE;

-- 6. 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회
-->> ANSI 구문
SELECT DEPT_TITLE "부서명", SUM(SALARY) "급여의 합"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= 10000000;

-->> 오라클 구문
SELECT DEPT_TITLE "부서명", SUM(SALARY) "급여의 합"
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= 10000000;

-- 7. 사번, 직원명, 직급명, 급여등급, 구분을 조회 이때 구분에 해당하는 값은 급여등급이 S1, S2 = 고급 / S3, S4 = 중급 / S5, S6 = 초급 로 조회하기
-->> ANSI 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명", SAL_LEVEL "급여등급",
    CASE WHEN SAL_LEVEL IN ('S1', 'S2') THEN '고급'
         WHEN SAL_LEVEL IN ('S3', 'S4') THEN '중급'
         WHEN SAL_LEVEL IN ('S5', 'S6') THEN '초급'
    END "구분"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL);

-->> 오라클 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명", SAL_LEVEL "급여등급",
    CASE WHEN SAL_LEVEL IN ('S1', 'S2') THEN '고급'
         WHEN SAL_LEVEL IN ('S3', 'S4') THEN '중급'
         WHEN SAL_LEVEL IN ('S5', 'S6') THEN '초급'
    END "구분" 
FROM EMPLOYEE E, JOB J, SAL_GRADE S
WHERE E.JOB_CODE = J.JOB_CODE 
  AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL;

-- 8. 보너스를 받지 않는 직원들 중 직급 코드가 J4, J7인 직원들의 직원명, 직급명, 급여를 조회
-->> ANSI 구문
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE BONUS IS NULL
  AND J.JOB_CODE IN ('J4', 'J7');

-->> 오라클 구문
SELECT EMP_NAME "사원명", JOB_NAME "직급명", SALARY "급여"
FROM EMPLOYEE E, JOB J 
WHERE E.JOB_CODE = J.JOB_CODE
  AND J.JOB_CODE IN ('J4', 'J7');

-- 9. 부서가 있는 직원들의 직원명, 직급명, 부서명, 근무지역을 조회
-->> ANSI 구문
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-->> 오라클 구문
SELECT EMP_NAME "사원명", JOB_NAME "직급명", DEPT_TITLE "부서명", LOCAL_NAME "근무지역"
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID
  AND D.LOCATION_ID = L.LOCAL_CODE;

-- 10. 해외영업팀에 근무하는 직원들의 직원명, 직급명, 부서코드, 부서명 조회
-->> ANSI 구문
SELECT EMP_NAME "사원명", JOB_NAME "직급명",E.DEPT_CODE "부서코드", DEPT_TITLE "부서명"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
WHERE DEPT_TITLE LIKE '해외영업%';

-->> 오라클 구문
SELECT EMP_NAME "사원명", JOB_NAME "직급명",E.DEPT_CODE "부서코드", DEPT_TITLE "부서명"
FROM EMPLOYEE E, JOB J, DEPARTMENT D
WHERE DEPT_TITLE LIKE '해외영업%'
  AND E.JOB_CODE = J.JOB_CODE
  AND E.DEPT_CODE = D.DEPT_ID;

-- 11. 이름에 '형' 자가 들어있는 직원들의 사번, 직원명, 직급명을 조회
-->> ANSI 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명"
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE EMP_NAME LIKE '%형%';

-->> 오라클 구문
SELECT EMP_ID "사번", EMP_NAME "사원명", JOB_NAME "직급명"
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
  AND EMP_NAME LIKE '%형%';