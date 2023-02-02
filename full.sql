SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE SCHEMA IF NOT EXISTS `data_warehousing` DEFAULT CHARACTER SET utf16 ;
USE `data_warehousing` ;

DROP TABLE IF EXISTS `data_warehousing`.`facts` ;

CREATE TABLE IF NOT EXISTS `data_warehousing`.`facts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `anzahl` INT NULL,
  `umsatz` DOUBLE NULL,
  `gewinn` DOUBLE NULL,
  `filialen_id` INT NOT NULL,
  `quartal_id` INT NOT NULL,
  `artikel_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_facts_filialen_idx` (`filialen_id` ASC),
  INDEX `fk_facts_quartal1_idx` (`quartal_id` ASC),
  INDEX `fk_facts_artikel1_idx` (`artikel_id` ASC),
  CONSTRAINT `fk_facts_filialen`
    FOREIGN KEY (`filialen_id`)
    REFERENCES `data_warehousing`.`filialen` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facts_quartal1`
    FOREIGN KEY (`quartal_id`)
    REFERENCES `data_warehousing`.`quartal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_facts_artikel1`
    FOREIGN KEY (`artikel_id`)
    REFERENCES `data_warehousing`.`artikel` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `data_warehousing`.`filialen` ;

CREATE TABLE IF NOT EXISTS `data_warehousing`.`filialen` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `filiale_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`filiale_name` ASC))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `data_warehousing`.`quartal` ;

CREATE TABLE IF NOT EXISTS `data_warehousing`.`quartal` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quartal_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `quartal_UNIQUE` (`quartal_name` ASC))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `data_warehousing`.`artikel` ;

CREATE TABLE IF NOT EXISTS `data_warehousing`.`artikel` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `artikel_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `artikelname_UNIQUE` (`artikel_name` ASC))
ENGINE = InnoDB;



DROP TABLE IF EXISTS `data_warehousing`.`import_rohdaten` ;

CREATE TABLE IF NOT EXISTS `data_warehousing`.`import_rohdaten` (
  `Filialen` VARCHAR(45) NULL,
  `Quartal` VARCHAR(45) NULL,
  `Artikel` VARCHAR(45) NULL,
  `Anzahl` INT NULL,
  `Umsatz` DOUBLE NULL,
  `Gewinn` DOUBLE NULL)
ENGINE = InnoDB;
LOAD DATA INFILE '/opt/lampp/var/mysql/datawarehouse/RohdatenDataWareHouse.csv'

INTO TABLE data_warehousing.import_rohdaten
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

INSERT IGNORE INTO filialen (filiale_name)
select Distinct Filialen from import_rohdaten;

INSERT IGNORE INTO quartal (quartal_name)
SELECT DISTINCT Quartal FROM import_rohdaten;

INSERT IGNORE INTO artikel (artikel_name)
SELECT DISTINCT Artikel FROM import_rohdaten;

INSERT INTO facts (anzahl, umsatz, gewinn, filialen_id, quartal_id, artikel_id)

SELECT Anzahl, Umsatz, Gewinn,
(SELECT filialen.id FROM filialen WHERE filialen.filiale_name = import_rohdaten.Filialen),
(SELECT quartal.id FROM quartal WHERE quartal.quartal_name = import_rohdaten.Quartal),
(Select artikel.id FROM artikel WHERE artikel.artikel_name = import_rohdaten.Artikel)
FROM import_rohdaten;

DROP VIEW IF EXISTS vw_data_warehousing; 
CREATE VIEW vw_data_warehousing AS
SELECT
facts.anzahl AS Anzahl,
facts.umsatz AS Umsatz,
facts.gewinn AS Gewinn,
filialen.filiale_name AS Filiale,
artikel.artikel_name AS Artikel,
quartal.quartal_name AS Quartal

FROM facts
JOIN filialen ON filialen.id = facts.filialen_id
JOIN artikel ON artikel.id = facts.artikel_id
JOIN quartal ON quartal.id = facts.quartal_id