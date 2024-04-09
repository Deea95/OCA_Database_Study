--*Capitolul 2* -> Using Column aliases:

--1.Utilizare de baz?:
    SELECT column_name AS alias_name
      FROM table_name;

SELECT first_name AS employee_first_name
  FROM employees; -- 97 linii

--2. Aliases pentru Tabele (Aliasuri de Tabele):
    SELECT column_name AS alias_name
      FROM table_name;

SELECT e.first_name AS employee_first_name
  FROM employees e; -- 97 linii


--3. Folosind Aliasuri în Clauza WHERE:
    SELECT column_name AS alias_name
      FROM table_name
     WHERE alias_name = 'some_value';

SELECT e.first_name AS employee_first_name
  FROM employees e
 WHERE e.employee_id = 100; -- 1 linie: John

--4. Folosind Aliasuri în Clauza ORDER BY:
    SELECT product_name, unit_price * 0.9 AS discounted_price
      FROM products
    ORDER BY discounted_price DESC; -- nu face parte din schema de HR

SELECT first_name AS employee_first_name,
       last_name AS employee_last_name
  FROM employees
 ORDER BY employee_last_name DESC; -- 97 linii


--5. Aliasuri pt Subqueries:
    SELECT employee_id
         , first_name
         , last_name
         , (SELECT MAX(salary) 
              FROM employees 
             WHERE employee_id = e.employee_id) AS max_salary
      FROM employees e; -- 97 linii
      
--*Capitolul 2* -> Using the SQL SELECT Statement:

--1. Selectarea Tuturor Coloanelor dintr-o Tabel?:
    SELECT *
      FROM table_name;
      
    SELECT *
  FROM employees; -- 97 linii


--2. Selectarea Coloanelor Specifice:
    SELECT column1
         , column2
      FROM table_name;

SELECT employee_id
     , first_name
     , last_name
  FROM employees; -- 97 linii

--3. Filtrarea Rândurilor cu Clauza WHERE:
    SELECT column1
         , column2
      FROM table_name
     WHERE condition;
     
     SELECT first_name
     , last_name
  FROM employees
 WHERE department_id = 30; -- 6 linii


--4. Sortarea Rezultatelor cu Clauza ORDER BY:
    SELECT column1
         , column2
      FROM table_name
    ORDER BY column1 [ASC|DESC], column2 [ASC|DESC];
    
    SELECT first_name
     , last_name
  FROM employees
 ORDER BY last_name ASC, first_name ASC; -- 97 linii


--5. Limitarea Rezultatelor cu LIMIT/OFFSET (sau FETCH FIRST în unele baze de date):
    SELECT column1
         , column2
      FROM table_name
     LIMIT count OFFSET offset;
     
SELECT first_name, last_name
FROM (
    SELECT first_name, last_name, ROWNUM AS rn
    FROM employees
)
WHERE rn <= 5; -- 5 linii -> nu exista in Oracle: LIMIT si OFFSET



--6. Gruparea Datelor cu Clauza GROUP BY:
    SELECT department_id
         , AVG(salary)
      FROM employees
    GROUP BY department_id; -- 11 linii

--7. Unirea Tabelelor cu Clauza JOIN:
    SELECT employees.first_name
         , departments.department_name
      FROM employees
      JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--8. Subqueries:
    SELECT column1
      FROM table_name
     WHERE column1 IN (SELECT column1 
                         FROM another_table
                        WHERE condition);
                        
                        SELECT employee_id
  FROM employees
 WHERE department_id IN (SELECT department_id 
                           FROM departments
                          WHERE location_id = 1700); -- 16 linii

                        
--*Capitolul 3* -> Aplicarea Regulilor de Preceden?? pentru Operatorii dintr-o Expresie:

--1. Paranteze:
---Expresiile cuprinse între paranteze sunt evaluate în primul rând.
    SELECT (salary + bonus) * 0.1 AS tax
      FROM employee_compensation; -- nu exista tabela in schema HR

--2. Operatori unari:
---Operatorii unari (de exemplu, - pentru nega?ie) au urm?toarea cea mai mare preceden??.
    SELECT -salary AS negated_salary
      FROM employees; -- imi arata cele 97 salarii negative

--3. Operatori aritmetici:
---Înmul?irea (*), împ?r?irea (/) ?i modulo (%) au o preceden?? mai mare decât adunarea (+) ?i sc?derea (-).
    SELECT salary * 0.1 + bonus AS total_compensation
      FROM employee_compensation; -- nu exista tabela in schema HR

--4. Operatorul de concatenare:
---Operatorul de concatenare (||) are o preceden?? mai mare decât majoritatea celorlal?i operatori.
    SELECT first_name || ' ' || last_name AS full_name
      FROM employees; -- full name ; total: 97 linii

--5. Operatorii de compara?ie:
---Operatorii de compara?ie (de exemplu, =, <, >, <=, >=, <>, !=) au o preceden?? mai mic? decât operatorii aritmetici ?i de concatenare.
    SELECT employee_id
         , salary * 1.1 AS increased_salary
      FROM employees
     WHERE department_id <> 10; -- 96 linii

--6. Operatorii logici:
---Operatorii logici (de exemplu, AND, OR, NOT) au cea mai mic? preceden??.
    SELECT employee_id
         , first_name
         , last_name
      FROM employees
     WHERE salary > 50000 
       AND department_id = 20; -- nimic
       
--*Capitolul 3* -> Limitarea Rândurilor Returnate într-o Instruc?iune SQL:

--1. Utilizarea Clauzei LIMIT:
---Clauza LIMIT este folosit? în mod obi?nuit pentru a restric?iona num?rul de rânduri returnate în setul de rezultate. Este acceptat? de baze de date precum MySQL, PostgreSQL, SQLite ?i altele.
    SELECT *
      FROM table_name
     LIMIT n;

SELECT *
  FROM (SELECT *
          FROM employees
         ORDER BY employee_id)
 WHERE ROWNUM <= 5; -- 5 linii

--2. Utilizarea Clauzei FETCH FIRST (ANSI SQL):
---Clauza FETCH FIRST face parte din standardul SQL:2008 ?i poate fi folosit? pentru a limita num?rul de rânduri returnate.
    SELECT *
      FROM table_name
     FETCH FIRST n ROWS ONLY;
     
SELECT *
  FROM employees
 ORDER BY employee_id
FETCH FIRST 5 ROWS ONLY; -- 5 linii

--3. Utilizarea ROWNUM sau ROW_NUMBER() (Oracle):
---În Oracle, po?i folosi ROWNUM sau ROW_NUMBER() cu o subinterogare pentru a limita num?rul de rânduri returnate.
    SELECT column1
         , column2
     FROM (SELECT column1
                , column2
             FROM table_name
            WHERE ROWNUM <= n);

SELECT *
  FROM (SELECT *
          FROM employees
         ORDER BY employee_id)
 WHERE ROWNUM <= 5; -- 5 linii

--4. Utilizarea OFFSET ?i FETCH (pentru Paginare):
---Pentru a implementa paginarea, po?i folosi clauzele OFFSET ?i FETCH.
    SELECT *
      FROM table_name
    OFFSET m ROWS FETCH FIRST n ROWS ONLY;
    
SELECT *
  FROM employees
ORDER BY employee_id
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY; -- 5 linii

--*Capitolul 3* -> Utilizarea comenzilor DEFINE ?i VERIFY:

--1. Comanda DEFINE:
---Comanda DEFINE este folosit? pentru a crea ?i a asigna valori la variabilele de substitu?ie în SQL*Plus.
    DEFINE variable_name = value;
    
-- Definirea unei variabile de substitu?ie pentru departament_id
DEFINE dept_id = 50;

-- Utilizarea variabilei într-o interogare
SELECT * 
FROM employees
WHERE department_id = &dept_id; -- 41 linii

--2. Comanda VERIFY:
---Comanda VERIFY este folosit? pentru a afi?a valorile variabilelor de substitu?ie atunci când prompt-ul pentru variabilele de substitu?ie este oprit.
    SET VERIFY ON | OFF;

-- Activarea afi??rii valorilor de substitu?ie
SET VERIFY ON;

-- Utilizarea variabilei de substitu?ie într-o interogare
SELECT *
FROM employees
WHERE department_id = &dept_id; -- 41 linii

--*Capitolul 3* -> Utilizarea Variabilelor de Substitu?ie:

