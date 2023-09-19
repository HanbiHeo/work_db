--FROM 절에서 사용하는 서브쿼리 : 인라인뷰라고도 부름. FROM절에서 직접 테이블을 명시하여 사용하기에는 태에블 내 데이터 규모가 너무 큰 경우 사용. 
--보안이나 특정 목적으로 정보를 제공하는 경우
SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROM(SELECT * FROM EMP WHERE DEPTNO = 10) E10
JOIN(SELECT * FROM DEPT)D
ON E10.DEPTNO = D.DEPTNO;
--먼저 정렬하고 해당 갯수만 가져오는 경우
--ROWNUM: 오라클에서 제공하는 문법으로 행번호를 자동으로 매겨줌
--정렬된 결과에서 상위 3개를 뽑으려먼 테이블을 가져올 때 정렬된 상태로 가져와야 함. 일반적인 SELECT문에서는 ORDER BY 절이 마지막에 수행되기 때문
SELECT ROWNUM ENAME, SAL
FROM (SELECT * FROM EMP ORDER BY SAL DESC) --FROM절에서 가져올 때 정렬 먼저 한 후 위에서 잘라야함 -> 테이블을 가져올 때 정렬된 상태로 가져온다(내림차순 정렬).
WHERE ROWNUM <= 3;
--서브쿼리를 너무 많이쓰면 성능이 저하될 수 있음.

--SELECT절에 사용하는 서브쿼리: 스칼라 서브쿼리라고도 부름. 열을 제한하기 위해 쓰며, 반드시 하나의 결과만 나와야함.
SELECT EMPNO, ENAME, JOB, SAL, 
    (SELECT GRADE FROM SALGRADE
    WHERE E.SAL BETWEEN LOSAL AND HISAL) AS 급여등급,
    DEPTNO,
    (SELECT DNAME FROM DEPT
    WHERE E.DEPTNO = DEPT.DEPTNO) AS DNAME
FROM EMP E;

--매 행마다 부서번호가 각 행의 부서번호와 동일한 사원들의 SAL
SELECT ENAME, DEPTNO, SAL,
    (SELECT TRUNC(AVG(SAL))
    FROM EMP
    WHERE DEPTNO = E.DEPTNO) AS "부서별 평균급여"
FROM EMP E;

--부서위치가 NEW YORK 인 경우 본사로, 그 외 부서는 분점으로 반환
SELECT EMPNO, ENAME,
    CASE WHEN DEPTNO = (SELECT DEPTNO FROM DEPT WHERE LOC = 'NEW YORK')
    THEN '본사'
    ELSE '분점'
    END AS 소속
FROM EMP
ORDER BY 소속 DESC;

--1. 전체 사원 중 ALLEN과 같은 직책(JOB)인 사원들의 사원 정보, 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요.(조인과 서브쿼리가 필요)
SELECT E.JOB, E.EMPNO, E.ENAME, E.SAL, D.DEPTNO, D.DNAME
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB = (SELECT JOB FROM EMP WHERE ENAME = 'ALLEN');

--2. 전체 사원의 평균 급여(SAL)보다 높은 급여를 받는 사원들의 사원 정보, 부서 정보, 급여 등급 정보를 출력하는 SQL문을 작성하세요(단 출력할 때 급여가 많은 순으로 정렬하되 급여가 같을 경우에는 사원 번호를 기준으로 오름차순으로 정렬하세요). (EMP, DEPT, SALGRADE 세개의 테이블 조인 해야함)
SELECT E.EMPNO, E.ENAME, D.DNAME, E.HIREDATE, D.LOC, E.SAL, S.GRADE
FROM EMP E 
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL
WHERE E.SAL > (SELECT AVG(SAL) FROM EMP)
ORDER BY E.SAL DESC, E.EMPNO;


SELECT *
FROM EMP;
SELECT*
FROM DEPT;
SELECT *
FROM SALGRADE;
--3. 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원 정보, 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요
SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.DEPTNO = 10 
AND JOB NOT IN(SELECT DISTINCT JOB FROM EMP WHERE DEPTNO=30);

