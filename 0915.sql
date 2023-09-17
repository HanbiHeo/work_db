--문자함수:문자 데이터를 가공하는 것
SELECT ENAME, UPPER(ENAME), LOWER(ENAME), INITCAP(ENAME)
FROM EMP;

SELECT *
FROM EMP
WHERE UPPER(ENAME) = UPPER('james');

--LENGTH 함수 : 문자열 길이 반환
--LENGTHB : 문자열의 바이트 수 반환
SELECT LENGTH('한글'), LENGTHB('한글')
FROM DUAL;

--SUBSTR / SUBSTRB
--데이터베이스 시작위치가 0이 아님. 1이 첫번째 글자, 3번째 매개변수를 생략하면 끝까지
SELECT JOB, SUBSTR(JOB,1,2), SUBSTR(JOB,3,2), SUBSTR(JOB,5)/*5부터 끝까지*/
FROM EMP;

SELECT JOB,
    SUBSTR(JOB, -LENGTH(JOB)), --음수는 뒤에서 부터 계산, 길이에 대한 역순으로 접근
    SUBSTR(JOB, -LENGTH(JOB),2), -- SALESMAN, -8이면 S위치에서 길이가 2만큼 출력
    SUBSTR(JOB,-3)
FROM EMP;

--INSTR은 문자나 문자열 데이터 안의 에디에 포함되어있는지 여부를 확인하고자 할 때 사용
SELECT INSTR('HELLO, ORACLE!', 'L') AS INSTR_1,
INSTR('HELLO, ORACLE!', 'L', 5) AS INSTR_2, --시작위치, 3번째 인자로 찾을 시작위치 지정
INSTR('HELLO, ORACLE!', 'L', 2, 2) AS INSTR_3 --3번째 인자는 시작위치, 4번째 인자는 몇번째인지
FROM DUAL;

--특정 문자가 포함된 행찾기
SELECT *
FROM EMP
WHERE INSTR(ENAME, 'S') > 0;

SELECT *
FROM EMP
WHERE ENAME LIKE '%S%'; -- 찾기는 대부분 못찾으면 -값이 넘어옴.

--REPLACE: 특정 문자열이 포함된 데이터 문자를 다른 문자로 대체(대체할 문자를 넣지 않으면 해당 문자를 '삭제' = 삭제할 경우도 사용)
SELECT '010-1234-5678'AS REPACE_BEFOR,
    REPLACE('010-1234-5678', '-', ' ') AS REPLACE_1, --공백으로 대체
    REPLACE('010-1234-5678', '-') AS REPLACE_2 --해당문자 삭제
FROM DUAL;

--LPAD / RPAD: 기존 공간의 칸 수를 특정 문자로 채우는 함수
SELECT LPAD('ORACLE', 10, '+')
FROM DUAL;
SELECT RPAD('ORACLE', 10, '+')
FROM DUAL;

SELECT 'ORACLE',
    LPAD('ORACLE',10,'#')AS LPAD_1,
    RPAD('ORACLE',10,'*')AS LPAD_1,
    LPAD('ORACLE',10)AS LPAD_2,
    RPAD('ORACLE',10)AS LPAD_2
FROM DUAL;
--실제 활용 예) 개인정보 뒤자리 *표시로 출력하기
SELECT
    RPAD('971225-', 14, '*') AS RPAD_IDNUM,
    RPAD('010-1234-',13, '*') AS RPAD_PHONE
FROM DUAL;

--두 문자열을 합치는 CONCAT 함수
SELECT CONCAT(EMPNO, ENAME),
    CONCAT(EMPNO, CONCAT(' : ', ENAME))
FROM EMP
WHERE ENAME = 'JAMES';

--TRIM(문자열 지우기 불가능) / LTRIM / RTRIM: 문자열 내에서 특정 문자열을 지우기 위해 사용
--삭제할 문자를 지정하지 않으면 공백 제거(공백제거 용도로 사용하기 좋음, 특정 문자열 제거하기 위한 함수는 'REPLACE' 쓰는게 좋음.)
SELECT 
    '[' || TRIM('   _Oracle_   ') || ']' AS TRIM,
    '[' || LTRIM(' _Oracle_ ') || ']' AS LTRIM,
    '[' || LTRIM('<_Oracle_>', '<_') || ']' AS LTRIM_2,
    '[' || RTRIM('   _Oracle_   ') || ']' AS RTRIM,
    '[' || RTRIM('<_Oracle_>', '_>') || ']' AS RTRIM_2
 FROM DUAL;

 SELECT LTRIM('             SSSSSELECT                 ','             S')
 FROM DUAL;

 --날짜 데이터를 다루는 날짜 함수
 --SYSDATE:운영체제로부터 날짜와 시간정보를 가져옴
 SELECT SYSDATE FROM DUAL;
