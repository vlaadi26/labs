-- Pregunta 01: Usando la tabla o pestaña de clientes, por favor escribe una consulta SQL que muestre Título, Nombre y Apellido y Fecha de Nacimiento para cada uno de los clientes. No necesitarás hacer nada en Excel para esta.
SELECT TITLE, FIRSTNAME,LASTNAME, DATEOFBIRTH FROM CUSTOMER;
-- Pregunta 02: Usando la tabla o pestaña de clientes, por favor escribe una consulta SQL que muestre el número de clientes en cada grupo de clientes (Bronce, Plata y Oro). Puedo ver visualmente que hay 4 Bronce, 3 Plata y 3 Oro pero si hubiera un millón de clientes ¿cómo lo haría en Excel? Tabla dinamica
SELECT CUSTOMERGROUP, COUNT(custid) 
FROM CUSTOMER
GROUP BY CUSTOMERGROUP;
-- Pregunta 03: El gerente de CRM me ha pedido que proporcione una lista completa de todos los datos para esos clientes en la tabla de clientes pero necesito añadir el código de moneda de cada jugador para que pueda enviar la oferta correcta en la moneda correcta. Nota que el código de moneda no existe en la tabla de clientes sino en la tabla de cuentas. Por favor, escribe el SQL que facilitaría esto. ¿Cómo lo haría en Excel si tuviera un conjunto de datos mucho más grande?
SELECT c.*, a.currencycode
FROM CUSTOMER c
LEFT JOIN ACCOUNT a
ON a.CUSTID = c.CUSTID;
-- Pregunta 04: Ahora necesito proporcionar a un gerente de producto un informe resumen que muestre, por producto y por día, cuánto dinero se ha apostado en un producto particular. TEN EN CUENTA que las transacciones están almacenadas en la tabla de apuestas y hay un código de producto en esa tabla que se requiere buscar (classid & categoryid) para determinar a qué familia de productos pertenece esto. Por favor, escribe el SQL que proporcionaría el informe. Si imaginas que esto fue un conjunto de datos mucho más grande en Excel, ¿cómo proporcionarías este informe en Excel?
SELECT PRODUCT, BETDATE, ROUND(SUM(BET_AMT),2)
FROM BETTING b
GROUP BY PRODUCT, BETDATE
ORDER BY BETDATE DESC ;
-- Pregunta 05: Acabas de proporcionar el informe de la pregunta 4 al gerente de producto, ahora él me ha enviado un correo electrónico y quiere que se cambie. ¿Puedes por favor modificar el informe resumen para que solo resuma las transacciones que ocurrieron el 1 de noviembre o después y solo quiere ver transacciones de Sportsbook. Nuevamente, por favor escribe el SQL abajo que hará esto. Si yo estuviera entregando esto vía Excel, ¿cómo lo haría?
SELECT 
    PRODUCT,  
    TO_DATE(BETDATE, 'DD/MM/YYYY') AS fecha_convertida, 
    ROUND(SUM(BET_AMT), 2) AS total_apuestas
FROM BETTING b
WHERE PRODUCT = 'Sportsbook' AND TO_DATE(BETDATE, 'DD/MM/YYYY') >= '2012-11-01'
GROUP BY PRODUCT, BETDATE
ORDER BY FECHA_CONVERTIDA DESC;
-- Pregunta 06: Como suele suceder, el gerente de producto ha mostrado su nuevo informe a su director y ahora él también quiere una versión diferente de este informe. Esta vez, quiere todos los productos pero divididos por el código de moneda y el grupo de clientes del cliente, en lugar de por día y producto. También le gustaría solo transacciones que ocurrieron después del 1 de diciembre. Por favor, escribe el código SQL que hará esto.
SELECT 
    b.PRODUCT,  
    a.currencycode,
    c.customergroup,
    ROUND(SUM(b.BET_AMT), 2) AS total_apuestas
