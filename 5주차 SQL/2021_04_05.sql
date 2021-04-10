< INDEX 객체 사용형식 >
CREATE [UNIQUE | BITMAP] INDEX 인덱스명
  ON 테이블명(컬럼명1[, 컬럼명2,...]) [ASC|DESC]
  
-- 식별자 : 부모테이블의 기본키가 자식테이블의 기본키가 되는 관계

INDEX EX 1) 상품테이블에서 상품명으로 NOMAL INDEX를 구성하시오.
CREATE INDEX idx_prod_name
 ON prod(prod_name);
 
INDEX EX 2) 장바구니테이블에서 장바구니번호 중 3번 째에서 6글자로 인덱스를 구성하시오.
SELECT *
FROM cart;

CREATE INDEX idx_cart_no
 ON cart(SUBSTR(cart_no, 3, 6));

< 인덱스의 재구성 >
 - 데이터 테이블을 다른 테이블스페이스로 이동시킨 후
 - 자료의 삽입과 삭제 동작 후
 
 < 인덱스의 재구성 사용형식 >
 ALTER INDEX 인덱스명 REBUILD;