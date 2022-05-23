CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS"chkpass";

create table osoba(
  id_osoba uuid DEFAULT uuid_generate_v4() UNIQUE,
  imie varchar(30),
  nazwisko varchar(30),
  haslo chkpass NOT NULL,
  numer_telefonu numeric(9) NOT NULL UNIQUE,
  email varchar(40) NOT NULL UNIQUE,
  adres_zamieszkania varchar(40),
 pesel numeric(11) NOT NULL UNIQUE
);
INSERT INTO osoba(imie, nazwisko, haslo, numer_telefonu, email, adres_zamieszkania, pesel)
	VALUES('Anna', 'Warowny', crypt('annas_password', gen_salt('bf')), 111111111, 
	'anna.warowny@gmail.com', 'ul. Jana Matejki 23/22 Krakow', 13413413411); 
INSERT INTO osoba(imie, nazwisko, haslo, numer_telefonu, email, adres_zamieszkania, pesel)
        VALUES('Maja', 'Kwiatel', crypt('majas_passwd', gen_salt('bf')), 222222222, 
	'maja.kwiatek@fmail.com', 'ul. Mocy 2/3 Wieliczka', 44344344333);
INSERT INTO osoba(imie, nazwisko, haslo, numer_telefonu, email, adres_zamieszkania, pesel)
	VALUES('Patryk', 'Bar', crypt('patryks_passwd', gen_salt('bf')), 333333333,
	'patryk.bar@gmail.com', 'ul. Pokoju 33/3 Krakow', 56556556555);
INSERT INTO osoba(imie, nazwisko, haslo, numer_telefonu, email, adres_zamieszkania, pesel)
        VALUES('Bartosz', 'Sarat', crypt('bartoszs_passwd', gen_salt('bf')), 300033333,
        'bartosz.sarat@gmail.com', 'ul. Powstania 36/8 Krakow', 56556556599);
INSERT INTO osoba(imie, nazwisko, haslo, numer_telefonu, email, adres_zamieszkania, pesel)
        VALUES('Krystyna', 'Miasek', crypt('krystyna_passwd', gen_salt('bf')), 338933373,
        'krystyna.miasek@gmail.com', 'ul. Sloneczna 302 Krakow', 56558888855);
INSERT INTO osoba(imie, nazwisko, haslo, numer_telefonu, email, adres_zamieszkania, pesel)
        VALUES('Malgorzata', 'Zielonko', crypt('patryks_passwd', gen_salt('bf')), 126677133,
        'malgorzata.zielonko@gmail.com', 'ul. Kopalniana 12/1 Krakow', 56557825345);
create table lekarze_specjalizacje(
  id_lekarza uuid references osoba(id_osoba),
  specjalizacja varchar(20)
);


create table lekarze_dyzur(
  id_lekarza uuid references osoba(id_osoba),
  data_od timestamp,
  data_do timestamp
);
create table urlop(
  id_lekarza uuid references osoba(id_osoba),
  data_od timestamp,
  data_do timestamp
);
create table osoby_uprawnienia(
  id_osoby uuid references osoba(id_osoba),
  id_lekarza uuid references osoba(id_osoba)
);
create table uprawnienia(
  id_uprawnienia serial primary key,
  nazwa varchar(30),
  opis varchar(255)
);

----
CREATE TABLE wizyty(
	id_wizyty serial;
        id_pacjenta uuid REFERENCES osoba(id_osoba),
        id_lekarza uuid REFERENCES osoba(id_osoba),
        data_od timestamp,
        data_do timestamp CHECK(data_od < data_do),
        diagnoza varchar(1000)
);
CREATE TABLE dokumentacja(
        id_pacjenta uuid REFERENCES osoba(id_osoba),
        id_pliku serial
);
CREATE TABLE recepty(
        id_recepty serial PRIMARY KEY,
	id_wizyty serial,
        id_pacjenta uuid REFERENCES osoba(id_osoba), 
        id_lekarza_wystawiajacego uuid REFERENCES osoba(id_osoba),
        data_wystawienia timestamp,
        termin_waznosci timestamp CHECK(data_wystawienia < termin_waznosci),
        zalecenia varchar(1000)
);
CREATE TABLE lekarstwa(
        id_lekarstwa serial PRIMARY KEY,
        nazwa varchar(30),
        cena numeric(4,2)
);
CREATE TABLE recepty_lekarstwa(
        id_recepty serial REFERENCES recepty(id_recepty),
        id_lekarstwa serial REFERENCES lekarstwa(id_lekarstwa),
        ilosc numeric (2)
);
CREATE TABLE skierowania(
        id_skierowania serial PRIMARY KEY,
        nazwa varchar(30)
);
CREATE TABLE skierowania_pacjenci(
        id_skierowania serial REFERENCES skierowania(id_skierowania),
        id_pacjenta uuid REFERENCES osoba(id_osoba),
        id_lekarza_wystawiajacego uuid REFERENCES osoba(id_osoba),
	id_wizyty serial,
        data_wystawienia timestamp,
        termin_waznosci timestamp CHECK(termin_waznosci > data_wystawienia)
);
