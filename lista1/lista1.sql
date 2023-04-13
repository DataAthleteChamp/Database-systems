CREATE TABLE Wampiry(
pseudo_wampira varchar2(15)
constraint pseudo_wampira_wampiry_pk primary key,
wampir_w_rodzinie date 
constraint wampir_w_rodzinie_nn not null,
plec_wampira char(1)
constraint wampiry_plec_ch check (plec_wampira in ('K', 'M')) 
constraint wampiry_plec_nn not null,
pseudo_szefa varchar2(15) 
constraint pseudo_szefa_koW references Wampiry(pseudo_szefa)
);


CREATE TABLE Zlecenia(
nr_zlecenia number(6) 
constraint nr_zlecenia_ch check (nr_zlecenia > 0)
constraint nr_zlecenia_pk primary key,
data_zlecenia date 
constraint data_zlecenia_nn not null,
pseudo_wampira varchar2(15) 
constraint zlec_pseudo_wampira_koW references Wampiry(pseudo_wampira) not null
);


CREATE TABLE Dawcy(
pseudo_dawcy varchar2(15) 
constraint pseudo_dawcy_pk primary key,
rocznik_dawcy number(4)
constraint rocznik_dawcy_nn not null,
plec_dawcy char(1)
constraint plec_dawcy_ch check (plec_dawcy in ('K', 'M')) 
constraint plec_dawcy_nn not null,        
grupa_krwi varchar2(2) 
constraint dawcy_grupa_krwi_ch check (grupa_krwi in ('0','A','B','AB')) 
constraint dawcy_grupa_krwi_nn not null
);


CREATE TABLE Donacje(
nr_zlecenia number (6)
constraint don_nr_zlecenia_koZ references Zlecenia(nr_zlecenia),
pseudo_dawcy varchar2(15)
constraint pseudo_dawcy_koD references Dawcy(pseudo_dawcy),
data_oddania date 
constraint do_data_oddania_nn not null, 
ilosc_krwi number(3)
constraint ilosc_krwi_ch check (ilosc_krwi > 0),
pseudo_wampira varchar2(15) 
constraint don_pseudo_wampira_koW references Wampiry(pseudo_wampira),
data_wydania date
constraint don_data_wydania_nn not null
constraint don_data_wydania_ch check (data_wydania >= data_oddania),
constraint don_pk primary key(nr_zlecenia, pseudo_dawcy)
);


CREATE TABLE Sprawnosci(
sprawnosc varchar2(20) 
constraint sprawnosc_pk primary key
);


CREATE TABLE sprawnosc_w (
pseudo_wampira varchar2(15)
constraint sprw_pseudo_wampira_koW references Wampiry(pseudo_wampira),
sprawnosc varchar2(20)
constraint sprw_sprawnosc_koS references Sprawnosci(sprawnosc),
sprawnosc_od date
constraint sprw_sprawnosc_od_nn not null,
constraint sprw_pk primary key(sprawnosc, pseudo_wampira)
);


CREATE TABLE Jezyki_obce(
jezyk_obcy varchar2(20) 
constraint jezyk_obcy_pk primary key
);           


CREATE TABLE Jezyki_obce_w(
pseudo_wampira varchar2(15)
constraint jow_pseudo_wampira_koW references Wampiry(pseudo_wampira),
jezyk_obcy varchar2(20) 
constraint jow_jezyk_obcy_koJ references Jezyki_obce(jezyk_obcy),
jezyk_obcy_od date 
constraint jow_jezyki_obce_od_nn not null,
constraint jow_pk primary key(pseudo_wampira, jezyk_obcy)
);

alter session set nls_date_format = 'DD.MM.YYYY';