--Definirea unei variabile de substitu?ie
    ACCEPT department_id CHAR PROMPT 'Enter Department ID: ';

--Utilizarea variabilei de substitu?ie într-o interogare SQL
    SELECT employee_id, first_name, last_name
      FROM employees
     WHERE department_id = '&department_id'; -- afiseaza o linie
     
--*Capitolul 4* -> Sortarea Datelor:

--1. Utilizare de baz?:
    SELECT product_name, unit_price, supplier_id
      FROM products
    ORDER BY supplier_id, unit_price DESC;

-- Selectarea numelor angaja?ilor, salariilor ?i id-urilor departamentelor pentru to?i angaja?ii
SELECT first_name, salary, department_id
FROM employees
ORDER BY department_id, salary DESC; -- 97 linii

--2. Sortarea Valorilor NULL:
    SELECT product_name, unit_price, supplier_id
      FROM products
    ORDER BY supplier_id ASC NULLS FIRST;
    
 -- Selectarea numelor angaja?ilor, salariilor ?i id-urilor departamentelor pentru to?i angaja?ii, sortate dup? id-ul departamentului în ordine cresc?toare, cu valorile NULL sortate primele
SELECT first_name, salary, department_id
FROM employees
ORDER BY department_id ASC NULLS FIRST; -- 97 linii

--*Capitolul 4* -> Manipularea ?irurilor cu func?ii de caractere în clauzele SELECT ?i WHERE din SQL:

--1. LENGTH:
---Returneaz? lungimea (num?rul de caractere) a unui ?ir.
     Using LENGTH
    SELECT first_name
         , LENGTH(first_name) AS name_length
      FROM employees; -- 88 linii

--2. SUBSTR:
---Extrage un sub?ir dintr-un ?ir(string).
    SELECT product_name
         , SUBSTR(product_name, 1, 5) AS short_name
      FROM products;

-- Selectarea numelor angaja?ilor ?i extragerea unei sub?iruri scurte din numele de familie
SELECT first_name
     , SUBSTR(last_name, 1, 3) AS short_last_name
  FROM employees; -- 97 linii

--3. UPPER ?i LOWER:
---Converte?te un ?ir în majuscule sau minuscule.
    SELECT first_name
         , UPPER(first_name) AS upper_name
         , LOWER(last_name) AS lower_last_name
      FROM employees; -- 97 linii

--4. TRIM:
---Înl?tur? spa?iile de început sau de final dintr-un string.
    SELECT product_name
        , TRIM(BOTH ' ' FROM product_name) AS trimmed_name
      FROM products;
      
-- 4. TRIM: Elimin? spa?iile albe de la începutul ?i sfâr?itul unui ?ir.
SELECT job_id
    , TRIM(BOTH ' ' FROM job_title) AS trimmed_title
  FROM jobs; -- 20 linii
  
--5. REPLACE:
---Înlocuie?te apari?iile unui substring cu un alt substring.
    SELECT product_name
         , REPLACE(product_name, 'Small', 'Large') AS updated_name
      FROM products;

-- 5. REPLACE: Înlocuie?te apari?iile unui sub?ir cu un alt sub?ir.
SELECT job_id
     , REPLACE(job_title, 'Engineer', 'Analyst') AS updated_title
  FROM jobs; -- 20 linii
  
--6. INSTR:
---G?se?te pozi?ia unui sub?ir într-un ?ir.
    SELECT product_name, INSTR(product_name, 'XL') AS position_in_string
      FROM products;
      
-- 6. INSTR: G?se?te pozi?ia unui sub?ir într-un ?ir.
SELECT department_name
     , INSTR(department_name, 'SALES') AS position_in_string
  FROM departments; -- 11 linii

--7. LEFT ?i RIGHT nu sunt disponibile direct în Oracle SQL. În schimb, po?i folosi SUBSTR:
---Extrage un num?r specificat de caractere din stânga sau din dreapta unui ?ir.
    SELECT product_name
         , SUBSTR(product_name, 1, 3) AS left_part
      FROM products;

-- 7. LEFT ?i RIGHT nu sunt disponibile direct în Oracle SQL. În schimb, pute?i folosi SUBSTR:
-- Extrage un num?r specificat de caractere de la începutul sau sfâr?itul unui ?ir.
SELECT department_name
     , SUBSTR(department_name, 1, 3) AS left_part
  FROM departments; -- 11 linii


--8. COMPARA?IE CU SENSIBILITATE LA MAJUSCULE/MINUSCULE:
---Pentru compara?ie cu sensibilitate la majuscule/minuscule, po?i folosi operatorul BINARY.
    SELECT first_name
      FROM employees
     WHERE first_name = BINARY 'John'; -- ORA-00933: SQL command not properly ended
     
SELECT first_name
  FROM employees
 WHERE first_name = 'John'; -- 97 linii, este similar ca cel de mai sus
 
--*Capitolul 4* -> Realizarea de opera?ii aritmetice cu date:

--1. Ad?ugarea/Sc?derea Zilelor:
---Folose?te operatorii + ?i - pentru a ad?uga sau sc?dea zile dintr-o dat?.
   -- Ad?ugarea a 5 zile la data curent?:
    SELECT SYSDATE + 5 AS future_date
      FROM dual; -- Future date: 14-APR-24

   -- Sc?derea a 10 zile dintr-o dat? specific?:
    SELECT hire_date - 10 AS past_date
      FROM employees
     WHERE employee_id = 101; -- Past date: 11-SEP-05

--2. Calcularea Diferen?elor de Dat?:
---Folose?te operatorul - pentru a g?si diferen?a dintre dou? date.
   -- Calcularea num?rului de zile între dou? date:
    SELECT end_date - start_date AS days_difference
      FROM some_table;
      
 SELECT end_date - start_date AS days_difference
  FROM job_history; -- 11 linii
     
--3. Ad?ugarea/Sc?derea Lunilor:
---Folose?te func?ia ADD_MONTHS pentru a ad?uga sau sc?dea luni dintr-o dat?.
  -- Ad?ugarea a 3 luni la o dat? specific?:
    SELECT ADD_MONTHS(some_date, 3) AS future_date
      FROM some_table;

    -- Sc?derea a 2 luni din data curent?:
    SELECT ADD_MONTHS(SYSDATE, -2) AS past_date
      FROM dual; -- Past date: 09-FEB-24

-- Ad?ugarea a 3 luni la data de 1-feb-2024 din tabelul job_history:
SELECT ADD_MONTHS('01-FEB-24', 3) AS future_date
  FROM dual; -- 01-MAY-24

-- Sc?derea a 2 luni de la data curent?:
SELECT ADD_MONTHS(SYSDATE, -2) AS past_date
  FROM dual; -- 09-FEB-24

--4. Calcularea Vârstei:
---Folose?te func?ia MONTHS_BETWEEN pentru a calcula num?rul de luni între dou? date.
    --Calcularea vârstei în ani:
    SELECT employee_name, TRUNC(MONTHS_BETWEEN(SYSDATE, birth_date) / 12) AS age
      FROM employees;

SELECT first_name, TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS age
  FROM employees; -- 97 linii

--5. Extragerea Componentelor:
---Folose?te func?ia EXTRACT pentru a recupera componente specifice (an, lun?, zi) dintr-o dat?.
   -- Extrage anul dintr-o dat?:
    SELECT employee_name, EXTRACT(YEAR FROM hire_date) AS hire_year
      FROM employees;
      
SELECT first_name, EXTRACT(YEAR FROM hire_date) AS hire_year
  FROM employees; -- 97 linii

--6. Aritmetic? cu Intervale:
---Folose?te cuvântul cheie INTERVAL pentru aritmetic? cu date mai complex?.
   -- Ad?ugarea a 3 luni ?i 10 zile la o dat?:
    SELECT some_date + INTERVAL '3' MONTH + INTERVAL '10' DAY AS future_date
      FROM some_table;

SELECT hire_date + INTERVAL '3' MONTH + INTERVAL '10' DAY AS future_date
  FROM employees; -- 97 linii
  
--*Capitolul 4* -> Manipularea datelor cu func?ia date:

--1. CURRENT_DATE:
---Returneaz? data curent?.
    SELECT CURRENT_DATE AS current_date
      FROM dual; -- 09-APR-24

--2. SYSDATE:
---Returneaz? data ?i ora curent?.
    SELECT SYSDATE AS current_datetime
      FROM dual; -- 09-APR-24

