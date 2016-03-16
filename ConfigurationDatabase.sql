-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Config
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Config` ;

-- -----------------------------------------------------
-- Schema Config
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Config` DEFAULT CHARACTER SET utf8 ;
USE `Config` ;

-- -----------------------------------------------------
-- Table `Config`.`ConfigJob`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`ConfigJob` ;

CREATE TABLE IF NOT EXISTS `Config`.`ConfigJob` (
  `ConfigJobID` INT NOT NULL AUTO_INCREMENT,
  `JobNamed` VARCHAR(45) NOT NULL,
  `KjbFile` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ConfigJobID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`FrequencyType`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`FrequencyType` ;

CREATE TABLE IF NOT EXISTS `Config`.`FrequencyType` (
  `FrequencyTypeID` INT NOT NULL AUTO_INCREMENT,
  `FrequencyTypeValue` VARCHAR(255) NULL,
  PRIMARY KEY (`FrequencyTypeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`Frequency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`Frequency` ;

CREATE TABLE IF NOT EXISTS `Config`.`Frequency` (
  `FrequencyID` INT NOT NULL AUTO_INCREMENT,
  `measurement` INT NULL,
  `FrequencyTypeID` INT NULL,
  PRIMARY KEY (`FrequencyID`),
  INDEX `fk_Frequency_FrequencyType1_idx` (`FrequencyTypeID` ASC),
  CONSTRAINT `fk_Frequency_FrequencyType1`
    FOREIGN KEY (`FrequencyTypeID`)
    REFERENCES `Config`.`FrequencyType` (`FrequencyTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`JobSchedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`JobSchedule` ;

CREATE TABLE IF NOT EXISTS `Config`.`JobSchedule` (
  `JobScheduleID` INT NOT NULL AUTO_INCREMENT,
  `ConfigJobID` INT NOT NULL,
  `ScheduleJobName` VARCHAR(255) NOT NULL,
  `JobStartTime` TIME NOT NULL,
  `JobFrequency` INT NOT NULL,
  PRIMARY KEY (`JobScheduleID`),
  UNIQUE INDEX `schedule_job_name_UNIQUE` (`ScheduleJobName` ASC),
  INDEX `fk_from_configjob_idx` (`ConfigJobID` ASC),
  INDEX `fk_from_Frequency_idx` (`JobFrequency` ASC),
  CONSTRAINT `fk_from_configjob_To_JobSchedule`
    FOREIGN KEY (`ConfigJobID`)
    REFERENCES `Config`.`ConfigJob` (`ConfigJobID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_from_Frequency`
    FOREIGN KEY (`JobFrequency`)
    REFERENCES `Config`.`Frequency` (`FrequencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`AuditHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`AuditHistory` ;

CREATE TABLE IF NOT EXISTS `Config`.`AuditHistory` (
  `AuditHistoryId` INT NOT NULL AUTO_INCREMENT,
  `ConfigJobID` INT NOT NULL,
  `StartDateTime` DATETIME NOT NULL,
  `EndDateTime` DATETIME NULL,
  `EventType` VARCHAR(45) NULL,
  `Success` TINYINT(1) NOT NULL DEFAULT 0,
  `Details` VARCHAR(5000) NOT NULL,
  PRIMARY KEY (`AuditHistoryId`),
  INDEX `fk_from_transformation_id_idx` (`ConfigJobID` ASC),
  CONSTRAINT `fk_from_config_id`
    FOREIGN KEY (`ConfigJobID`)
    REFERENCES `Config`.`ConfigJob` (`ConfigJobID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`DataProvider`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`DataProvider` ;

CREATE TABLE IF NOT EXISTS `Config`.`DataProvider` (
  `DataProviderID` INT NOT NULL AUTO_INCREMENT,
  `DataProviderName` VARCHAR(255) NOT NULL,
  `URL` VARCHAR(1000) NULL,
  `Username` VARCHAR(255) NULL,
  `Password` VARCHAR(255) NULL,
  PRIMARY KEY (`DataProviderID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`JobToDataProvider`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`JobToDataProvider` ;

CREATE TABLE IF NOT EXISTS `Config`.`JobToDataProvider` (
  `JobToDatasourceID` INT NOT NULL AUTO_INCREMENT,
  `ConfigJobID` INT NOT NULL,
  `DataProviderID` INT NULL,
  `IsActive` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`JobToDatasourceID`),
  INDEX `IDXConfigJobID` (`ConfigJobID` ASC),
  INDEX `IDXDatasourceID` (`DataProviderID` ASC),
  CONSTRAINT `fk_from_ConfigJob_to_JobToDatasource`
    FOREIGN KEY (`ConfigJobID`)
    REFERENCES `Config`.`ConfigJob` (`ConfigJobID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_from_DataProvider_to_JobToDataProvider`
    FOREIGN KEY (`DataProviderID`)
    REFERENCES `Config`.`DataProvider` (`DataProviderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`DatasourceType`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`DatasourceType` ;

CREATE TABLE IF NOT EXISTS `Config`.`DatasourceType` (
  `DatasourceTypeID` INT NOT NULL AUTO_INCREMENT,
  `DatasourceTypeName` VARCHAR(255) NULL,
  PRIMARY KEY (`DatasourceTypeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`DataSource`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`DataSource` ;

CREATE TABLE IF NOT EXISTS `Config`.`DataSource` (
  `DataSourceID` INT NOT NULL AUTO_INCREMENT,
  `DataProviderID` INT NOT NULL,
  `DatasourceTypeID` INT NOT NULL,
  `DatasourceName` VARCHAR(45) NOT NULL,
  `FrequencyID` INT NULL,
  PRIMARY KEY (`DataSourceID`),
  INDEX `fk_from_data_provider_idx` (`DataProviderID` ASC),
  INDEX `fk_from_datasource_idx` (`DatasourceTypeID` ASC),
  INDEX `fk_from_frequency_idx` (`FrequencyID` ASC),
  CONSTRAINT `DataSource_fk_from_data_provider`
    FOREIGN KEY (`DataProviderID`)
    REFERENCES `Config`.`DataProvider` (`DataProviderID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `DataSource_fk_from_datasourceType`
    FOREIGN KEY (`DatasourceTypeID`)
    REFERENCES `Config`.`DatasourceType` (`DatasourceTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `DataSource_fk_from_frequency`
    FOREIGN KEY (`FrequencyID`)
    REFERENCES `Config`.`Frequency` (`FrequencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`DataType`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`DataType` ;

CREATE TABLE IF NOT EXISTS `Config`.`DataType` (
  `DataTypeID` INT NOT NULL AUTO_INCREMENT,
  `DataTypeName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`DataTypeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`AttributeGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`AttributeGroup` ;

CREATE TABLE IF NOT EXISTS `Config`.`AttributeGroup` (
  `AttributeGroupID` INT NOT NULL AUTO_INCREMENT,
  `AttributeGroupName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`AttributeGroupID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`DataURI`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`DataURI` ;

CREATE TABLE IF NOT EXISTS `Config`.`DataURI` (
  `DataURIID` INT NOT NULL AUTO_INCREMENT,
  `DataSourceID` INT NULL,
  `AttributeID` INT NULL,
  `DataURIName` VARCHAR(255) NULL,
  PRIMARY KEY (`DataURIID`),
  INDEX `fk_DataURI_DataSource1_idx` (`DataSourceID` ASC),
  CONSTRAINT `fk_DataURI_DataSource`
    FOREIGN KEY (`DataSourceID`)
    REFERENCES `Config`.`DataSource` (`DataSourceID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'For Spreadsheet, Database Table, API Endpoint information';


-- -----------------------------------------------------
-- Table `Config`.`Attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`Attribute` ;

CREATE TABLE IF NOT EXISTS `Config`.`Attribute` (
  `AttributeID` INT NOT NULL AUTO_INCREMENT,
  `DataSourceID` INT NULL,
  `DataTypeID` INT NOT NULL,
  `DataURIID` INT NOT NULL,
  `AttributeGroupID` INT NOT NULL,
  `AttributeName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`AttributeID`),
  INDEX `fk_from_datatype_idx` (`DataTypeID` ASC),
  INDEX `fk_from_attribute_group_idx` (`AttributeGroupID` ASC),
  INDEX `fk_Attribute_DataURI_idx` (`DataURIID` ASC),
  CONSTRAINT `fk_from_datatype`
    FOREIGN KEY (`DataTypeID`)
    REFERENCES `Config`.`DataType` (`DataTypeID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_from_attribute_group`
    FOREIGN KEY (`AttributeGroupID`)
    REFERENCES `Config`.`AttributeGroup` (`AttributeGroupID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Attribute_DataURI`
    FOREIGN KEY (`DataURIID`)
    REFERENCES `Config`.`DataURI` (`DataURIID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`MappedAttribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`MappedAttribute` ;

CREATE TABLE IF NOT EXISTS `Config`.`MappedAttribute` (
  `MappedAttributeID` INT NOT NULL AUTO_INCREMENT,
  `AttributeID` INT NOT NULL,
  `MappedFieldID` INT NOT NULL,
  `Priority` INT NOT NULL,
  `IsActive` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`MappedAttributeID`),
  INDEX `fk_attr_id_from_attribute_idx` (`AttributeID` ASC),
  CONSTRAINT `fk_attr_id_from_attribute`
    FOREIGN KEY (`AttributeID`)
    REFERENCES `Config`.`Attribute` (`AttributeID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`MappedTable`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`MappedTable` ;

CREATE TABLE IF NOT EXISTS `Config`.`MappedTable` (
  `MappedTableID` INT NOT NULL AUTO_INCREMENT,
  `MappedTableName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MappedTableID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`MappedField`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`MappedField` ;

CREATE TABLE IF NOT EXISTS `Config`.`MappedField` (
  `MappedFieldID` INT NOT NULL AUTO_INCREMENT,
  `MappedTableID` INT NOT NULL,
  `MappedFieldName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MappedFieldID`),
  INDEX `fk_mtid_from_mappedtable_idx` (`MappedTableID` ASC),
  CONSTRAINT `fk_mtid_from_mappedtable`
    FOREIGN KEY (`MappedTableID`)
    REFERENCES `Config`.`MappedTable` (`MappedTableID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Config`.`MappedTransform`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`MappedTransform` ;

CREATE TABLE IF NOT EXISTS `Config`.`MappedTransform` (
  `MappedTransformID` INT NOT NULL AUTO_INCREMENT,
  `MappedAttributeID` INT NOT NULL,
  `MappedFieldID` INT NOT NULL,
  PRIMARY KEY (`MappedTransformID`),
  INDEX `fk_MappedTransform_MappedAttribute1_idx` (`MappedAttributeID` ASC),
  INDEX `fk_MappedTransform_MappedField1_idx` (`MappedFieldID` ASC),
  CONSTRAINT `fk_MappedTransform_MappedAttribute1`
    FOREIGN KEY (`MappedAttributeID`)
    REFERENCES `Config`.`MappedAttribute` (`MappedAttributeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MappedTransform_MappedField1`
    FOREIGN KEY (`MappedFieldID`)
    REFERENCES `Config`.`MappedField` (`MappedFieldID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Config`.`TestTable1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Config`.`TestTable1` ;

CREATE TABLE IF NOT EXISTS `Config`.`TestTable1` (
  `idTestTable1` INT NOT NULL,
  PRIMARY KEY (`idTestTable1`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
