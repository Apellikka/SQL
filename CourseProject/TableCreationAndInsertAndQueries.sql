

CREATE TABLE rltunti (
	rltunnus INT,
	rlnimi VARCHAR(50) NOT NULL,
	kuvaus VARCHAR(50),
	kesto INT,
	taso INT,
	ktunnus INT NOT NULL,
	PRIMARY KEY(rltunnus),
	UNIQUE(rlnimi),
	FOREIGN KEY(ktunnus) REFERENCES kategoria
	);
	
	INSERT INTO rltunti VALUES (
		1, 'Muokkaus', 'Muokataan lihaksia', 45, 2, 1
	);
	
	INSERT INTO rltunti VALUES (
		2, 'Joogan perusteet', 'Opetellaan joogaa', 50, 1, 2
	);
	INSERT INTO rltunti VALUES (
		3, 'Jooga 1', 'Jatketaan joogaamista', 50, 2, 2
	);
	INSERT INTO rltunti VALUES (
		4, 'Pilates 1', 'Opetellaan pilatesta', 60, 2, 2
	);
	INSERT INTO rltunti VALUES (
		5, 'Spinning alkeet', 'Poljetaan', 60, 1, 3
	);
	INSERT INTO rltunti VALUES (
		6, 'Spinning pro', 'Raskaita osuuksia ja tiukkoja spurtteja', 80, 4, 3
	);
	
	
	
	
	
CREATE TABLE kategoria (
	ktunnus INT,
	knimi VARCHAR(50) NOT NULL,
	PRIMARY KEY(ktunnus),
	UNIQUE(knimi)
	);
	
	INSERT INTO kategoria VALUES(
		1, 	'Lihaskunto'
	);
	INSERT INTO kategoria VALUES(
		2, 	'Kehonhuolto'
	);
	INSERT INTO kategoria VALUES(
		3, 	'Spinning'
	);
		
		
		
		

CREATE TABLE voi_ohjata (
	otunnus INT,
	rltunnus INT,
	PRIMARY KEY(otunnus, rltunnus),
	FOREIGN KEY(otunnus) REFERENCES ohjaaja,
	FOREIGN KEY(rltunnus) REFERENCES rltunti
	);
	
	INSERT INTO voi_ohjata VALUES (
		1, 3
	);
	INSERT INTO voi_ohjata VALUES (
		1, 5
	);
	INSERT INTO voi_ohjata VALUES (
		1, 6
	);
	INSERT INTO voi_ohjata VALUES (
		2, 2
	);
	INSERT INTO voi_ohjata VALUES (
		2, 3
	);
	INSERT INTO voi_ohjata VALUES (
		2, 4
	);
	INSERT INTO voi_ohjata VALUES (
		3, 5
	);
	INSERT INTO voi_ohjata VALUES (
		3, 6
	);


CREATE TABLE ohjaaja (
	otunnus INT,
	onimi VARCHAR(50) NOT NULL,
	syntymaika DATE,
	PRIMARY KEY(otunnus),
	UNIQUE(onimi)
	);
	
	INSERT INTO ohjaaja VALUES (
		1, 'Elisa Markkanen', '1986-01-21'
	);
	INSERT INTO ohjaaja VALUES (
		2, 'Eero Ilonen', '1988-03-14'
	);
	INSERT INTO ohjaaja VALUES (
		3, 'Mikko Kontinen', '1977-11-01'
	);
	
	
CREATE TABLE ljtunti (
	rltunnus INT,
	viikonpaiva VARCHAR(10) NOT NULL,
	alkamisaika TIME NOT NULL, 
	paattymisaika TIME,
	maxosallistujalkm INT,
	otunnus INT NOT NULL,
	stunnus INT NOT NULL,
	PRIMARY KEY(rltunnus, viikonpaiva, alkamisaika),
	FOREIGN KEY(rltunnus) REFERENCES rltunti,
	FOREIGN KEY(otunnus) REFERENCES ohjaaja,
	FOREIGN KEY(stunnus) REFERENCES sali
	);
	
	INSERT INTO ljtunti VALUES (
		3, 'ma', '8:10', '9:00', 10, 1, 3
	);
	INSERT INTO ljtunti VALUES (
		3, 'ma', '13:00', '13:50', 15, 1, 1
	);
	INSERT INTO ljtunti VALUES (
		3, 'ma', '20:10', '21:00', 10, 1, 3
	);
	INSERT INTO ljtunti VALUES (
		3, 'ti', '8:10', '9:00', 15, 2, 1
	);	
	INSERT INTO ljtunti VALUES (
		4, 'ma', '8:00', '9:00', 15, 2, 1
	);
	INSERT INTO ljtunti VALUES (
		6, 'ma', '7:00', '8:20', 20, 3, 2
	);
	INSERT INTO ljtunti VALUES (
		5, 'ma', '10:45', '11:45', 20, 3, 2
	);
	INSERT INTO ljtunti VALUES (
		6, 'pe', '14:00', '15:20', 20, 1, 2
	);
	

