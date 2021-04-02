< VIEW >
- TABLE과 유사한 객체
- 기존의 테이블이나 다른 VIEW객체를 통하여 새로운 SELECT문의 결과를 테이블처럼 사용(가상테이블)
- SELECT문에 귀속되는 것이 아닌 독립적으로 테이블처럼 존재
- 원본 테이블을 수정하면 VIEW도 수정된다.


< VIEW 를 이용하는 경우 >
- 필요한 정보가 한 개의 테이블에있지 않고 여러 개의 테이블에 분산되어 있는 경우
- 테이블의 일부분만 필요하고 자료의 전체나 row, colum이 필요하지 않은 경우
- 특정 자료에 대한 접근을 제한하고자 할 경우(보안) ex) 영업비밀, 거래처별 단가, 사원 연봉 등
-- 즉, 보안 / QUERY 실행의 효율성 / TABLE의 은닉성을 위해 사용


< VIEW 사용형식 >
CREATE [OR REPLACE][FORCE|NOFORCE] VIEW 뷰이름[(컬럼LIST)]
AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]
    
- OR REPLACE : VIEW가 존재하면 대체되고 없으면 신규로 생성
- FORCE|NOFORCE : 원본 테이블이 없어도 VIEW를 생성(FORCE), 생성불가(NOFORCE)
- 컬럼LIST : 생성된 뷰의 컬럼명
- WITH CHECK OPTION : SELECT문의 조건절(WHERE)에 위배되는 DML명령 실행 거부
- WITH READ ONLY : 읽기전용 VIEW 생성
-- WITH CHECK OPTION 과 WITH READ ONLY는 같이 쓸 수 없다!

VIEW EX 1) 사원테이블에서 부모부서 코드가 90번 부서에 속한 사원정보를 조회하시오
           조회 데이터 : 사원번호, 사원명, 부서명, 급여
           
VIEW EX 2) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하시오.
SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
FROM member
WHERE mem_mileage >= 3000;

-- VIEW 생성
CREATE OR REPLACE VIEW v_member01
AS
    SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000;    
    
SELECT * FROM v_member01;

-- 신용환 회원의 자료 검색
SELECT mem_name, mem_job, mem_mileage
FROM member
WHERE UPPER(mem_id) = 'C001';  -- 아이디가 대문자인지 소문자인지 모르기 때문에 UPPER 활용

-- member테이블에서 신용환의 마일리지를 10000으로 변경
UPDATE member 
SET mem_mileage = 10000
WHERE mem_name = '신용환';

-- VIEW v_member01에서 신용환의 마일리지를 500으로 변경

UPDATE v_member01
SET 마일리지 = 500
WHERE 회원명 = '신용환';

ROLLBACK; -- 데이터 복원

-- WITH CHECK OPTION 사용하여 VIEW 생성
CREATE OR REPLACE VIEW v_member01(mid, mname, mjob, mile)
AS
    SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000
    WITH CHECK OPTION;   

SELECT * FROM v_member01;

< VIEW 컬럼명 기술법 >
1. 컬럼LIST에 기술한 컬럼명을 최우선적으로 적용
2. VIEW 작성 시 별칭을 부여하면 VIEW의 컬럼명으로 적용
3. 아무 별칭도 부여하지 않으면 원본 TABLE의 컬럼명 사용

VIEW EX 3) v_member01에서 신용환 회원의 마일리지를 2000으로 변경
UPDATE v_member01
SET mile = 2000
WHERE UPPER(mid) = 'c001';

VIEW EX 4) member테이블에서 신용환 회원의 마일리지를 2000으로 변경
UPDATE member
SET mem_mileage = 2000
WHERE UPPER(mem_id) = 'c001';

ROLLBACK;

-- WITH READ ONLY를 사용하여 VIEW 생성
CREATE OR REPLACE VIEW v_member01(mid, mname, mjob, mile)
AS
    SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000
    WITH READ ONLY;

SELECT * FROM v_member01;

VIEW EX 5) v_member01에서 오철희 회원의 마일리지를 5700으로 변경
UPDATE v_member01
SET mile = 5700
WHERE UPPER(mid) = 'k001';
--------------------------------------------------------------------------------------------------------------------------------

SELECT hr.departments.department_id, department_name
FROM hr.departments;
-- 타 계정의 테이블 및 컬럼 불러오는 법