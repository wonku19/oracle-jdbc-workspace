/*
함수 : 전달된 컬럼값을 읽어들여서 함수를 실행한 결과를 반환한다
- 단일행 함수 : N 개의 값을 읽어서 N개의 결과값을 리턴한다 (매 행마다 함수 실행 결과를 반환한다)
- 그룹 함수 : N 개의 값을 읽어서 1개의 결과값을 리턴한다 (그룹별로 함수 실행 결과를 반환한다)

주의할점!!
>> SELECT 절에 단일행 함수와 그룹 함수는 함께 사용하지 못함! 이유는 결과행의 갯수가 다르기 때문에!
>> 함수식을 기술할 수 있는 위치 : SELECT, WHERE, ORDER BY, GROUP BY, HAVING
*/

-- 단일행 함수 --
/*
문자 처리 함수
LENGTH / LENGTHB
- LENGHT(컬럼|'문자열값') : 해당 값의 글자 수 반환
- LENGTHB (컬럼|'문자열값') : 해당 값의 바이트 수 반환

한글 한글자 -> 3 BYTE
영문, 숫자, 특수문자 한글자 -> 1 BYTE
*/
SELECT LENGTH('오라클'), LENGTHB('오라클'), LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL; -- DUAL : 오라클에서 기본적으로 제공하는 가상테이블

-- 사원명, 사원명의 글자 수, 사원명의 바이트 수, 이메일, 이메일의 글자 수, 이메일의 바이트 수 조회
SELECT EMP_NAME 사원명, LENGTH(EMP_NAME) "사원명(글자수)", LENGTHB(EMP_NAME) "사원명(바이트)", EMAIL 이메일, LENGTH(EMAIL) "이메일(글자수)", LENGTHB(EMAIL) "이메일(바이트)"
FROM EMPLOYEE;

/*
INSTR
- INSTR(STRING, STR [, POSITION, OCCURRENCE])
- 지정된 위치부터 지정된 숫자 번째로 나타나는 문자의 시작 위치를 반환

설명
- STRING : 문자 타입 컬럼 또는 문자열
- STR : 찾으려는 문자열
- POSITION : 찾을 위치의 시작 값 (기본값 1)
  1 : 앞에서부터 찾는다.
  -1 : 뒤에서부터 찾는다.
- OCCURRENCE : 찾을 문자값이 반복될 때 지정하는 빈도 (기본값 1), 음수 사용 불가
*/
SELECT INSTR('AABAACAABBAA', 'B')
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1, 2)
FROM DUAL;

-- 'S'가 포함되어있는 이메일 중 이메일, 이메일의 @ 위치, 이메일에서 뒤에서 2번째에 있는 'S' 위치 조회
SELECT EMAIL, INSTR(EMAIL, '@'), INSTR(EMAIL, 's', -1, 2)
FROM EMPLOYEE
WHERE EMAIL LIKE '%s%';

/*
LPAD / RPAD
- 문자열을 조회할 때 통일감 있게 조회하고자 할 때 사용한다
- LPAD/RPAD(STRING, 최종적으로 반환할 문자의 길이, [덧붙이고자 하는 문자])
- 문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열을 반환한다
*/
SELECT LPAD('HELLO', 10) -- 덧붙이고자하는 문자 생략 시 공백으로 채운다
FROM DUAL;

SELECT LPAD('HELLO', 10, 'A')
FROM DUAL;

SELECT RPAD('HELLO', 10)
FROM DUAL;

SELECT RPAD('HELLO', 10, '*')
FROM DUAL;

/*
LTRIM / RTRIM
- 문자열에서 특정 문자를 제거한 나머지를 반환한다
- LTRIM/RTRIM(STRING, [제거하고자하는 문자들])
- 문자열의 왼쪽 또는 오른쪽에서 제거하고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환한다.
*/

-- 제거하고자 하는 문자 생략 시 기본값으로 공벡을 제거한다
SELECT LTRIM('         K  H         ')
FROM DUAL;

SELECT LTRIM('ACABACCKH', 'ABC')
FROM DUAL;

SELECT RTRIM('5782KH123', '0123456789')
FROM DUAL;

/*
TRIM
- 문자열의 양쪽(앞/뒤)에 있는 지정한 문자들을 제거한 나머지 문자열을 반환한다
- TRIN([LEADING|TRAILING|BOTH] 제거하고자하는 문자들 FORM STRING)
*/
SELECT TRIM('        K  H        ')
FROM DUAL;

