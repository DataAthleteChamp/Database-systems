--lista 3

--1
SELECT distinct DO.nr_zlecenia "Zlecenie AB"
FROM DONACJE DO, DAWCY DA
WHERE DO.pseudo_dawcy=DA.pseudo_dawcy AND grupa_krwi like 'AB';


--2 
SELECT w1.pseudo_wampira  "Pseudo wampira", w1.plec_wampira "Plec", w1.pseudo_szefa "Pseudo szefa", w2.plec_wampira "Plec szefa" 
FROM Wampiry w1 LEFT JOIN Wampiry w2
ON w1.pseudo_szefa = w2.pseudo_wampira;
                

--3
SELECT D1.pseudo_dawcy "Dawca przed Slodka" , D1.plec_dawcy "Plec"
FROM Dawcy D1, Dawcy D2
WHERE D2.pseudo_dawcy='Slodka' AND
      D1.rocznik_dawcy<D2.rocznik_dawcy;

--4
SELECT  pseudo_dawcy "Pseudonim", 'Ponizej 700' "Pobor"
FROM Donacje
GROUP BY pseudo_dawcy
HAVING SUM(ilosc_krwi)<700
UNION ALL --zlaczenie tabel pionowe bez powtórzeń
SELECT  pseudo_dawcy "Pseudonim", 'Miedzy 700 a 1000'
FROM Donacje
GROUP BY pseudo_dawcy
HAVING SUM(ilosc_krwi) BETWEEN 700 AND 1000
UNION ALL
SELECT  pseudo_dawcy "Pseudonim", 'Powyzej 1000'
FROM Donacje
GROUP BY pseudo_dawcy
HAVING SUM(ilosc_krwi)>1000;

--5
SELECT Jezyki_obce_w.pseudo_wampira, count(distinct(Sprawnosci_w.sprawnosc))
from Sprawnosci_w
join Jezyki_obce_w on Sprawnosci_w.pseudo_wampira = Jezyki_obce_w.pseudo_wampira
group by Jezyki_obce_w.pseudo_wampira
having count(distinct(Jezyki_obce_w.jezyk_obcy)) = count(distinct(Sprawnosci_w.sprawnosc));

--6
select zlecenia.nr_zlecenia, to_char(Zlecenia.data_zlecenia,'DD.MM.YYYY')
from zlecenia
where nr_zlecenia in
     (select nr_zlecenia from Donacje where pseudo_dawcy in
                                            (select pseudo_dawcy from Dawcy where grupa_krwi like 'AB'));
--7
SELECT plec_wampira "Plec", count(pseudo_wampira)
From Wampiry
WHERE pseudo_wampira in (Select pseudo_wampira
                         From Jezyki_obce_w
                         Group by pseudo_wampira having count(jezyk_obcy)>1)
GROUP BY plec_wampira;

--8
--a)
SELECT ilosc_krwi "Objetosc", pseudo_dawcy "Dawca"
FROM Donacje D
WHERE 3>(SELECT COUNT(DISTINCT D2.ilosc_krwi)
           FROM Donacje D2
           WHERE D.ilosc_krwi<D2.ilosc_krwi)
ORDER BY ilosc_krwi DESC;

--b)
SELECT D1.ilosc_krwi "Objetosc", D1.pseudo_dawcy "Dawca"
FROM Donacje D1 JOIN Donacje D2 ON D1.ilosc_krwi<=D2.ilosc_krwi--zlaczenie theta
GROUP BY D1.pseudo_dawcy, D1.ilosc_krwi, D1.nr_zlecenia
HAVING COUNT(distinct D2.ilosc_krwi)<4
ORDER BY D1.ilosc_krwi DESC;

--9
--a)
SELECT pseudo_dawcy, grupa_krwi
From Dawcy
Where pseudo_dawcy in (SELECT distinct pseudo_dawcy
                       FROM Donacje
                       WHERE nr_zlecenia in (select nr_zlecenia
                                             from Zlecenia
                                             where pseudo_wampira in (Select pseudo_wampira
                                                                       from Jezyki_obce_w
                                                                       WHERE jezyk_obcy = 'polski')));

--b)
SELECT Da.pseudo_dawcy, Da.grupa_krwi, Z.pseudo_wampira
From Jezyki_obce_w J, Zlecenia Z, Donacje Do, Dawcy Da
WHERE J.jezyk_obcy = 'polski' and J.pseudo_wampira = Z.pseudo_wampira and Z.nr_zlecenia = Do.nr_zlecenia and Da.pseudo_dawcy = Do.pseudo_dawcy;

--10
SELECT pseudo_wampira, extract(year from wampir_w_rodzinie)
From Wampiry
where to_char(wampir_w_rodzinie,'YYYY') in (select to_char(wampir_w_rodzinie,'YYYY')
                                           from Wampiry
                                           group by to_char(wampir_w_rodzinie,'YYYY')
                                           having count(*)>1);

