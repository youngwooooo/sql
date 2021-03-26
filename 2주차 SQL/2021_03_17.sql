-- WHERE 조건1 : 10건
-- WHERE 조건1
-- AND 조건2    ==> 조건 10건을 넘을 수 없다.

SELECT *
FROM emp
WHERE deptno = 10
 AND sal > 500;
--------------------------------------------------------------------------------------------------------------------------------
-- 함수(Function)
-- 1. Single row function
--  1) 단일 행을 기준으로 작업하고, 행 당 하나의 결과를 반한
--  2) 특정 컬럼의 문자열 길이 : length(ename)
-- 2. Multi row function
--  1) 여러 행을 기준으로 작업하고, 하나의 결과를 반환
--  2) 그룹함수 : count, sum, avg

-- 함수명을 보고
-- 1. 파라미터가 어떤게 들어갈까?
-- 2. 몇 개의 파라미터가 들어갈까?
-- 3. 변환되는 값은 무엇일까?

-- charater
-- 1. 대소문자
--  1) LOWER : 소문자로 바꿈, 문자열, 입력 및 반환되는 값 문자
--  2) UPPER : 대문자로 바꿈, 문자열, 입력 및 반환되는 값 문자
--  3) INITCAP : 데이터를 소문자로 바꾼 후 첫 글자를 대문자로 바꿈, 문자열, 입력 및 반환되는 값 문자

-- 2. 문자열 조작
--  1) CONCAT : 연쇄,2개의 인자, 결합된 문자열 1개 반환 
--  2) SUBSTR : 좁은 문자열, 문자열의 일부분을 가져옴
--  3) LENGTH : 문자열의 길이 반환
--  4) INSTR : 문자열에 내가 필요한 문자열이 있는지
--  5) LPAD||RPAD : 문자열 왼쪽,오른쪽에 특정 문자 삽입
--  6) TRIM : 문자열 시작, 종료부분 공백 삭제
--  7) REPLACE : 특정 문자로의 치환, 3개의 인자
SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename),
       SUBSTR(ename, 4, 5),
       REPLACE(ename, 'S', 'T')
FROM emp;

-- 3. DUAL table
--  1) sys 계정에 있는 테이블
--  2) 누구나 사용 가능
--  3) DUMMY 컬럼 하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재
--  4) 사용 용도
--   - 데이터와 관련 없이 사용 : 함수 실행, 시퀀스 실행-
--   - merge(INSERT + UPDATE) 문에서
--   - 데이터 복제 시 사용(CONNECT BY LEVEL)
SELECT *
FROM dual;

SELECT LENGTH('TEST')
FROM dual;
-- 행이 하나이므로 실행은 한 번만 된다.

SELECT LENGTH('TEST')
FROM dual
CONNECT BY LEVEL <= 10;

-- SINGLE ROW FUNCTION : WHERE절에서도 사용 가능
-- emp 테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원만 조회
SELECT *
FROM emp
WHERE LENGTH(ename) > 5;

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
-- 권장하지 않음, ename을 LOWER로 14번을 실행해야함 ==> 비효율적

SELECT *
FROM emp
WHERE ename = UPPER('smith');
-- ename 중 'smith'를 1번만 실행하면 됨

-- ORACLE 문자열 함수
SELECT CONCAT('HELLO', CONCAT(',', 'WORLD')) CONCAT,
--  == 'HELLO || ',' || 'WORLD
       SUBSTR('HELLO, WORLD', 1, 5) SUBSTR,
       LENGTH('HELLO, WORLD'), -- 공백도 문자열에 포함된다.
       INSTR('HELLO, WORLD', 'O') INSTR,
       INSTR('HELLO, WORLD', 'O', 6) INSTR2,
       LPAD('HELLO, WORLD', 15, '=') LPAD,
       RPAD('HELLO, WORLD', 15, '=') RPAD,
       REPLACE('HELLO, WORLD', 'O', 'X') REPLACE,
       TRIM('   HELLO, WORLD'   ) TRIM,
       -- 공백을 제거, 문자열의 앞과 뒷부분에 있는 공백만! 중간 공백은 제거하지 않음!
       TRIM('H' FROM 'HELLO, WORLD') TRIM2
       -- 앞,뒤부분의 문자열을 치환
FROM dual;

-- 4. 숫자 조작
--  1) ROUND : 반올림, 2개의 인자
--  2) TRUNC : 내림, 2개의 인자
--  3) MOD : 나눗셈의 나머지
SELECT MOD (10, 3)
FROM dual;

