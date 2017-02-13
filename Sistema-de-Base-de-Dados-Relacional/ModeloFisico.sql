-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Comboios
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Comboios
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Comboios` DEFAULT CHARACTER SET utf8 ;
USE `Comboios` ;

-- -----------------------------------------------------
-- Table `Comboios`.`Passageiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comboios`.`Passageiro` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `PalavraPasse` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Comboios`.`Estacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comboios`.`Estacao` (
  `ID` INT NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Comboios`.`Comboio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comboios`.`Comboio` (
  `ID` INT NOT NULL,
  `Observacoes` TEXT(1000) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Comboios`.`LugarComboio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comboios`.`LugarComboio` (
  `NumeroLugar` INT NOT NULL,
  `Comboio_ID` INT NOT NULL,
  PRIMARY KEY (`NumeroLugar`, `Comboio_ID`),
  INDEX `fk_LugarComboio_Comboio1_idx` (`Comboio_ID` ASC),
  CONSTRAINT `fk_LugarComboio_Comboio1`
    FOREIGN KEY (`Comboio_ID`)
    REFERENCES `Comboios`.`Comboio` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Comboios`.`Viagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comboios`.`Viagem` (
  `ID` INT NOT NULL,
  `Comboio_ID` INT NOT NULL,
  `HoraPartida` TIME(0) NOT NULL,
  `Origem` INT NOT NULL,
  `Destino` INT NOT NULL,
  `HoraChegada` TIME(0) NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Viagem_Comboio1_idx` (`Comboio_ID` ASC),
  INDEX `fk_Viagem_Estação1_idx` (`Origem` ASC),
  INDEX `fk_Viagem_Estação2_idx` (`Destino` ASC),
  CONSTRAINT `fk_Viagem_Comboio1`
    FOREIGN KEY (`Comboio_ID`)
    REFERENCES `Comboios`.`Comboio` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Viagem_Estação1`
    FOREIGN KEY (`Origem`)
    REFERENCES `Comboios`.`Estacao` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Viagem_Estação2`
    FOREIGN KEY (`Destino`)
    REFERENCES `Comboios`.`Estacao` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Comboios`.`Bilhete`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comboios`.`Bilhete` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Passageiro_ID` INT NOT NULL,
  `Viagem_ID` INT NOT NULL,
  `DataViagem` DATE NOT NULL,
  `LugarComboio_NumeroLugar` INT NOT NULL,
  `LugarComboio_Comboio_ID` INT NOT NULL,
  PRIMARY KEY (`ID`),
  INDEX `fk_Reserva_Cliente_idx` (`Passageiro_ID` ASC),
  INDEX `fk_Reserva_Viagem1_idx` (`Viagem_ID` ASC),
  INDEX `fk_Reserva_LugarComboio1_idx` (`LugarComboio_NumeroLugar` ASC, `LugarComboio_Comboio_ID` ASC),
  CONSTRAINT `fk_Reserva_Cliente`
    FOREIGN KEY (`Passageiro_ID`)
    REFERENCES `Comboios`.`Passageiro` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Reserva_Viagem1`
    FOREIGN KEY (`Viagem_ID`)
    REFERENCES `Comboios`.`Viagem` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Reserva_LugarComboio1`
    FOREIGN KEY (`LugarComboio_NumeroLugar` , `LugarComboio_Comboio_ID`)
    REFERENCES `Comboios`.`LugarComboio` (`NumeroLugar` , `Comboio_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
