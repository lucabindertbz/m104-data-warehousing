LOAD DATA INFILE '/opt/lampp/var/mysql/datawarehouse/RohdatenDataWareHouse.csv'

INTO TABLE data_warehousing.import_rohdaten
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

Insert into filialen (filiale_name)
select Distinct Filialen from import_rohdaten

INSERT INTO quartal (quartal_name)
SELECT DISTINCT Quartal FROM import_rohdaten

INSERT INTO artikel (artikel_name)
SELECT DISTINCT Artikel FROM import_rohdaten



INSERT INTO facts (anzahl, umsatz, gewinn, filialen_id, quartal_id, artikel_id)

SELECT Anzahl, Umsatz, Gewinn,
(SELECT filialen.id FROM filialen WHERE filialen.filiale_name = import_rohdaten.Filialen),
(SELECT quartal.id FROM quartal WHERE quartal.quartal_name = import_rohdaten.Quartal),
(Select artikel.id FROM artikel WHERE artikel.artikel_name = import_rohdaten.Artikel)
FROM import_rohdaten
