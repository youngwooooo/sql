-- 컬럼 정보를 보는 방법
-- 1. SELECT * ==> 컬럼의 이름을 알 수 있다.
-- 2. SQL developer의 테이블 객체를 클릭하여 정보 확인
-- 3. DESC 테이블이름;  // Describe : 설명하다
DESC emp;
---------------------------------------------------------------------------------------------------

-- 데이터 타입: 날짜 / 숫자[NUMBER(0, 0) / 문자[VARCHAR2(0 BYTE)]
---------------------------------------------------------------------------------------------------

-- 숫자, 날짜에서 사용가능한 연산자
-- 일반적인 사칙연산(+, -, /, *), (): 우선순위 변경
---------------------------------------------------------------------------------------------------

-- Ctrl + F로 오류를 찾을 수 있다.
---------------------------------------------------------------------------------------------------

-- [youngwoo] 계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리(SQL) 작성
SELECT *
FROM prod;

-- [youngwoo] 계정에 있는 prod 테이블의 prod_id, prod_name 두 개의 컬럼만 조회하는 SELECT 쿼리(SQL) 작성
SELECT prod_id, prod_name
FROM prod;

-- [SELECT 실습 1]
SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;
---------------------------------------------------------------------------------------------------

-- 컬럼에 데이터타입을 추가해도 원본 데이터에 영향 X, 데이터타입을 추가한 컬럼이 새로 만들어짐
-- expression(표현)이라고 함.
SELECT empno, empno + 10
FROM emp;

SELECT empno, empno + 10, 10,
       hiredate, hiredate + 10
FROM emp;
---------------------------------------------------------------------------------------------------

-- ALIAS : 컬럼의 이름을 변경
-- ***컬럼 | expression [AS] [별칭명] => 문법이기에 중요함!, 시험문제!
SELECT empno empno, empno + 10 AS empno_plus
FROM emp;

-- 별칭명을 대문자로 하고 싶으면 ""
-- ""안에 있는 별칭명은 한글자씩 대문자로 변경 및 띄어쓰기 가능
SELECT empno "emp no", empno + 10 AS empno_plus
FROM emp;
---------------------------------------------------------------------------------------------------

-- NULL : 아직 모르는 값
-- 0과 공백은 NULL과 다르다.
-- ***NULL을 포함한 연산은 결과가 항상 NULL!
-- ==> NULL 값을 다른 값으로 치환해주는 함수
SELECT ename, sal, comm, sal+comm, comm + 100
FROM emp;
---------------------------------------------------------------------------------------------------

-- [SELECT 실습 2]
SELECT prod_id id, prod_name name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

-- 값이 한글인 것은 있으나 컬럼을 한글로 잘 쓰지 않음 
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;
---------------------------------------------------------------------------------------------------

-- literal : 값 자체
-- literal 표기법 : 값을 표현하는 방법
-- DB에서는 문자열 값을 ''로 표기
-- Hello World라고 표기하면 컬럼 + 알리아스라고 오라클은 인식함. ''안에 써줘야 문자열로 인식
-- * | { 컬럼 | 표현식 [AS] [ALIAS] }
SELECT empno, 10, 'Hello World'
FROM emp;

-- 문자열 연산
-- JAVA : String msg = "Hellow" + ", World";
-- DB : 컬럼과 문자열의 결합은 컬럼 || ''
-- CONCAT => 결합할 두 개의 문자열을 입력받아 결합하고 결합된 문자열을 변환 해준다.
SELECT empno + 10, ename || ', World',
       CONCAT(empno, ', World')
FROM emp;

-- 아이디: apeach로 표현하기
SELECT '아이디 : ' || userid,
       CONCAT('아이디 : ', userid)
FROM users;
---------------------------------------------------------------------------------------------------

-- 현재 계정에 생성된 테이블이 아닌 오라클이 내부적으로 관리하는 테이블도 호출 할 수 있다. ex: user_tables
-- 문자열을 컬럼 앞 뒤로 결합
SELECT table_name, 'SELECT * FROM ' || table_name || ';' query,
       CONCAT(CONCAT('SELECT * FROM ', table_name), ';')
       -- = CONCAT('SELECT * FROM ' || table_name, ';')
       -- = CONCAT('SELECT * FROM ', table_name || ';')
FROM user_tables;
---------------------------------------------------------------------------------------------------

-- ***SQL 키워드는 대소문자를 가리지 않지만 데이터 값은 대소문자를 가린다!
-- WHERE : 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다.(FILTER)

-- WHERE절 조건연산자
-- 부서번호가 10인 직원들만 조회(=)
SELECT *
FROM emp
WHERE deptno = 10;

-- users 테이블에서 userid 컬럼의 값이 brown인 사용자만 조회(=)
SELECT *
FROM users
WHERE userid = 'brown';

-- emp 테이블에서 부서번호가 20번보다 큰 부서에 속한 직원 조회(>)
SELECT *
FROM emp
WHERE deptno > 20;

-- emp 테이블에서 부서번호가 20번 부서에 속하지 않는 모든 직원 조회(!=)
SELECT *
FROM emp
WHERE deptno != 20;

-- 기술한 조건 자체가 참이므로 해당 컬럼의 데이터가 모두 나온다.(ex: 1 = 1, 100 = 100)
SELECT *
FROM emp
WHERE 1 = 1;

-- 문자열을 날짜 타입으로 변환하는 방법
-- TO_DATE(날짜 문자열, 날짜 문자열의 포맷팅) => 매우 안전한 방법
-- ex : TO_DATE('1981/12/11', 'YYYY/MM/DD')

-- 입사일이 81년 3월 1일부터인 모든 직원 조회
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD') ;


