--날짜데이터는 정수값을 연산(+,-만)하는게 가능하다.
 SELECT SYSDATE AS TODAY,
    SYSDATE-1 AS YESTERDAY,
    SYSDATE+1 AS TOMOROW
FROM DUAL;

--몇 개월 이후 날짜 구하는 ADD_MONTHS 함수
--특정 날짜에 지정한 개월 수 이후의 날짜데이터를 반환하는 함수
SELECT SYSDATE,
    ADD_MONTHS(SYSDATE, 3) --두번째 인자는 달수를 의미한다.
FROM DUAL;


--EMP TABLE에서 입사 10주년이 되는 사원들 데이터 출력
SELECT EMPNO, ENAME, HIREDATE,
    ADD_MONTHS(SYSDATE, 120) AS 입사10주년
FROM EMP;

-- SYSDATE와 ADD_MONTHS 함수를 사용하여 현재 날짜와 6개월 후 날짜 출력
SELECT SYSDATE AS TODAY,
    ADD_MONTHS(SYSDATE, 6) AS 더하기6개월
FROM DUAL;

--두 날짜간의 개월 수 차이 구하는 MONTHS_BETWEEN 함수
SELECT EMPNO, ENAME, HIREDATE, SYSDATE,
    MONTHS_BETWEEN(HIREDATE, SYSDATE) AS MONTHS1, --과거에서 현재시간 빼기
    MONTHS_BETWEEN(SYSDATE, HIREDATE) AS MONTHS2,
    TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE)) AS MONTHS3 --TRUNC 소수점 이하 절삭(OR ROUND)
FROM EMP;

--날짜 정보 추출 함수
--EXTRACT 함수는 날짜 유형의 데이터로부터 날짜정보를 분리하여 새로운 컬럼의 형태로 추출해주는 함수
SELECT EXTRACT(YEAR FROM DATE'2023-09-15') AS 년도추출
FROM DUAL;

SELECT *
FROM EMP
WHERE EXTRACT(MONTH FROM HIREDATE) = 12; --입사일 12월인 사람만 뽑아낸다


--오늘 날짜에 대한 정보 조회
SELECT SYSDATE
FROM DUAL;
--EMP테이블에서 사번, 사원명, 급여조회,(단, 급여는 100단위까지만의 값만 출력하고 급여 기준 내림차순 정렬)
SELECT EMPNO, ENAME, 
    ROUND(SAL,-3)
FROM EMP;
ORDER BY SAL DESC;
--EMP테이블에서 사원번호가 홀수인 사원들을 조회
SELECT EMPNO
FROM EMP
WHERE MOD(EMPNO, 2) = 1;
--EMP테이블에서 사원명, 입사일 조회(단, 입사일은 년도와 월을 분리해서 추출)
SELECT ENAME, 
-- SUBSTR(HIREDATE,8,2) AS YEAR,
-- SUBSTR(HIREDATE,4,3) AS MONTH
EXTRACT(YEAR FROM HIREDATE), EXTRACT(MONTH FROM HIREDATE)
FROM EMP;
--EMP테이블에서 9월에 입사한 직원의 정보조회
SELECT ENAME, HIREDATE
FROM EMP
-- WHERE HIREDATE LIKE '%SEP%';
WHERE EXTRACT(MONTH FROM HIREDATE) = 9;
--EMP테이블에서 81년도에 입사한 직원 조회
SELECT ENAME, HIREDATE
FROM EMP
-- WHERE HIREDATE LIKE '%81%';
WHERE EXTRACT(YEAR FROM HIREDATE) = 1981;
--EMP테이블에서 이름이 'E'로 끝나는 직원 조회
SELECT *
FROM EMP
WHERE ENAME LIKE '%E';
--EMP테이블에서 이름의 세번째 글자가 'R'로 끝나는 사원 조회
SELECT*
FROM EMP
WHERE ENAME LIKE '__R%';
--EMP테이블에서 사번, 사원명, 입사일, 입사일로부터 40년되는 날짜조회
SELECT EMPNO, ENAME, HIREDATE, (EXTRACT(YEAR FROM HIREDATE) + 40)
-- SELECT EMPNO, ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 40*12)
FROM EMP;
--EMP테이블에서 입사일로부터 38년 이상 근무한 직원이 정보 조회
SELECT *
FROM EMP
WHERE MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12 >= 38;
--오늘날짜에서 년도만 추출
SELECT EXTRACT(YEAR FROM SYSDATE)
FROM DUAL;

