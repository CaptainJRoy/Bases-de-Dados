INSERT INTO Comboio (ID, Observacoes)
VALUES 	(1, 'Comboio com bar. Atinge velocidades na ordem dos 200 km/h'), 
		(2, 'Comboio de luxo com restaurante, bar e casa de banho. Atinge velocidades de 300 km/h'), 
		(3, 'Comboio simples, recomendado para viagens nacionais. Atinge velocidades de 150 km/h');

INSERT INTO Estacao (ID, Nome, Cidade)
VALUES	(1, 'Oriente', 'Lisboa'),
        (2, 'Atocha', 'Madrid'),
        (3, 'Sants', 'Barcelona'),
        (4, 'Saint Jean', 'Bordeaux'),
        (5, 'Part Dieu', 'Lyon'),
        (6, 'Gare de Lyon', 'Paris');
        
INSERT INTO LugarComboio (NumeroLugar, Comboio_ID)
VALUES	(1, 1),
		(2, 1),
        (3, 1),
        (4, 1),
        (5, 1),
        (6, 1),
        (7, 1),
        (8, 1),
        (9, 1),
        (10, 1);
        
INSERT INTO LugarComboio (NumeroLugar, Comboio_ID)
VALUES  (1, 2),
        (2, 2),
        (3, 2),
        (4, 2),
        (5, 2),
        (6, 2),
        (7, 2),
        (8, 2),
        (9, 2),
        (10, 2),
        (11, 2),
        (12, 2),
        (13, 2),
        (14, 2),
        (15, 2);
        
INSERT INTO LugarComboio (NumeroLugar, Comboio_ID)
VALUES  (1, 3),
        (2, 3),
        (3, 3),
        (4, 3),
        (5, 3);
        
INSERT INTO Viagem (ID, Comboio_ID, HoraPartida, Origem, Destino, HoraChegada)
VALUES	(1, 1, '07:00', 1, 2, '11:45'),
		(2, 3, '12:30', 2, 3, '17:00'),
        (3, 2, '18:00', 3, 5, '22:30');