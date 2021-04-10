< 반복문 >
  - 개발언어의 반복문과 같은 기능 제공
  - loop, while, for문
  
  1) LOOP 문
    - 반복문의 기본 구조
    - JAVA의 DO 문과 유사한 구조
    - 기본적으로 무한 루프 구조
    (사용 형식)
    LOOP
        반복처리문(들);
        [EXIT WHEN 조건;]
    END LOOP;
    - 'EXIT WHEN 조건' : '조건'이 참인 경우 반복문의 범위를 벗어난다
    
LOOP EX 1) 구구단의 7단을 출력
DECLARE
    V_CNT NUMBER:= 1;  -- NUMBER를 쓰면 꼭 초기화해야함!
    V_RES NUMBER:= 0;
BEGIN
    LOOP
    V_RES:= 7*V_CNT;
    EXIT WHEN V_CNT > 9;
    DBMS_OUTPUT.PUT_LINE(7||'*'||V_CNT||'='||V_RES);
    V_CNT:= V_CNT+1;
    END LOOP;
END;    

LOOP EX 2) 1~50사이의 피보나치수를 구하여 출력하시오
  - FIBONACCI NUMBER : 첫 번째와 두 번째 수가 1로 주어지고 세 번째 수부터 전 두 수의 합이 현재수가 되는 수열 => 검색 알고리즘에 사용(피보나치 서칭)
DECLARE
    V_PNUM NUMBER:= 1; -- 전 수
    V_PPNUM NUMBER:= 1; -- 전전 수
    V_CURRNUM NUMBER:= 0; -- 현재 수
    V_RES VARCHAR(100);
BEGIN
    V_RES:=V_PPNUM||', '||V_PNUM;
    
    LOOP
        V_CURRNUM:= V_PPNUM+V_PNUM;
        EXIT WHEN V_CURRNUM >=50;
        V_RES:=V_RES||', '||V_CURRNUM;
        V_PPNUM:=V_PNUM;
        V_PNUM:= V_CURRNUM;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~50사이의 파보나치 수 : '||V_RES);
END;    
--------------------------------------------------------------------------------------------------------------------------------

  2) WHILE 문
    - 개발언어의 WHILE문과 같은 기능
    - 조건을 미리 체크하여 '조건'이 참인 경우에만 반복처리
    (사용형식)
    WHILE 조건
        LOOP
            반복처리문(들);
        END LOOP;    
        
WHILE EX 1) 첫 날에 100원, 둘째 날부터 전 날의 2배씩 저축할 경우 최초로 100만원을 넘는 날과 저축한 금액을 구하시오.
DECLARE
    V_DAYS NUMBER:= 0;  -- 날짜
    V_AMT NUMBER:= 100;  -- 날짜별 저축 할 액수
    V_SUM NUMBER:= 0;  -- 전체 저축금액의 합
BEGIN
    WHILE V_SUM < 1000000
        LOOP
            V_SUM:= V_SUM+V_AMT;
            V_DAYS:= V_DAYS + 1;
            V_AMT:= V_AMT*2;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('날수 : '||V_DAYS);
        DBMS_OUTPUT.PUT_LINE('저축금액 : '||V_SUM);
END;        

WHILE EX 2) 회원테이블(MEMBER)에서 마일리지가 3000이상인 회원들을 찾아, 그들이 2005년 5월에 구매한 횟수와 구매금액의 합계를 구하시오.(커서사용)
            출력은 회원번호, 회원명, 구매횟수, 구매금액
                 
SELECT * FROM MEMBER;
SELECT * FROM CART;
SELECT * FROM PROD;

(LOOP를 사용한 커서 실행) 
DECLARE
    V_MID MEMBER.MEM_ID%TYPE;  -- 회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE;  -- 회원명
    V_CNT NUMBER:= 0;  -- 구매횟수
    V_AMT NUMBER:= 0;  -- 구매금액 합계
    
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE > 3000;

