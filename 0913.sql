DESC EMP;
DESC DEPT;
DESC BONUS;
DESC SALGRADE;
----------------------------------------------------------
--기본 SELECT *(열을 의미) FROM EMP(테이블 이름); 세미콜론으로 끝남
--드래그해서 실행하면 실행 된다--
SELECT * FROM EMP;
--EMP테이블에서 사원번호, 사원이름, 사원이 속한 부서 번호만 조회
SELECT EMPNO, ENAME, DEPTNO
FROM EMP;
--SQL문 작성시 유의사항
--SQL문은 대소문자를 구분하지 않음
--SQL문장은 한줄 또는 여러줄에 입력될 수 있음
--일반적으로 키워드는 대문자로 입력한다.
--일반적으로 이름, 열 이름등은 소문자로 작성한다.
--SQL문의 마지막 절은 ';'으로 끝난다.
--사원번호와 부서 번호만 나오도록 EMP테이블 조회하기
SELECT EMPNO, DEPTNO FROM EMP;

--별칭설정하기 : AS, 별칭 만드는 키워드. 열 이름을 또는 컬럼을 별칭으로 표시할 수 있음.
SELECT ENAME AS 이름, SAL AS 급여, SAL*12+COMM AS 연봉, COMM AS 성과금 FROM EMP;

--중복제거하기 : DISTINCT, 중복 제거하기. 데이터를 조회할 때 값이 중복되는 행이 여러개 조회되는 경우, 값이 중복된 행을 한개씩만 선택하고자 하는 경우 사용
SELECT DISTINCT JOB, DEPTNO FROM EMP; --두가지 조건에 대한 중복제거

-- 컬럼값을 계산하는 산술연산자 : +, -, *, /
SELECT ENAME, SAL, SAL-12 FROM EMP;

-- WHERE 구문 : 데이터를 조회할 때 사용자가 원하는 조건에 맞는 데이터만 조회하고 싶을 때 사용(행을 제한)
-- 여러 연산자와 함께 사용함
SELECT * FROM EMP
WHERE DEPTNO = 10; --데이터베이스에서는 '='는 대입연산자가 아닌, 같다는 의미로 사용됨 -> DEPNO가 10인것만 보겠다는 의미.

SELECT * FROM EMP
WHERE EMPNO = 7369;

--급여가 2500 초과인 사람의 사원번호, 이름, 직무, 급여 보기.
SELECT EMPNO, ENAME, JOB, SAL 
FROM EMP
WHERE SAL > 2500;

SELECT *
FROM EMP
WHERE SAL * 12 = 36000;

--성과급이 500 초과인 사원 출력
SELECT * FROM EMP
WHERE COMM > 500;

-- 입사일이 81년 01월 01일 이전인 사원 데이터 조회하는 명령
-- 날짜 비교할 경우 날짤 형식에 맞춰서 비교하면 됨.
SELECT * FROM EMP
WHERE HIREDATE < '81/01/01';

--같지 않음을 표현하는 방법은 여러가지가 존재. <> != ^= NOT
SELECT * FROM EMP
WHERE DEPTNO <> 30;

--급여가 3000이상이고, 부서가 20번인 사원 조회하기. (2가지 조건 모두 만족해야하는 경우)
SELECT *
FROM EMP
WHERE SAL >= 3000 AND DEPTNO = 20;

--급여가 3000 이상이고, 부서가 20번 이고, 입사일이 82년 1워 1일 이전 입사인 사원 조회.
SELECT *
FROM EMP
WHERE SAL >= 3000 AND DEPTNO = 20; AND HIREDATE < '82/01/01';

--급여가 3000이상이고, 부서가 20번 이거나 입사일이 82년 1월 1일 이전인 사원 조회.
SELECT * 
FROM EMP
WHERE SAL >= 3000 AND (DEPTNO = 20 OR HIREDATE < '82/01/01');

--급여가 2500이상이고, 직업이 MANAGER인 사원정보만 출력
SELECT *
FROM EMP
WHERE SAL >= 2500 AND JOB = 'MANAGER';

SELECT *
FROM EMP
WHERE SAL != 3000;

-- IN 연산자 : 포함되어 있는 조건을 다 출력
SELECT *
FROM EMP
WHERE JOB = 'MANAGER' 
    OR JOB = 'SALESMAN' 
    OR JOB = 'CLERK';
--포함되어 있는지 여부 확인 
SELECT *
FROM EMP
WHERE JOB NOT IN ('MANAGER', 'SALESMAN', 'CLERK');

SELECT *
FROM EMP
WHERE DEPTNO NOT IN (20,30);

-- BETWEEN A AND B 연산자 : 일정한 범위를 조회할 때 사용하는 연산자
--급여가 2000 이상 3000이하 인 사언 조회
SELECT *
FROM EMP
WHERE SAL >= 2000 AND SAL <= 3000;

SELECT *
FROM EMP
WHERE SAL NOT BETWEEN 2000 AND 3000;

--사원번호가 7689~ 9702 사이의 사원 조회
SELECT *
FROM EMP
WHERE EMPNO BETWEEN 7689 AND 9702;

--1980년에 입사하지 않은 사원 조회
SELECT *
FROM EMP
WHERE NOT HIREDATE BETWEEN '1980/01/01' AND '1980/12/31';

--LIKE, NOT LIKE 연산자 : 일부 문자열에 포함되어 있는지 여부 확인하는 연산자, 주로 검색에서 사용
-- % : 길이와 상관없이 모든 문자를 의미
-- _ : 문자 1자를 의미
SELECT EMPNO, ENAME
FROM EMP
WHERE ENAME LIKE '%K%'; --K 앞뒤의 문자 길이 상관없이 0부터 무한대까지

SELECT *
FROM EMP
WHERE ENAME LIKE '_L%';

--사원이름에 AM이 포함되어 있는 사원 데이터 출력
SELECT *
FROM EMP
WHERE ENAME LIKE '%AM%';

--사원이름에 AM이 포함되어있지 않은 사원 데이터 출력
SELECT *
FROM EMP
WHERE ENAME NOT LIKE '%AM%';

--NULL : 값이 정해지지 않음. (미확정 또는 알 수 없는 값) = 연산, 할당, 비교 불가 (=, IN 안됨)
SELECT ENAME, SAL, SAL*12+COMM AS 연봉, COMM
FROM EMP;

SELECT *
FROM EMP
WHERE COMM = NULL; --연산불가. 

--IS NULL : NULL여부 확인하는 연산자
SELECT *
FROM EMP
WHERE COMM IS NULL;

--MANAGER가 없는 사원만 조회
SELECT *
FROM EMP
WHERE MGR IS NOT NULL;