FROM BETTING b
LEFT JOIN ACCOUNT a
ON a.accountno= b.accountno
LEFT JOIN CUSTOMER c
ON c.custid = a.custid
WHERE TO_DATE(BETDATE, 'DD/MM/YYYY') >= '2012-12-01'
GROUP BY b.product,a.currencycode,c.customergroup;
--ORDER BY FECHA_CONVERTIDA DESC;
-- Pregunta 07:  En nuestro ejemplo, es posible que no todos los jugadores hayan estado activos. Por favor, escribe una consulta SQL que muestre a todos los jugadores Título, Nombre y Apellido y un resumen de su cantidad de apuesta para el período completo de noviembre.
SELECT c.TITLE, c.FIRSTNAME,c.LASTNAME, CONCAT(a.currencycode, ' ', ROUND(SUM(b.BET_AMT), 2)) AS total_apuestas
FROM CUSTOMER c
LEFT JOIN ACCOUNT a
ON c.custid = a.custid
LEFT JOIN BETTING b
ON a.accountno= b.accountno
WHERE TO_DATE(b.BETDATE, 'DD/MM/YYYY') BETWEEN '2012-11-01' AND '2012-11-31'
GROUP BY c.TITLE, c.FIRSTNAME,c.LASTNAME, a.currencycode;
-- Pregunta 08: Nuestros equipos de marketing y CRM quieren medir el número de jugadores que juegan más de un producto. ¿Puedes por favor escribir 2 consultas, una que muestre el número de productos por jugador y otra que muestre jugadores que juegan tanto en Sportsbook como en Vegas?
SELECT c.FIRSTNAME, c.LASTNAME, count(p.product) 
FROM CUSTOMER c
LEFT JOIN ACCOUNT a
ON c.custid= a.custid
LEFT JOIN BETTING b
ON a.accountno = b.accountno
LEFT JOIN PRODUCT p
ON p.product = b.product
GROUP BY c.firstname, c.lastname;
SELECT c.FIRSTNAME, c.LASTNAME, count(p.product) 
FROM CUSTOMER c
LEFT JOIN ACCOUNT a
ON c.custid= a.custid
LEFT JOIN BETTING b
ON a.accountno = b.accountno
LEFT JOIN PRODUCT p
ON p.product = b.product
WHERE p.product IN ('Sportsbook','Vegas')
GROUP BY c.firstname, c.lastname;
-- Pregunta 09: Ahora nuestro equipo de CRM quiere ver a los jugadores que solo juegan un producto, por favor escribe código SQL que muestre a los jugadores que solo juegan en sportsbook, usa bet_amt > 0 como la clave. Muestra cada jugador y la suma de sus apuestas para ambos productos.
SELECT a.accountno,count(b.product), sum(b.bet_amt) 
FROM account a
-- LEFT JOIN ACCOUNT a
--ON c.custid= a.custid
LEFT JOIN BETTING b
ON a.accountno = b.accountno
WHERE b.product ='Sportsbook'
GROUP BY a.accountno
HAVING count(b.product)=1;
SELECT ACCOUNTNO, 
    SUM(IFF(PRODUCT = 'Sportsbook', BET_AMT, 0)) AS total_sportsbook_bet
FROM 
    BETTING
WHERE 
    BET_AMT > 0
GROUP BY 
    ACCOUNTNO
HAVING 
    COUNT(DISTINCT PRODUCT) = 1
    AND MAX(PRODUCT) = 'Sportsbook';
-- Pregunta 10: La última pregunta requiere que calculemos y determinemos el producto favorito de un jugador. Esto se puede determinar por la mayor cantidad de dinero apostado. Por favor, escribe una consulta que muestre el producto favorito de cada jugador
WITH Bestproduct AS (
    SELECT accountno, product, SUM(bet_amt) AS total_bet_amt,
           ROW_NUMBER() OVER (PARTITION BY accountno ORDER BY SUM(bet_amt) DESC) AS rank
    FROM betting
    GROUP BY accountno, product
)
SELECT accountno, product, total_bet_amt
FROM Bestproduct
WHERE rank = 1;
-- Mirando los datos abstractos en la pestaña "Student_School" en la hoja de cálculo de Excel, por favor responde las siguientes preguntas:
-- Pregunta 11: Escribe una consulta que devuelva a los 5 mejores estudiantes basándose en el GPA
SELECT student_id, GPA
FROM student
ORDER BY GPA DESC
LIMIT 5;
-- Pregunta 12: Escribe una consulta que devuelva el número de estudiantes en cada escuela. (¡una escuela debería estar en la salida incluso si no tiene estudiantes!)
SELECT c.school_name, count(t.student_id),
FROM school c
LEFT JOIN student t
ON c.school_id = t.school_id
GROUP BY c.school_name;
-- Pregunta 13: Escribe una consulta que devuelva los nombres de los 3 estudiantes con el GPA más alto de cada universidad.
WITH RankedStudents AS (
    SELECT student_id, GPA, school_id,
           ROW_NUMBER() OVER (PARTITION BY school_id ORDER BY GPA DESC) AS rank
    FROM student)
SELECT student_id, GPA, school_id
FROM RankedStudents
WHERE rank <= 3;