--4.직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원 정보, 급여 등급 정보를 다음과 같이 출력하는 SQL문을 작성하세요(단 서브쿼리를 활용할 때 다중행 함수를 사용하는 방법과 사용하지 않는 방법을 통해 사원 번호를 기준으로 오름차순으로 정렬하세요).
SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL
WHERE E.SAL > (SELECT MAX(SAL) FROM EMP WHERE JOB='SALESMAN')
ORDER BY E.EMPNO;
--다중행을 사용해서 풀기
SELECT E.EMPNO, E.ENAME, E.SAL, S.GRADE
FROM EMP E JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL
AND SAL > ALL(SELECT SAL FROM EMP WHERE JOB = 'SALESMAN')
ORDER BY E.EMPNO;

-- DML(DATA MANUPULATION LANGUAGE):데이터를 조회(SELECT), 삭제(DELETE), 입력(INSERT), 변경(UPDATE)
-- 테이블이 아닌 데이터를 조작하는 것.

--1. DML을 하기 위해 임시 테이블 생성 ; 기존의 DEPT 테이블을 복사해서 DEPT_TEMP 테이블 생성하기.
CREATE TABLE DEPT_TEMP
AS SELECT * FROM DEPT;
--2. 테이블 조회
SELECT * FROM DEPT_TEMP;
--3. 테이블 삭제
DROP TABLE DEPT_TEMP;
--4. 테이블에 데이터 추가
INSERT INTO DEPT_TEMP(DEPTNO, DNAME, LOC) 
VALUES(50, 'DATABASE', '서울');
--NULL로 값을 생략도 가능
INSERT INTO DEPT_TEMP(DEPTNO, DNAME, LOC) 
VALUES(70, NULL, '인천');
--순서 바꿔도 들어감
INSERT INTO DEPT_TEMP(DEPTNO, LOC, DNAME) 
VALUES(50, '부산', 'DEVELOPMENT');
--5. 데이터 변경
UPDATE DEPT_TEMP SET DEPTNO = 60
WHERE LOC = '부산';

--다른 방법 1.반드시 순서를 지켜주어야 함
INSERT INTO DEPT_TEMP VALUES(80, 'FRONTEND', NULL);INSERT INTO DEPT_TEMP(DEPTNO, DNAME) VALUES(80, 'BACKEND');

CREATE TABLE EMP_TEMP
AS SELECT * FROM EMP
--내용지우면서 복사(모든 데이터를 거짓으로 만들면서 테이블 내용 지우며 복사)
WHERE 1 != 1; -- 테이블을 복사해 새로운 테이블 만들 때 데이터는 복사하지 않고 싶을 때 주로 사용.
SELECT * FROM EMP_TEMP;

--테이블에 날짜 데이터 추가하기(EMP테이블 복사)
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(9002, '이수현', 'MANAGER', 9000, '19-SEP-2023', 1500, 1000, 15);

INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(9004, '이정재', 'PRESIDENT', 9000, SYSDATE, 4000, 2000, 10);

--서브쿼리를 이용한 INSERT
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
SELECT E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, E.DEPTNO
FROM EMP E JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL
WHERE S.GRADE = 1;

--UPDATE: 행의 정보를 변경할 때 사용[UPDATE '테이블이름' SET '변경할 열 이름과 데이터' WHERE '조건식']]
SELECT * FROM DEPT_TEMP2;
CREATE TABLE DEPT_TEMP2 AS SELECT* FROM DEPT_TEMP;

UPDATE DEPT_TEMP2
    SET DNAME = '백엔드',
        LOC = '광주'
    WHERE DEPTNO = 30;

ROLLBACK; --롤백 SQLDEVELOPER 에서는 실행됨(오토커밋 되서 VSCODE에서는 안됨_오토커밋 꺼야함. 설정에서 AUTO COMMIT 해제). 오토커밋(트렌젝션 문제가 발생할 수 있음) 없기때문에.

--테이블에 있는 데이터 삭제하기
CREATE TABLE EMP_TEMP2
AS SELECT* FROM EMP; -- 복제

SELECT* FROM EMP_TEMP2; -- 조회
SELECT* FROM EMP;
DROP TABLE EMP_TEMP2;

--조건절 없이 테이블 이름 명시하면 전체 삭제됨.
DELETE FROM EMP_TEMP2 
WHERE JOB = 'MANAGER';

CREATE TABLE DEPT_TCL
AS SELECT *
FROM DEPT;

SELECT * FROM DEPT_TCL;

INSERT INTO DEPT_TCL VALUES(50, 'DATABASE', 'SEOUL');
COMMIT;

UPDATE DEPT_TCL
SET DNAME='DATABASE'
WHERE DEPTNO = 30;