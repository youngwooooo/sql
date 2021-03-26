-- 1교시 Between and 배움 알아볼것
-- Betwwen A and B = A 이상이고 B 이하인 데이터를 조회할 때 사용!
-- emp 테이블에서 입사일이 1981년 1월 1일 ~ 1981년 12월 31일인 직원의 정보 조회
SELECT *
FROM emp
WHERE hiredate Between '1981/01/01' and '1981/12/31';
---------------------------------------------------------------------------------------------------

-- IN 연산자는 OR과 같다.
-- IN 연산자: WHERE절 내에서 특정한 값 여러개를 선택
-- 
SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno = 10
 OR deptno = 20;

SELECT *
FROM emp
WHERE 10 IN (10, 20);
-- 10은 10과 같거나 10은 20과 같다
--  TRUE      OR      FALSE  ==> TRUE!

-- [ IN 실습 WHERER 3]
-- IN 연산자 사용
SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');

-- userid = 'borwn' 이거나 userid = 'cony' 이거나 userid = 'sally'
SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid = 'brown'
 OR userid = 'cony'
 OR userid  = 'sally';
---------------------------------------------------------------------------------------------------

-- LIKE 연산자 : 문자열 매칭 조회
-- 게시글 : 제목 검색, 내용 검색
--         제목에 [맥북에어]가 들어가는 게시글만 조회
-- ex) 1. 얼마 안된 맥북에어 팔아요, 2. 맥북에어 팔아요, 3. 팝니다 맥북에어
-- 테이블: 게시글, 제목 컬럼: 제목, 내용 컬럼: 내용
SELECT *
FORM 게시글
WHERE 제목 LIKE '%맥북에어%'
 OR 내용 LIKE '%맥북에어%';
-- 제목       내용
--  1          2
-- TRUE  OR  TRUE  ==> TRUE
-- TRUE  OR  FLASE  ==> TRUE
-- FALSE OR  TRUE  ==> TRUE
-- FLASE OR  FLASE  ==> FLASE

-- 제목       내용
--  1          2
-- TRUE  AND  TRUE  ==> TRUE
-- TRUE  AND  FLASE  ==> FLASE
-- FALSE AND  TRUE  ==> FLASE
-- FLASE AND  FLASE  ==> FLASE

-- % : 0개 이상의 문자 ==> 거의 이거씀!
-- _ : 1개의 문자 ==> 잘 쓰지 않음!

-- userid 가 c로 시작하는 모든 사용자
SELECT *
FROM users
WHERE userid LIKE 'c%';

-- userid가 c로 시작하면서 c이후에 3개의 글자가 오는 사용자
SELECT *
FROM users
WHERE userid LIKE 'c___';

-- userid에 l이 들어가는 모든사용자 조회
-- 
SELECT *
FROM users
WHERE userid LIKE '%l%';

--[ LKIE, %, _ 실습 WHERE 4]
-- member 테이블에서 성이 '신'인 사람 mem_id, mem_name 조회 ==> mem_name의 첫 글자가 '신'이고 뒤에는 뭐가와도 상관없다.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

--[ LIK, %, _ 실습 WHERE 5]
-- member 테이블에서 회원의 이름에 글자 '이'가 들어가있는 모든사람의 mem_id, mem_name을 조회
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';
---------------------------------------------------------------------------------------------------

-- IS(NULL 비교)
-- NULL 값을 조회할 때는 ' = '를 사용할 수 없음!
-- emp 테이블에서 comm 컬럼의 값이 NULL인 사람만 조회
SELECT *
FROM emp
WHERE comm IS NULL;

-- emp 테이블에서 comm 컬럼의 값이 NULL이 아닌 사람만 조회
SELECT *
FROM emp
WHERE comm IS NOT NULL;

-- emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NULL;
---------------------------------------------------------------------------------------------------

-- BETWEEN AND, IN, LIKE, IS, IS NOT

