CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

----
--table

create table osoba(
  id_osoba uuid DEFAULT uuid_generate_v4() UNIQUE,
  imie varchar(30) NOT NULL,
  nazwisko varchar(30) NOT NULL,
  haslo text NOT NULL,
  numer_telefonu numeric(9) NOT NULL UNIQUE,
  email varchar(40) NOT NULL UNIQUE,
  adres_zamieszkania varchar(40),
  pesel char(11) NOT NULL UNIQUE
);

create table uprawnienia(
  id_uprawnienia serial primary key,
  nazwa varchar(30),
  opis varchar(255)
);

insert into uprawnienia values(1,'Pacjent','');
insert into uprawnienia values(2,'Lekarz','');
insert into uprawnienia values(3,'Recepcionista','');

create table osoby_uprawnienia(
  id_osoby uuid references osoba(id_osoba),
  id_uprawnienia int references uprawnienia(id_uprawnienia),
  UNIQUE (id_osoby,id_uprawnienia)
);

----
create table specjalizacje(
  id_specjalizacja serial primary key,
  nazwa varchar(30),
  opis varchar(255)
);

insert into specjalizacje values(1,'Alergologia','');
insert into specjalizacje values(2,'Chirurgia','');
insert into specjalizacje values(3,'Ginekologia','');
insert into specjalizacje values(4,'Kardiologia','');
insert into specjalizacje values(5,'Neurologia','');
insert into specjalizacje values(6,'Okulistyka','');
insert into specjalizacje values(7,'Onkologia','');
insert into specjalizacje values(8,'Ortopedia','');
insert into specjalizacje values(9,'Pediatria','');
insert into specjalizacje values(10,'Położnictwo i ginekologia','');
insert into specjalizacje values(11,'Psychiatria','');
insert into specjalizacje values(12,'Reumatologia','');
insert into specjalizacje values(13,'Seksuologia','');
insert into specjalizacje values(14,'Toksykologia','');
insert into specjalizacje values(15,'Transplantologia','');
insert into specjalizacje values(16,'Urologia','');

create table lekarze_specjalizacje(
  id_lekarza uuid references osoba(id_osoba),
  id_specjalizacja int references specjalizacje(id_specjalizacja)
);
----

create table lekarze_dyzur(
  id_lekarza uuid references osoba(id_osoba),
  data_od timestamp not null,
  data_do timestamp CHECK(data_od < data_do) not null
);

create table urlop(
  id_lekarza uuid references osoba(id_osoba),
  data_od timestamp not null,
  data_do timestamp CHECK(data_od < data_do) not null
);

CREATE TABLE wizyty(
	id_wizyty serial PRIMARY KEY,
    id_pacjenta uuid REFERENCES osoba(id_osoba),
    id_lekarza uuid REFERENCES osoba(id_osoba),
    data_od timestamp not null,
    data_do timestamp CHECK(data_od < data_do) not null,
    diagnoza varchar(1000)
);

CREATE TABLE dokumentacja(
    id_pacjenta uuid REFERENCES osoba(id_osoba),
    plik text not null
);

CREATE TABLE recepty(
    id_recepty serial PRIMARY KEY,
	id_wizyty int REFERENCES wizyty(id_wizyty),
    id_pacjenta uuid REFERENCES osoba(id_osoba), 
    id_lekarza uuid REFERENCES osoba(id_osoba),
    data_wystawienia timestamp DEFAULT now() not null,
    termin_waznosci timestamp CHECK(data_wystawienia < termin_waznosci and data_wystawienia < now()),
    zalecenia varchar(1000)
);

CREATE TABLE lekarstwa(
    id_lekarstwa serial PRIMARY KEY,
    nazwa varchar(30) UNIQUE,
    cena numeric(6,2)
);

insert into lekarstwa (nazwa,cena) values('lekarstwo1',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo2',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo3',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo4',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo5',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo6',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo7',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo8',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo9',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));
insert into lekarstwa (nazwa,cena) values('lekarstwo10',round(random()::numeric*random()::numeric*random()::numeric*500+10,1));

CREATE TABLE recepty_lekarstwa(
    id_recepty serial REFERENCES recepty(id_recepty),
    id_lekarstwa serial REFERENCES lekarstwa(id_lekarstwa),
    ilosc numeric(2)
);

CREATE TABLE skierowania(
    id_skierowania serial PRIMARY KEY,
	id_specjalizacja int references specjalizacje(id_specjalizacja),
    opis varchar(100),
	wykorzystane boolean default false not null
);