insert into Wampiry values('Drakula','12.12.1217','M',NULL);
insert into Wampiry values ('Opoj','07.11.1777','M','Drakula');
insert into Wampiry values ('Wicek','11.11.1721','M','Drakula');
insert into Wampiry values ('Baczek','13.04.1855','M','Opoj');
insert into Wampiry values ('Bolek','31.05.1945','M','Opoj');
insert into Wampiry values ('Gacek','21.02.1891','M','Wicek');
insert into Wampiry values ('Pijawka','03.11.1901','K','Wicek');
insert into Wampiry values ('Czerwony','13.09.1823','M','Wicek');
insert into Wampiry values ('Komar','23.07.1911','M','Wicek');
insert into Wampiry values ('Zyleta','23.09.1911','K','Opoj');
insert into Wampiry values ('Predka','29.03.1877','K','Drakula');
SELECT * FROM Wampiry;


insert into Zlecenia values (221,'04.07.2005','Opoj');
insert into Zlecenia values (221,'04.07.2005','Opoj');
insert into Zlecenia values (223,'17.07.2005','Bolek');
insert into Zlecenia values (223,'17.07.2005','Bolek');
insert into Zlecenia values (225,'01.08.2005','Pijawka');
insert into Zlecenia values (226,'07.08.2005','Gacek');
SELECT * FROM Zlecenia;


insert into Dawcy values ('Slodka',1966,'K','AB');
insert into Dawcy values ('Slodka',1966,'K','AB');
insert into Dawcy values ('Gorzka',1958,'K','0');
insert into Dawcy values ('Gorzka',1958,'K','0');
insert into Dawcy values ('Wytrawny',1971,'M','A');
insert into Dawcy values ('Okocim',1966,'M','B');
insert into Dawcy values ('Adonis',1977,'M','AB');
insert into Dawcy values ('Zywiec',1969,'M','A');
insert into Dawcy values ('Eliksir',1977,'M','0');
insert into Dawcy values ('Eliksir',1977,'M','0');
insert into Dawcy values ('Zoska',1963,'K','0');
insert into Dawcy values ('Czerwonka',1953,'M','A');
SELECT * FROM Dawcy;


insert into Donacje values (221,'Slodka','04.07.2005',455,'Drakula','06.08.2005');
insert into Donacje values (221,'Miodzio','04.07.2005',680,'Gacek','15.08.2005');
insert into Donacje values (221,'Gorzka','05.07.2005',471,'Pijawka','11.08.2005');
insert into Donacje values (221,'Lolita','05.07.2005',340,'Czerwony','21.08.2005');
insert into Donacje values (222,'Wytrawny','07.07.2005',703,'Drakula','17.07.2005');
insert into Donacje values (222,'Okocim','07.07.2005',530,'Komar','01.09.2005');
insert into Donacje values (222,'Adonis','08.07.2005',221,'Zyleta','11.09.2005');
insert into Donacje values (223,'Zywiec','17.07.2005',587,'Wicek','18.09.2005');
insert into Donacje values (224,'Gorzka','22.07.2005',421,'Drakula','23.08.2005');
insert into Donacje values (224,'Eliksir','25.07.2005',377,'Predka','26.07.2005');
insert into Donacje values (225,'Zenek','04.08.2005',600,'Opoj','15.08.2005');
insert into Donacje values (225,'Zenek','04.08.2005',600,'Opoj','15.08.2005');
insert into Donacje values (226,'Czerwonka','10.08.2005',517,'Pijawka','30.09.2005');
insert into Donacje values (226,'Miodzio','11.08.2005',644,NULL,NULL);
SELECT * FROM Donacje;


