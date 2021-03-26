-- [GROUP FUCNTION 실습 3]
-- emp 테이블을 이용하여 다음을 구하시오
-- grp2에서 작성한 쿼리를 활용하여 deptno대신 부서명이 나올 수 있도록 수정하시오
SELECT DECODE(deptno,
                10, 'ACCOUNTING',
                20, 'RESEARCH',
                30, 'SALES',
                40, 'OPERATIONS', 
                'DDIT') dname_decode ,MAX(sal), MIN(sal), ROUND(AVG(sal), 2), SUM(sal), count(sal), count(mgr), count(*)
FROM emp
GROUP BY deptno;

-- [GROUP FUCNTION 실습 4]
-- emp 테이블을 이용하여 다음을 구하시오
-- 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');
-- ORDER BY TO_CHAR(hiredate, 'yyyymm'); 오름차순으로 정리할 수 있다.

-- [GROUP FUCNTION 실습 5]
-- emp테이블을 이용하여 다음을 구하시오.
-- 직원의 입사 년별로 몇명의 직원이 입사햇는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');
 
 -- [GROUP FUCNTION 실습 6]
 -- 회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하시오
 SELECT COUNT(*)
 FROM dept;
 
 -- [GROUP FUCNTION 실습 7]
 -- 직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오.
 SELECT COUNT(*) cnt
 FROM
(SELECT deptno
 FROM emp
 GROUP BY deptno);
 
 SELECT *
 FROM emp;
 -------------------------------------------------------------------------------------------------------------------------------
 
 -- <데이터 결합(확장)>
 -- 1. 컬럼에 대한 확장 : JOIN 
 -- * JOIN
 -- : RDBMS는 중복을 최소화하는 형태의 테이터베이스
 -- : 다른 테이블과 결합하여 데이터를 조회
 -- 1) 중복을 최소화 하는 RDBMS 방식으로 설계한 경우
 -- 2) emp 테이블에는 부서코드만 존재, 부서정보를 담은 dept 테이블 별도로 생성
 -- 3) emp 테이블과 dept 테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다.
 -- 4) 열(clo)을 확장
 
  -- 2. 행에 대한 확장: 집합연산자
 -- UNION ALL
 -- UNON(합집합)
 -- MINUS(차집합)
 -- INSERSECT(교집합)
 
 -- JOIN
 -- 표준 SQL : ANSI SQL
 -- 비표준 SQL : SQL - DBMS를 만드는 회사에서 만든 고유의 SQL 문법 
 
-- 1. ANSI SQL - NATURAL JOUN
-- : JOIN하고자 하는 테이블의 연결컬럼 명(타입도 동일)이 동일한 경우(emp.deptno, dept.deptno)
-- : 연결컬럼의 값이 동일할 때(=) 컬럼이 확장된다.
SELECT emp.empno, emp.ename
FROM emp NATURAL JOIN dept;
-- deptno 연결고리 컬럼이므로 SELECT절에서 불러올 수 없다.

-- 2. ANSI SQL - OINT WITH USING
-- : 조인하려고 하는 테이블의 컬럼명과 타입이 같은 컬럼이 두 개 이상인 상황에서 두 컬럼을 모두 조인 조건으로 참여시키지 않고,
--   개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용
SELECT *
FROM emp JOIN dept USING(deptno);
-- 연결컬럼에 대해서 SELECT절에 쓰지 않아도 됨. 몰라도 된다 다른게 있음!

-- * JOIN WITH ON!! ==> ANSI SQL은 이거 하나만 써도 됨!
-- : NATURAL JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
-- : 조인 컬럼 조건을 개발자가 임의로 지정
SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno);
-- ORACLE JOIN과 다른점 : JOIN을 쓰지 않고 동등 비교만 씀. WHERE절을 사용함



-- ORACLE SQL - ORACLE JOIN
-- 1. FROM절에 조인할 테이블을 (,)콤마로 구분하여 나열
-- 2. WHERE : 조인할 테이블의 연결조건을 기술
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
-- ORACLE JOIN 형식은 이렇게 씀.

-- 7369 SMITH, 7902 FORD
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;
-- KING은 mgr이 null값이라 호출되지 않았음.

-- 사원 번호, 사원 이름, 해당사원의 상사 사번, 해당사원의 상사 이름: JOIN WITH ON을 이용하여 쿼리작성
-- 단 사원의 번호가 7369에서 7698인 사원들만 조회
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;
 
 -- ORACLE로 바꿨을 떄
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.empno BETWEEN 7369 AND 7698
    AND e.mgr = m.empno;
    
-- 논리적인 조인 형태
-- 1. SELF JOIN : 조인 테이블이 같은 경우. EX) 계층구조
-- 2. NONEQUI-JOIN : 조인 조건이 =(equals)가 아닌 조인 // 시험문제!!
SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno;

SELECT *
FROM salgrade;

-- salgrade를 이용하여 직원의 급여 등급 구하기
-- empno, ename, sal, 급여등급
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal BETWEEN s.losal AND s.hisal;

SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e JOIN salgrade s ON(e.sal BETWEEN s.losal AND s.hisal);
 
-- [JOIN 실습 1]
-- emp,dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하시오.
SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- [JOUN 실습 1-1]
-- emp, dept 테이블을 이용하여 다음과 같이 조회하도록 쿼리를 작성하세요
-- 부서번호가 10, 30인 데이터만 조회
SELECT empno, ename, e.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.deptno IN(10, 30);

-- [JOIN 실습 2]
-- emp,dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
-- 급여가 2500 초과
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND sal > 2500;
    
-- [JOIN 실습 3]
-- 급여 2500 초과, 사번이 7600보다 큰 직원
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND sal > 2500
    AND empno > 7600;

-- [JOIN 실습 4]
-- 급여 2500 초과, 사번이 7600보다 크고 RESEARCH 부서에 속하는 직원
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND sal > 2500
    AND empno > 7600
    AND dname = 'RESEARCH';
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 