--데이터 사전에는 데이터베이스 메모리, 성능, 사용자, 권한, 객체 등 오라클 데이터베이스 운영에 중요한 데이터 보관
SELECT * FROM DICT;
SELECT TABLE_NAME FROM USER_TABLES;
--인덱스란? 인덱스를 사용하면 시스템 부하를 줄여 성능 향상이 되나, INSERT/UPDATE/DELETE가 빈번히 일어나면 성능 저하가 일어남. [검색 성능을 개선하기 위해 별도의 색인 테이블에 등록 후 관리]
--인덱스; 기본키와 유일키의 경우는 자동으로 인덱스 자동 생성 됨
SELECT ROWID, EMPNO, ENAME FROM EMP;
SELECT* FROM USER_IND_COLUMNS;

--EMP테이블의 SAL열의 인덱스 생성하기
CREATE INDEX IDX_EMP_SAL ON EMP(SAL);
--인덱스 검색하기
SELECT*FROM USER_IND_COLUMNS;

--복합인덱스 생성(EMP 테이블의 두개의 인덱스 지정)
CREATE INDEX IDX_EMP_TUPLE ON EMP(JOB, DEPTNO);

--인덱스 삭제
DROP INDEX IDX_EMP_TUPLE;

--VIEW: 하나 이상의 테이블을 조회하는 SELECT문을 저장한 객체, 복잡한 테이블을 단순화 하기위한 목적, 보안성 목적
--터미널에서 권한 주기.(뷰 생성을 위해서는 권한 필요)
CREATE VIEW VW_EMP20
AS (SELECT EMPNO, ENAME, JOB, DEPTNO
    FROM EMP
    WHERE DEPTNO = 20);

SELECT* FROM VW_EMP20;