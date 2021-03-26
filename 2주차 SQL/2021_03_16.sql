-- 연산자 우선순위
-- 헷갈리면 ()를 사용하여 우선순위를 조정하자!
-- AND가 OR 보다 우선순위가 높다!

-- ==> ename이 ALLEN이면서 job이 SALESMAN 이거나 ename이 SMITH인 직원 정보를 조회
SELECT *
FROM emp
WHERE ename = 'SMITH' OR (ename = 'ALLEN' AND job = 'SALESMAN');
--     1             +           2       +       3

-- ==> ename이 ALLEN이거나 SMITH이면서 job이 SALESMAN인 직원 정보를 조회
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND job = 'SALESMAN';

-- [AND, OR 실습 WHERE 14]
-- emp 테이블에서
-- 1. job이 SALESMAN이거나
-- 2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원 정보를 다음과 같이 조회하시오.(1번 조건 또는 2번 조건을 만족하는 직원)

SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
-----------------------------------------------------------------------------------------------------

-- !<데이터 정렬>!
-- TABLE 객체에는 데이터를 저장/조회 시 순서를 보장하지 않음!
-- 보편적으로 데이터가 입력된 뒤 순서대로 조회
-- 데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다.
-- 데이터가 삭제되고, 다른 데이터가 들어올 수도 있음
-- ==> 즉 데이터의 순서가 딱 정해져 있지 않음! 조회할 때마다 순서가 바뀔 수 있다.

--!<데이터 정렬이 필요한 이유?>!
-- 1. TABLE 객체는 순서를 보장하지 않기 때문에 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수가 있다
-- 2. 현실세계에서는 정렬된 데이터가 필요한 경우가 있다. ==> 게시판은 보편적으로 가장 최신글이 처음, 가장 오래된 글이 맨 뒤에 있다.

-- SQL에서의 정렬 : ORDER BY ==> 순서: SELECT -> FROM -> (WHERE) -> ORDER BY
-- 정렬 방법 : ORDER BY 컬럼명 | 컬럼인덱스(순서) | 별칭 [정렬순서]
-- 정렬 순서 : 기본 ASC(오름차순), DESC(내림차순)

SELECT *
FROM emp
ORDER BY job;
-- ex) A -> B -> C -> D -> ..... -> Z
--     1 -> 2 -> ....... -> 1000 : 오름차순(ASC, 작은 값부터 정렬, 굳이 뒤에다 안써줘도 됨.)
--    100 -> 99 -> ...... -> 1 : 내림차순(DESC, 큰값부터 정렬, 꼭 뒤에다 써줄 것!)

SELECT *
FROM emp
ORDER BY job, sal;
-- job을 오름차순으로 정렬하고나서 job이 정렬되있는 상태에서 sal를 오름차순으로 정렬함

SELECT *
FROM emp
ORDER BY job DESC, sal, ename;
-- 정렬하고자 하는 컬럼이 여러개 일 때 각 컬럼 뒤에 DESC를 붙여주면 각각 내림차순으로 정렬해줌, 안 쓸경우 오름차순

-- 정렬 : 컬럼명이 아닌 SELECT절의 컬럼 순서(index)
-- 테이블의 첫 컬럼부터 1, 2, 3, 4.. 번째 컬럼이다.
-- ==> 2번째 컬럼을 정렬해라
SELECT *
FROM emp
ORDER BY 2;

-- SELECT에 *이 아닌 컬럼명을 넣으면 넣은 순서대로 1, 2, 3, 4... 번째 컬럼이다.
SELECT ename, empno, job, mgr
FROM emp
ORDER BY 2;

-- alias를 사용한 경우 alias된 별칭으로도 정렬이 가능
SELECT ename, empno, job, mgr AS m
FROM emp
ORDER BY m;

-- [ORDER BY 실습 1]
-- 1. dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하시오.
-- 2. dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회하도록 쿼리를 작성하시오.
-- * 컬럼명을 명시하지 않음, 지난 수업시간에 배운 내용으로 올바른 컬럼을 찾기!

-- 1번 문제
SELECT *
FROM dept
ORDER BY dname;

-- 2번 문제
SELECT *
FROM dept
ORDER BY loc DESC;

-- [ORDER BY 실습 2]
-- emp테이블에서 상여정보가 있는 사람들만 조회하고, 상여를 많이 받는 사람이 먼저 조회되도록 정렬하고, 상여가 같을 경우 사번으로 내림차순 정렬
-- * 상여가 0인 사람은상여가 없는 것으로 간주
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0
-- ==> WHERE comm != 0 (간단하게)
ORDER BY comm DESC, empno DESC;

-- [ORDER BY 실습 3]
-- emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군 순으로 오름차순 정렬하고, 직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리 작성
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

-- [ORDER BY 실습 4]
-- emp 테이블에서 10번 부서 혹은 30번 부서에 속하는 사람 중 급여가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리 작성
SELECT *
FROM emp
WHERE deptno IN (10, 30) AND sal > 1500
ORDER BY ename DESC;
-----------------------------------------------------------------------------------------------------

