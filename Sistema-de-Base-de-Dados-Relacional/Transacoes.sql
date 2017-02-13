-- Registar Passageiro
DELIMITER $$
CREATE PROCEDURE `RegistarPassageiro`(IN Nome VARCHAR(45), IN Email VARCHAR(45), IN PalavraPasse VARCHAR(45))
BEGIN
	INSERT INTO Passageiro (Nome, Email, PalavraPasse)
	VALUES (Nome, Email, PalavraPasse);
END$$
DELIMITER ;

CALL RegistarPassageiro ('Bruno Machado', 'brunomachado@email.com', 'brunomachado');
CALL RegistarPassageiro ('Fabio Baiao', 'fabiobaiao@email.com', 'fabiobaiao');
CALL RegistarPassageiro ('Joao Rui', 'joaorui@email.com', 'joaorui');
CALL RegistarPassageiro ('Luis Costa', 'luiscosta@email.com', 'luiscosta');

-- Consultar Viagens
DELIMITER $$
CREATE PROCEDURE `ConsultarViagem`(IN Origem VARCHAR(45), IN Destino VARCHAR(45))
BEGIN
	SELECT Viagem.ID, HoraPartida, HoraChegada, o.Nome AS 'Origem', d.Nome AS 'Destino'
	FROM Viagem
    INNER JOIN (
		SELECT *
		FROM Estacao
		WHERE Origem = Cidade) AS o
	ON Viagem.origem = o.ID
	INNER JOIN (	
		SELECT *
		FROM Estacao
		WHERE Destino = Cidade) AS d
	ON Viagem.destino = d.ID;
END$$
DELIMITER ;

CALL ConsultarViagem ('Lisboa', 'Madrid');

-- Consultar Lugares
DELIMITER $$
CREATE PROCEDURE `ConsultarLugares`(IN ViagemID INT, IN DataV DATE)
BEGIN
	SELECT lc.NumeroLugar
    FROM Viagem
    INNER JOIN LugarComboio AS lc
	ON Viagem.Comboio_ID = lc.Comboio_ID
    WHERE ViagemID = ID AND (NumeroLugar) NOT IN (
		SELECT LugarComboio_NumeroLugar
		FROM Bilhete
		WHERE Viagem = Viagem_ID AND DataViagem = DataV);
END$$
DELIMITER ;

CALL ConsultarLugares (1, '2017-01-06');

-- Reservar Lugar
DELIMITER $$
CREATE PROCEDURE `ReservarLugar` (IN idViagem INT, IN DataV DATE, IN NumLugar INT, IN Mail VARCHAR(45), IN Passe VARCHAR(45))
BEGIN
    DECLARE Comboio, IDPassageiro INT;
    
    SELECT Comboio_ID INTO Comboio
    FROM Viagem
    WHERE ID = idViagem;
    
    SELECT ID INTO IDPassageiro
    FROM Passageiro
    WHERE Email = Mail AND 
		  PalavraPasse = Passe;
 	
    IF	IDPassageiro IS NOT NULL
	THEN
		INSERT INTO Bilhete (Passageiro_ID, Viagem_ID, DataViagem, LugarComboio_NumeroLugar, LugarComboio_Comboio_ID)
		VALUES 	(IDPassageiro, idViagem, DataV, NumLugar, Comboio);
	END IF;
END$$
DELIMITER ;

CALL ReservarLugar (1, '2017-01-06', 3, 'joaorui@email.com', 'joaorui');
CALL ReservarLugar (1, '2017-01-06', 1, 'fabiobaiao@email.com', 'fabiobaiao');

-- Consultar Bilhetes
DELIMITER $$
CREATE PROCEDURE `ConsultarBilhetes` (IN e VARCHAR(45), IN pass VARCHAR(45))
BEGIN
	IF
    (
		SELECT Passageiro.PalavraPasse 
        FROM Passageiro
        WHERE Passageiro.Email = e
    ) = pass
	THEN
		SELECT Bilhete.ID AS 'ID Bilhete', Bilhete.DataViagem AS 'Data de Viagem',
			   Bilhete.LugarComboio_NumeroLugar AS 'Lugar Nr', Bilhete.LugarComboio_Comboio_ID AS 'Comboio Nr',
			   Viagem.HoraPartida AS 'Hora de Partida', concat(ori.Cidade, ' - ', ori.Nome) AS 'Estação Origem',
			   Viagem.HoraChegada AS 'Hora de Chegada', concat(dest.Cidade, ' - ', dest.Nome) AS 'Estação Destino'
			   FROM Passageiro
			INNER JOIN Bilhete ON Bilhete.Passageiro_ID = Passageiro.ID
			INNER JOIN Viagem ON Bilhete.Viagem_ID = Viagem.ID
			INNER JOIN Estacao AS ori ON Viagem.Origem = ori.ID
			INNER JOIN Estacao AS dest ON Viagem.Destino = dest.ID
			WHERE Passageiro.Email = e;
	END IF;
END $$
DELIMITER ;

Call ConsultarBilhetes('fabiobaiao@email.com', 'fabiobaiao');
Call ConsultarBilhetes('joaorui@email.com', 'joaorui');

DELIMITER $$
CREATE TRIGGER UmaReservaPorViagem
	BEFORE INSERT ON Bilhete
	FOR EACH ROW
BEGIN
	IF (
		SELECT COUNT(*)
        FROM Bilhete
        WHERE Passageiro_ID = NEW.Passageiro_ID AND 
			DataViagem = NEW.DataViagem AND 
            Viagem_ID = NEW.Viagem_ID
        ) >= 1
	THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Já comprou um bilhete para esta viagem para este dia';
	END IF;
END $$
DELiMITER ;