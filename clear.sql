DROP RULE pacjenci ON pacjenci CASCADE;
DROP RULE lekarze ON lekarze CASCADE;
DROP RULE recepcionisci ON recepcionisci CASCADE;

DROP TRIGGER a ON osoba CASCADE;
DROP TRIGGER a ON wizyty CASCADE;
DROP TRIGGER a ON lekarze_dyzur CASCADE;
DROP TRIGGER a ON nieobecnosci CASCADE;

DROP TRIGGER pacjent ON wizyty CASCADE;
DROP TRIGGER pacjent ON dokumentacja CASCADE;
DROP TRIGGER pacjent ON recepty CASCADE;

DROP TRIGGER lekarz ON lekarze_specjalizacje CASCADE;
DROP TRIGGER lekarz ON lekarze_dyzur CASCADE;
DROP TRIGGER lekarz ON nieobecnosci CASCADE;
DROP TRIGGER lekarz ON wizyty CASCADE;
DROP TRIGGER lekarz ON recepty CASCADE;

DROP TRIGGER przydziel_wizyty_z_dyzurow ON lekarze_dyzur CASCADE;

Drop function poprawnosc_osoba CASCADE;
Drop function czy_istnieje_pacjent CASCADE;
Drop function czy_istnieje_lekarz CASCADE;
Drop function poprawnosc_wizyty CASCADE;
Drop function poprawnosc_dyzur CASCADE;
Drop function id_osoba CASCADE;
Drop function login_pacjent CASCADE;
Drop function login_lekarz CASCADE;
Drop function wizyta CASCADE;
Drop function poprawnosc_nieobecnosci CASCADE;
Drop function dodaj_wizyte CASCADE;
Drop function uzyj_recepty CASCADE;
Drop function uzyj_skierowania CASCADE;
Drop function szukaj_wizyt CASCADE;
Drop function wizyta_after_dyzur CASCADE;
Drop function umow_wizyte CASCADE;
Drop function anuluj_wizyte CASCADE;

Drop view pacjenci CASCADE;
Drop view lekarze CASCADE;
Drop view farmaceuci CASCADE;

DROP TABLE osoba CASCADE;
DROP TABLE osoby_uprawnienia CASCADE;
DROP TABLE uprawnienia CASCADE;
DROP TABLE specjalizacje CASCADE;
DROP TABLE lekarze_specjalizacje CASCADE;
DROP TABLE lekarze_dyzur CASCADE;
DROP TABLE nieobecnosci CASCADE;
DROP TABLE wizyty CASCADE;
DROP TABLE dokumentacja CASCADE;
DROP TABLE recepty CASCADE;
DROP TABLE lekarstwa CASCADE;
DROP TABLE recepty_lekarstwa CASCADE;
DROP TABLE skierowania CASCADE;
DROP TABLE terminy_wizyt CASCADE;