CREATE TABLE skierowania_pacjenci(
    id_skierowania serial REFERENCES skierowania(id_skierowania),
    id_pacjenta uuid REFERENCES osoba(id_osoba),
    id_lekarza uuid REFERENCES osoba(id_osoba),
	id_wizyty int,
    data_wystawienia timestamp not null,
    termin_waznosci timestamp CHECK(termin_waznosci > data_wystawienia)
);

----
--view

CREATE OR REPLACE view pacjenci as
select a.* from osoba a,osoby_uprawnienia b,uprawnienia c 
where a.id_osoba = b.id_osoby and b.id_uprawnienia = c.id_uprawnienia and c.nazwa = 'Pacjent';

CREATE OR REPLACE view lekarze as
select id_osoba,imie,nazwisko,haslo,numer_telefonu,email,adres_zamieszkania,pesel,g.nazwa as specjalizacja 
from ((select a.* from osoba a,osoby_uprawnienia b,uprawnienia c
where a.id_osoba = b.id_osoby and b.id_uprawnienia = c.id_uprawnienia and c.nazwa = 'Lekarz') d
left join lekarze_specjalizacje e on d.id_osoba = e.id_lekarza) f
left join specjalizacje g on f.id_specjalizacja = g.id_specjalizacja;

CREATE OR REPLACE view recepcionisci as
select a.* from osoba a,osoby_uprawnienia b,uprawnienia c 
where a.id_osoba = b.id_osoby and b.id_uprawnienia = c.id_uprawnienia and c.nazwa = 'Recepcionista';

----
--function

create or replace function id_osoba(a text)
  returns uuid as $$
declare
  out uuid;
begin
  select id_osoba from osoba where pesel = a into out;
  return out;
end;
$$ language 'plpgsql';

create or replace function login_pacjent(p text,h text)
  returns uuid as $$
declare
  out uuid;
begin
  select id_osoba from pacjenci where pesel = p and haslo = md5(h) into out;
  return out;
end;
$$ language 'plpgsql';

create or replace function login_lekarz(p text,h text)
  returns uuid as $$
declare
  out uuid;
begin
  select id_osoba from lekarze where pesel = p and haslo = md5(h) into out;
  return out;
end;
$$ language 'plpgsql';

create or replace function wizyta(p uuid,s text,o timestamp,d timestamp)
  returns boolean as $$
declare
	id int;
begin
  Select nextval(pg_get_serial_sequence('wizyty', 'id_wizyty')) into id;	

  insert into wizyty
	  select
	          id,p,id_lekarza,o,d
	  from
	          lekarze_specjalizacje
      where id_lekarza != all 
	  (select id_lekarza from wizyty where d > data_od and d < data_do or o > data_od and o < data_do or
	  data_od > o and data_od < d and data_do > o and data_do < d or o = data_od or d = data_do)
	  and id_specjalizacja in (select id_specjalizacja from specjalizacje where nazwa = s)
	  and id_lekarza in (select id_lekarza from lekarze_dyzur where d between data_od and data_do or o between data_od and data_do) order by 1 limit 1;
	if exists( select * from wizyty where id_wizyty = id) then
		return true;
	end if;
	return false;
end;
$$ language 'plpgsql';

create or replace function dodaj_wizyte(p uuid,s text)
  returns boolean as $$
declare
	id int;
	start timestamp;
	stop timestamp;
	out boolean;
	row record;
begin
  out = false;
  Select nextval(pg_get_serial_sequence('wizyty', 'id_wizyty')) into id;	
  
  for row in select * from lekarze_dyzur 
  where id_lekarza in (select id_lekarza from lekarze_specjalizacje where id_specjalizacja = (select id_specjalizacja from specjalizacje where nazwa = s)) and data_od > now() loop
  	start = row.data_od;
      while start < row.data_do loop
		stop = start + interval '30 minutes';
		select wizyta(p,s,start,stop) into out;
		if out then
			EXIT;
		end if;
		start = start + interval '30 minutes';
	  end loop;
	  if out then
		EXIT;
	  end if;
  end loop;
  return out;
end;
$$ language 'plpgsql';

create or replace function uzyj_recepty(id int)
  returns numeric as $$
declare
	out numeric;
begin
  if not exists(select * from recepty where id_recepty = id and termin_waznosci > now()) then
	return -1;
  end if;
  select sum(b.ilosc * c.cena) 
  from recepty a,recepty_lekarstwa b,lekarstwa c 
  where a.id_recepty = b.id_recepty and b.id_lekarstwa = c.id_lekarstwa and a.id_recepty = id into out;
  update recepty set termin_waznosci = now() where id_recepty = id;
  return out;
