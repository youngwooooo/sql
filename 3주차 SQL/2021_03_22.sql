-- [데이터 결합 실습 join 1]
SELECT *
FROM  prod;


SELECT *
FROM  lprod;

SELECT lprod.lprod_gu, lprod.lprod_nm,
       prod.prod_id, prod.prod_name
FROM prod, lprod
WHERE lprod.lprod_gu = prod.prod_lgu;

-- [데이터 결합 실습 join 2]
-- erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buy별 담당하는 제품정보를 다음과 같은 결과가 나오도록 쿼리 작성
SELECT *
FROM buyer;

SELECT *
FROM prod;

SELECT buyer.buyer_id, buyer.buyer_name,
       prod.prod_id, prod.prod_name
FROM buyer, prod
WHERE buyer.buyer_id = prod.prod_buyer;

-- [데이터 결합 실습 join 3]
-- erd 다이어그램을 참고하여 member,cart,prod 테이블을 조인하여 회원 별 장박니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리 작성
SELECT *
FROM member;

SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT mem_id, mem_name,
       prod_id, prod_name,
       cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member AND
      cart.cart_prod = prod.prod_id;
      
SELECT mem_id, mem_name,
       prod_id, prod_name,
       cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);      

-- [데이터 결합 실습 joint 4]
-- erd 다이어그램에서 customer, cycle 테이블을 조인하여 고객별 애음 제품, 애음 요일, 개수를 나오도록 쿼리 작성(고객명이 brown, sally인 고객만 조회)
SELECT *
FROM customer;

SELECT *
FROM product;

SELECT *
FROM cycle;

SELECT customer.cid, customer.cnm, 
       cycle.pid, cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid 
  AND customer.cnm IN ('brown', 'sally');
      
-- [데이터 결합 실습 joint 5]
-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음 제품, 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록 쿼리 작성
-- 고객명이 brown, sally인 고객만 조회
SELECT customer.cid, customer.cnm,
       cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND product.pid = cycle.pid 
  AND customer.cnm IN ('brown', 'sally');
      
-- [데이터 결합 실습 joint 6]
-- erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 애음요일과 관계없이 고객별 애음 제품별, 개수의 합과 제품명을 다음과 같은 결과가 나오도록 쿼리 작성
SELECT customer.cid, customer.cnm,
       product.pid, product.pnm,
       sum(cycle.cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid 
  AND product.pid = cycle.pid
GROUP BY customer.cid, customer.cnm, product.pid, product.pnm; 

-- [데이터 결합 실습 joint 7]
-- erd 다이어그램을 참고하여 cycle, product 테이블을 이용하여 제품별, 개수의 합, 제품명을 다음과 같은 결과가 나오도록 쿼리 작성
SELECT product.pid, product.pnm,
       sum(cycle.cnt) cnt
FROM cycle, product
WHERE product.pid = cycle.pid
GROUP BY product.pid, product.pnm; 
--------------------------------------------------------------------------------------------------------------------------------
-- OUTER JOIN :컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인
-- LEFT OUTER JOIN : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
-- RIGHT OUTER JOIN : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
-- FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복데이터
-- => 테이블1 JOIN 테이블 2
-- => 테이블1 LEFT OUTER JOIN 테이블2
-- => 테이블2 RIGHT OUTER JOIN 테이블1

-- 직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 JOIN 쿼리 작성
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

-- 1. LEFT OUT JOIN

-- ORACLE SQL OUTER JOIN 표기 : (+)
-- OUTER JOIN으로 인해 데이터가 안나오는 쪽 컬럼에 (+)를 붙여준다!
SELECT ename
FROM emp;


SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno = 10;

SELECT e.ename, m.ename, m.deptno
FROM emp e, emp m
WHERE e.mgr = m.empno(+)
  AND m.deptno(+) = 10;

-- ANSI SQL
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10);

SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10;

-- 2. RIGHT OUTER JOIN


SELECT e.ename, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno);

-- 데이터 몇 건이 나올까? 그려볼 것
SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

-- FULL OUTER : LEFT OUTER(14) + RIGTH OUTER(21) - 중복데이터 : 1개만 남기고 제거
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);

-- FULL UTER JOIN은 오라클 SQL 문법으로 제공하지 않는다!
SELECT e,ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);

-- [OUTER JOIN 실습 1]
-- buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다. 모든 품목이 나올 수 있도록 쿼리 작성
SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON(buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));

SELECT COUNT(*)
FROM prod;

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON(buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'))
WHERE buyprod.buy.prod_id(+) = pord.prod_id
  AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');

-- 모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회, 없을경우는 NULL
-- 제품코드 : 수량











