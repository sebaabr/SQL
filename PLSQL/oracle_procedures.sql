set SERVEROUTPUT ON;
/*
Peocedura wyprodukowano_w jako parametr przyjmuje tekst - nazwe kraju, 
wyswietla ilosc filmow wyprodukowanych w podanym kraju, tytulu filmow oraz czas trwania
*/
CREATE OR REPLACE PROCEDURE wyprodukowano_w (p_kraj varchar2)
AS
v_idKraj int;
v_ile int;
v_tytul film.tytul%type;
v_czas film.czas_trwania_min%type;
CURSOR k IS SELECT tytul, czas_trwania_min from film where kraj_produkcji = v_idKraj;
BEGIN
SELECT count(1) into v_ile  FROM kraj where nazwa = p_kraj;

IF v_ile = 0 THEN
    dbms_output.put_line('Nie wyprodukowano jeszcze zadnego filu w podanym ' || p_kraj);
ELSE
    select id_kraj into v_idKraj from kraj where nazwa = p_kraj;
    select count(1) into v_ile from film where kraj_produkcji = v_idKraj;
    dbms_output.put_line('Filmow wyprodukowanych w '|| p_kraj || ' jest ' || v_ile || ':');
    open k;
    LOOP
        exit when k%notfound;
        fetch k into v_tytul, v_czas;
        dbms_output.put_line(v_tytul || '(' || v_czas || ' min)');
    END LOOP;    
    close k;
END IF;

--dbms_output.put_line(v_ile);

END;

call wyprodukowano_w('USA');
/*
Peocedura wyswietlono jako parametr przyjmuje 2 liczby wiek od i do (podawany w latach), 
wyswietla tytuy filmow oraz ile rozy zostaly obejrzane przez osoby w podanej grupie wiekowej (w parametrze)
*/
CREATE OR REPLACE PROCEDURE wyswietlono (p_od int, p_do int)
AS
--v_curr_date date;
CURSOR k IS SELECT Tytul, count(1) AS "wyswietlenia"
FROM Uzytkownik_Film UF 
INNER JOIN Film F ON f.Id_film = UF.Film_Id_film
WHERE Uzytkownik_Id_uzytkownik IN 
	(SELECT Id_uzytkownik FROM Uzytkownik WHERE (extract(year from current_date) - extract(year from data_urodz)) BETWEEN p_od AND p_do)
GROUP BY Film_Id_film, Tytul
ORDER BY count(1) DESC;
v_tytul char(40);
v_ile int;
BEGIN
OPEN k;
fetch k into v_tytul, v_ile;
IF k%notfound THEN
    dbms_output.put_line('Nie znaleziono fizadnego filmu w podanym przedziale');
ELSE
LOOP 
    exit when k%notfound;
    fetch k into v_tytul, v_ile;
    dbms_output.put_line(v_tytul || ' (' || v_ile || ')');
END LOOP;
END IF;
CLOSE k;
END;

call wyswietlono(15, 21);

/*
Wyzwalacz film_checher sprawdza czy dane wprowadzane do tabeli film sa poprawne
- czy nie istnieje juz taki tytul
- opis powinien byc dluzszy niz 10 znakow
- czas trwania powinien byc dluzszy niz 10 min
- rok produkcji powinien byc nie wczesniejszy niz 1895
*/
CREATE OR REPLACE TRIGGER film_checher
BEFORE update or insert on film 
for each row
DECLARE
v_tytul_ile film.tytul%type := 0; 
BEGIN
--    dbms_output.put_line(length(:new.opis));
    select count(1) into v_tytul_ile From film where tytul = :new.tytul;
    
    IF v_tytul_ile > 0 THEN
        raise_application_error(-20001, :new.tytul || ' taki film juz jest w bazie');
    END IF;
    
    IF length(:new.opis) < 10 THEN
        raise_application_error(-20001, :new.tytul || ' za krotki opis');
    END IF;
    
    IF :new.czas_trwania_min < 10 THEN
        raise_application_error(-20001, :new.tytul || ' za krotki czas trwania filmu');
    END IF;
       
    IF :new.rok_produkcji < 1895 THEN
        raise_application_error(-20001, :new.tytul || ' nieprawidlowy rok produkcji. Podaj poprawny rok wyprodukowania filmu!');
    END IF;
END;


select * from film;

insert into Film(Id_film, Tytul, Opis, Czas_trwania_min, Rok_produkcji, Data_premiery, Kraj_produkcji, Gatunek_Id_gatunek)
VALUES(10, 'JOKER', 'ABC', 5, 1800, '2020-05-05', 1, 1 );
 
 
 /*
Wyzwalacz check_ocena sprawdzaja czy konkretny film nie zostal juz oceniony przez dana osobe
*/   
CREATE OR REPLACE TRIGGER check_ocena
BEFORE insert or update ON uzytkownik_film
for each row
DECLARE 
--CURSOR k IS SELECT id_uzytkownik_film, Uzytkownik_id_uzytkownik, Film_id_film, ocena_id_ocena from inserted where Ocena_Id_ocena IS NOT NULL; 
v_ile int;
BEGIN
    SELECT count(1) into v_ile from uzytkownik_film where Uzytkownik_id_uzytkownik = :new.Uzytkownik_id_uzytkownik AND   
                                            Film_id_film = :new.Film_id_film AND
                                            Ocena_Id_ocena IS NOT NULL;
                                            
--    dbms_output.put_line(v_ile);
    
    IF v_ile > 0 THEN
        :new.ocena_id_ocena := null;
        dbms_output.put_line('Film zostal juz oceniony przez ta osobe');
    END IF;
END;

insert into Uzytkownik_Film values(26, 1,1,10);
insert into Uzytkownik_Film values(27,1,1,5);
insert into Uzytkownik_Film values(28,1,1,4);
select * from uzytkownik_film ;
delete uzytkownik_film where id_uzytkownik_film in(26, 27, 28);
