[연습문제]
SMITH가 속한 부서에 있는 직원들을 조회하기?
1. SMITH가 속한 부서번호를 알아낸다.
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp테이블에서 검색한다.

1. 부서번호 알아내기
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2. 부서번호에 있는 직원 조회
SELECT *
FROM emp
WHERE deptno = 20;

* 서브쿼리(subquery) 활용
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
* 서브쿼리 사용에 따라 연산자를 변경 할 필요가 있다.
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN');  ==> 오류
                
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename = 'SMITH' OR ename = 'ALLEN');  ==> =를 IN으로 변경
                 
SUBQUERY : 쿼리의 일부로 사용되는 쿼리
1. 사용위치에 따른 분류
    - SELECT : 스칼라 서브 쿼리 => 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리
    - FROM : 인라인 뷰
    - WHERE : 서브 쿼리
                * 메인쿼리의 컬럼을 서브쿼리 컬럼에 가져다 사용할 수 있다!!!
                * 반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다!!!

2. 반환값에 따른 분류(행, 컬럼의 개수에 따른 분류)
    * 행: 다중행, 단일행 / 컬럼: 단일 컬럼, 복수 컬럼
    - 다중행 / 단일 컬럼 IN, NOT IN
    - 다중행 / 복수 컬럼
    - 단일행 / 단일 컬럼
    - 단일행 / 복수 컬럼
    
3. main-sub query의 관계에 따른 분류
    - 상호 연관 서브 쿼리(correlated subquery) : 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
        ==> 메인 쿼리가 없으면 서브 쿼리만 독자적으로 실행 불가능!
    - 비상호 연관 서브 쿼리(non-correlated subquery) : 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않는 경우
        ==> 메인 쿼리가 없어도 서브 쿼리만 실행 가능!
                
-- [서브쿼리 실습 1]
-- 평균 급여보다 높은 급여를 받는 직원의 수 조회
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal >= 2073;
                
SELECT COUNT(*)
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);        
              
-- [서브쿼리 실습 2]
-- 평균 급여보다 높은 급여를 받는 직원의 정보 조회
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);
              
-- [서브쿼리 실습 3]
-- SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회
SELECT deptno
FROM emp
WHERE ename IN('SMITH', 'WARD');

SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ename IN('SMITH', 'WARD'));
                
MULTI ROW 연산자(많이 쓰진 않는다.)
 - IN : = + OR
 - 비교 연산자 ANY
 - 비교 연산자 ALL

- 비교연산자 ANY  
 SELECT *
 FROM emp m
 WHERE m.sal < ANY(SELECT s.sal
                   FROM emp s
                   WHERE s.ename IN('SMITH', 'WARD'));  ==> 직원 중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 적은 직원을 조회
                                                        ==> 즉, 직원 중에 급여값이 WARD(1250)보다 적은 직원 조회

 SELECT *
 FROM emp m
 WHERE m.sal < (SELECT MAX(s.sal)
                FROM emp s
                WHERE s.ename IN('SMITH', 'WARD'));  ==> ANY 연산자를 쓰지 보통 서브쿼리로 표현
                
- 비교연산자 ALL
SELECT *
 FROM emp m
 WHERE m.sal < ALL (SELECT s.sal
                    FROM emp s
                    WHERE s.ename IN('SMITH', 'WARD'));  ==> 직원 중에 급여가 SMITH(800)보다 작고 WARD(1250)보다 작은 직원 조회
                                                         ==> 즉, 직원의 급여가 SMITH(800)보다 작은 직원 조회

SELECT *
 FROM emp m
 WHERE m.sal < (SELECT MIN(s.sal)
                FROM emp s
                WHERE s.ename IN('SMITH', 'WARD'));  ==> ALL 연산자를 쓰지 않고 보통 서브쿼리로 표현
                
* subquery 사용 시 주의점!
  : NULL 값
    - IN ()
    - NOT IN ()
    
