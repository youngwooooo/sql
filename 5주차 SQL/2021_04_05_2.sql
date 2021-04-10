< PL/SQL >
  - PROCEDURAL LANGUAGE SQL의 약자
  - 표준 SQL에 절차적 언어의 기능(비교, 반복, 변수 등)이 추가
  - 블록(BLOCK)구조로 구성
  - 미리 컴파일되어 실행 가능한 상태로 서버에 저장되어 필요 시 호출되어 사용됨
  - 모듈화, 캡슐화 기능 제공
  - Anonynous Block, Stored Procedure, User Defined Function, Package, Trigger 등으로 구성
  
1. 익명블록
  - pl/sql의 기본구조
  - 선언부와 실행부로 구성

< 익명블록 구성형식 >
DECLARE
  -- 선언영역
  -- 변수, 상수, 커서 선언
BEGIN
  -- 실행영역
  -- BUSINESS LOGIC 처리
  
  [EXCEPTION 예외처리명령;]

END;

-- DBMS 출력 방법 : 보기 -> DBMS 출력 -> 계정 로그인

PL/SQL EX 1) 키보드로 2~9사이의 값을 입력 받아 그 수에 해당하는 구구단을 작성하시오.

ACCEPT P_NUM PROMPT ' 수 입력(2~9) : ' -- P_  :
-- ACCEPT : 값 입력 창을 만들어줌
DECLARE V_BASE NUMBER := TO_NUMBER('&P_NUM');  -- V_ : 변수 이름을 만들 때
        V_CNT NUMBER := 0;
        V_RES NUMBER := 0;        
BEGIN
    LOOP
        V_CNT := V_CNT+1;
        EXIT WHEN V_CNT > 9;
        V_RES:= V_BASE*V_CNT;
        
        DBMS_OUTPUT.PUT_LINE(V_BASE||'*'||V_CNT||'='||V_RES);
    END LOOP;
    
    EXCEPTION WHEN OTHERS THEN  -- 모든 시스템 중에 있는 예외 중 하나라면
        DBMS_OUTPUT.PUT_LINE('예외발생 : '|| SQLERRM);  -- SQLERRM : SQL ERROR MESSAGE 
END;        
    
1) 변수, 상수 선언
  - 실행영역에서 사용할 변수 및 상수 선언
  (1) 변수 종류
    - SCLAR 변수 : 하나의 데이터를 저장하는 일반적 변수
    - REFERENCES 변수 : 해당 테이블의 컬럼이나 행에 대응하는 타입과 크기를 참조하는 변수
    - COMPOSITE 변수 : PL/SQL에서 사용하는 배열 변수(RECORD TYPE, TABLE TYPE)
    - BIND 변수 : 파라미터로 넘겨지는 IN, OUT, INOUT에서 사용되는 변수. RETURN 되는 값을 전달받기 위한 변수
    
  (2) 선언 방식
    변수명 [CONSTANT] 데이터타입 [:= 초기값] 
    변수명 테이블명.컬럼명%TYPE [:= 초기값]  ==> 컬럼 참조형
    변수명 테이블명%ROWTYPE  ==> 행 참조형
    
  (3) 데이터 타입
    - 표준 SQL에서 사용하는 데이터 타입
    - PLS_INTEGER, BINARY_INTEGER : 2147483647 ~ -2147483647까지 자료처리
    - BOOLEAN : TRUE, FALSE, NULL 처리
    - LONG(문자열), LONG RAW : DEPRECATIED
    
PL/SQL EX 1) 장바구니에서 2005년 5월 가장 많은 구매를 한(구매금액 기준) 회원정보를 조회하시오(회원번호, 회원명, 구매금액합)
SELECT *
FROM cart, prod, member;

SELECT d.mid 회원번호, m.mem_name 회원명, d.amt 구매금액합
FROM(SELECT c.cart_member mid, SUM(p.prod_price*c.cart_qty) amt
     FROM cart c, prod p
     WHERE c.cart_prod = p.prod_id 
     GROUP BY c.cart_member
     ORDER BY 2 DESC) d, member m
WHERE d.mid = m.mem_id
ORDER BY d.amt DESC
GRO

CREATE OR REPLACE VIEW V_MAXAMT
AS
SELECT d.mid 회원번호, m.mem_name 회원명, d.amt 구매금액합
FROM(SELECT c.cart_member mid, SUM(p.prod_price*c.cart_qty) amt
     FROM cart c, prod p
     WHERE c.cart_prod = p.prod_id 
     GROUP BY c.cart_member
     ORDER BY 2 DESC) d, member m
WHERE d.mid = m.mem_id
ORDER BY d.amt DESC;

ROLLBACK;
  ------ ???

익명블록
DECLARE
    V_MID V_MAXAMT.회원번호%TYPE;
    V_NAME V_MAXAMT.회원명%TYPE;
    V_AMT V_MAXAMT.구매금액합%TYPE;
    V_RES VARCHAR2(100);
BEGIN
    SELECT 회원번호, 회원명, 구매금액합 INTO V_MID, V_NAME, V_AMT
    FROM V_MAXAMT;
    
    V_RES:= V_MID||', '||V_NAME||', '||TO_CHAR(V_AMT,'99,999,999');
    
    DBMS_OUTPUT.PUT_LINE(V_RES);
END;

(상수사용 예)
키보드로 수 하나를 입력받아 그 값을 반지름으로하는 원의 넓이를 구하시오

ACCEPT P_NUM PROMPT '원의 반지름 : '
DECLARE
    V_RADIUS NUMBER := TO_NUMBER('&P_NUM');
    V_PI CONSTANT NUMBER := 3.1415926;
    V_RES NUMBER := 0;
BEGIN
    V_RES := V_RADIUS*V_RADIUS * V_PI;
    DBMS_OUTPUT.PUT_LINE('원의 너비 = '||V_RES);
END;    