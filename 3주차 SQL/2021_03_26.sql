읽기 일관성 레벨 (0 -> 3)
트랜젝션에서 실행한 결과가 다른 트랜잭션에 어떻게 영향을 미치는지 정의한 레벨(단계)

LEVEL 0 : READ UNCOMMITED
- drity (변경이 가해졌다) read
- 커밋을 하지 않은 변경사항도 다른 트랜잭션에서 확인 가능
- ORACLE에서는 지원하지 않음.

LEVEL 1 : READ COUMMITED
- 대부분의 DBMS 읽기 일관성 설정 레벨
- 커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다.
- 커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다.

LEVEL 2 : Reapeatable Read
- 선행 트랜잭션에서 읽은 데이터를 후행 트랜잭션에서 수정하지 못하도록 방지
- 선행 트랜젝션에서 읽었던 데이터를 트랜잭션 마지막에서 다시 조회를 해도 동일한 결과가 나오게끔 유지
- 신규 입력 데이터에 대해서는 막을 수 없음  ==> Phantom Read(유령 읽기) : 없는 데이터가 조회 되는 현상
  기존 데이터에 대해서는 동일한 데이터가 조회되도록 유지
- oracle에서는 LEVEL 2에 대해 공식적으로 지원하지 않으나 FOR UPDATE 구문을 이용하여 효과를 만들어 낼 수 있다.

LEVEL 3 : Serialzable read 직렬화 읽기
- 후행 트랜잭션에서 수정, 입력, 삭제한 데이트가 선행 트랜잭션에 영향을 주지 않음.
- 선 : 데이터조회 (14)
- 후 : 신규에 데이터 입력(15)
- 선 : 데이터 조회 (14)

< 인덱스 >
- 눈에 보이지 않음.
- 테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
   ==> 정렬이 되있다. 즉, 원하는 데이터를 빠르게 찾을 수 있다.
   ==> 일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWUID가 같이 저장 됨.
- ROWID : 테이블의 저장된 행의 물리적 위치, 집 주소 같은 개념
          주소를 통해서 해당 행의 위치를 빠르게 접근하는 것이 가능하다.
          데이터가 입력이 될 때 생성(생성되는 ID 값은 오라클이 알아서 만든 것)
   
SELECT ROWID, emp.*
FROM emp
WHERE ROWID = 'AAAE5gAAFAAAACPAAA';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

< 오라클 객체 생성 >
CREAT 객체 타입(INDEX, TABLE, ....) 객체명

< 인덱스 생성 >
CREATE [UNIQUE] INDEX 인덱스이름 ON 테이블명(컬럼1, 컬럼2, ....);

CREATE UNIQUE INDEX PK_emp ON emp(empno); 

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 2949544139

 2->1->0
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)



EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 56244932
 
 1->0 , 테이블이 아닌 인덱스로 접근하여 empno 값만 확인
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782)
   
   
   
DROP INDEX PK_emp; -- 인덱스 삭제

CREATE INDEX IDX_emp_01 ON emp(empno);
-- 중복이 가능한 INDEX (UNIQUE를 안넣음)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
-- RANGE = 범위, 중복이 가능하기 때문에 범위를 읽음. 7782가 중복이 되는지 안되는지 확인을 하기 위함.
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   

CREATE INDEX IDX_emp_02 ON emp(job);

SELECT job, ROWID
FROM emp
WHERE job = 'MANAGER';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
   
   
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY); 

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
   
   
CREATE INDEX IDX_emp_03 ON emp(job, ename);   

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY); 

Plan hash value: 2549950125
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
       

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
 AND ename LIKE '%C';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);        