SELECT TRIM('Z' FROM 'ZZZKHZZZ') -- LEADING|TRAILING|BOTH 생략 시 기본값은 BOTH
FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZKHZZZ') -- LEADING 는 LTRIM 과 똑같다
FROM DUAL;

SELECT TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ') -- TRAILING 는 RTRIM 과 똑같다
FROM DUAL;

SELECT TRIM(BOTH 'Z' FROM 'ZZZKHZZZ') 
FROM DUAL;

/*
SUBSTR
- 문자열에서 특정 문자열을 추출해서 반환한다
- SUBSTR(STRING, POSITION, [LENGHT])
  STRING : 문자타입컬럼 또는 '문자열값'
  POSITION : 문자열을 추출할 시작 위치값 (음수값도 가능, 음수값이면 뒤에서부터 추출)
  LENGTH : 추출할 문자 개수 (생략시 끝까지)
*/
SELECT SUBSTR('PROGRAMMING', 5, 2)
FROM DUAL;

SELECT SUBSTR('PROGRAMMING', -8, 3)
FROM DUAL;

-- 여자 사원들의 이름만 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8) LIKE '2%';
--WHERE SUBSTR(EMP_NO, 8, 1) = '2'; -- 위와 같은 결과의 조건식
--WHERE SUBSTR(EMP_NO, 8, 1) IN (2, 4); -- 뒷자리가 4로 시작하는 여성이 있을경우 쓸 수 있는 조건식

-- 남자 사원들의 이름만 조회
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8) LIKE '1%';
--WHERE SUBSTR(EMP_NO, 8, 1) = '1'; -- 위와 같은 결과의 조건식
--WHERE SUBSTR(EMP_NO, 8, 1) IN (1, 3); -- 뒷자리가 3로 시작하는 남성이 있을경우 쓸 수 있는 조건식

-- 사원명과 주민등록번호(123456-1******) 으로 조회
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

-- 직원명, 이메일, 아이디(이메일에서 '@' 앞의 문자) 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;

/*
LOWER / UPPER / INITCAP
- LOWER/UPPER/INITCAP(STRIN)
- LOWER : 다 소문자로 변경한 문자열 반환
- UPPER : 다 대문자로 변경한 문자열 반환
- INITCAP : 단어 앞글자마다 대문자로 변경한 문자열 반환
*/
SELECT LOWER('Welcome TO My World!')
FROM DUAL;

SELECT UPPER('Welcome TO My World!')
FROM DUAL;

SELECT INITCAP('welcome tO my world!')
FROM DUAL;

/*
CONCAT 
- 문자열 두개 전달받아 하나로 합친 후 결과 반환
- CONCAT(STRING, STRING)
*/
SELECT CONCAT('가나다라', 'ABCD')
--SELECT '가나다라'||'ABCD' -- CONCAT은 연결연산자와 동일한 기능이다
FROM DUAL;

SELECT '가나다라'||'ABCD'||'1234'
--SELECT CONCAT('가나다라', 'ABCD', '1234') -- CONCAT 은 문자열을 여러게 합쳐서 사용하면 오류 발생됨
--SELECT CONCAT(CONCAT('가나다라', 'ABCD'), '1234') -- 여러개의 문자열을 CONCAT으로 합치려면 합치는 갯수 만큼 CONCAT을 사용해야함
FROM DUAL;

/*
REPLACE
- REPLACE(STRING, STR1, STR2)
  STRING : 컬럼 또는 문자열값
  STR1 : 변경시킬 문자열
  STR2 : STR1을 변경할 문자열
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')
FROM DUAL;

--사원명, 이메일, 이메일의 kh.or.kr 을 gmail.com 으로 변경해서 조회
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;

/*
숫자 처리 함수
ABS(NUMBER) : 숫자의 절대값을 구해주는 함수
*/

SELECT ABS(-10)
FROM DUAL;

/*
MOD(NUMBER, NUMBER) : 두 수를 나눈 나머지값을 반환해주는 함수
*/

SELECT MOD(10, 3)
FROM DUAL;

/*
ROUND(NUMBER, [위치]) : 반올림한 결과를 반환하는 함수
*/

SELECT ROUND(123.456) -- 위치 생략 시 0 소수점을 다 제거한다
FROM DUAL;

SELECT ROUND(123.456, 5) -- 소수점 5 자리가 없기 떄문에 그대로 출력됨
FROM DUAL;

SELECT ROUND(123.456, 1) -- 소수점 1 자리까지 보여주고 반올림하여 123.5 출력됨
FROM DUAL;