--3. LAST_DAY:
---Returneaz? ultima zi a lunii pentru o dat? dat?.
    SELECT LAST_DAY(SYSDATE) AS last_day_of_month
      FROM dual; -- 30-APR-24

--4. NEXT_DAY:
---Returneaz? ultima zi a lunii pentru o dat? specificat?.
    SELECT NEXT_DAY(SYSDATE) AS last_day_of_month
      FROM dual; -- ORA-00909: invalid number of arguments
      
-->Rezolvarea erorii:
SELECT NEXT_DAY(SYSDATE, 'MONDAY') AS next_monday
FROM dual; -- 15-APR-24

--5. TO_DATE and TO_CHAR:
---TO_DATE converte?te un ?ir într-o dat?, iar TO_CHAR converte?te o dat? într-un ?ir.
    SELECT TO_DATE('20/11/2023', 'DD/MM/RRRR') AS converted_date
      FROM dual; -- 20-NOV-23

    SELECT TO_CHAR(SYSDATE, 'DD/MM/RRRR HH24:MI:SS') AS formatted_date
      FROM dual; -- 09/04/2024 11:31:35
      
--*Capitolul 4* -> Manipularea numerelor cu func?iile ROUND, TRUNC ?i MOD:

--1. Func?ia ROUND:
---Func?ia ROUND este folosit? pentru a rotunji o valoare numeric? la un num?r specificat de zecimale.
-- Rotunjirea unui num?r la dou? zecimale:
    SELECT ROUND(15.6789, 2) AS rounded_number
      FROM dual; -- 15.68

--2. Func?ia TRUNC:
---Func?ia TRUNC este folosit? pentru a trunchia o valoare numeric? la un num?r specificat de zecimale sau pentru a trunchia o dat? la un component specificat al datei.
-- Trunchierea unui num?r la o zecimal?:
    SELECT TRUNC(25.345, 1) AS truncated_number
      FROM dual; -- 25.3

--3. Func?ia MOD:
---Func?ia MOD returneaz? restul unei opera?ii de împ?r?ire.
-- Calcularea restului împ?r?irii:
    SELECT MOD(17, 5) AS remainder
      FROM dual; -- 2

  -- Folosind MOD pentru a verifica numerele pare:
    SELECT employee_id
      FROM employees
     WHERE MOD(employee_id, 2) = 0; -- de la 100 pana la 206 ; total: 50 linii
     
--*Capitolul 5* -> Aplicarea func?iilor NVL, NULLIF ?i COALESCE asupra datelor:

--1. Func?ia NVL:
---Func?ia NVL este folosit? pentru a înlocui o valoare NULL cu o valoare implicit? specificat?.
    SELECT employee_id
         , NVL(salary, 0) AS actual_salary
      FROM employees; -- 97 linii

--2. Func?ia NULLIF:
---Func?ia NULLIF returneaz? NULL dac? dou? expresii sunt egale; altfel, returneaz? prima expresie.
    SELECT employee_id, NULLIF(commission_pct, 0) AS commission_percentage
      FROM employees; -- 97 linii

--3. Func?ia COALESCE:
---Func?ia COALESCE returneaz? prima expresie non-NULL din list?.
    SELECT employee_id, COALESCE(manager_id, supervisor_id, 'Not Assigned') AS assigned_manager
      FROM employees; --ORA-00904: "SUPERVISOR_ID": invalid identifier
      
--> Rezolvare eroare:
SELECT employee_id, COALESCE(manager_id, 'Not Assigned') AS assigned_manager
FROM employees; -- apare o noua eroare: ORA-00932: inconsistent datatypes: expected NUMBER got CHAR

--> Rezolvarea noii erori:
SELECT employee_id, COALESCE(NVL(manager_id, -1), -1) AS assigned_manager
FROM employees; -- 97 linii

--4. Folosirea NVL2 pentru Înlocuirea Condi?ionat?:
---Func?ia NVL2 este folosit? pentru înlocuirea condi?ionat?. Returneaz? prima expresie dac? nu este NULL; altfel, returneaz? a doua expresie.
    SELECT employee_id, NVL2(manager_id, 'Assigned', 'Not Assigned') AS manager_assignment
      FROM employees; -- 97 linii
      
--*Capitolul 5* -> În?elegerea conversiei implicite ?i explicite a tipurilor de date:

-- Example of implicit data type conversion:
    SELECT salary + 500
      FROM employees; -- 97 linii actualizate
      
-- Example of explicit data type conversion:
    SELECT TO_NUMBER('123') + 500 as "Calcul"
      FROM dual; -- 1 rand: Calcul: 623    

--*Capitolul 5* -> Using the TO_CHAR, TO_NUMBER and TO_DATE conversion functions:

--1. TO_CHAR:
---Func?ia TO_CHAR converte?te o valoare într-un ?ir de caractere.
    SELECT TO_CHAR(salary, '$999,999.99') AS formatted_salary
      FROM employees; -- 97 linii

--2. TO_NUMBER:
---Func?ia TO_NUMBER converte?te un ?ir de caractere într-un num?r.
    SELECT employee_id, TO_NUMBER('12345') AS numeric_employee_id
      FROM employees; -- 97 linii

--3. TO_DATE:
---Func?ia TO_DATE converte?te un ?ir de caractere într-o dat?.
    SELECT hire_date, TO_DATE('2022-01-01', 'YYYY-MM-DD') AS converted_date
      FROM employees; -- 97 linii
      
--*Capitolul 5* -> Utilizarea comenzilor DEFINE ?i VERIFY:

--1. Îngr?direa func?iilor TO_CHAR ?i TO_DATE:
---Po?i îngr?di func?iile TO_CHAR ?i TO_DATE pentru a schimba formatul unei valori de dat?.
    SELECT TO_CHAR(TO_DATE('2022-01-15', 'YYYY-MM-DD'), 'DD-MON-YYYY') AS formatted_date
      FROM dual; -- 15-JAN-2022

--2. Îngr?direa func?iilor TO_NUMBER ?i TO_CHAR:
---Po?i îngr?di func?iile TO_NUMBER ?i TO_CHAR pentru a formata o valoare numeric?.
    SELECT TO_CHAR(TO_NUMBER('12345') + 500, '999,999') AS formatted_number
      FROM dual; -- 12,845

--3. Îngr?direa Func?iilor în Clauza WHERE:
---Po?i îngr?di func?iile în clauza WHERE pentru a filtra datele în func?ie de condi?ii complexe.
    SELECT employee_id, salary
      FROM employees
     WHERE TO_NUMBER(salary) > 50000; -- nimic

--4. Imbricarea func?iilor TRUNC ?i TO_CHAR pentru Formatarea Datelor:
---Pute?i imbrica func?ii pentru a efectua opera?iuni ?i formatare într-o singur? interogare.
    SELECT employee_id, TO_CHAR(TRUNC(hire_date, 'MONTH'), 'DD-MON-YYYY') AS start_of_month
      FROM employees; -- 97 linii

--5. Imbricarea func?iilor COALESCE ?i TO_NUMBER:
---Pute?i imbrica func?ii pentru a gestiona valorile NULL ?i a efectua opera?iuni numerice.
    SELECT employee_id, COALESCE(TO_NUMBER(salary), 0) AS numeric_salary
      FROM employees; -- 97 linii
      
--*Capitolul 6* -> Limitarea rezultatelor grupului:

-- 1. Clauza HAVING de baz?:
--- Pute?i utiliza clauza HAVING pentru a filtra grupuri în func?ie de condi?ii bazate pe agreg?ri.
    SELECT department_id, COUNT(*) AS employee_count
      FROM employees
     GROUP BY department_id
    HAVING COUNT(*) > 5; -- 3 linii

-- 2. Combinarea clauzei HAVING cu GROUP BY:
--- Pute?i utiliza împreun? clauzele GROUP BY ?i HAVING pentru agreg?ri mai complexe.
    SELECT department_id
         , job_id, AVG(salary) AS avg_salary
      FROM employees
     GROUP BY department_id
            , job_id
    HAVING AVG(salary) > 50000; -- nimic

-- 3. Utilizarea HAVING cu SUM:
--- Pute?i folosi clauza HAVING împreun? cu func?ia SUM pentru a filtra datele în func?ie de suma total? a unei coloane.
    SELECT department_id
         , MAX(salary) AS max_salary
      FROM employees
     GROUP BY department_id
    HAVING MAX(salary) > 80000; -- nimic