SELECT ROUND(105.54, 1) round1, -- 반올림의 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘 째 자리에서 반올림 = 105.5
       ROUND(105.55, 1) round2, -- 반올림의 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘 째 자리에서 반올림 = 105.6
       ROUND(105.55, 0) round3, -- 반올림의 결과가 첫 번째 자리까지(일의 자리) 나오도록 : 소수점 첫 째 자리에서 반올림 = 106
       ROUND(105.55, -1) round4, -- 반올림의 결과가 두 번째 자리(십의자리)까지 나오도록 : 정수 첫 째 자리에서 반올림 = 110
       ROUND(105.55) round5 -- 소수점 첫 째 자리에서 반올림, 두 번째 인자가 없으면 0이 생략되있다고 보면됨.
FROM dual;

SELECT TRUNC(105.54, 1) trunc1, -- 반올림의 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘 째 자리에서 절삭 = 105.5
       TRUNC(105.55, 1) trunc2, -- 반올림의 결과가 소수점 첫 번째 자리까지 나오도록 : 소수점 둘 째 자리에서 절삭 = 105.6
       TRUNC(105.55, 0) trunc3, -- 반올림의 결과가 첫 번째 자리까지(일의 자리) 나오도록 : 소수점 첫 째 자리에서 절삭 = 105
       TRUNC(105.55, -1) trunc4, -- 반올림의 결과가 두 번째 자리(십의자리)까지 나오도록 : 정수 첫 째 자리에서 절삭 = 100
       TRUNC(105.55) trunc5 -- 소수점 첫 째 자리에서 절삭, 두 번째 인자가 없으면 0이 생략되있다고 보면됨.
FROM dual;

-- ex) : 789, Allen, 1600, 1, 600
SELECT empno, ename, sal, TRUNC(sal / 1000) TRUNC , MOD(sal, 1000) MOD
FROM emp;
--------------------------------------------------------------------------------------------------------------------------------
-- 4. DATE
-- FORMAT
-- 1) YYYY : 4자리 년도
-- 2) MM : 2자리 월
-- 3) DD : 2자리 일자
-- 4) D : 주간 일자(1~7)
-- 5) IW : 주차(1~53)
-- 6) HH, HH12 : 2자리 시간(12시간 표현)
-- 7) HH24 : 2자리 시간(24시간 표현)
-- 8) MI : 2자리 분
-- 9) SS : 2자리 초

-- 날짜 <==> 문자 바꾸기
-- 서버의 현재 시간 : SYSDATE
SELECT SYSDATE + 1
FROM dual;
-- 날짜 1일 추가

SELECT SYSDATE + 1/24
FROM dual;
-- 시간 1시간 추가

SELECT SYSDATE + 1/24/60
FROM dual;
-- 시간 1분 추가

SELECT SYSDATE + 1/24/60/60
FROM dual;
-- 시간 1초 추가

-- [FUCNTION 데이터 실습 1}
-- 1. 2019년 12월 31일 date 형으로 표현
-- 2. 2019년 12월 31일 date 형으로 표현하고 5일 이전 날짜
-- 3. 현재 날짜
-- 4. 현재 날짜에서 3일 전 값
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY, 
       TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 LASTDAY, 
       SYSDATE NOW, 
       SYSDATE - 3 NOW_BEFORE3
FROM dual;

-- TO_DATE : 문자를 날짜로 바꾸는 법, 인자 = 문자, 문자의 형식
-- TO_CHAR : 날짜를 문자로 바꾸는 법, 인자 = 날짜, 문자의 형식

SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY/MM/DD')
FROM dual;

-- NLS : YYYY/MM/DD/ HH24:MI:SS
-- 1=일, 2=월, 3=화, 4=수, 5=목, 6=금, 7=토
-- 'IW' = 1년의 몇 주차인가 알 수 있음, 'D' = 요일 알기
SELECT SYSDATE, TO_CHAR(SYSDATE, 'D')
FROM dual;

-- 오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오.
-- 1. 년-월-일
-- 2. 년-월-일 시간(24)-분-초
-- 3. 일-월-년
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

-- TO_DATE(문자열, 문자열 포맷)
SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD')
FROM dual;

-- TO_CHAR(날짜, 포맷팅 문자열)
-- '2021-03-17' ==> '2021-03-17 12:41:00'
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

-- 문자열을 날짜로 바꾸었다가 날짜를 다시 문자로 바꾸는 이유는 시,분,초를 기본값으로 하기 위함.
SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE - 5,'YYYYMMDD'), 'YYYYMMDD HH24:MI:SS')
FROM dual;