SELECT ROUND(123.456, -2) -- 앞에서 2번째 자리부터 반올림하여 100 출력됨
FROM DUAL;

/*
CEIL(NUMBER) : 올림처리 해주는 함수
*/
SELECT CEIL(123.152) -- 124 출력됨
FROM DUAL;

/*
FLOOR(NUMBER) : 소수점 아래 버림처리 해주는 함수, 소수점 위치 지정 불가
*/
SELECT FLOOR(123.952) -- 123 출력됨
FROM DUAL;

/*
TRUNC(NUMBER, [위치]) : 위치 지정 가능한 버림처리 해주는 함수 위치 미지정 시 FLOOR과 동일한 기능
*/
SELECT TRUNC(123.952, 1) -- 123.9 출력됨
FROM DUAL;

SELECT TRUNC(123.952, -1) -- 120 출력됨
FROM DUAL;

/*
날짜 처리 함수
SYSDATE : 시스템의 날짜를 반환
*/
SELECT SYSDATE
FROM DUAL;

-- 날짜 포멧 변경 
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

/*
MONTHS_BETWEEN(DATE, DATE)
- 입력받는 두 날짜 사이의 개월 수를 반환
*/

SELECT MONTHS_BETWEEN(SYSDATE, '20230521')
FROM DUAL;

-- 직원명, 입사일, 근무개월 수 조회하기
SELECT EMP_NAME, HIRE_DATE, TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'개월' 근속개월
FROM EMPLOYEE;

/*
ADD MONTHS(DATE, NUMBER)
- 특정 날짜에 입력받은 숫자 만큼의 개월 수를 더한 날짜를 반환
*/
SELECT ADD_MONTHS(SYSDATE, 5)
FROM DUAL;

-- 직원명, 입사일, 입사 후 6개월이 된 날짜를 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6)
FROM EMPLOYEE;

/*
NEXT_DAY(DATE, 요일(문자|숫자)
- 특정 날짜에서 구하려는 요일의 가장 가까운 날짜를 리턴
- 요일 : 1 - 일요일, 2 - 월요일 ... 7 - 토요일
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일')
FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금')
FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 4)
FROM DUAL;

-- 현재 언어가 KOREAN이기 때문에 영어를 인식하지 못해서 오류 발생함
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'THURSDAY') 
FROM DUAL;

-- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;

/*
LAST_DAY(DATE)
- 해당 월의 마지막 날짜를 반환
*/
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

SELECT LAST_DAY('20230515')
FROM DUAL;

SELECT LAST_DAY('23/11/01')
FROM DUAL;

-- 직원명, 입사일, 입사월의 마지막 날짜, 입사월에 근무한 일 수 를 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE) - HIRE_DATE + 1
FROM EMPLOYEE;

/*
EXTRACT(YEAR|MONTH|DAY FROM DATE)
- 특정 날짜에서 연도, 월, 일 정보를 추출해서 반환
  YEAR : 연도만 추출
  MONTH : 월만 추출
  DAY : 일만 추출
*/
-- 직원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE) 입사년도, EXTRACT(MONTH FROM HIRE_DATE) 입사월, EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
--ORDER BY EXTRACT(YEAR FROM HIRE_DATE), EXTRACT(MONTH FROM HIRE_DATE) ASC, EXTRACT(DAY FROM HIRE_DATE) ASC;
ORDER BY 2, 3 ASC, 4 ASC; 
-- 지정된 컬럼의 숫자로 ORDER BY 사용 가능하다

/*
형 변환 함수
TO_CHAR(날짜|숫자, [포맷])
- 날짜 또는 숫자형 데이터를 문자 타입으로 변환해서 반환한다
- 포맷에서 FM을 붙여주면 공백을 제거해준다
*/
SELECT TO_CHAR(1234, 'L999999') -- L은 현재 설정된 나라의 화폐 단위를 출력함
FROM DUAL;

SELECT TO_CHAR(1234, '$999999') 
FROM DUAL;

SELECT TO_CHAR(1234, '$99') -- 포맷 자리수가 안맞아서 출력시 # 으로 표시됨
FROM DUAL;

SELECT TO_CHAR(1234, 'L999,999') 
FROM DUAL;

-- 직원명, 급여, 연봉 (TO_CHAR) 조회하기
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999') 월급, TO_CHAR(SALARY * 12, 'L999,999,999') 연봉
FROM EMPLOYEE
ORDER BY 연봉;
-- 별명을 지정하면 해당 별명으로 ORDER BY 가능

