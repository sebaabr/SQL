-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-01-28 10:07:19.899

-- tables
-- Table: Film
CREATE TABLE Film (
    Id_film integer  NOT NULL,
    Tytul varchar2(40)  NOT NULL,
    Opis varchar2(250)  NOT NULL,
    Czas_trwania_min integer  NOT NULL,
    Rok_produkcji number(4,0)  NOT NULL,
    Data_premiery date  NOT NULL,
    Kraj_produkcji integer  NOT NULL,
    Gatunek_Id_gatunek integer  NOT NULL,
    CONSTRAINT Film_pk PRIMARY KEY (Id_film)
) ;

-- Table: Film_Nagroda
CREATE TABLE Film_Nagroda (
    Film_Id_film integer  NOT NULL,
    Nagroda_Id_nagroda integer  NOT NULL,
    Rok_przyznania number(4,0)  NOT NULL,
    CONSTRAINT Film_Nagroda_pk PRIMARY KEY (Film_Id_film,Nagroda_Id_nagroda)
) ;

-- Table: Gatunek
CREATE TABLE Gatunek (
    Id_gatunek integer  NOT NULL,
    Nazwa varchar2(20)  NOT NULL,
    Opis varchar2(250)  NOT NULL,
    CONSTRAINT Gatunek_pk PRIMARY KEY (Id_gatunek)
) ;

-- Table: Konto
CREATE TABLE Konto (
    Id_konto integer  NOT NULL,
    Status_Id_status integer  NOT NULL,
    Uz_1 integer  NOT NULL,
    Uz_2 integer  NULL,
    Uz_3 integer  NULL,
    Uz_4 integer  NULL,
    Uz_5 integer  NULL,
    Data_zalozenia date  NOT NULL,
    CONSTRAINT Konto_pk PRIMARY KEY (Id_konto)
) ;

-- Table: Kraj
CREATE TABLE Kraj (
    Id_kraj integer  NOT NULL,
    Nazwa varchar2(15)  NOT NULL,
    CONSTRAINT Kraj_pk PRIMARY KEY (Id_kraj)
) ;

-- Table: Nagroda
CREATE TABLE Nagroda (
    Id_nagroda integer  NOT NULL,
    Nazwa varchar2(20)  NOT NULL,
    CONSTRAINT Nagroda_pk PRIMARY KEY (Id_nagroda)
) ;

-- Table: Ocena
CREATE TABLE Ocena (
    Id_ocena integer  NOT NULL,
    Ocena integer  NOT NULL,
    CONSTRAINT Ocena_pk PRIMARY KEY (Id_ocena)
) ;

-- Table: Status
CREATE TABLE Status (
    Id_status integer  NOT NULL,
    Nazwa varchar2(15)  NOT NULL,
    CONSTRAINT Status_pk PRIMARY KEY (Id_status)
) ;

-- Table: Uzytkownik
CREATE TABLE Uzytkownik (
    Id_uzytkownik integer  NOT NULL,
    Imie varchar2(15)  NOT NULL,
    Nazwisko varchar2(15)  NOT NULL,
    Data_urodz date  NOT NULL,
    CONSTRAINT Uzytkownik_pk PRIMARY KEY (Id_uzytkownik)
) ;

-- Table: Uzytkownik_Film
CREATE TABLE Uzytkownik_Film (
    Id_uzytkownik_film integer  NOT NULL,
    Uzytkownik_Id_uzytkownik integer  NOT NULL,
    Film_Id_film integer  NOT NULL,
    Ocena_Id_ocena integer  NULL,
    CONSTRAINT Uzytkownik_Film_pk PRIMARY KEY (Id_uzytkownik_film)
) ;

-- foreign keys
-- Reference: Film_Gatunek (table: Film)
ALTER TABLE Film ADD CONSTRAINT Film_Gatunek
    FOREIGN KEY (Gatunek_Id_gatunek)
    REFERENCES Gatunek (Id_gatunek);

-- Reference: Film_Kraj (table: Film)
ALTER TABLE Film ADD CONSTRAINT Film_Kraj
    FOREIGN KEY (Kraj_produkcji)
    REFERENCES Kraj (Id_kraj);

-- Reference: Konto_Status (table: Konto)
ALTER TABLE Konto ADD CONSTRAINT Konto_Status
    FOREIGN KEY (Status_Id_status)
    REFERENCES Status (Id_status);

-- Reference: Konto_Uzytkownik1 (table: Konto)
ALTER TABLE Konto ADD CONSTRAINT Konto_Uzytkownik1
    FOREIGN KEY (Uz_1)
    REFERENCES Uzytkownik (Id_uzytkownik);

-- Reference: Konto_Uzytkownik2 (table: Konto)
ALTER TABLE Konto ADD CONSTRAINT Konto_Uzytkownik2
    FOREIGN KEY (Uz_4)
    REFERENCES Uzytkownik (Id_uzytkownik);

-- Reference: Konto_Uzytkownik3 (table: Konto)
ALTER TABLE Konto ADD CONSTRAINT Konto_Uzytkownik3
    FOREIGN KEY (Uz_3)
    REFERENCES Uzytkownik (Id_uzytkownik);

-- Reference: Konto_Uzytkownik4 (table: Konto)
ALTER TABLE Konto ADD CONSTRAINT Konto_Uzytkownik4
    FOREIGN KEY (Uz_2)
    REFERENCES Uzytkownik (Id_uzytkownik);

-- Reference: Konto_Uzytkownik5 (table: Konto)
ALTER TABLE Konto ADD CONSTRAINT Konto_Uzytkownik5
    FOREIGN KEY (Uz_5)
    REFERENCES Uzytkownik (Id_uzytkownik);

-- Reference: Table_11_Film (table: Film_Nagroda)
ALTER TABLE Film_Nagroda ADD CONSTRAINT Table_11_Film
    FOREIGN KEY (Film_Id_film)
    REFERENCES Film (Id_film);

-- Reference: Table_11_Nagroda (table: Film_Nagroda)
ALTER TABLE Film_Nagroda ADD CONSTRAINT Table_11_Nagroda
    FOREIGN KEY (Nagroda_Id_nagroda)
    REFERENCES Nagroda (Id_nagroda);

-- Reference: Uzytkownik_Film_Film (table: Uzytkownik_Film)
ALTER TABLE Uzytkownik_Film ADD CONSTRAINT Uzytkownik_Film_Film
    FOREIGN KEY (Film_Id_film)
    REFERENCES Film (Id_film);

-- Reference: Uzytkownik_Film_Ocena (table: Uzytkownik_Film)
ALTER TABLE Uzytkownik_Film ADD CONSTRAINT Uzytkownik_Film_Ocena
    FOREIGN KEY (Ocena_Id_ocena)
    REFERENCES Ocena (Id_ocena);

-- Reference: Uzytkownik_Film_Uzytkownik (table: Uzytkownik_Film)
ALTER TABLE Uzytkownik_Film ADD CONSTRAINT Uzytkownik_Film_Uzytkownik
    FOREIGN KEY (Uzytkownik_Id_uzytkownik)
    REFERENCES Uzytkownik (Id_uzytkownik);

-- End of file.