-- 논리 연산자: AND, OR, NOT
-- 1. AND : 두 가지 조건을 동시에 만족시키는지 확인할 때  ==> 조건1 AND 조건2
-- 2. OR : 두 가지 조건 중 하나라도 만족시키는지 확인할 때  ==> 조건1 OR 조건2
-- 3. NOT : 부정형 논리연산자, 특정조건을 부정  ==> ex) mgr IS NULL : mgr 컬럼 값이 NULL인 사람만 조회
--                                          ==>     mgr IS NOT NULL: mgr 컬럼 값이 NULL이 아닌 사람만 조회

-- emp 테이블에서 mgr의 사번이 7698이면서 sla값이 1000보다 큰 직원만 조회
SELECT *
FROM emp
WHERE mgr = 7698
 AND sal > 1000;

-- 조건의 순서는 결과와 상관없음!
SELECT *
FROM emp
WHERE sal > 1000
 AND mgr = 7698;

-- sal 컬럼의 값이 1000보다 크거나 mgr 사번이 7698인 직원 조회
SELECT *
FROM emp
WHERE sal > 1000
 OR mgr = 7698; 

-- AND 조건이 많다 : 조회되는 데이터 건수가 줄어든다.
-- OR 조건이 많다. : 조회되는 데이터 건수가 많아진다.

-- NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다.
--       IS NOT, NOT IN, NOT LIKE
-- 직원의 부서번호가 30번이 아닌 직원 조회
SELECT *
FROM emp
WHERE deptno NOT IN (30);
-- NOT IN 연산자 사용시 주의점 : 데이터 중 NULL값이 있으면 NULL값을 가진 데이터는 조회되지 않는다.
SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);
-- ==> mgr = 7698 OR mgr = 7839 OR mgr = NULL  * 중요!
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
-- ==> mgr != 7698 AND mgr != 7839 AND mgr != NULL  * 중요! / 시험문제!!
-- TURE, FALSE 의미가 없음 mgr != NULL  ==> AND FALSE, NULL이 있으면 그 구문은 FALSE로 데이터가 안나온다!
-- mgr = 7698  ==> mgr != 7698
-- OR의 부정형 ==> AND  *중요!

-- 직원의 이름이 'S'로 시작하는 사람이 아닌 직원
SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';

-- [ AND, OR 실습 WHERE 7]
-- emp 테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- [ AND, OR 실습 WHERE 8]
-- emp 테이블에서 부서번호가 10이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보 조회(NOT IN 사용금지) 
SELECT *
FROM emp
WHERE deptno != 10  -- ==> deptno NOT IN ( 10 );
 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
 
-- [ AND, OR 실습 WHERE 10]
-- emp 테이블에서 부서번호가 10이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보 조회( IN 사용 / INT는 10, 20, 30만 있다고 가정)
SELECT *
FROM emp
WHERE deptno IN ( 20, 30 )
 AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

-- [ AND, OR 실습 WHERE 11 ]
-- emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후의 직원의 정보 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'
 OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
 
 -- [ AND, OR 실습 WHERE 12 ] ==> 풀면 좋고, 못풀어도 괜찮음!
 -- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회
 SELECT *
 FROM emp
 WHERE job = 'SALESMAN' 
  OR empno LIKE '78%';
  
  -- [ AND, OR 실습 WHERE 13 ] ==> 과제
  -- emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회(LIKE 사용금지)
  SELECT *
  FROM emp
  WHERE job = 'SALESMAN'
   OR empno BETWEEN 7800 AND 7899
   OR empno BETWEEN 780 AND 789
   OR empno BETWEEN 78 AND 78;
   
---------------------------------------------------------------------------------------------------

-- 중요한 것!
-- 해당 연산자는 몇개의 항을 연결하고 써야하는가?
-- BETWEEN, IN, LIKE
-- 논리 연산자
-- LIKE = 문자열 매칭 조회
-- NOT IN 사용시 주의점 = 논리적으로 어떻게 해석이되는가?, NULL값이 포함되어 비교시 데이터가 나오지 않음
