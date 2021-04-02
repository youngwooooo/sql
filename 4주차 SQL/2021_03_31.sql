SELECT empno, ename, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal,
       MIN(sal) OVER (PARTITION BY deptno) min_sal, -- 해당 부서에서 가장 낮은 급여
       MAX(sal) OVER (PARTITION BY deptno) max_sal, -- 해당 부서에서 가장 높은 급여
       SUM(sal) OVER (PARTITION BY deptno) sum_sal -- 해당 부서 급여의 합
FROM emp;


1. LAG : 파티션 별 윈도우에서 이전 행의 컬럼 값
2. LEAD : 파티션 별 윈도우에서 이후 행의 컬럼 값

- 자신보다 급여 순위가 한 단계 낮은 사람의 급여를 5번째 컬럼으로 설정
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER (ORDER BY sal DESC, hiredate)
FROM emp;

- 모든 사원에 대해 사원번호, 사원이름, 입사일자,급여, 전체 사원 중 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리 작성
SELECT empno, ename, hiredate, sal,
      LAG(sal) OVER (ORDER BY sal DESC, hiredate)
FROM emp;      

SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) a,
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) b
WHERE a.rn-1 = b.rn(+)
ORDER BY a.sal DESC, a.hiredate;


-- [ 분석함수 실습 6]
- 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군, 급여정보와 담당업무(job)별 급여순위가 1단계 높은 사람의 급여를 조회하는 쿼리 작성
- 급여가 같을 경우 입사일이 빠른 사람이 높은 순위

SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;
       
LAG, LEAD 함수의 두 번째 인자 : 이전, 이후 몇 번째 행을 가져올지 표기
SELECT empno, ename, hiredate, sal,
        LAG(sal, 2) OVER (ORDER BY sal DESC, hiredate) lag_sal,
        LEAD(sal, 2) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

-- [분석함수 실습 7]
- HINT : ROWNUM, 범위조인

<사용한 방법>
1. ROWNUM
2. INLINE VIEW
3. NON-EQUI-JOIN
4. 그룹함수
SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) a,
(SELECT a.*, ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal, empno) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;

분석함수 WINDOWING 활용 (지정한 부분만)
- 기본적으로 ORDER BY가 들어가 있어야 함! 그래야 행의 기준을 지정할 수 있음.
WINDOWING : 윈도우 함수의 대상이 되는 행을 지정
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전 행(LAG)
(= n PRECEDING : 특정행을 기준으로 n행 이전 행(LAG))
CURRENT ROW : 현재행
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후 행(LEAD)
(= n FOLLOWING : 특정 행을 기준으로 n행 이후 행(LEAD))

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, -- <-- 명확하기 때문에 이 형식으로 쓰는게 좋다.
       SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum
FROM emp;

SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp;

-- [분석함수 실습 7]
- 사원번호, 사원이름, 부서번호, 급여정보를 부서별로 급여, 사원번호 오름차순으로 정렬 했을 때, 자신의 급여와 선행하는 사원들의 급여 합을 조회하는 쿼리 작성
- WINDOW 함수사용
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

ROW와 RANGE의 차이
SELECT empno, ename, sal,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) row_c_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_c_sum,
       SUM(sal) OVER (ORDER BY sal) no_win_c_sum, -- windowing을 지정하지 않으면 자동적으로 RANGE UNBOUNDED PRECEDING이 들어간다
       SUM(sal) OVER () no_ord_c_sum
FROM emp
ORDER BY sal, empno;

<이 외의 분석함수> - 공부해보기
- RATIO_TO_REPORT
- PRECEDING 

수업 내용을 다 이해한 다는 가정하에 추천하는 책
1.오라클
SQL 전문가(2020개정판)
오라클 실습(전문가로 가는 지름길) -> 구글에 검색해서 블로그 들어가면 다 있음 / 15장에 실습 있음. / 17장은 안해도 됨
                              -> 실무 수준의 연습 가능
 
2. 데이터모델링
관계형 데이터 모델링(김기창)

3. DBMS
조광원 인터파크강의 영상 찾아보기