SELECT *
FROM emp
WHERE deptno IN(10, 20, NULL);
==> deptno = 10 OR deptno = 20 OR deptno = NULL;
                                    FALSE          ==> 즉 앞의 TRUE인 조건들은 조회가능!

SELECT *
FROM emp
WHERE deptno NOT IN(0, 20, NULL);
==> !(deptno = 10 OR deptno = 20 OR deptno = NULL);
==> deptno != 10 AND deptno != 20 AND deptno != NULL;
                                         FALSE  ==> AND이라서 맨 마지막 조건이 FALSE이기 때문에 조건 자체가 FALSE가 되어 데이터가 조회 불가!


SELECT *
FROM emp
WHERE empno NOT IN(SELECT NVL(mgr, 9999)
                   FROM emp);
                   

PAIR WISE : 순서쌍

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN(7499, 7782))
 AND deptno IN (SELECT deptno
                FROM emp
                WHERE empno IN(7499,7782));
            
-- ALLEN(30, 7698), CLARK(10, 7839)                
SELECT ename, mgr, deptno
FROM emp
WHERE empno IN(7499, 7782);

SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
 AND deptno IN (10, 30);
-- mgr, deptno로 만들어지는 경우의 수
--(7698, 10) (7698, 30) (7839, 10) (7839, 30)

--요구사항: ALLEN 또는 CLARK의 소속 부서번호와 같으면서 상사도 같은 경우

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE ename IN('ALLEN', 'CLARK'));
                
DISTINCT가 사용되는 경우
  1. 설계가 잘못된 경우
  2. 개발자가 SQL을 잘 작성하지 못하는 사람인 경우
  3. 요구사항이 이상한 경우
  
스칼라 서브 쿼리 : SELECT 절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 반환하는 서브쿼리  * 보통 상호 연관성 서브 쿼리를 사용함!
                 행의 수가 많을 경우 비효율적!

SELECT empno, ename, SYSDATE
FROM emp;

SELECT SYSDATE
FROM dual;

SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp;
                   
emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다.
해당 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.

* 상호 연관 서브 쿼리는 항상 메인 쿼리가 먼저 실행된다!!
SELECT *
FROM dept;

SELECT empno, ename, depton, (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)
FROM emp;

* 비상호연관 서브쿼리는 메인쿼리가 먼저 실행 될 수도 있고
                     서브쿼리가 먼저 실행 될 수도 있다.
                        ==> 성능측면에서 유리한 쪽으로 오라클이 선택
                        
인라인 뷰 : SELECT QUERY
 - inline : 해당 위치에 직접 기술 함.
 - inline view : 해당 위치에 직접 기술한 view
 - view : QUERY(O) ==> VIEW TABLE(X)

SELECT *
FROM
(SELECT deptno, ROUND(AVG(sal), 2)
FROM emp
GROUP BY deptno);
--------------------------------------------------------------------------------------------------------------------------------
상호 연관성 비상호 연관성 쿼리 비교 예제

아래 쿼리는전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);

직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회
SELECT empno, ename, sal, deptno
FROM emp e
WHERE e.sal > (SELECT AVG(sal)
                FROM emp a
                WHERE a.deptno = e.deptno);
                ==> 상호 연관성 서브 쿼리를 where절에도 쓸 수있다.

10번 부서의 급여 평균(2916)
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

20번 부서의 급여 평균(2175)
SELECT AVG(sal)
FROM emp
WHERE deptno = 20;

30번 부서의 급여 평균(1566)
SELECT AVG(sal)
FROM emp
WHERE deptno = 30;

모든 부서의 급여 평균
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;


-- [서브쿼리 실습 4]
-- dept 테이블에는 신규등록된 99번 부서에 속한 사람은 없음.
-- 직원이 속하지 않는 부서를 조회하는 쿼리를 작성하세요
SELECT *
FROM dept;

SELECT deptno
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);

-- [서브쿼리 실습 5]
-- cycle, product 테이블을 이용하여 cid=1인 고객이 애음하지 않는 제품을 조회하는 쿼리 작성
SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);




