--자료형을 변환하는 형 변환 함수
--자동 형변환 : NUMBER + 문자타입 => NUMBER 타입으로 자동변환
SELECT EMPNO, ENAME, EMPNO + '500'
FROM EMP
WHERE ENAME = 'FORD';

SELECT EMPNO, ENAME, EMPNO + 'ABCD' -- 불가능
FROM EMP
WHERE ENAME = 'FORD';

--날짜, 숫자 문자열로 변환하는 TO_CHAR 함수
--주로 날짜 데이터를 문자 데이터로 변환하는데 사용
--자바의 SimpleDateFormat() 유사
-- SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') AS "현재 시간" -- 띄어쓰기는 "" 를 써야 가능
SELECT TO_CHAR(SYSDATE, 'YY/MON/DD HH:MI:SS') AS "현재 시간"
FROM DUAL;

SELECT SYSDATE,
    TO_CHAR(SYSDATE, 'CC') AS 세기,
    TO_CHAR(SYSDATE, 'YY') AS 연도,
    TO_CHAR(SYSDATE, 'YYYY/MM/DD PM HH:MI:SS ') AS "년/월/일 시:분:초",
    TO_CHAR(SYSDATE, 'Q') AS 쿼터,
    TO_CHAR(SYSDATE, 'DD') AS 일,
    TO_CHAR(SYSDATE, 'DDD') AS 경과일,
    TO_CHAR(SYSDATE, 'HH') AS "12시간제",
    TO_CHAR(SYSDATE, 'HH12') AS "12시간제",
    TO_CHAR(SYSDATE, 'HH24') AS "24시간제",
    TO_CHAR(SYSDATE, 'W') AS 몇주차
FROM DUAL;

SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'MM') AS MM,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MON_KOR,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = JAPANESE') AS MON_JPN,
     TO_CHAR(SYSDATE, 'MON', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MON_ENG,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = KOREAN' ) AS MONTH_KOR,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = JAPANESE') AS MONTH_JPN,
     TO_CHAR(SYSDATE, 'MONTH', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS MONTH_ENG
FROM DUAL;

SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'MM') AS MM,
     TO_CHAR(SYSDATE, 'DD') AS DD,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = KOREAN' ) AS DY_KOR,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = JAPANESE') AS DY_JPN,
     TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS DY_ENG,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = KOREAN' ) AS DAY_KOR,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = JAPANESE') AS DAY_JPN,
     TO_CHAR(SYSDATE, 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH' ) AS DAY_ENG
FROM DUAL;

SELECT SYSDATE,
     TO_CHAR(SYSDATE, 'HH24:MI:SS') AS HH24MISS,
     TO_CHAR(SYSDATE, 'HH12:MI:SS AM') AS HHMISS_AM,
     TO_CHAR(SYSDATE, 'HH12:MI:SS A.M.') AS HHMISS_AM,
     TO_CHAR(SYSDATE, 'HH:MI:SS P.M.') AS HHMISS_PM
FROM DUAL;

SELECT SAL,
    TO_CHAR(SAL, '$999,999') AS SAL_$,
    TO_CHAR(SAL, 'L999,999') AS SAL_L,
    TO_CHAR(SAL, '999,999.00') AS SAL_1,
    TO_CHAR(SAL, '000,999,999.00') AS SAL_2,
    TO_CHAR(SAL, '000999999.99') AS SAL_3,
    TO_CHAR(SAL, '999,999,00') AS SAL_4
FROM EMP;

--TO_NUMBER():NUMBER타입으로 형 변환
SELECT TO_NUMBER('1300') - '1500'
FROM DUAL;

--TO_DATE():문자열로 명시된 날짜를 날짜 타입으로 형변환
SELECT TO_DATE('22/08/20', 'YY/MM/DD')
FROM DUAL;

--NEXT_DAY(기준일자, 찾을요일): 기준일자 다음에 오는 날짜 구하는 함수

--1981년 6월 1일 이후에 입사한 사원 정보 출력하기
SELECT*
FROM EMP
WHERE HIREDATE > TO_DATE('1981/06/01','YYYY/MM/DD');
-- WHERE HIREDATE > '01/JUN/81';

--NULL처리 함수:NULL은 값이 없음, 즉 할당되지 않음을 의미
--NULL은 0이나 공백과는 다른 의미, 연산불가
--NVL(NULL인지 검사할 열, 앞의 열 데이터가 열인 경우 반환할 데이터)
SELECT EMPNO, ENAME, SAL, COMM, SAL+COMM,
    NVL(COMM,0), SAL+NVL(COMM,0)
FROM EMP;

-- NVL2(): NULL이 아닌 경우와 NULL인경우 모두에 대해서 값을 지정할 수 있음
SELECT EMPNO, ENAME, COMM, SAL,
    NVL2(COMM, 'O', 'X') AS 성과급유무,
    NVL2(COMM, SAL*12+COMM, SAL*12) AS 연봉
FROM EMP;

--NULLIF():두값이 동일하면 NULL반환, 아니면 첫번째 값 반환
SELECT NULLIF(10,10), NULLIF('A','B')
FROM DUAL;

--DECODE:주어진 데이터 값이 조건값과 일치하는 값 출력
--일치하는 값이 없으면 기본값 출력
SELECT EMPNO, ENAME, JOB, SAL,
    DECODE(JOB,
        'MANAGER', SAL*1.1,
        'SALESMAN', SAL*1.05,
        'ANALYST', SAL,
        SAL*1.03) AS 연봉인상
FROM EMP;

--CASE문
SELECT EMPNO,ENAME,JOB,SAL,
    CASE JOB   
        WHEN 'MANAGER' THEN SAL*1.1
        WHEN 'SALESMAN' THEN SAL*1.05
        WHEN 'ANALYST' THEN SAL
        ELSE SAL*1.03
    END AS 연봉인상
FROM EMP;
--CASE문: 열 값에 따라 출력값이 달라지는 CASE
SELECT EMPNO,ENAME,
    CASE
        WHEN COMM IS NULL THEN '해당사항없음' --행에 대한 내용이 아닌 데이터 부분에는 ''로 문자열을 넣어줌.
        WHEN COMM = 0 THEN '수당없음'
        WHEN COMM > 0 THEN '수당 : ' || COMM --||->이어붙임
    END AS 성과급
FROM EMP;

--함수 실습문제 1
SELECT EMPNO,
    RPAD(SUBSTR(EMPNO,1,2),4,'*') AS MASKING_EMPNO,
    ENAME,
    RPAD(SUBSTR(ENAME,1,1),LENGTH(ENAME),'*') AS MASKIN_ENAME
FROM EMP
WHERE LENGTH(ENAME) = 5;

--함수 실습문제 2
SELECT EMPNO, ENAME, SAL,
    TRUNC(SAL / 21.5, 2) AS DAY_PAY,
    ROUND(SAL / 21.5 / 8,1) AS TIME_PAY
FROM EMP;

--함수 실습문제 3
SELECT EMPNO, ENAME, HIREDATE,

    TO_CHAR(NEXT_DAY(ADD_MONTHS(HIREDATE, 3),'MON'), 'YYYY-MM-DD') AS R_JOB,
    NVL(TO_CHAR(COMM),'N/A') AS COMM

--     TO_CHAR(NEXT_DAY(ADD_MONTHS(HIREDATE, 3), 'MON'), 'YYYY-MM-DD') AS R_JOB,
--    NVL(TO_CHAR(COMM), 'N/A') AS COMM

    -- 둘 다 문자열로 바꿔야함. 데이터형이 틀릴 수 있기 때문에
FROM EMP;
--NEXT_DAY(기준일자, 찾을요일): 기준일자 다음에 오는 날짜 구하는 함수

--함수 실습문제 4
SELECT EMPNO, ENAME, MGR,
    CASE
        WHEN MGR IS NULL THEN '0000'
        WHEN SUBSTR(MGR, 1, 2) = '78' THEN '8888'
        WHEN SUBSTR(MGR, 1, 2) = '77' THEN '7777'
        WHEN SUBSTR(MGR, 1, 2) = '76' THEN '6666'
        WHEN SUBSTR(MGR, 1, 2) = '75' THEN '5555'
        ELSE TO_CHAR(MGR)
    END AS CHG_MGR
FROM EMP;

--다중행 함수 : 여러행에 대한 함수가 적용되어 하나의 결과를 나타내는 함수(집계함수)
--여러행이 입력되어 결과가 단일형으로 출력
SELECT SUM(SAL)
FROM EMP;

SELECT SUM(SAL), ENAME -- not a single-group group function 에러
FROM EMP
GROUP BY ENAME; -- 그룹함수에 오류 안뜨려면 그룹.
--GROUP BY : 그룹으로 묶어줄 때 

--COUNT(*) ; 부서인원집계
SELECT DEPTNO, COUNT(*), SUM(SAL), ROUND(AVG(SAL), 2), MIN(SAL)
FROM EMP
GROUP BY DEPTNO;

SELECT JOB, SUM(SAL)
FROM EMP
GROUP BY JOB;