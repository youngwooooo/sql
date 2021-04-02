문제 1] 사원테이블(employees)에서 50번 부서에 속한 사원 중 급여가 5000이상인 사원번호, 사원명, 입사일, 급여를 읽기 전용 뷰로 생성하시오
       뷰 이름은 v_emp_sal01이고 컬럼명은 원본테이블의 컬럼명을 사용
       뷰가 생성된 후 해당 사원의 사원번호, 사원명, 직무명, 급여를 출력하는 sql작성
       
SELECT *
FROM employees;

SELECT *
FROM jobs;

CREATE OR REPLACE VIEW v_emp_sal01
AS
    SELECT employee_id, emp_name, hire_date, salary
    FROM employees
    WHERE department_id = 50 
      AND salary >= 5000
    WITH READ ONLY;
    
SELECT * FROM v_emp_sal01;

SELECT C.employee_id 사원번호, C.emp_name 사원명, B.job_title 직무명, C.salary 급여
FROM employees A, jobs B, v_emp_sal01 C
WHERE A.employee_id = C.employee_id
  AND A.job_id = B.job_id;
    