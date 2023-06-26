-- 01 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서명, 직급, 입사일, 순위 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 순위
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE,
             RANK() OVER(ORDER BY ((SALARY + SALARY * NVL(BONUS, 0)) * 12) DESC) "순위"
      FROM EMPLOYEE
      JOIN JOB USING (JOB_CODE)
      JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE))
WHERE 순위 <= 5;      

-- 02 부서별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--   (방법은 여러 가지..! 가급적으로 서브쿼리 사용해보세요!


-- 03 WITH을 이용하여 급여 합과 급여 평균 조회