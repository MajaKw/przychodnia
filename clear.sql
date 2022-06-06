DROP RULE pacjenci ON pacjenci CASCADE;
DROP RULE lekarze ON lekarze CASCADE;
DROP RULE recepcionisci ON recepcionisci CASCADE;

DROP TRIGGER a ON osoba CASCADE;
DROP TRIGGER a ON wizyty CASCADE;
DROP TRIGGER a ON lekarze_dyzur CASCADE;

DROP TRIGGER pacjent ON wizyty CASCADE;
DROP TRIGGER pacjent ON dokumentacja CASCADE;
DROP TRIGGER pacjent ON recepty CASCADE;
DROP TRIGGER pacjent ON skierowania_pacjenci CASCADE;

DROP TRIGGER lekarz ON lekarze_specjalizacje CASCADE;
DROP TRIGGER lekarz ON lekarze_dyzur CASCADE;
DROP TRIGGER lekarz ON urlop CASCADE;
DROP TRIGGER lekarz ON wizyty CASCADE;
DROP TRIGGER lekarz ON recepty CASCADE;
DROP TRIGGER lekarz ON skierowania_pacjenci CASCADE;

Drop function poprawnosc_osoba CASCADE;
Drop function czy_istnieje_pacjent CASCADE;
Drop function czy_istnieje_lekarz CASCADE;
Drop function poprawnosc_wizyty CASCADE;
Drop function poprawnosc_dyzur CASCADE;
Drop function id_osoba CASCADE;
Drop function login_pacjent CASCADE;

Drop view pacjenci CASCADE;
Drop view lekarze CASCADE;
Drop view farmaceuci CASCADE;

DROP TABLE osoba CASCADE;
DROP TABLE osoby_uprawnienia CASCADE;
DROP TABLE uprawnienia CASCADE;
DROP TABLE specjalizacje CASCADE;
DROP TABLE lekarze_specjalizacje CASCADE;
DROP TABLE lekarze_dyzur CASCADE;
DROP TABLE urlop CASCADE;
DROP TABLE wizyty CASCADE;
DROP TABLE dokumentacja CASCADE;
DROP TABLE recepty CASCADE;
DROP TABLE lekarstwa CASCADE;
DROP TABLE recepty_lekarstwa CASCADE;
DROP TABLE skierowania CASCADE;
DROP TABLE skierowania_pacjenci CASCADE;