-- 4. Filtrarea pe baza condi?iilor de agregare:
--- Clauza HAVING permite filtrarea pe baza diferitelor condi?ii de agregare.

    SELECT department_id
         , AVG(salary) AS avg_salary
      FROM employees
     GROUP BY department_id
    HAVING AVG(salary) BETWEEN 50000 AND 80000; -- nimic

-- 5. Utilizarea HAVING cu COUNT ?i operatori logici:
--- Pute?i folosi operatori logici împreun? cu COUNT ?i HAVING pentru a filtra grupuri în func?ie de condi?ii multiple.
    SELECT department_id, COUNT(*) AS employee_count
      FROM employees
     GROUP BY department_id
    HAVING COUNT(*) > 5 AND COUNT(*) < 10; -- o linie: Employee_id: 30 ; Employee_count: 6

-- 6. Ascunderea valorilor NULL cu HAVING:
--- Pute?i utiliza clauza HAVING pentru a filtra grupurile care includ valori NULL.
    SELECT department_id, AVG(salary) AS avg_salary
      FROM employees
     GROUP BY department_id
    HAVING AVG(salary) IS NOT NULL; -- 11 linii

--*Capitolul 6* -> Using Group Functions:

--1. Func?ia COUNT:
---Func?ia COUNT este folosit? pentru a num?ra num?rul de rânduri într-un set.
    SELECT COUNT(*) AS total_employees
      FROM employees; -- 97 total angajati

--2. Func?ia SUM:
---Func?ia SUM este folosit? pentru a calcula suma unei coloane numerice.
    SELECT department_id, SUM(salary) AS total_salary
      FROM employees
     GROUP BY department_id; -- 11 linii
--Aceast? interogare returneaz? salariul total pentru fiecare departament.

--3. Func?ia AVG:
---Func?ia AVG calculeaz? valoarea medie a unei coloane numerice.
    SELECT department_id, AVG(salary) AS average_salary
      FROM employees
     GROUP BY department_id; -- 11 linii

--4. Func?iile MAX ?i MIN:
---Func?iile MAX ?i MIN recupereaz?, respectiv, valorile maxime ?i minime dintr-o coloan?.
    SELECT department_id, MAX(salary) AS max_salary, MIN(salary) AS min_salary
      FROM employees
     GROUP BY department_id; -- 11 linii

--5. GROUP_CONCAT (LISTAGG în Oracle 11g ?i ulterior):
---Func?ia LISTAGG în Oracle concateneaz? valorile din mai multe rânduri într-un singur ?ir.
    SELECT department_id
         , LISTAGG(employee_name, ', ') WITHIN GROUP (ORDER BY employee_name) AS employee_list
      FROM employees
     GROUP BY department_id; -- ORA-00904: "EMPLOYEE_NAME": invalid identifier

-->Rezolvare eroare:
     SELECT department_id
         , LISTAGG(first_name, ', ') WITHIN GROUP (ORDER BY first_name) AS employee_list
      FROM employees
     GROUP BY department_id;  -- 11 linii

--6. SETURI DE GRUPURI (GROUPING SETS):
---SETURILE DE GRUPURI î?i permit s? specifici mai multe criterii de grupare într-o singur? interogare.
    SELECT department_id
         , job_id
         , COUNT(*) AS employee_count
      FROM employees
     GROUP BY GROUPING SETS ((department_id)
                          , (job_id)
                          , ()); -- 31 linii

--7. ROLLUP:
---ROLLUP este folosit pentru a crea subtotaluri ?i totaluri generale pentru un set de coloane.
    SELECT department_id
         , job_id
         , COUNT(*) AS employee_count
      FROM employees
     GROUP BY ROLLUP (department_id
                    , job_id); -- 31 linii

--8. CUBE:
---CUBE genereaz? toate subtotalurile posibile ?i totalurile generale pentru un set de coloane.
    SELECT department_id
         , job_id
         , COUNT(*) AS employee_count
      FROM employees
     GROUP BY CUBE (department_id
                  , job_id); -- 50 linii
                  
--*Capitolul 7* -> Using Self-joins:

--Example: Self-Join pentru a Ob?ine Angaja?ii ?i Managerii Lor
    SELECT e.employee_id
         , e.first_name
         , m.first_name AS manager_name
      FROM employees e
      LEFT JOIN employees m ON e.manager_id = m.employee_id; -- 97 linii
      
--Exemplu complex:
SELECT employee_id
         , first_name
         , manager_id
         , LEVEL
      FROM employees
     START WITH manager_id IS NULL
    CONNECT BY PRIOR employee_id = manager_id
    ORDER BY LEVEL, employee_id; -- 97 linii
    
--*Capitolul 7* -> Using Various Types of Joins:

--1. INNER JOIN:
---Cuvântul cheie INNER JOIN selecteaz? înregistr?rile care au valori potrivite în ambele tabele.
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
      FROM employees
      INNER JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--2. LEFT JOIN (sau LEFT OUTER JOIN):
---Cuvântul cheie LEFT JOIN returneaz? toate înregistr?rile din tabela din stânga (angaja?ii) ?i înregistr?rile potrivite din tabela din dreapta (departamente).
---Rezultatul este NULL din partea dreapt? dac? nu exist? nicio potrivire.
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
      FROM employees
      LEFT JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--3. RIGHT JOIN (sau RIGHT OUTER JOIN):
---Cuvântul cheie RIGHT JOIN returneaz? toate înregistr?rile din tabela din dreapta (departamente) ?i înregistr?rile potrivite din tabela din stânga (angaja?i).
---Rezultatul este NULL din partea stâng? când nu exist? nicio potrivire.
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
      FROM employees
      RIGHT JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--4. FULL JOIN (sau FULL OUTER JOIN):
---Cuvântul cheie FULL JOIN returneaz? toate înregistr?rile când exist? o potrivire în înregistr?rile tabelelor din stânga (angaja?i) sau din dreapta (departamente).
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
      FROM employees
      FULL JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--5. CROSS JOIN:
---Cuvântul cheie CROSS JOIN returneaz? produsul cartezian al celor dou? tabele, combinând fiecare rând din prima tabel? cu fiecare rând din a doua tabel?.
    SELECT employees.employee_id, employees.first_name, departments.department_name
      FROM employees
      CROSS JOIN departments; -- 1067 linii

--6. SELF JOIN:
---Un SELF JOIN este o al?turare obi?nuit?, dar tabela este al?turat? cu ea îns??i. Este util pentru structurile ierarhice.
    SELECT e1.employee_id
         , e1.first_name
         , e2.first_name AS manager_name
      FROM employees e1
      LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id; -- 97 linii
      
--*Capitolul 6* -> Using OUTER joins:

--1. LEFT OUTER JOIN:
---The LEFT OUTER JOIN returns all records from the left table (the table specified before the JOIN keyword) 
---and the matched records from the right table. 
---If there is no match, NULL values are returned for columns from the right table.
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
      FROM employees
      LEFT JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--2. RIGHT OUTER JOIN:
---The RIGHT OUTER JOIN returns all records from the right table (the table specified after the JOIN keyword) and the matched records from the left table. 
---If there is no match, NULL values are returned for columns from the left table.
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
    FROM employees
    RIGHT JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--3. FULL OUTER JOIN:
---The FULL OUTER JOIN returns all records when there is a match in either the left or the right table. 
---If there is no match, NULL values are returned for columns from the table without a match.
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
      FROM employees
      FULL JOIN departments ON employees.department_id = departments.department_id; -- 97 linii

--*Capitolul 7* -> Understanding and Using Cartesian Products:

--Here is an example of using a Cartesian product in Oracle SQL:
--Example: Cartesian Product
    SELECT employees.employee_id
         , employees.first_name
         , departments.department_name
      FROM employees
      CROSS JOIN departments; -- 1067 linii
      
--*Capitolul 7* -> Using Non equijoins:

--Lets say you have two tables, "employees" and "salaries," and you want to retrieve employees whose salary is greater than the average salary in the "salaries" table:
    SELECT e.employee_id
         , e.first_name
         , e.salary
         , s.average_salary
      FROM employees e
      JOIN (SELECT department_id, AVG(salary) AS average_salary
              FROM employees
             GROUP BY department_id) s 
           ON e.department_id = s.department_id 
          AND e.salary > s.average_salary; -- nimic
          