-- 날짜 -> 문자
SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'MON DAY DY, DD, YYYY')
FROM DUAL;
-- DD : 일 / DY : 요일 한글자 / DAY : 요일 / MON : 달 / Y : 연도 (Y갯수만큼 자리수 증가)

-- 연도와 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'), TO_CHAR(SYSDATE, 'YY'), TO_CHAR(SYSDATE, 'RRRR'), TO_CHAR(SYSDATE, 'RR'), TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- 월과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'MM'), TO_CHAR(SYSDATE, 'MON'), TO_CHAR(SYSDATE, 'MONTH'), TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

-- 일과 관련된 포멧
SELECT TO_CHAR(SYSDATE, 'D'), TO_CHAR(SYSDATE, 'DD'), TO_CHAR(SYSDATE, 'DDD')
FROM DUAL;
-- D : 주 기준 / DD : 월 기준 / DDD : 년 기준

-- 요일과 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'DAY'), TO_CHAR(SYSDATE, 'DY')
FROM DUAL;

-- 직원명, 입사일 조회하되 단 입사일은 포맷을 지정해서 조회 EX)2023년 06월 21일 (수)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)')
FROM EMPLOYEE;

/*
TO_DATE(숫자|문자, [포맷])
- 숫자 또는 문자형 데이터를 날짜 타입으로 변환해서 반환
*/

-- 날짜 포멧 변경 
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';

-- 숫자 -> 날짜
SELECT TO_DATE(20230621)
FROM DUAL;

SELECT TO_DATE(20230621153410, 'YYYY-MM-DD HH24:MI:SS') 
FROM DUAL;
-- 20230621153410 의 포멧을 지정하지 않으면 오류 발생함

-- 문자 -> 날짜
SELECT TO_DATE('20230621', 'YYYYMMDD')
FROM DUAL;

SELECT TO_DATE('20230621033823', 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

/*
TO_NUMBER('문자값', [포맷])
- 문자형 데이터를 숫자 타입으로 변환해서 반환
*/
SELECT '1000000' + '550000'
FROM DUAL;
-- 1550000 정상출력

SELECT '1,000,000' + '550,000'
FROM DUAL;
-- , 이 있어서 오류 발생

SELECT TO_NUMBER('1,000,000', '999,999,999') + TO_NUMBER('550,000', '999,999,999')
FROM DUAL;

/*
NULL 처리 함수
NVL(값1, 값2)
- 값1이 NULL이 아니면 값1을 반환하고 값1이 NULL이면 값2를 반환한다
*/

-- 사원명, 보너스 조회
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

-- 사원명, 보너스포함 연봉(월급 + 월급*보너스) * 12
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999') 월급 , TO_CHAR(SALARY * 12, 'L999,999,999') 연봉, NVL(BONUS, 0) 보너스, TO_CHAR((SALARY + SALARY * NVL(BONUS, 0)) * 12, 'L999,999,999') 총수령액
FROM EMPLOYEE;

-- 사원명, 부서코드 조회(부서코드가 NULL이면 '부서없음') 조회
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음') 부서명
FROM EMPLOYEE
ORDER BY DEPT_CODE NULLS FIRST;

/*
NVL2(값1, 값2, 값3)
- 값1이 NULL이 아니면 값2를 반환하고 값1이 NULL이면 값3을 반환
*/

-- 사원명, 부서코드가 있는경우 "부서있음", 없는경우는 "부서없음" 조회하기
SELECT EMP_NAME, DEPT_CODE, NVL2(DEPT_CODE, '부서있음', '부서없음') 부서유무
FROM EMPLOYEE;

/*
NULLIF(값1, 값2)
- 두개의 값이 동일하면 NULL을 반환하고 두개의 값이 동일하지 않으면 값1을 반환한다
*/
SELECT NULLIF('123', '123')
FROM DUAL;

SELECT NULLIF('123', '456')
FROM DUAL;

/*
선택 함수 : 여러가지 경우에 선택을 할 수 있는 기능을 제공하는 함수
DECODE(컬럼|산술연산|함수식, 조건값1, 결과값1, 조건값2, 결과값2, ... , 결과값N)
- 비교하고자 하는 값이 조건값과 일치할 경우 그에 해당하는 결과값을 반환해주는 함수
*/

-- 사번, 사원명, 주민번호, 성별(남, 여) 조회
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), 1, '남자', 2, '여자') 성별
FROM EMPLOYEE;