CREATE TABLE sali (
	stunnus INT,
	snimi VARCHAR(30) NOT NULL,
	paikkalkm INT,
	PRIMARY KEY(stunnus),
	UNIQUE(snimi)
	);

	
	INSERT INTO sali VALUES (
		1, 'Sali 1', 25
	);
	
	INSERT INTO sali VALUES (
		2, 'Spinning sali', 20
	);
	
	INSERT INTO sali VALUES (
		3, 'Sali 3', 20
	);
	
	
	"QUERY 1"
	SELECT lj.viikonpaiva, lj.alkamisaika, rl.rlnimi, rl.kesto
	FROM ljtunti lj, rltunti rl, kategoria k
	WHERE lj.rltunnus = rl.rltunnus
	AND rl.ktunnus = k.ktunnus
	AND knimi = 'Kehonhuolto'
	ORDER BY viikonpaiva, alkamisaika, rlnimi ASC;
	
	"QUERY 2"
	SELECT lj.viikonpaiva, lj.alkamisaika, rl.rlnimi, rl.kesto, rl.taso
	FROM ljtunti lj, rltunti rl, kategoria k
	WHERE lj.rltunnus = rl.rltunnus
	AND rl.ktunnus = k.ktunnus
	AND knimi = 'Kehonhuolto'
	AND (rl.taso >= 2 OR rl.kesto >= 60)
	ORDER BY viikonpaiva, alkamisaika, rlnimi ASC;
	
	"QUERY 3"
	SELECT rlnimi, kesto
	FROM rltunti
	WHERE kesto = (SELECT MIN(kesto)
				FROM rltunti)
	ORDER BY rlnimi ASC;
	
	"QUERY 4"
	SELECT rlnimi, kesto, knimi
	FROM rltunti rl, kategoria k
	WHERE kesto = (SELECT MIN(kesto)
				FROM rltunti)
	AND rl.ktunnus = k.ktunnus
	ORDER BY rlnimi ASC;
	
	"QUERY 5"
	SELECT rlnimi, kesto, knimi
	FROM rltunti, kategoria
	WHERE kesto = (SELECT MIN(kesto)
				FROM rltunti, kategoria
				WHERE rltunti.ktunnus = kategoria.ktunnus
				AND knimi = 'Kehonhuolto')
	AND rltunti.ktunnus = kategoria.ktunnus
	ORDER BY rlnimi ASC;
	
	"QUERY 6"
	SELECT DISTINCT o.otunnus, onimi
	FROM ohjaaja o, voi_ohjata vo, kategoria k, rltunti rl
	WHERE o.otunnus = vo.otunnus
	AND vo.rltunnus = rl.rltunnus
	AND rl.ktunnus = k.ktunnus
	AND k.knimi = (SELECT knimi 
				FROM kategoria 
				WHERE knimi = 'Kehonhuolto')
	INTERSECT 
	SELECT DISTINCT o.otunnus, onimi
	FROM ohjaaja o, voi_ohjata vo, kategoria k, rltunti rl
	WHERE o.otunnus = vo.otunnus
	AND vo.rltunnus = rl.rltunnus
	AND rl.ktunnus = k.ktunnus
	AND k.knimi = (SELECT knimi 
				FROM kategoria 
				WHERE knimi = 'Spinning')
	ORDER BY o.otunnus ASC;
	
	"QUERY 7"
	SELECT knimi, count(*) AS lkm, MIN(kesto) AS minkesto, MAX(kesto) AS maxkesto
	FROM rltunti, kategoria
	WHERE rltunti.ktunnus = kategoria.ktunnus
	GROUP BY rltunti.ktunnus
	ORDER BY kategoria.knimi ASC;
	
	
	
	