--*Capitolul 8* -> Using Single Row Subqueries:

--Example: Using Single Row Subquery in a SELECT Statement
---Suppose you have a "salaries" table, and you want to retrieve employees whose salary is greater than the average salary for their department:
    SELECT employee_id
         , first_name
         , salary
         , (SELECT AVG(salary) 
              FROM employees s2 
             WHERE s2.department_id = s1.department_id) AS avg_department_salary
      FROM employees s1; -- 97 linii
      
--For instance, you might use a single-row subquery in a WHERE clause to filter records based on a specific condition:
    SELECT employee_id
         , first_name
         , salary
      FROM employees
     WHERE salary > (SELECT AVG(salary) FROM employees); -- nimic
     
--*Capitolul 8* -> Using Multiple Row Subqueries:

--Example: Using Multiple Row Subquery in a WHERE Clause
---Suppose you have a "departments" table, and you want to retrieve employees whose salaries are greater than the average salary for their department:
    SELECT employee_id
         , first_name
         , salary
         , department_id
      FROM employees
     WHERE salary > ALL (SELECT AVG(salary) 
                           FROM employees
                          WHERE department_id = employees.department_id); -- nimic
                          
--You can also use multiple-row subqueries in other contexts. For instance, you might use them in a SELECT clause to retrieve values based on a condition:
    SELECT employee_id
         , first_name
         , (SELECT MAX(salary) 
              FROM employees 
             WHERE department_id = employees.department_id) AS max_department_salary
      FROM employees; -- 97 linii
      
--*Capitolul 8* -> Update and delete row using correlated subqueries:

--Example: Updating Rows with Correlated Subquery
---Suppose you have a "students" table, and you want to update the grades of students to the maximum grade in their respective courses:
    UPDATE students s
       SET grade = (SELECT MAX(grade) 
                      FROM students 
                     WHERE course_id = s.course_id);
                     
--Example: Deleting Rows with Correlated Subquery
---Suppose you have an "employees" table, and you want to delete employees who earn less than the average salary in their department:
    DELETE employees e
     WHERE salary < (SELECT AVG(salary) 
                       FROM employees 
                      WHERE department_id = e.department_id); -- 0 linii sterse
                      
--*Capitolul 9* -> Matching the SELECT statements:

--1. UNION Operator:
---The UNION operator combines the results of two or more SELECT statements, removing duplicates.
    -- Example 1: UNION with similar columns
    SELECT employee_id, first_name FROM employees
    UNION
    SELECT manager_id, last_name FROM managers; -- 100 linii

    -- Example 2: UNION with different columns (requires aliasing)
    SELECT employee_id, first_name FROM employees
    UNION
    SELECT department_id AS employee_id, department_name AS first_name FROM departments; -- 108 linii

--2. INTERSECT Operator:
---The INTERSECT operator returns the common rows between two SELECT statements.
    SELECT employee_id, first_name FROM employees
    INTERSECT
    SELECT manager_id, last_name FROM managers; -- nimic

--3. MINUS Operator:
---The MINUS operator returns the rows from the first SELECT statement that are not present in the second SELECT statement.
    SELECT employee_id, first_name FROM employees
    MINUS
    SELECT manager_id, last_name FROM managers; -- 97 linii

--4. Matching SELECT Statements with Set Operators:
---Ensure that the SELECT statements have compatible columns in terms of number and data types.
    SELECT e.employee_id, e.first_name FROM employees as e
    UNION
    SELECT m.manager_id, m.last_name FROM managers as m WHERE e.hire_date > TO_DATE('2022-01-01', 'YYYY-MM-DD'); -- ORA-00933: SQL command not properly ended

select * from managers; -- 3 linii
--5. Applying Set Operators to More Than Two Queries:
---You can use parentheses to control the order of evaluation when applying set operators to more than two queries.
    (SELECT employee_id, first_name FROM employees)
    UNION
    (SELECT manager_id, last_name FROM managers)
    MINUS
    (SELECT contractor_id, contractor_name FROM contractors); -- ORA-00942: table or view does not exist

--6. Using Set Operators in the WHERE Clause:
---You can use set operators within the WHERE clause for more complex conditions.
    SELECT employee_id
         , first_name 
      FROM employees 
     WHERE employee_id IN (SELECT manager_id 
                             FROM managers 
                            WHERE hire_date > SYSDATE - 365); -- nimic
                            
--*Capitolul 9* -> Using the ORDER BY clause in set operations:

--Here is an example:

    SELECT *
      FROM (SELECT employee_id
                 , employee_name 
              FROM employees
            UNION
            SELECT manager_id
                 , manager_name 
              FROM managers
            ORDER BY 1)
     WHERE department_id = 10;
     
--*Capitolul 9* -> Using the INTERSECT operator:

--1. INTERSECT Operator:
---The INTERSECT operator returns the common rows between two SELECT statements.

SELECT employee_id, employee_name FROM employees
INTERSECT
SELECT manager_id, manager_name FROM managers;

--*Capitolul 9* -> Using the MINUS operator:

--1. MINUS Operator:
---The MINUS operator returns the rows from the first SELECT statement that are not present in the second SELECT statement.

SELECT employee_id, employee_name FROM employees
MINUS
SELECT manager_id, manager_name FROM managers;

--*Capitolul 9 * -> Using the UNION and UNION ALL operators:

--1. UNION Operator:
---The UNION operator is used to combine the results of two or more SELECT statements, and it removes duplicate rows from the result set.
    SELECT employee_id, employee_name FROM employees
    UNION
    SELECT manager_id, manager_name FROM managers;

--2. UNION ALL Operator:
---The UNION ALL operator is similar to UNION, but it does not remove duplicate rows; it includes all rows from the combined result sets.
    SELECT employee_id, employee_name FROM employees
    UNION ALL
    SELECT manager_id, manager_name FROM managers;
    
--*Capitolul 10* -> Managing Database Transactions:

--Example: Managing Transactions
    BEGIN
       -- Start a transaction explicitly
       -- Perform DML operations

       -- Check for errors and commit or rollback accordingly
       IF (no_errors) THEN
          COMMIT; -- Commit changes
       ELSE
          ROLLBACK; -- Rollback changes
       END IF;
    END;
    
--*Capitolul 10* -> Controlling transactions:

--1. BEGIN TRANSACTION (Implicit Commit):
    BEGIN TRANSACTION;
    -- Your SQL statements here
    COMMIT;

--2. COMMIT:
COMMIT;

--3. ROLLBACK:
ROLLBACK;

--4. SAVEPOINT:
SAVEPOINT savepoint_name;
    -- Your SQL statements here
    ROLLBACK TO savepoint_name;
    
--Example: Controlling Transactions
    BEGIN
       -- Start a transaction explicitly
       SAVEPOINT start_transaction;

       -- Perform DML operations
       UPDATE employees SET salary = salary * 1.1 WHERE department_id = 10;

       -- Check for errors and commit or rollback accordingly
       IF (no_errors) THEN
          COMMIT; -- Commit changes
       ELSE
          ROLLBACK TO start_transaction; -- Rollback to the savepoint
       END IF;
    END;
    
--*Capitolul 10* -> Performing multi table inserts:

--Example: Multi-Table Insert
---Suppose you have two tables, "employees" and "departments," and you want to insert data into both tables in a single transaction:
    INSERT ALL 
       INTO employees (employee_id, employee_name, department_id, salary)
          VALUES (1, 'John Doe', 101, 50000)
       INTO departments (department_id, department_name, location)
          VALUES (101, 'Development', 'New York')
    SELECT * FROM dual;
    
--*Capitolul 10* -> Perform Insert, Update and Delete operations:

--1. Insert Operation:
---Example: Inserting a New Employee
    INSERT INTO employees (employee_id, employee_name, department_id, salary)
                   VALUES (1, 'John Doe', 101, 50000);
                   
--2. Update Operation:
---Example: Updating Employee Salary
    UPDATE employees
       SET salary = 55000
     WHERE employee_id = 1;
     
--3. Delete Operation:
---Example: Deleting an Employee
    DELETE employees
     WHERE employee_id = 1;
     
--*Capitolul 10* -> Performing Merge statements:

--Example: Using MERGE Statement
---Suppose you have a target table named "employees" and a source table named "employees_updates." 
---You want to update existing records if they match, insert new records if they don't exist
---, and delete records from the target table if they no longer exist in the source.
    MERGE INTO employees target
    USING employees_updates source
    ON (target.employee_id = source.employee_id)
    WHEN MATCHED THEN
       UPDATE SET target.salary = source.new_salary
    WHEN NOT MATCHED THEN
       INSERT (employee_id, employee_name, department_id, salary)
       VALUES (source.employee_id, source.employee_name, source.department_id, source.new_salary)
    WHEN NOT MATCHED BY SOURCE THEN
       DELETE;
       
--*Capitolul 11* -> Managing indexes:

--Creating an Index:
---To create an index on a specific column, you can use the CREATE INDEX statement. For example:
    CREATE INDEX idx_employee_name ON employees(employee_name);

--Removing an Index:
---To remove an existing index, you can use the DROP INDEX statement. For example:
    DROP INDEX idx_employee_name;

--Viewing Index Information:
---You can view information about existing indexes in a table by querying the data dictionary views. 
---For example, to see the indexes on the employees table:
    SELECT index_name
         , column_name
      FROM user_ind_columns
    WHERE table_name = 'EMPLOYEES';

--Managing Index Options:
---When creating an index, you can specify various options to customize its behavior. For example:
    CREATE INDEX idx_employee_name ON employees(employee_name)
    TABLESPACE users
    PCTFREE 10
    INITRANS 2;
    
--Rebuilding an Index:
---You can use the ALTER INDEX statement to rebuild an existing index. Rebuilding an index can be useful for defragmentation or to apply changes made to the index options. 
---For example:
    ALTER INDEX idx_employee_name REBUILD;

--Monitoring Index Usage:
---Oracle provides tools to monitor and gather statistics on index usage. 
---The Oracle optimizer uses these statistics to make informed decisions about query execution plans.
    Gather statistics on an index
    EXEC DBMS_STATS.GATHER_INDEX_STATS('HR', 'EMPLOYEES', 'IDX_EMPLOYEE_NAME');
    
--*Capitolul 11* -> Managing Sequences:

--Creating a Sequence:
---To create a sequence, you can use the CREATE SEQUENCE statement. For example:
    CREATE SEQUENCE employee_id_seq
      START WITH 1
      INCREMENT BY 1
      MAXVALUE 1000
      NOCACHE
      NOCYCLE;
      
--Retrieving Sequence Values:
---To retrieve the next value from a sequence, you can use the NEXTVAL function:
    SELECT employee_id_seq.NEXTVAL 
      FROM dual;

--Using Sequence Values in Insert Statements:
---You can use sequence values in INSERT statements to automatically generate unique identifiers:
    INSERT INTO employees (employee_id, employee_name, salary)
                   VALUES (employee_id_seq.NEXTVAL, 'John Doe', 50000);

--Altering a Sequence:
---You can use the ALTER SEQUENCE statement to modify the properties of an existing sequence. For example:
    ALTER SEQUENCE employee_id_seq
      INCREMENT BY 2
      MAXVALUE 2000;

--Dropping a Sequence:
---To remove a sequence, you can use the DROP SEQUENCE statement:
    DROP SEQUENCE employee_id_seq;

--Viewing Sequence Information:
---You can query the data dictionary views to obtain information about existing sequences. For example:
    SELECT sequence_name
         , last_number
      FROM user_sequences
     WHERE sequence_name = 'EMPLOYEE_ID_SEQ';
     
--*Capitolul 11* -> Managing Synonyms:

--Creating a Synonym:
---To create a synonym, you can use the CREATE SYNONYM statement. For example:
    CREATE SYNONYM emp_syn FOR employees;

--Dropping a Synonym:
---To remove a synonym, you can use the DROP SYNONYM statement:
    DROP SYNONYM emp_syn;

--Viewing Synonym Information:
---You can query the data dictionary views to obtain information about existing synonyms. For example:
    SELECT synonym_name, table_name
      FROM user_synonyms
     WHERE synonym_name = 'EMP_SYN';

--Altering a Synonym:
---Synonyms don't have many alterable properties, but you can replace the underlying object that a synonym refers to using the REPLACE keyword:
    CREATE OR REPLACE SYNONYM emp_syn FOR new_employees_table;

--Public Synonyms:
---A public synonym is a synonym that is accessible to all database users. 
---To create a public synonym, you need the CREATE PUBLIC SYNONYM privilege. For example:
    CREATE PUBLIC SYNONYM emp_syn FOR employees;
    
--*Capitolul 12* -> Describing and Working with Tables:

--Create a Table:
---Use the CREATE TABLE statement to define a new table. 
---Include the column names along with their data types and any constraints.
    CREATE TABLE employees (
        employee_id INT PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hire_date DATE,
        department_id INT,
        CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments(department_id));

--Alter Table Structure:
---The ALTER TABLE statement is used to modify an existing table. You can add, modify, or drop columns.
    ALTER TABLE employees ADD salary DECIMAL(10, 2);
    ALTER TABLE employees MODIFY last_name VARCHAR(100);
    ALTER TABLE employees DROP COLUMN hire_date;

--Create Index:
---Indexes improve the speed of data retrieval operations on a table. 
---Use the CREATE INDEX statement to create an index on one or more columns.
    CREATE INDEX idx_last_name ON employees(last_name);

--Create Unique Constraint:
---A unique constraint ensures that values in a column or a group of columns are unique across the table.
    ALTER TABLE employees ADD CONSTRAINT uc_employee_id UNIQUE (employee_id);

--Create Check Constraint:
---A check constraint enforces a condition on the values in a column.
    ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary > 0);

--Drop Table:
---Use the DROP TABLE statement to remove a table and its data from the database.
---Be cautious when using DROP TABLE as it permanently deletes the table and its data.
    DROP TABLE employees;
    
--*Capitolul 12* - Describing and Working with Columns and Data Types:

--Describing a Table:
---Use the DESCRIBE statement or the DESC shorthand to view the structure of a table, including the details of its columns, data types, and constraints.
    DESCRIBE employees;

--Creating a Table with Columns:
---When creating a table, specify the columns along with their data types. 
---Data types define the kind of data that can be stored in a column.
    CREATE TABLE employees (
        employee_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hire_date DATE);

--Altering Column Data Types:
---Use the ALTER TABLE statement to modify the data type of a column.
    ALTER TABLE employees MODIFY hire_date TIMESTAMP;

--Adding a New Column:
---You can add a new column to an existing table using the ALTER TABLE statement.
    ALTER TABLE employees ADD email VARCHAR(100);

--Renaming a Column:
---Renaming a column is possible using the ALTER TABLE statement.
    ALTER TABLE employees RENAME COLUMN first_name TO given_name;

--Dropping a Column:
---To remove a column from a table, use the ALTER TABLE statement with the DROP COLUMN clause.
    ALTER TABLE employees DROP COLUMN email;

--Column Constraints:
---Constraints define rules that enforce data integrity. 
---Common constraints include NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, and CHECK.
    CREATE TABLE students (
        student_id INT PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE,
        age INT CHECK (age >= 18));
        
--*Capitolul 12* -> Creating tables:

--Below is a basic example of how you can create a table:
    CREATE TABLE employees (
        employee_id INT PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hire_date DATE,
        department_id INT);
        
--*Capitolul 12* -> Dropping columns and setting column UNUSED:

--Dropping Columns:
---To drop a column from a table, you can use the ALTER TABLE statement with the DROP COLUMN clause. Here's an example:
    ALTER TABLE employees DROP COLUMN hire_date;

--Setting Column UNUSED:
--The syntax is as follows:
    ALTER TABLE employees SET UNUSED COLUMN hire_date;

-- the DROP UNUSED COLUMNS statement:
    ALTER TABLE employees DROP UNUSED COLUMNS;
    
--*Capitolul 12* -> Truncating tables:

--Here's the basic syntax for truncating a table in SQL:
    TRUNCATE TABLE table_name;

--Replace table_name with the name of the table you want to truncate. Here's an example:
    TRUNCATE TABLE employees;
    
--*Capitolul 12* -> Creating and using Temporary Tables:

--Creating a Temporary Table:
---Here's an example using the CREATE TEMPORARY TABLE syntax:
    CREATE TEMPORARY TABLE temp_employees (
        employee_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50));