insert into Sprawnosci values('podryw');
insert into Sprawnosci values ('gorzala');
insert into Sprawnosci values ('kasa');
insert into Sprawnosci values('przymus');
insert into Sprawnosci values ('niesmiertelnosc');
SELECT * FROM Sprawnosci;

 
insert into Sprawnosc_w values ('Drakula','podryw','12.12.1217');
insert into Sprawnosc_w values ('Drakula','gorzala','12.12.1217');
insert into Sprawnosc_w values ('Wicek','kasa','11.11.1721');
insert into Sprawnosc_w values ('Wicek','przymus','07.01.1771');
insert into Sprawnosc_w values ('Opoj','podryw','07.11.1777'),
insert into Sprawnosc_w values ('Czerwony','niesmiertelnosc','13.09.1823');
insert into Sprawnosc_w values ('Drakula','kasa','13.09.1823');
insert into Sprawnosc_w values ('Opoj','gorzala','11.12.1844');
insert into Sprawnosc_w values ('Baczek','gorzala','13.04.1855');
insert into Sprawnosc_w values ('Drakula','przymus','14.06.1857');
insert into Sprawnosc_w values ('Drakula','niesmiertelnosc','21.08.1858');
insert into Sprawnosc_w values ('Opoj','przymus','15.07.1861');
insert into Sprawnosc_w values ('Wicek','gorzala','19.01.1866');
insert into Sprawnosc_w values ('Predka','podryw','29.03.1877');
insert into Sprawnosc_w values ('Czerwony','kasa','03.02.1891');
insert into Sprawnosc_w values ('Gacek','kasa','21.02.1891');
insert into Sprawnosc_w values ('Pijawka','podryw','03.11.1901');
insert into Sprawnosc_w values ('Komar','gorzala','23.07.1911');
insert into Sprawnosc_w values ('Zyleta','przymus','23.09.1911');
insert into Sprawnosc_w values ('Bolek','gorzala','31.05.1945');
SELECT * FROM Sprawnosc_w;


insert into Jezyki_obce values('niemiecki');
insert into Jezyki_obce values('wegierski');
insert into Jezyki_obce values('bulgarski');
insert into Jezyki_obce values('rosyjski');
insert into Jezyki_obce values('portugalski');
insert into Jezyki_obce values('francuski');
insert into Jezyki_obce values('angielski');
insert into Jezyki_obce values('polski');
insert into Jezyki_obce values('hiszpanski');
insert into Jezyki_obce values('czeski');
insert into Jezyki_obce values('wloski');
insert into Jezyki_obce values('szwedzki');
SELECT * FROM Jezyki_obce;


insert into Jezyki_obce_w values('Drakula','niemiecki','12.12.1217');
insert into Jezyki_obce_w values('Drakula','wegierski','12.12.1217');
insert into Jezyki_obce_w values('Drakula','bulgarski','03.04.1455');
insert into Jezyki_obce_w values('Wicek','rosyjski','11.11.1721');
insert into Jezyki_obce_w values('Opoj','portugalski','07.11.1777');
insert into Jezyki_obce_w values('Czerwony','francuski','13.09.1823');
insert into Jezyki_obce_w values('Drakula','angielski','13.09.1823');
insert into Jezyki_obce_w values('Wicek','polski','18.08.1835');
insert into Jezyki_obce_w values('Opoj','hiszpanski','12.03.1851');
insert into Jezyki_obce_w values('Baczek','czeski','13.04.1855');
insert into Jezyki_obce_w values('Wicek','niemiecki','11.06.1869');
insert into Jezyki_obce_w values('Wicek','wloski','14.03.1873');
insert into Jezyki_obce_w values('Predka','czeski','29.03.1877');
insert into Jezyki_obce_w values('Czerwony','rosyjski','23.11.1888');
insert into Jezyki_obce_w values('Gacek','polski','21.02.1891');
insert into Jezyki_obce_w values('Predka','niemiecki','07.06.1894');
insert into Jezyki_obce_w values('Baczek','angielski','04.12.1899');
insert into Jezyki_obce_w values('Pijawka','angielski','03.11.1901');
insert into Jezyki_obce_w values('Komar','szwedzki','23.07.1911');
insert into Jezyki_obce_w values('Zyleta','angielski','23.09.1911');
insert into Jezyki_obce_w values('Bolek','francuski','31.05.1945');
SELECT * FROM Jezyki_obce_w;

