
--1
SELECT pseudo_dawcy "Dawca A", rocznik_dawcy "Rocznik" 
FROM Dawcy 
WHERE grupa_krwi='A';
--2
SELECT DISTINCT pseudo_dawcy "Dawca" 
FROM Donacje 
WHERE data_oddania 
BETWEEN '20.07.2005' AND '20.08.2005';
--3
SELECT pseudo_dawcy "Dawca", plec_dawcy "Plec" 
FROM Dawcy 
WHERE rocznik_dawcy 
IN ('1977','1971');
--4
SELECT DISTINCT pseudo_dawcy "Dawca" 
FROM Donacje 
WHERE MONTHS_BETWEEN('17.05.2006', data_wydania) >= 10;
--5
SELECT pseudo_dawcy "Dawca", ilosc_krwi "Donacja", NVL(TO_CHAR(data_wydania),'Na stanie')"Wydano" 
FROM Donacje 
WHERE data_oddania > '10.07.2005';
--6
SELECT COUNT(DISTINCT sprawnosc)"Liczba sprawnosci" 
FROM Sprawnosci_w 
WHERE pseudo_wampira 
IN ('Opoj','Czerwony');--ditinct eliminuje mi podwójne sprawności count zlicza krotki
--7
SELECT 
SUM(ilosc_krwi) "Cieple buleczki" 
FROM Donacje 
WHERE data_wydania - data_oddania <= 10; --sum sumuje wartości
--8
SELECT pseudo_wampira "Wampir", 
COUNT(jezyk_obcy_od)"liczba jezykow" 
FROM Jezyki_obce_w 
WHERE jezyk_obcy != 'rosyjski' GROUP BY pseudo_wampira; 
#czy można dowolny atrybut do counta? - TAK, bo dla każdego języka jest 1 rekord (unikalny)
--9
SELECT pseudo_wampira "Wampir", 
COUNT(data_oddania)"Liczba konsumpcji" 
FROM Donacje WHERE pseudo_wampira 
IS NOT NULL HAVING COUNT(data_oddania) > 1 
GROUP BY pseudo_wampira;
--10
SELECT grupa_krwi "Grupa", plec_dawcy "Plec", 
COUNT(pseudo_dawcy)"Liczba dawcow" 
FROM Dawcy 
GROUP BY plec_dawcy,grupa_krwi 
ORDER BY grupa_krwi ASC; 
#czy można zmienić kolejność grupowania - TAK, bo w gruopowaniu kolejność nie ma znaczenia