--11
SELECT 'Srednia' "ROK",
       AVG(COUNT(pseudo_wampira))  "LICZBA WSTAPIEN"
FROM Wampiry
GROUP BY TO_CHAR(wampir_w_rodzinie,'YYYY')
union all --zlaczenie pionowe z powtorzeniami
select to_char(wampir_w_rodzinie,'YYYY') rok,
count(wampir_w_rodzinie) "Liczba wystapien"
from Wampiry
group by to_char(wampir_w_rodzinie,'YYYY')
having count(wampir_w_rodzinie) <=
(SELECT floor(avg(count(*))) from Wampiry group by to_char(wampir_w_rodzinie,'YYYY'))
or count(wampir_w_rodzinie) >=
(SELECT ceil(avg(count(*))) from Wampiry group by to_char(wampir_w_rodzinie,'YYYY'))
order by 2; --PRZY UNION KOLEJNOŚC OKREŚLONA LICZBA

--12
--a.
SELECT pseudo_dawcy "Dawczyni",
       grupa_krwi "Grupa krwi",
      (SELECT SUM(ilosc_krwi)
        FROM Donacje
        WHERE D.pseudo_dawcy = Donacje.pseudo_dawcy
        GROUP BY pseudo_dawcy) "W sumie oddala",
       (SELECT ROUND(AVG(SUM(ilosc_krwi)),0)
        FROM Dawcy NATURAL JOIN Donacje
        WHERE Dawcy.grupa_krwi=D.grupa_krwi AND plec_dawcy='K'
        GROUP BY pseudo_dawcy) "Srednia suma w jej grupie"
FROM Dawcy D
WHERE plec_dawcy='K';

--b
SELECT *
FROM (SELECT D1.pseudo_dawcy , grupa_krwi ,SUM(D2.ilosc_krwi) "W sumie oddala"
      FROM Dawcy D1 JOIN Donacje D2 ON D1.pseudo_dawcy = D2.pseudo_dawcy
      WHERE plec_dawcy = 'K'
      GROUP BY D1.pseudo_dawcy, grupa_krwi)
       JOIN
     (SELECT ROUND(AVG("Suma indywidualna"), 0) "Srednia suma w jej grupie", grupa_krwi
      FROM (SELECT SUM(D6.ilosc_krwi) "Suma indywidualna", D5.pseudo_dawcy, grupa_krwi
            FROM Dawcy D5 JOIN Donacje D6 ON D5.pseudo_dawcy = D6.pseudo_dawcy
            WHERE plec_dawcy = 'K'
            GROUP BY D5.pseudo_dawcy, grupa_krwi)
      GROUP BY grupa_krwi)
  USING(grupa_krwi);

--13
SELECT W.pseudo_wampira "Wampir", D.pseudo_dawcy "Zrodlo", (select sum(ilosc_krwi) from Donacje where pseudo_wampira = W.pseudo_wampira and pseudo_dawcy = D.pseudo_dawcy)"Wypil ml"
from Wampiry W join Donacje D on W.pseudo_wampira = D.pseudo_wampira
where NOT EXISTS (SELECT *
                   FROM Zlecenia
                   WHERE W.pseudo_wampira=pseudo_wampira)
and D.pseudo_dawcy in 
(select Donacje.pseudo_dawcy from Donacje join Dawcy on Donacje.pseudo_dawcy = Dawcy.pseudo_dawcy where Dawcy.plec_dawcy = 'K' group by Donacje.pseudo_dawcy having sum(Donacje.ilosc_krwi)>800)
and W.plec_wampira = 'M';

--14
SELECT pseudo_dawcy, rocznik_dawcy
from Dawcy
where grupa_krwi = '0';

update Dawcy set rocznik_dawcy = rocznik_dawcy + 5;

--ROLLABACK cofniecie transakcje jesli nie było comita

--cofnicie
--update Dawcy set rocznik_dawcy = rocznik_dawcy -5;

--15 
SELECT WA.pseudo_wampira pseudo_wmapira, WA.pseudo_szefa pseudo_szefa, WU.pseudo_szefa pseudo_szefa_szefa
from Wampiry WA, Wampiry WU
where WU.pseudo_wampira = WA.pseudo_szefa and WA.plec_wampira = 'M'
union select 'Drakula', null, null from Dual;

--16
SELECT W.plec_wampira, 
       SUM(DECODE(W.pseudo_szefa, 'Drakula', D.ilosc_krwi, 0)) "Pod Drakula",
       SUM(DECODE(W.pseudo_szefa, 'Opoj', D.ilosc_krwi, 0)) "Pod Opojem",
       SUM(DECODE(W.pseudo_szefa, 'Wicek', D.ilosc_krwi, 0)) "Pod Wickiem"
FROM Wampiry W NATURAL JOIN Donacje D --ta sama kolumna z onu tabel i dostawia reszte
GROUP BY plec_wampira;