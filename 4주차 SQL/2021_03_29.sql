SELECT ename, job, ROWID
FROM emp
ORDER BY ename, job;

*** INDEX 생성에서 컬림의 순서는 중요하다!       

CREATE 객체타입(INDEX,TABLE 등등) 객체명(이름) 
DROP 객체타입 객체명

job, ename 컬럼으로 구성된 IDX_emp_03 인덱스 삭제
DROP INDEX IDX_emp_03;
ename, job 컬럼으로 구성된 IDX_emp_04 인덱스 생성
CREATE INDEX IDX_emp_04 ON emp(ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%';
 
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       


SELECT ROWID, dept.*
FROM dept;

CREATE INDEX IDX_dept_01 ON dept(deptno);

테이블을 동시에 읽을 수는 없다. 차례대로 읽어야함
* WHERE절에 보통 '='를 쓴 컬럼을 우선순위로 인덱스를 생성함
emp
1. table full access
2. idx_emp_01
3. idx_emp_02
4. idx_emp_04

dept
1. table full access
2. idx_dept_01

ex)
emp(4) -> dept(2)
dept(2) -> emp(4)
총 16가지의 읽기 방법이 있다.
접근방법 * 테이블^개수

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.empno = 7788;
  
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

응답성 : OLTP (Online Transaction Processing)
퍼포먼스 : OLAT (Online Analysis Processing) - ex) 은행이자 계산

4 -> 3 -> 5 -> 2 -> 6 -> 1 -> 0
---------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |     1 |    32 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |             |       |       |            |          |
|   2 |   NESTED LOOPS                |             |     1 |    32 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    13 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_EMP_01  |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN           | IDX_DEPT_01 |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT        |     1 |    19 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   
   
Index Access
1. 각 인덱스마다 저장공간이 필요하다.
2. 소수의 데이터를 조회할 때 유리(응답속도가 필요할 때)
    -> Index를 사용하는 Input/Output Single Block I/O
3. 다량의 데이터를 인덱스로 접근할 경우 속도가 느리다(2~3000건) 

Table Access
1. 테이블의 모든 데이터를 읽고서 처리를 해야하는 경우 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
    -> I/O기준이 multi bloce
    
DDL(테이블에 인덱스가 많은경우)
1. 테이블의 빈 공간을 찾아 데이터를 입력
2. 인덱스 구성 컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장
3. 인덱스는 B*트리 구조이고, root node부터 leaf node까지의 depth가 항상 같도록 밸런스를 유지한다.
4. 즉 데이터 입력으로 밸런스가 무너질 경우 밸런스를 맞추는 추가 작업이 필요
5. 2~4까지의 과정을 각 인데스 별로 반복
6. 인덱스가 많아 질 경우 위 과정이 인덱스 개수 만큼 반복 되기 때문에 UPDATE, INSERT, DELETE 시 부하가 커진다
7. 인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터 변경시 부하가 생긴다
8. 테이블에 과도한 수의 인덱스를 생성하는 것은 바람직 하지 않음
9. 하나의 쿼리를 위한 인덱스 설계는 쉬움
10. 시스템에서 실행되는 모든 쿼리를 분석하여 적절한 개수의 최적의 인덱스를 설계하는 것이 힘듬

-- [DDL INDEX 실습 3] -> 인덱스 짜보기!

<달력 만들기>
* 배우고자 하는 것
- 데이터의 행을 열로 바꾸는 방법
- 레포트 쿼리에서 활용할 수 있는 예제 연습

- 주어진 상황 : 년, 월 6자리 문자열 
- 만들 것 : 해당 년월의 일자를 달력형태로 출력, 요일을 맞춰 한 줄에 한주차씩 표현
- 7컬럼짜리 테이블을 만드는 것임

20210301 - 날짜
.
.
.
.
20210331

-- LEVEL은 1부터 시작
SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <= 10;

SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;


SELECT  /*DECODE(d, 1, iw+1, iw),*/
        MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,
        MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
        MIN(DECODE(d, 5, dt)) tho, MIN(DECODE(d, 6, dt)) fri,
        MIN(DECODE(d, 7, dt)) sat
FROM
      (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
              TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
              TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


-- iw로 group by를 하지말고 해결해야함.
SELECT  /*DECODE(d, 1, iw+1, iw),*/
        MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,
        MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,
        MIN(DECODE(d, 5, dt)) tho, MIN(DECODE(d, 6, dt)) fri,
        MIN(DECODE(d, 7, dt)) sat
FROM
      (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
              TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d,
              TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


<계층쿼리>
- 조직도, BOM(Bill Of Materail), 게시판(답변형 게시판)
- 데이터의 상하관계를 나타내는 쿼리
SELECT empno, ename, mgr
FROM emp;

- 사용방법
1. 시작위치를 설정(START WIHT)
2. 행과 행의 연결 조건을 기술
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;


CONNECT BY 내가 읽은 행의 사번과 = 앞으로 읽을 행의 mgr 컬럼

PRIOR : 이미 읽은 데이터
이미 읽은 데이터        앞으로 읽어야 할 데이터
king의 사번 = mgr 컬럼의 값이 king의 사번인 사람
emp = mgr

SELECT LPAD('TEST', 1*4)
FROM dual;

<계층쿼리 방향에 따른 분류>
- 상향식 : 최하위 노드(leaf node)에서 자신의 부모 노드를 방문하는 형태
- 하향식 : 최상위 노드(root)에서 모든 자식 노드를 방문하는 형태

- 상향식 계층쿼리 예제
SMITH(7369)부터 시작하여 노드의 부모를 따라가는 계층형 쿼리 생성

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY PRIOR mgr = empno;
-- CONNECT BY PRIOR mgr 컬럼값 = 앞으로 읽을 행의 empno
--------------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM dept_h;

최상위 노드부터 리프노드까지 탐색하는 계층쿼리 작성
(LPAD를 이용한 시각적 표현까지 포함)

SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm, p_deptcd, LEVEL
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

//PSUEDO CODE - 가상코드
CONNECT BY 현재 행의

정보시스템부 하위의 부서계층 구조를 조회하는 쿼리 작성
SELECT LEVEL, deptcd, 
       LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

디자인팀에서 시작하는 상향식 계층쿼리 작성
SELECT LEVEL, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd;
--------------------------------------------------------------------------------------------------------------------------------
계층형쿼리복습.sql을 이용하여 테이블을 생성하고
다음가 같은 결과가 나오도록 쿼리 작성
s_id : 노드 아이디
ps_id : 부모 노드 아이디
value : 노드 값

SELECT LPAD(' ', (LEVEL-1)*4) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

DESC h_sum;