-- <실무에서 정렬을 어떻게 사용할까?>
-- 페이징 처리: 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을 때 원하는 페이지의 데이터만 가져오는 방법
-- ex) 1. 400건을 다 조회하고 필요한 20건만 사용하는 방법 ==> 전체조회(400건)
--     2. 400건의 데이터 중 원하는 페이지의 20건만 조회 ==> 페이징 처리(20건)
-- 페이징 처리(게시글) ==> 정렬의 기준이 무엇인가? (일반적으로는 게시글의 작성일자 역순)
-- 페이징 처리 시 고려해야할 변수 : 페이지 번호, 페이지 사이즈

-- <페이징 처리 시 알아야 할 것!>
-- 1. ROWNUM : 행 번호를 컬럼에 부여하는 특수 키워드(오라클에서만 제공!)
--   * ROWNUM 사용 시 제약사항 : ROWNUM은 WHERE절에서도 사용 가능!
--                            (단, ROWNUM의 사용을 1부터 사용하는 경우에만 사용 가능)
--    ex) WHERE ROWNUM BETWEEN 1 AND 5 ==> O
--        WHERE ROWNUM BETWEEN 6 AND 10 ==> X
--        WHERE ROWNUM = 1; ==> O
--        WHERE ROWNUM = 2; ==> X
--        WHERE ROWNUM < 10; ==> O
--        WHERE ROWNUM > 10; ==> X
-- * SQL절은 다음의 순서로 실행된다.
--   FROM -> WHERE -> SELECT -> ORDER BY
--   즉, ORDER BY와 ROWNUM을 동시에 사용하면 정렬된 기준으로 ROWNUM이 부여되지 않는다.
--       ==> SELECT절이 먼저 실행되므로 ROWNUM이 부여된 상태에서 ORDER BY에 의해 정렬이 된다.
-- 2. 인라인 뷰
-- 3. ALIAS

-- 1. ROWNUM
-- 행 번호를 컬럼에 부여하는 방법(ROWNUM)
SELECT ROWNUM, empno, ename
FROM emp;

-- WHERE절에서 ROUNUM 사용
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 5;
-- WHERE ROWNUM = 1;
-- WHERE ROWNUM <= n;
-- WHERE ROWNUM < n;      ==> 모두 가능

-- SQL 실행 순서 : FROM -> SELECT -> ORDER BY
-- ROWNUM이 ORDER BY보다 먼저 실행되었기 때문에 이런 결과가 나옴
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

-- 2. 인라인 뷰(SELECT 쿼리)
-- ()로 묶으면 하나의 테이블로 인식된다.
-- ORDER BY로 정렬된 데이터를 다시 정리하기 위함!
-- 1. 정렬할 컬럼으로 정렬된 테이블 만들기
SELECT empno, ename
FROM emp
ORDER BY ename;

-- 2. 정렬 후 SELECT절을 사용하여 ROWNUM으로 행 번호를 부여
--    ROWNUM을 alias를 사용하여 rn 별칭 부여 ==> WHERE절에서 사용하기 위함임!
SELECT ROWNUM rn, empno, ename
        FROM (SELECT empno, ename
                FROM emp
                ORDER BY ename);

-- 3. 행 번호 부여 후 다시 SELECT문을 사용하고 WHERE절을 이용하여 출력하고 싶은 페이지 범위 정하기
SELECT *
FROM(SELECT ROWNUM rn, empno, ename
        FROM (SELECT empno, ename
                FROM emp
                ORDER BY ename))
-- WHERE rn BETWEEN 1 AND 10;
WHERE rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize;
-- ==> 페이지 전체 범위와 불러올 페이지 범위를 설정하는 공식!

-- 페이지 사이즈 : 5건
-- 1페이지 사이즈 : rn BETWEEN 1 AND 5;
-- 2페이지 사이즈 : rn BETWEEN 6 AND 10;
-- 3페이지 사이즈 : rn BETWEEN 11 AND 15;
-- n페이지 사이즈 : rn BETWEEN (:page-1)*:pageSize + 1 AND :page*:pageSize;
-- n*pageSize-4
-- => n*pageSize - (pageSize - 1)
-- => n*pageSize - pageSize + 1
-- => (n-1)*pageSize + 1
-- => n = page => (page-1)*pageSize + 1

-- [가상컬럼 ROWNUM 실습 1]
-- emp 테이블에서 ROWNUM값이 1~10인 값만 조회하는 커리를 작성해보세요
-- * 정렬없이 진행, 결과 화면은 다를 수 있다.
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

-- [가상컬럼 ROWNUM 실습 2]
-- ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요
SELECT *
FROM(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 14;

-- [가상컬럼 ROWNUM 실습 3]
-- emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용했을 때의 11~14번째행을 다음과 같이 조회하는 쿼리를 작성해보세요
SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename))
WHERE rn BETWEEN 11 AND 14; 
-----------------------------------------------------------------------------------------------------

-- 한정자
-- ROWNUM와 * 사용시 주의점!  
SELECT ROWNUM, *
FROM emp;
-- ==> 실행 불가

SELECT ROWNUM, emp.*
From emp;
-- ==> *앞에 테이블.을 명시해줘야함

SELECT ROWNUM, e.*
From emp e;
-- ==> 테이블에 alias해도 가능, 테이블은 테이블 뒤에 바로 별칭 붙일 것! AS 별칭은 안됨!




















