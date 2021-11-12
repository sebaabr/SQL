use "2019SBD";

/*
Peocedura wyprodukowano_w jako parametr przyjmuje tekst - nazwe kraju, 
wyswietla ilosc filmow wyprodukowanych w podanym kraju, tytulu filmow oraz rok wyprodukowania
*/
CREATE PROCEDURE wyprodukowano_w @kraj varchar(15)
AS BEGIN
SET NOCOUNT on;
	DECLARE @idKraj int, @info varchar(100);

	SELECT @idKraj = id_kraj From Kraj Where Nazwa = @kraj;

	IF @idKraj IS NULL
		BEGIN
		PRINT 'Nie ma jeszcze ¿adnego filmu powstalego w ' + @kraj;
		RETURN;
		END
	ELSE
		BEGIN
		DECLARE @ile int;
		SELECT @ile = COUNT(1) FROM Film where Kraj_produkcji = @idKraj;
	
		PRINT 'Znaleziono ' + convert(varchar, @ile) +  ' filmow wyprodukowanych w ' + @kraj + ':';
		
			DECLARE filmy CURSOR FOR SELECT Tytul, rok_produkcji FROM Film WHERE Kraj_produkcji = @idKraj ORDER BY Rok_produkcji DESC
			DECLARE @tytul varchar(40), @rok_produkcji int;
			OPEN filmy
			FETCH NEXT FROM filmy INTO @tytul, @rok_produkcji
			WHILE @@FETCH_STATUS = 0
				BEGIN
				PRINT @tytul + ', wyprodukowany w roku ' +  CONVERT(varchar, @rok_produkcji);
				FETCH NEXT FROM filmy INTO @tytul, @rok_produkcji;
				END
			CLOSE filmy;
			DEALLOCATE filmy;
		
		END
END

GO

EXEC wyprodukowano_w 'USA'
GO

/*
Peocedura wyswietlono jako parametr przyjmuje 2 liczby wiek od i do (podawany w latach), 
wyswietla tytuy filmow oraz ile rozy zostaly obejrzane przez osoby w podanej grupie wiekowej (w parametrze)
*/
CREATE PROCEDURE wyswietlono @od int, @do int
AS BEGIN

SELECT Tytul, count(1) AS "ilosc wyswietlen"
FROM Uzytkownik_Film UF 
INNER JOIN Film F ON f.Id_film = UF.Film_Id_film
WHERE Uzytkownik_Id_uzytkownik IN 
	(SELECT Id_uzytkownik FROM Uzytkownik WHERE YEAR(GETDATE()) - YEAR(Data_urodz) BETWEEN @od AND @do)
GROUP BY Film_Id_film, Tytul
ORDER BY count(1) DESC

IF @@rowcount = 0
	PRINT 'Brak rekordow dla podanych danych';

END
GO

EXEC wyswietlono 18, 25
GO


select * from film;
GO
/*
Wyzwalacz film_checher sprawdza czy dane wprowadzane do tabeli film sa poprawne
- czy nie istnieje juz taki tytul
- opis powinien byc dluzszy niz 10 znakow
- czas trwania powinien byc dluzszy niz 10 min
- rok produkcji powinien byc nie wczesniejszy niz 1895
*/
ALTER TRIGGER film_checker
ON Film FOR INSERT, UPDATE
AS

	DECLARE filmy1 CURSOR FOR select tytul, opis, czas_trwania_min, rok_produkcji FROM inserted
	DECLARE @tytul varchar(40), @opis varchar(250), @czas_trwania int, @rok_produkcji int;
	OPEN filmy1
	FETCH NEXT FROM filmy1 INTO @tytul, @opis, @czas_trwania, @rok_produkcji
	WHILE @@FETCH_STATUS = 0
		BEGIN 

		IF exists (select 1 from inserted f1 where exists(SELECT tytul from film f2 where f1.Tytul = f2.Tytul AND f1.Id_film != f2.Id_film))
		BEGIN
			PRINT @tytul + ' film juz istnieje w bazie!'
			rollback;
		END

		IF LEN(@opis) <10
		BEGIN
			PRINT @tytul + ' za krotki opis. Minimalna dlugosz to 10 znakow!'
			rollback;
		END

		IF @czas_trwania < 10
		BEGIN
			PRINT @tytul + ' za krotki czas trwania. Podaj poprawny czas trwania filmu w minutach!'
			rollback;
		END

		IF @rok_produkcji < 1895
		BEGIN
			PRINT @tytul + ' nieprawidlowy rok produkcji. Podaj poprawny rok wyprodukowania filmu!'
			rollback;
		END

		FETCH NEXT FROM filmy1 INTO @tytul, @opis, @czas_trwania, @rok_produkcji
		END
	
	CLOSE filmy1;
	DEALLOCATE filmy1;

GO
	insert into Film(Id_film, Tytul, Opis, Czas_trwania_min, Rok_produkcji, Data_premiery, Kraj_produkcji, Gatunek_Id_gatunek)
	VALUES(11, 'JOKER', 'ABCABDAASBASSBASBSASBAS', 15, 1900, '2020-05-05', 1, 1 )

GO

/*
Wyzwalacz check_ocena sprawdzaja czy konkretny film nie zostal juz oceniony przez dana osobe
*/ 
CREATE TRIGGER check_ocena
ON uzytkownik_film
FOR insert
AS
BEGIN
DECLARE k CURSOR FOR SELECT id_uzytkownik_film, Uzytkownik_id_uzytkownik, Film_id_film, ocena_id_ocena from inserted where Ocena_Id_ocena IS NOT NULL;
DECLARE @id int, @id_uz int, @id_film int, @id_ocena int;
OPEN k;
FETCH NEXT FROM k INTO @id, @id_uz, @id_film, @id_ocena
WHILE @@FETCH_STATUS = 0
BEGIN
	IF EXISTS (SELECT 1 from Uzytkownik_Film where Id_uzytkownik_film != @id 
												AND Uzytkownik_Id_uzytkownik = @id_uz 
												AND Film_Id_film = @id_film 
												AND Ocena_Id_ocena IS NOT NULL)
	BEGIN
		PRINT 'Film zostal juz oceniony przez ta osobe!';
		rollback;
	END
	FETCH NEXT FROM k INTO @id, @id_uz, @id_film, @id_ocena
END
close k;
DEALLOCATE k;

END;
GO

insert into Uzytkownik_Film values(26, 1,1,10), (27,1,1,5);