end;
$$ language 'plpgsql';
----
--trigger

create or replace function poprawnosc_osoba()
  returns trigger as $$
declare
  suma int;
  j int;
begin
  suma = 0;
  j = 1;
  if length(new.pesel) != 11 then
          raise notice 'Niepoprawny PESEL';
  end if;

  for i in 1..10 loop
      suma = suma + substring(new.pesel from i for 1)::integer * j;
      if j = 3 then
          j = j + 4;
      else
          j = (j + 2) % 10;
      end if;
  end loop;

  suma = suma % 10;
  if suma != 0 then
          suma = 10 - suma;
  end if;

  if suma != substring(new.pesel from 11 for 1)::integer then
          raise notice 'Niepoprawny PESEL';
  end if;
  
  if old is not null then
	new.id_osoba = old.id_osoba;
  end if;
  new.haslo = md5(new.haslo);
  return new;
end
$$ language 'plpgsql';

create trigger a before insert or update on osoba
for each row execute procedure poprawnosc_osoba();

----

create or replace function poprawnosc_wizyty()
  returns trigger as $$
begin
  if exists(select * from lekarze_dyzur where id_lekarza = new.id_pacjenta and 
  	( new.data_do > data_od and new.data_do < data_do or new.data_od > data_od and new.data_od < data_do or
	  data_do > new.data_od and data_do < new.data_do or data_od > new.data_od and data_od < new.data_do))then
	return null;
  end if;
  if exists(select * from wizyty where id_lekarza = new.id_lekarza and
	  ( new.data_do > data_od and new.data_do < data_do or new.data_od > data_od and new.data_od < data_do or
	  data_do > new.data_od and data_do < new.data_do or data_od > new.data_od and data_od < new.data_do)) then
	  return null;
  end if;
  if not exists(select * from lekarze_dyzur where id_lekarza = new.id_lekarza and
	  new.data_do between data_od and data_do and new.data_od between data_od and data_do ) then
	  return null;
  end if;
  if old is not null then
  new.id_wizyty = old.id_wizyty;
  end if;
  return new;
end
$$ language 'plpgsql';

create trigger a before insert or update on wizyty
for each row execute procedure poprawnosc_wizyty();

----
create or replace function poprawnosc_dyzur()
  returns trigger as $$
begin
  if new.data_od + (interval '8 hour') < new.data_do then
	  return null;
  end if;
  if exists(select * from lekarze_dyzur where id_lekarza = new.id_lekarza and
	  ( new.data_do between data_od and data_do or new.data_od between data_od and data_do or
	  data_do between new.data_od and new.data_do or data_od between new.data_od and new.data_do ) ) then
	  return null;
  end if;
  if exists(select * from urlop where id_lekarza = new.id_lekarza and
	  ( new.data_do between data_od and data_do or new.data_od between data_od and data_do or
	  data_do between new.data_od and new.data_do or data_od between new.data_od and new.data_do ) ) then
	  return null;
  end if;
  if old is not null then
  new.id_wizyty = old.id_wizyty;
  end if;
  return new;
end
$$ language 'plpgsql';

create trigger a before insert or update on lekarze_dyzur
for each row execute procedure poprawnosc_dyzur();

----
create or replace function poprawnosc_urlop()
  returns trigger as $$
begin
  if exists(select * from lekarze_dyzur where id_lekarza = new.id_lekarza and
	  ( new.data_do between data_od and data_do or new.data_od between data_od and data_do or
	  data_do between new.data_od and new.data_do or data_od between new.data_od and new.data_do ) ) then
	  return null;
  end if;
  if exists(select * from urlop where id_lekarza = new.id_lekarza and
	  ( new.data_do between data_od and data_do or new.data_od between data_od and data_do or
	  data_do between new.data_od and new.data_do or data_od between new.data_od and new.data_do ) ) then
	  return null;
  end if;
  return new;
end
$$ language 'plpgsql';

create trigger a before insert or update on urlop
for each row execute procedure poprawnosc_urlop();

----
create or replace function czy_istnieje_pacjent()
  returns trigger as $$
begin
  if exists(select * from pacjenci where id_osoba = new.id_pacjenta) then
  	return new;
  end if;
  return null;
end
$$ language 'plpgsql';

create trigger pacjent before insert or update on wizyty
for each row execute procedure czy_istnieje_pacjent();

create trigger pacjent before insert or update on dokumentacja
for each row execute procedure czy_istnieje_pacjent();

create trigger pacjent before insert or update on recepty
for each row execute procedure czy_istnieje_pacjent();

