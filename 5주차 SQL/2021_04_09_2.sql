< TRIGGER >
  - 어떤 이벤트가 발생하면 그 이벤트의 발생 전, 후로 자동적을 실행되는 코드블록(프로시져의 일종)
    (사용형식)
    CREATE TRIGGER 트리거명
        (timming)BEFORE|AFTER    (event)INSERT|UPDATE|DELETE
        ON 테이블명
        [FOR EACH ROW]
        [WHEN 조건]
    [DECLARE
        변수, 상수, 커서;
    ]
     BEGIN
        명령문(들);  -- 트리거처리문
        [EXCEPTION
            예외처리문;
        ]
     END;
     
     - 'timming' : 트리거처리문 수행 시점(BEFORE : 이벤트 발생전, AFTER : 이벤트 발생후)
     - 'event' : 트리거가 발생될 원인 행위 (OR로 연결 사용 가능) ex) INSERT OR UPDATE OR DELETE)
     - '테이블명' : 이벤트가 발생되는 테이블 이름
     - 'FOR EACH ROW' : 행단위 트리거 발생, 생략되면 문장단위 트리거 발생
     - 'WHEN 조건' : 행단위 트리거에서만 사용 가능, 이벤트가 발생될 세부조건 추가 설정