--Inserting Data into a Temporary Table:
---You can insert data into a temporary table using the INSERT INTO statement, just like with regular tables:
    INSERT INTO temp_employees (employee_id, first_name, last_name)
                        VALUES (1, 'John', 'Doe'),
                               (2, 'Jane', 'Smith');

--Querying and Using the Temporary Table:
---Once the temporary table is created and populated, you can perform queries and operations on it as you would with any other table:
    SELECT * FROM temp_employees;

--Dropping the Temporary Table:
--- the DROP TABLE statement:
    DROP TEMPORARY TABLE temp_employees;
    
--*Capitolul 12* -> Creating and using external tables:

--Creating an External Table:
---The syntax for creating an external table can vary depending on the database system you're using. 
---Below is an example for Oracle Database using the CREATE TABLE...ORGANIZATION EXTERNAL statement:
    CREATE TABLE external_employees
       (employee_id NUMBER,
        first_name VARCHAR2(50),
        last_name VARCHAR2(50))
    ORGANIZATION EXTERNAL
       (TYPE ORACLE_LOADER
        DEFAULT DIRECTORY ext_data_dir
        ACCESS PARAMETERS
           (RECORDS DELIMITED BY NEWLINE
            FIELDS (employee_id CHAR(10),
                    first_name CHAR(50),
                    last_name CHAR(50)))
        LOCATION ('employees.csv'));
        
--Querying the External Table:
---You can query the external table as if it were a regular table:
    SELECT * FROM external_employees;

--Dropping the External Table:
---To drop an external table, you can use the DROP TABLE statement:
    DROP TABLE external_employees;
    
--*Capitolul 12* -> Managing Constraints:

--1. Primary Key Constraint:
---A primary key uniquely identifies each record in a table. To create a primary key constraint:
    CREATE TABLE employees (
        employee_id INT PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50));

--To add a primary key to an existing table:
    ALTER TABLE employees ADD PRIMARY KEY (employee_id);

