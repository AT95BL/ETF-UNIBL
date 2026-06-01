CREATE TABLE SEMINAR(
    IdSeminara INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Naziv VARCHAR(100),
    Od DATE NOT NULL,
    Do DATE NOT NULL
);

CREATE TABLE OSOBA(
    IdOsobe INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Ime VARCHAR(50) NOT NULL,
    Prezime VARCHAR(50) NOT NULL
);

-- IS-A veza (Nasljeđivanje): IdOsobe je i PK i FK 
CREATE TABLE PREDAVAC(
    IdOsobe INT NOT NULL PRIMARY KEY,
    CONSTRAINT fk_predavac_osoba
        FOREIGN KEY (IdOsobe) REFERENCES OSOBA(IdOsobe) -- Ispravljeno: bez donje crte
);

-- 1:N veza sa uslovnom nulom sa strane predavanja 
CREATE TABLE PREDAVANJE(
    IdPredavanja INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Naziv VARCHAR(100) NOT NULL,
    Datum DATE NOT NULL,
    IdSeminara INT NOT NULL,
    IdOsobe INT NULL, -- Ispravljeno: NULL omogućava opcionu vezu (kružić na dijagramu) 
    CONSTRAINT fk_predavanje_seminar
        FOREIGN KEY (IdSeminara) REFERENCES SEMINAR(IdSeminara),
    CONSTRAINT fk_predavanje_predavac
        FOREIGN KEY (IdOsobe) REFERENCES PREDAVAC(IdOsobe) -- Ispravljeno: bez donje crte
);

-- M:N veza: Kreira se nova tabela sa kompozitnim PK 
CREATE TABLE PRIJAVLJENA(
    IdOsobe INT NOT NULL,
    IdSeminara INT NOT NULL,
    PRIMARY KEY (IdOsobe, IdSeminara),
    CONSTRAINT fk_prijavljena_osoba
        FOREIGN KEY (IdOsobe) REFERENCES OSOBA(IdOsobe),
    CONSTRAINT fk_prijavljena_seminar
        FOREIGN KEY (IdSeminara) REFERENCES SEMINAR(IdSeminara)
);

-- M:N veza: Kreira se nova tabela sa kompozitnim PK 
CREATE TABLE PRISUSTVUJE( -- Ispravljeno: uklonjen tipfeler iz naziva tabele 
    IdPredavanja INT NOT NULL,
    IdOsobe INT NOT NULL,
    PRIMARY KEY(IdPredavanja, IdOsobe),
    CONSTRAINT fk_prisustvuje_predavanje
        FOREIGN KEY (IdPredavanja) REFERENCES PREDAVANJE(IdPredavanja),
    CONSTRAINT fk_prisustvuje_osoba
        FOREIGN KEY (IdOsobe) REFERENCES OSOBA(IdOsobe)
);

-- Imas tabelu SEMINAR, i u istoj popunjene kolone, duz svake kolone
-- ti lezi jedan seminar, e sad ovde je tvoj zadatak da prebrojis sve te kolone
-- i da prikazes sve one kolone kod kojih je 'Do < CURDATE()'
SELECT COUNT(*) AS Broj_Odrzanih_Seminara FROM SEMINAR WHERE Do < CURDATE();

SELECT
    seminar.Naziv       AS NazivSeminara,
    predavanje.Naziv    AS NazivPredavanja,
    osoba.Ime           AS ImePredavaca,
    osoba.Prezime       AS PrezimePredavaca
FROM PREDAVANJE predavanje
JOIN SEMINAR seminar ON seminar.IdSeminara = predavanje.IdSeminara
JOIN PREDAVAC predavac ON predavac.IdOsobe = predavanje.IdOsobe
JOIN OSOBA osoba ON osoba.IdOsobe = predavac.IdOsobe
WHERE predavanje.Datum = CURDATE(); 

SELECT 
    seminar.IdSeminara               AS  IdSeminara,
    seminar.Naziv                    AS  NazivSeminara,
    seminar.Od                       AS  DatumPocetkaSeminara,
    seminar.Do                       AS  DatumZavrsetkaSeminara,
    COUNT(prijavljena.IdOsobe)       AS  BrojPrijavljenihOsoba -- Popravljeno brojanje
FROM SEMINAR seminar -- Dodat alias 'seminar'
LEFT JOIN PRIJAVLJENA prijavljena ON prijavljena.IdSeminara = seminar.IdSeminara
WHERE seminar.Od > CURDATE()
GROUP BY seminar.IdSeminara, seminar.Naziv, seminar.Od, seminar.Do 
ORDER BY seminar.Od ASC; 

DELIMITER $$
CREATE PROCEDURE provjeri_prijavu(
    IN  p_IdOsobe INT,
    IN  p_IdPredavanja INT,
    OUT p_jePrijavljena BOOLEAN
)
BEGIN
    DECLARE v_broj INT DEFAULT 0;
    SELECT COUNT(*) 
    INTO v_broj 
    FROM PRIJAVLJENA prijavljena  --  Između PRIJAVLJENA i PREDAVANJE imaš SEMINAR!!! Stalno se pitaš KAKO/KOJE tabele povezati!!
    JOIN PREDAVANJE predavanje ON predavanje.IdSeminara = prijavljana.IdSeminara 
    WHERE predavanje.IdOsobe = p_IdOsobe
        AND predavanje.IdPredavanja = p_IdPredavanja;

    SET p_jePrijavljena = (v_Broj > 0);
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_provjera_prijave
BEFORE INSERT ON PRISUSTVUJE
FOR EACH ROW
BEGIN
    DECLARE v_Prijavljeno INT DEFAULT 0;
    CALL provjeri_prijavu(NEW.IdOsobe, NEW.IdPredavanja, v_prijavljeno);
    IF v_Prijavljeno = 0 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'OSOBA NIJE PRIJAVLJENA NA SEMINAR KOJEMU PRIPADA OVO PREDAVANJE.'; 
    END IF;
END $$
DELIMITER ;
