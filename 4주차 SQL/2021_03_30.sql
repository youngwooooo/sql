FROM -> [START WITH] -> WHERE -> GROUP BY -> SELECT -> ORDER BY : 읽는 순서

SELECT
FROM
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY

가지치기 : Pruning branch

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename ename, mgr, deptno, job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename ename, mgr, deptno, job
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr
  AND job != 'ANALYST';
==> SCOTT, FORD가 ANALYST여서 제외됬는데 SCOTT, FORD의 부하직원 ADAMS, SMITH는 CLERK이지만 ADAMS,SMITH의 상관인 SCOTT, FORD가 제외되면서 같이 제외됨. 즉 해당되는 값을 제외하면서 하위들 값을 같이 제외시켜버림!   
==> 계층쿼리에서 WHERE , CONNECT BY 의 차이점


<계층쿼리와 관련된 특수함수>
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값 
EX)
SELECT LPAD(' ', (LEVEL-1)*4) || ename ename, CONNECT_BY_ROOT(ename) root_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

최상위 노드가 한 명이 아닌 경우가 많음!
EX) 게시판
1. 제목
-- 2. 답글
3. 제목
-- 4. 답글
==> 각각의 제목이 최상위 노드임!

2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
                                             LTRIM 과 같이 쓰는 경우가 많다!(가장 왼쪽의 구분자를 삭제해주기 위함)
                                             INSTR, SUBSTR 를 사용하여 구분자를 빼고 원하는 값만 뽑아낼 수 있다.
SELECT LPAD(' ', (LEVEL-1)*4) || ename ename,
       LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr

3. CONNECT_BY_ISLEAF : 자식이 없는 leaf node 여부, 0 - false(no leaf node) / 1 - true(leaf node)

SELECT LPAD(' ', (LEVEL-1)*4) || ename ename,
       LTRIM(SYS_CONNECT_BY_PATH(ename, '-'), '-') path_ename,
       CONNECT_BY_ISLEAF isleaf
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr

-- 게시판 예제 테이블을 추가하고 강의
SELECT *
FROM board_test;

SELECT seq, parent_seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY seq DESC;
-- siblings = 형제, 계층쿼리를 작성하고 계층을 유지하면서 정렬할 수 있음
-- 제목은 최신부터 정렬이 됬지만 각 제목의 답글이 정렬되지 않음.

SELECT gn, seq, parent_seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;

SELECT *
FROM
(SELECT CONNECT_BY_ROOT(seq) root_seq, 
       seq, parent_seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY root_seq DESC, seq ASC;

시작(ROOT)글은 작성순서의 역순, 답글은 작성 순서대로 결정
시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가
/* ALTER TABLE board_test ADD (gn NUMBER);
DESC board_test;

UPDATE board_test SET gn = 1
WHERE seq IN (1, 9);

UPDATE board_test SET gn = 2
WHERE seq IN (2, 3);

UPDATE board_test SET gn = 4
WHERE seq NOT IN (1, 2, 3, 9);

COMMIT; */

SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT gn, 
       seq, parent_seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC) a )
WHERE rn BETWEEN 6 AND 10;
-- 인라인뷰를 활용하여 위의 구문을 넣어서 페이지사이즈 구문으로 만들 수 있다
--------------------------------------------------------------------------------------------------------------------------------
-- 부서번호 10에서 가장많은 sal을 받는 사람은 누구인가?
SELECT *
FROM emp
WHERE deptno = 10
  AND sal = 
(SELECT MAX(sal)
FROM emp
WHERE deptno = 10);      

<분석 함수(window 함수)>
 : SQL에서 행간 연산을 지원하는 함수
 
   해당행의 범위를 넘어서 다른 행과 연산이 가능
   - SQL의 약점 보완
   - 이전 행의 특정 컬럼을 참조
   - 특정 범위의 행들의 컬럼의 합
   - 특정 범위의 행 중 특정 컬럼을 기준으로 순위, 행번호 부여
   - OVER 키워드를 씀  
   - SUM, COUNT, AVG, MAX, MIN
   - RANK, LEAD, LAG, .....

SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;
/* RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
 - PARTITION BY deptno : 같은 부서코드를 갖는 행을 그룹으로 묶는다.
 - ORDER BY sal : 그룹내에서 sal로 행의 순서를 정한다.
 - RANK() : 파티션 단위 안에서 정렬 순서대로 순위를 부여한다. */
 SELECT a.*, ROWNUM rn
 FROM
 (SELECT ename, sal, deptno
 FROM emp
 ORDER BY deptno, sal DESC) a;
 
-- 분석함수를 안쓰는 풀이법
SELECT a.ename, a.sal, a.deptno, b.rank
FROM 
(SELECT a.*, ROWNUM rn
FROM 
(SELECT ename, sal, deptno
 FROM emp
 ORDER BY deptno, sal DESC) a ) a,

(SELECT ROWNUM rn, rank
FROM 
(SELECT a.rn rank
FROM
    (SELECT ROWNUM rn
     FROM emp) a,
     
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno
     ORDER BY deptno) b
 WHERE a.rn <= b.cnt
ORDER BY b.deptno, a.rn)) b
WHERE a.rn = b.rn;

<순위 관련된 함수>
3개의 차이점 : 중복값를 어떻게 처리하는가?
RANK : 동일 값에 대해 동일순위 부여하고, 후순위는 동일값만큼 건너 뜀
       EX) 1등이 2명이면 그 다음 순위는 3위
DENSE_RANK : 동일 값에 대해 동일순위 부여하고,후순위는 이어서 부여함
             EX) 1등이 2명이면 그 다음 순위는 2위
ROW_NUMBER : 중복 없이 행에 순차적인 번호를 부여(ROWNUM)

SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp;

SELECT WINDOW_FUCNTION([인자]) OVER ( [PARTITION BY 컬럼] [ORDER BY 컬럼] )
FROM ...

PARTITION BY : 영역 설정
ORDER BY(ASC/DESC) : 영역 안에서의 순서 정하기

-- [ 분석함수 실습 1]
-- 사원 전체급여 순위를 RANK, DENSE_RANK, ROW NUBER를 이용하여 구하기
-- 단 급여가 동일할 경우 사번이 빠른 사람이 높은 순위가 되도록 작성
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT COUNT(*)
FROM emp;

SELECT empno, ename, sal, deptno, 
       RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_number
FROM emp;

-- [분석함수 실습 2]
-- 기준의 배운 내용을 활용하여 모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리 작성

SELECT emp.empno, emp.ename, emp.deptno, b.cnt
FROM emp,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;

SELECT empno, ename, deptno,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;