BEGIN
    OPEN CUR_CART_AMT;
    LOOP
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        
        SELECT SUM(A.CART_QTY*B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = V_MID
          AND SUBSTR(A.CART_NO, 1, 6) = '200505';
      
          DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');
     END LOOP;
     CLOSE CUR_CART_AMT;
END;     

(WHILE를 사용한 커서 실행) -- ** FETCH문이 WHILE문 밖, END LOOP 전에 하나씩 있어야한다!
DECLARE
    V_MID MEMBER.MEM_ID%TYPE;  -- 회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE;  -- 회원명
    V_CNT NUMBER:= 0;  -- 구매횟수
    V_AMT NUMBER:= 0;  -- 구매금액 합계
    
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE > 3000;

BEGIN
    OPEN CUR_CART_AMT;
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;  -- <WHILE문 밖>
    WHILE CUR_CART_AMT%FOUND 
    LOOP
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        
        SELECT SUM(A.CART_QTY*B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = V_MID
          AND SUBSTR(A.CART_NO, 1, 6) = '200505';
      
          DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' => '||V_AMT||'('||V_CNT||')');
          
          FETCH CUR_CART_AMT INTO V_MID, V_MNAME;  -- <END LOOP 전>
     END LOOP;
     CLOSE CUR_CART_AMT;
END;     
--------------------------------------------------------------------------------------------------------------------------------

  3) FOR 문
    - 반복횟수를 알고 있거나 횟수가 중요한 경우 사용
    (사용형식 1 : 일반적인 FOR 문)
      - '인덱스'는 시스템에서 자동으로 설정
      
    FOR 인덱스 IN[REVERSE] 최소값..최대값  
    LOOP
        반복처리문(들);
    END LOOP;
      
    
FOR-1 EX 1) FOR문을 사용하여 구구단 7단 출력
DECLARE
   -- V_RES NUMBER:= 0;  -- 결과
BEGIN
    FOR I IN 1..9
    LOOP
      -- V_RES:= 7*I;
      -- DBMS_OUTPUT.PUT_LINE(7||'*'||I||'='||V_RES);
      DBMS_OUTPUT.PUT_LINE(7||'*'||I||'='||7*I);
    END LOOP;
END;

    (사용형식 2 : CURSOR에 사용하는 FOR 문)
      - '레코드명'은 시스템에서 자동으로 설정
      - 커서 컬럼 참조형식 : 레코드명.커서컬럼명  => 변수 선언이 필요 없다.
      - 커서명 대신 커서 선언문(선언부에 존재했던)을 INLINE 형식으로 기술할 수 있다
      - FOR 문을 사용하는 경우 커서의 OPEN, FETCH, CLOSE 문은 생략
      
    FOR 레코드명 IN 커서명|커서 선언문
    LOOP
        반복처리문(들);
    END LOOP;
      
      
FOR-2 EX 1) 회원테이블(MEMBER)에서 마일리지가 3000이상인 회원들을 찾아, 그들이 2005년 5월에 구매한 횟수와 구매금액의 합계를 구하시오.(커서사용)
            출력은 회원번호, 회원명, 구매횟수, 구매금액
                 
SELECT * FROM MEMBER;
SELECT * FROM CART;
SELECT * FROM PROD;

(FOR문을 사용한 커서 실행) 
DECLARE
    V_CNT NUMBER:= 0;  -- 구매횟수
    V_AMT NUMBER:= 0;  -- 구매금액 합계
    
    CURSOR CUR_CART_AMT
    IS
        SELECT MEM_ID, MEM_NAME
        FROM MEMBER
        WHERE MEM_MILEAGE > 3000;

BEGIN
    FOR REC_CART IN CUR_CART_AMT
    LOOP    
        SELECT SUM(A.CART_QTY*B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = REC_CART.MEM_ID
          AND SUBSTR(A.CART_NO, 1, 6) = '200505';
      
          DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||' => '||V_AMT||'('||V_CNT||')');
     END LOOP;
END;      

(FOR문에서 INLINE 커서를 사용) 
DECLARE
    V_CNT NUMBER:= 0;  -- 구매횟수
    V_AMT NUMBER:= 0;  -- 구매금액 합계
BEGIN
    FOR REC_CART IN (SELECT MEM_ID, MEM_NAME  -- 제일 많이 사용하는 형식
                     FROM MEMBER              -- 커서에 있는 SELECT문을 가져와 IN 뒤에 INLINE커서로 활용 => 커서는 없애도 됨.
                     WHERE MEM_MILEAGE > 3000)
    LOOP    
        SELECT SUM(A.CART_QTY*B.PROD_PRICE),
               COUNT(A.CART_PROD) INTO V_AMT, V_CNT
        FROM CART A, PROD B
        WHERE A.CART_PROD = B.PROD_ID
          AND A.CART_MEMBER = REC_CART.MEM_ID
          AND SUBSTR(A.CART_NO, 1, 6) = '200505';
      
          DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||' => '||V_AMT||'('||V_CNT||')');
     END LOOP;
END;      