create trigger pacjent before insert or update on skierowania_pacjenci
for each row execute procedure czy_istnieje_pacjent();

create or replace function czy_istnieje_lekarz()
  returns trigger as $$
begin
  if exists(select * from lekarze where id_osoba = new.id_lekarza) then
  	return new;
  end if;
  return null;
end
$$ language 'plpgsql';

create trigger lekarz before insert or update on lekarze_specjalizacje
for each row execute procedure czy_istnieje_lekarz();

create trigger lekarz before insert or update on lekarze_dyzur
for each row execute procedure czy_istnieje_lekarz();

create trigger lekarz before insert or update on urlop
for each row execute procedure czy_istnieje_lekarz();

create trigger lekarz before insert or update on wizyty
for each row execute procedure czy_istnieje_lekarz();

create trigger lekarz before insert or update on recepty
for each row execute procedure czy_istnieje_lekarz();

create trigger lekarz before insert or update on skierowania_pacjenci
for each row execute procedure czy_istnieje_lekarz();

----
--rule

CREATE OR REPLACE RULE pacjenci AS ON INSERT TO pacjenci
DO INSTEAD(
  insert into osoba (imie,nazwisko,haslo,numer_telefonu,email,adres_zamieszkania,pesel) values(new.imie,new.nazwisko,new.haslo,new.numer_telefonu,new.email,new.adres_zamieszkania,new.pesel);
  insert into osoby_uprawnienia values(id_osoba(new.pesel),1);
);

CREATE OR REPLACE RULE lekarze AS ON INSERT TO lekarze
DO INSTEAD(
  insert into osoba (imie,nazwisko,haslo,numer_telefonu,email,adres_zamieszkania,pesel) values(new.imie,new.nazwisko,new.haslo,new.numer_telefonu,new.email,new.adres_zamieszkania,new.pesel);
  insert into osoby_uprawnienia values(id_osoba(new.pesel),2);
  insert into lekarze_specjalizacje select id_osoba(new.pesel),id_specjalizacja from specjalizacje where nazwa = new.specjalizacja;
);

CREATE OR REPLACE RULE recepcionisci AS ON INSERT TO recepcionisci
DO INSTEAD(
  insert into osoba (imie,nazwisko,haslo,numer_telefonu,email,adres_zamieszkania,pesel) values(new.imie,new.nazwisko,new.haslo,new.numer_telefonu,new.email,new.adres_zamieszkania,new.pesel);
  insert into osoby_uprawnienia values(id_osoba(new.pesel),3);
);
----
--insert

insert into pacjenci values(null,'Patryk','Bar','1234','123456789','patryk.bar@student.uj.edu.pl',null,'97120215878');
insert into pacjenci values(null,'Patryk','Bar','1234','123456788','a1@student.uj.edu.pl',null,'59091626567');
insert into pacjenci values(null,'Patryk','Bar','1234','123456787','a2@student.uj.edu.pl',null,'72091084126');
insert into pacjenci values(null,'Patryk','Bar','1234','123456786','a3@student.uj.edu.pl',null,'78031832329');
insert into pacjenci values(null,'Patryk','Bar','1234','123456785','a4@student.uj.edu.pl',null,'78021773713');
insert into pacjenci values(null,'Patryk','Bar','1234','123456784','a5@student.uj.edu.pl',null,'04260499196');
insert into pacjenci values(null,'Patryk','Bar','1234','123456783','a6@student.uj.edu.pl',null,'74012638887');
insert into pacjenci values(null,'Patryk','Bar','1234','123456782','a7@student.uj.edu.pl',null,'90030352279');
insert into pacjenci values(null,'Patryk','Bar','1234','123456781','a8@student.uj.edu.pl',null,'84061596546');
insert into pacjenci values(null,'Patryk','Bar','1234','123456780','a9@student.uj.edu.pl',null,'68062155117');

insert into lekarze values(null,'Jan','Kowalski','1234','123456770','a11@student.uj.edu.pl',null,'67082727575','Alergologia');
insert into lekarze values(null,'Jan','Kowalski','1234','123456771','a21@student.uj.edu.pl',null,'61060985245','Alergologia');
insert into lekarze values(null,'Jan','Kowalski','1234','123456772','a31@student.uj.edu.pl',null,'76031324763','Alergologia');
insert into lekarze values(null,'Jan','Kowalski','1234','123456773','a41@student.uj.edu.pl',null,'87010132796','Alergologia');
insert into lekarze values(null,'Jan','Kowalski','1234','123456774','a51@student.uj.edu.pl',null,'87101814884','Alergologia');