--2. Foreign Key Constraint:
---A foreign key establishes a link between two tables by referencing a unique key in another table. To create a foreign key:
    CREATE TABLE orders (
        order_id INT PRIMARY KEY,
        customer_id INT,
        order_date DATE,
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

--3. Unique Constraint:
---A unique constraint ensures that all values in a column are distinct. To create a unique constraint:
    CREATE TABLE departments (
        department_id INT PRIMARY KEY,
        department_name VARCHAR(50) UNIQUE);

--4. Check Constraint:
---A check constraint enforces a condition on the values in a column. For example:
    CREATE TABLE students (
        student_id INT PRIMARY KEY,
        age INT CHECK (age >= 18),
        grade CHAR(1) CHECK (grade IN ('A', 'B', 'C', 'D', 'F')));

--5. Not Null Constraint:
---A not null constraint ensures that a column cannot have a null value:
    CREATE TABLE customers (
        customer_id INT PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL);

--6. Dropping Constraints:
---To drop a constraint, you can use the ALTER TABLE statement. For example, to drop a primary key constraint:
    ALTER TABLE employees DROP PRIMARY KEY;

--7. Disabling and Enabling Constraints:
---Some databases allow you to disable and enable constraints. 
---This can be useful when you need to perform operations that temporarily violate a constraint. For example:
    ALTER TABLE employees DISABLE CONSTRAINT emp_salary_check;
    ALTER TABLE employees ENABLE CONSTRAINT emp_salary_check;
    
--*Capitolul 13* -> Managing Views:

--1. Creating Views:
---You can create a view using the CREATE VIEW statement followed by a SELECT query.
    CREATE VIEW employee_view AS
        SELECT employee_id
             , employee_name
             , department_id
          FROM employees
         WHERE department_id = 10;

--2. Altering Views:
---To modify an existing view, you can use the CREATE OR REPLACE VIEW statement.
    CREATE OR REPLACE VIEW employee_view AS
        SELECT employee_id
             , employee_name
             , department_id
          FROM employees
         WHERE department_id = 20;

--3. Dropping Views:
---To remove a view, you can use the DROP VIEW statement.
    DROP VIEW employee_view;

--4. Querying Views:
---Once a view is created, you can query it like a table.
    SELECT * FROM employee_view;

--5. Updating Views:
---In some cases, you can update the underlying tables through a view. However, there are certain restrictions, and the view must meet certain criteria.
    UPDATE employee_view
       SET department_id = 30
     WHERE employee_id = 101;

--6. Managing View Security:
---You can control access to views by granting or revoking privileges.
    Grant SELECT privilege on the view to a user
    GRANT SELECT ON employee_view TO hr_user;

    Revoke SELECT privilege on the view from a user
    REVOKE SELECT ON employee_view FROM hr_user;

--7. View Dependencies:
---You can query the ALL_DEPENDENCIES data dictionary view to find dependencies of a view.
    SELECT *
      FROM ALL_DEPENDENCIES
     WHERE REFERENCED_NAME = 'EMPLOYEE_VIEW';

--8. Materialized Views:
---Oracle supports materialized views, which are physical copies of the result set stored in a table. 
---They can improve query performance but may require maintenance.
    CREATE MATERIALIZED VIEW mv_employee AS
        SELECT employee_id
             , employee_name
             , department_id
          FROM employees
         WHERE department_id = 10;

--9. Refreshing Materialized Views:
---Materialized views need to be refreshed to update the data. You can use the DBMS_MVIEW package or DBMS_SCHEDULER for automatic refresh.
    --Manual refresh
    EXEC DBMS_MVIEW.REFRESH('MV_EMPLOYEE');

  --  Automatic refresh using DBMS_SCHEDULER
    DBMS_SCHEDULER.create_refresh_job('MV_EMPLOYEE_REFRESH_JOB', INTERVAL=>'SYSDATE + 1');
    
--*Capitolul 14* -> Differential system privileges from object privileges:

--System Privileges:
---System privileges are permissions that allow a user to perform certain actions at the system level, such as managing database objects or administering the database itself. 
---Here are some common system privileges:
    CREATE SESSION --Allows a user to connect to the database.
    CREATE TABLE --Allows a user to create new tables in a database.
    CREATE USER --Grants the ability to create new user accounts.
    ALTER SYSTEM --Provides the ability to alter database-wide settings.
    DROP ANY TABLE --Allows a user to drop any table in the database.
    DBA Role --Users with the DBA (Database Administrator) role have a wide range of system privileges allowing them to perform administrative tasks.

--Object Privileges:
---Object privileges, on the other hand, are permissions that apply to specific database objects, such as tables, views, procedures, or sequences. 
---Here are some common object privileges:
    SELECT --Allows a user to retrieve data from a table or view.
    INSERT --Grants the ability to insert new rows into a table.
    UPDATE --Allows a user to modify existing rows in a table.
    DELETE --Grants the ability to remove rows from a table.
    EXECUTE --Provides the ability to execute a stored procedure or function.
    ALTER --Allows a user to modify the structure of a table, such as adding or dropping columns.
    REFERENCES --Grants the ability to create a foreign key reference to a column.

--Granting and Revoking Privileges:
  ---  Granting System Privileges:
    GRANT CREATE SESSION TO username;

 ---   Revoking System Privileges:
    REVOKE CREATE SESSION FROM username;

   --- Granting Object Privileges:
    GRANT SELECT, INSERT, UPDATE ON employees TO username;

   --- Revoking Object Privileges:
    REVOKE SELECT, INSERT, UPDATE ON employees FROM username;

--Roles:
---Roles are a way to group privileges together, simplifying the process of managing and assigning permissions. 
---For example, you can create a role with specific system or object privileges and then grant that role to users.
   --- Creating a Role:
    CREATE ROLE manager_role;

   --- Granting Privileges to a Role:
    GRANT SELECT, INSERT, UPDATE ON employees TO manager_role;

   --- Granting a Role to a User:
    GRANT manager_role TO username;

--Auditing Access:
---Database administrators can use auditing features to track user access, changes, and other activities in the database. 
---This helps in monitoring and ensuring security.
   --- Enabling Auditing:
    AUDIT SELECT TABLE, UPDATE TABLE BY scott BY ACCESS;

  ---  Viewing Audit Information:
    SELECT * FROM DBA_AUDIT_TRAIL WHERE USERNAME = 'SCOTT';
    
--*Capitolul 14* -> Granting privileges on tables:

--Object Privileges on Tables:
---Granting SELECT Privilege:
---Allows a user to retrieve data from a table.

    GRANT SELECT ON table_name TO username;

--Granting INSERT Privilege:
---Allows a user to insert new rows into a table.
    GRANT INSERT ON table_name TO username;

--Granting UPDATE Privilege:
---Allows a user to modify existing rows in a table.
    GRANT UPDATE ON table_name TO username;

--Granting DELETE Privilege:
---Allows a user to remove rows from a table.
    GRANT DELETE ON table_name TO username;

--Granting ALL Privileges:
---Grants all available privileges on a table.
    GRANT ALL ON table_name TO username;

--Granting Privileges with the OPTION Clause:
---When granting privileges, you can use the WITH OPTION clause to allow the grantee to further grant those privileges to other users. For example:
    GRANT SELECT, INSERT ON table_name TO username WITH GRANT OPTION;

--Granting Privileges to Roles:
---Instead of granting privileges directly to individual users, you can grant privileges to roles and then assign those roles to users.
    Creating a Role:
    CREATE ROLE role_name;

    Granting Privileges to a Role:
    GRANT SELECT, INSERT ON table_name TO role_name;

    Granting the Role to a User:
    GRANT role_name TO username;

--Revoking Privileges:
---To revoke previously granted privileges, you can use the REVOKE statement.
    Revoking SELECT Privilege:
    REVOKE SELECT ON table_name FROM username;

    Revoking ALL Privileges:
    REVOKE ALL ON table_name FROM username;

--Viewing Granted Privileges:
---To view the privileges granted on a table, you can query the USER_TAB_PRIVS or ALL_TAB_PRIVS view.
    SELECT * FROM USER_TAB_PRIVS WHERE TABLE_NAME = 'table_name';
    
--*Capitolul 14* -> Distinguishing between granting privileges and roles:

--1. Granting Privileges:
  ---  Definition:
     ---   Granting privileges involves giving specific permissions to a user on a particular database object (e.g., a table, view, or sequence).
   --- Syntax:
      ---  Privileges are granted using the GRANT statement.
            GRANT SELECT, INSERT ON table_name TO username;

--2. Using Roles:
  ---  Definition:
     ---   Roles are a way to group multiple privileges together. Users can be assigned roles, and the roles, in turn, have associated privileges.
   --- Syntax:
      ---  Roles are created using the CREATE ROLE statement and granted using the GRANT statement. Users are assigned roles with the GRANT statement as well.
            CREATE ROLE role_name;
            GRANT SELECT, INSERT ON table_name TO role_name;
            GRANT role_name TO username;
            
--*Capitolul 15* -> Using data dictionary views:

--1. ALL_TABLES:
---Provides information about tables accessible by the current user.
    SELECT table_name
         , num_rows
      FROM all_tables
     WHERE owner = 'HR';

--2. ALL_TAB_COLUMNS:
---Contains information about columns of tables accessible by the current user.
    SELECT table_name
         , column_name
         , data_type
      FROM all_tab_columns
     WHERE owner = 'HR';

--3. ALL_VIEWS:
---Provides information about views accessible by the current user.
    SELECT view_name
         , text
      FROM all_views
     WHERE owner = 'HR';

--4. USER_OBJECTS:
---Contains information about objects owned by the current user.
    SELECT object_name
         , object_type
      FROM user_objects;

--5. ALL_USERS:
---Contains information about all database users.
    SELECT username
         , account_status
      FROM all_users;

--6. DBA_TABLES:
---Provides information about all tables in the database (requires DBA privileges).
    SELECT table_name
         , num_rows
      FROM dba_tables
     WHERE owner = 'HR';

--7. DBA_TAB_COLUMNS:
---Contains information about columns of all tables in the database (requires DBA privileges).
    SELECT table_name
         , column_name
         , data_type
      FROM dba_tab_columns
     WHERE owner = 'HR';

--8. DBA_VIEWS:
    SELECT view_name
         , text
      FROM dba_views
     WHERE owner = 'HR';

--9. DBA_USERS:
---Contains information about all database users (requires DBA privileges).
    SELECT username
         , account_status
      FROM dba_users;
      
--*Capitolul 16* -> Working with CURRENT_DATE, CURRENT_TIMESTAMP and LOCALTIMESTAMP:

--1. CURRENT_DATE:
---The CURRENT_DATE function returns the current date in the session time zone.
    SELECT CURRENT_DATE AS current_date
      FROM dual;

--2. CURRENT_TIMESTAMP:
---The CURRENT_TIMESTAMP function returns the current date and time in the session time zone.
    SELECT CURRENT_TIMESTAMP AS current_datetime
      FROM dual;

--3. LOCALTIMESTAMP:
---The LOCALTIMESTAMP function also returns the current date and time, but it returns it in the session time zone.
    SELECT LOCALTIMESTAMP AS local_datetime
      FROM dual;

--4. Handling Different Time Zones:
---To work with data in different time zones, you can use the AT TIME ZONE clause to convert a timestamp to a different time zone.
    SELECT order_id, order_date
      FROM orders
     WHERE order_date > CURRENT_TIMESTAMP AT TIME ZONE 'UTC';

--5. Converting to a Specific Time Zone:
---You can explicitly convert a timestamp to a specific time zone using the FROM_TZ function.
    SELECT order_id, FROM_TZ(order_date, 'America/New_York') AS order_date_ny
      FROM orders;

--6. Working with Session Time Zone:
---You can change the session time zone using the ALTER SESSION statement.
    ALTER SESSION SET TIME_ZONE = 'UTC';
    SELECT CURRENT_TIMESTAMP AS current_datetime_utc
      FROM dual;

--7. Extracting Time Zone Information:
---You can extract time zone information using the EXTRACT function.
    SELECT order_id, EXTRACT(TIMEZONE_HOUR FROM order_date) AS timezone_offset
      FROM orders;
      
--*Capitolul 16* -> Working with INTERVAL data types:

--1. Creating INTERVALs:
---You can create intervals using the INTERVAL keyword.
    ---Creating an interval of 3 days
    SELECT SYSDATE + INTERVAL '3' DAY AS future_date
      FROM dual;

    ---Creating an interval of 2 hours and 30 minutes
    SELECT SYSTIMESTAMP + INTERVAL '2 30' MINUTE TO SECOND AS future_timestamp
      FROM dual;

--2. Adding and Subtracting INTERVALs:
---You can perform arithmetic operations with intervals.
    ---Adding 1 month to the current date
    SELECT SYSDATE + INTERVAL '1' MONTH AS future_date
      FROM dual;

   --- Subtracting 1 hour from the current timestamp
    SELECT SYSTIMESTAMP - INTERVAL '1' HOUR AS past_timestamp
      FROM dual;

--3. Extracting Components from INTERVALs:
---You can use the EXTRACT function to retrieve specific components from an interval.
   --- Extracting the number of days from an interval
    SELECT EXTRACT(DAY FROM INTERVAL '5' DAY) AS days_in_interval
      FROM dual;

   --- Extracting the number of hours from an interval
    SELECT EXTRACT(HOUR FROM INTERVAL '2 03:30:00' DAY TO SECOND) AS hours_in_interval
    FROM dual;

--4. Using INTERVAL with TIMESTAMP Data:
---You can add an interval to a timestamp to get a new timestamp.
   --- Adding 3 hours and 30 minutes to the current timestamp
    SELECT SYSTIMESTAMP + INTERVAL '3 30' MINUTE TO SECOND AS future_timestamp
      FROM dual;

--5. Using INTERVAL in WHERE Clause:
---You can use intervals in the WHERE clause to filter data based on time periods.
   -- Selecting orders placed in the last 7 days
    SELECT order_id, order_date
      FROM orders
     WHERE order_date > SYSDATE - INTERVAL '7' DAY;

--6. Formatting INTERVAL Data:
---You can use the TO_DSINTERVAL function to format an interval.
   -- Formatting an interval
    SELECT TO_DSINTERVAL('0 05:30:00') AS formatted_interval
      FROM dual;

--7. Extracting DAY TO SECOND Interval Components:
---When working with DAY TO SECOND intervals, you can extract individual components.
   -- Extracting days and hours from a DAY TO SECOND interval
    SELECT EXTRACT(DAY FROM INTERVAL '3 12:30:00' DAY TO SECOND) AS days_in_interval,
           EXTRACT(HOUR FROM INTERVAL '3 12:30:00' DAY TO SECOND) AS hours_in_interval
      FROM dual;
      