-- 사원명, 직급 코드, 기존 급여, 인상된 급여율을 조회하기
-- 직급코드 J7 -> 급여율 10% 인상
-- 직급코드 J6 -> 급여율 15% 인상
-- 직급코드 J5 -> 급여율 20% 인상
-- 나머지 직급은 급여를 5% 인상
-- 정렬 : 직급코드 J1부터 / 인상된 급여가 높은 순서대로
SELECT EMP_NAME 사원명, JOB_CODE 직급코드, SALARY 급여, DECODE(JOB_CODE, 'J7', SALARY * 1.1, 'J6', SALARY * 1.15, 'J5', SALARY * 1.2, SALARY * 1.05) "인상된 급여"
FROM EMPLOYEE
ORDER BY JOB_CODE, '인상된 급여' DESC;

/*
CASE WHEN 조건식1 THEN 결과값1 WHEN 조건식2 THEN 결과값2 .... ELSEL 결과값N END
*/

-- 사번, 사원명, 주민번호, 성별
SELECT EMP_ID, EMP_NAME, EMP_NO, CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남자' WHEN SUBSTR(EMP_NO, 8, 1) = 2 THEN '여자' ELSE '잘못된 주민번호 입니다.' END 성별
FROM EMPLOYEE;

-- 사원명, 급여, 급여 등급(1~4)
-- 급여값이 500만원 초과 : 1등급 / 350~500 2등급 / 200~350 3등급 / 그외 4등급
SELECT EMP_NAME 사원명, SALARY 급여, CASE WHEN SALARY > 5000000 THEN '1등급' 
                                         WHEN SALARY > 3500000 THEN '2등급'  
                                         WHEN SALARY > 2000000 THEN '3등급'
                                         ELSE '4등급' END 급여등급
FROM EMPLOYEE
ORDER BY SALARY DESC;

/*
그룹함수
- 대량의 데이터들로 집계나 통계같은 작업을 처리해야 하는 경우 사용되는 함수들
- 모든 그룹 함수는 NULL값을 자동으로 제외하고 값이 있는 것들만 계산한다

SUM(NUMBER)
- 해당 컬럼 값들의 총 합계를 반환
*/

-- 전체 사원의 총 급여 합
SELECT TO_CHAR(SUM(SALARY), 'FM999,999,999')
FROM EMPLOYEE;

-- 부서코드가 D5인 사원들의 총 연봉 합
SELECT TO_CHAR(SUM(SALARY) * 12, 'FM999,999,999')
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

/*
AVG(NUMBER)
- 해당 컬럼값들의 평균값을 반환한다
- 모든 그룹 함수는 NULL값을 제외 -> AVG 함수를 사용할 때 NVL 함수와 함께 사용하는것을 권장함
*/

-- 전체 사원의 평균 급여 조회
SELECT TO_CHAR(AVG(SALARY), 'FM999,999,999') "평균급여"
--SELECT ROUND(AVG(SALARY)) "평균급여"
FROM EMPLOYEE;

-- 보너스의 평균 구할때 NVL을 사용하지 않으면 0.21... 출력됨
SELECT AVG(BONUS)
FROM EMPLOYEE;

-- 보너스의 평균을 구할떄 NVL을 사용하면 0.08 출력됨 
-- NULL값이 있는 컬럼의 평균을 구할때는 NVL을 꼭 사용해야 정확한 값이 출력 가능하다
SELECT AVG(NVL(BONUS, 0))
FROM EMPLOYEE;

/*
MIN/MAX(모든타입의 컬럼)
- MIN : 해당 컬럼 값들 중에 가장 작은 값을 반환
- MAX : 해당 컬럼 값들 중에 가장 큰 값을 반환
*/

-- 가장 작은 값에 해당하는 사원명, 급여, 입사일
-- 가장 큰 값에 해당하는 사원명, 급여, 입사일
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE), MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

/*
COUNT(*|컬럼|DISTINCT 컬럼)
- 컬럼 또는 행의 개수를 세서 반환한다

COUNT(*) : 조회 결과에 해당하는 모든 행 개수를 반환한다
COUNT(컬럼) : 해당 컬럼값이 NULL이 아닌 행의 개수를 반환한다
COUNT(DISTINCT 컬럼) : 해당 컬럼값의 중복을 제거한 행의 개수를 반환한다
*/

-- 전체 사원 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- 부서가 배치된 사원 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 현재 사원들이 속해있는 부서 수
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

-- 현재 사원들이 속해있는 직급 수
SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;

-- 퇴사한 직원 수
SELECT COUNT(ENT_DATE)
FROM EMPLOYEE;