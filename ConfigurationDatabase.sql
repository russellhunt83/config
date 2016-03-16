-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Config
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Config
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Config` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema documenter_test
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema documenter_test
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `documenter_test` DEFAULT CHARACTER SET latin1 ;
USE `Config` ;

-- -----------------------------------------------------
-- Table `Config`.`AttributeGroup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`AttributeGroup` (
  `AttributeGroupID` INT(11) NOT NULL AUTO_INCREMENT,
  `AttributeGroupName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`AttributeGroupID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`DataType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`DataType` (
  `DataTypeID` INT(11) NOT NULL AUTO_INCREMENT,
  `DataTypeName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`DataTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`Attribute`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`Attribute` (
  `AttributeID` INT(11) NOT NULL AUTO_INCREMENT,
  `DataSourceID` INT(11) NULL DEFAULT NULL,
  `DataTypeID` INT(11) NOT NULL,
  `DataURIID` INT(11) NOT NULL,
  `AttributeGroupID` INT(11) NOT NULL,
  `AttributeName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`AttributeID`),
  INDEX `fk_from_datatype_idx` (`DataTypeID` ASC),
  INDEX `fk_from_attribute_group_idx` (`AttributeGroupID` ASC),
  CONSTRAINT `fk_from_attribute_group`
    FOREIGN KEY (`AttributeGroupID`)
    REFERENCES `Config`.`AttributeGroup` (`AttributeGroupID`),
  CONSTRAINT `fk_from_datatype`
    FOREIGN KEY (`DataTypeID`)
    REFERENCES `Config`.`DataType` (`DataTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`ConfigJob`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`ConfigJob` (
  `ConfigJobID` INT(11) NOT NULL AUTO_INCREMENT,
  `JobNamed` VARCHAR(45) NOT NULL,
  `KjbFile` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ConfigJobID`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`AuditHistory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`AuditHistory` (
  `AuditHistoryId` INT(11) NOT NULL AUTO_INCREMENT,
  `ConfigJobID` INT(11) NOT NULL,
  `StartDateTime` DATETIME NOT NULL,
  `EndDateTime` DATETIME NULL DEFAULT NULL,
  `EventType` VARCHAR(45) NULL DEFAULT NULL,
  `Success` TINYINT(1) NOT NULL DEFAULT '0',
  `Details` VARCHAR(5000) NOT NULL,
  PRIMARY KEY (`AuditHistoryId`),
  INDEX `fk_from_transformation_id_idx` (`ConfigJobID` ASC),
  CONSTRAINT `fk_from_config_id`
    FOREIGN KEY (`ConfigJobID`)
    REFERENCES `Config`.`ConfigJob` (`ConfigJobID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`DataProvider`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`DataProvider` (
  `DataProviderID` INT(11) NOT NULL AUTO_INCREMENT,
  `DataProviderName` VARCHAR(255) NOT NULL,
  `URL` VARCHAR(1000) NULL DEFAULT NULL,
  `Username` VARCHAR(255) NULL DEFAULT NULL,
  `Password` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`DataProviderID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`DatasourceType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`DatasourceType` (
  `DatasourceTypeID` INT(11) NOT NULL AUTO_INCREMENT,
  `DatasourceTypeName` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`DatasourceTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`FrequencyType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`FrequencyType` (
  `FrequencyTypeID` INT(11) NOT NULL AUTO_INCREMENT,
  `FrequencyTypeValue` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`FrequencyTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`Frequency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`Frequency` (
  `FrequencyID` INT(11) NOT NULL AUTO_INCREMENT,
  `measurement` INT(11) NULL DEFAULT NULL,
  `FrequencyTypeID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`FrequencyID`),
  INDEX `fk_Frequency_FrequencyType1_idx` (`FrequencyTypeID` ASC),
  CONSTRAINT `fk_Frequency_FrequencyType1`
    FOREIGN KEY (`FrequencyTypeID`)
    REFERENCES `Config`.`FrequencyType` (`FrequencyTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`DataSource`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`DataSource` (
  `DataSourceID` INT(11) NOT NULL AUTO_INCREMENT,
  `DataProviderID` INT(11) NOT NULL,
  `DatasourceTypeID` INT(11) NOT NULL,
  `DatasourceName` VARCHAR(45) NOT NULL,
  `FrequencyID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`DataSourceID`),
  INDEX `fk_from_data_provider_idx` (`DataProviderID` ASC),
  INDEX `fk_from_datasource_idx` (`DatasourceTypeID` ASC),
  INDEX `fk_from_frequency_idx` (`FrequencyID` ASC),
  CONSTRAINT `DataSource_fk_from_data_provider`
    FOREIGN KEY (`DataProviderID`)
    REFERENCES `Config`.`DataProvider` (`DataProviderID`),
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
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`JobSchedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`JobSchedule` (
  `JobScheduleID` INT(11) NOT NULL AUTO_INCREMENT,
  `ConfigJobID` INT(11) NOT NULL,
  `ScheduleJobName` VARCHAR(255) NOT NULL,
  `JobStartTime` TIME NOT NULL,
  `JobFrequency` INT(11) NOT NULL,
  PRIMARY KEY (`JobScheduleID`),
  UNIQUE INDEX `schedule_job_name_UNIQUE` (`ScheduleJobName` ASC),
  INDEX `fk_from_configjob_idx` (`ConfigJobID` ASC),
  INDEX `fk_from_Frequency_idx` (`JobFrequency` ASC),
  CONSTRAINT `fk_from_Frequency`
    FOREIGN KEY (`JobFrequency`)
    REFERENCES `Config`.`Frequency` (`FrequencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_from_configjob_To_JobSchedule`
    FOREIGN KEY (`ConfigJobID`)
    REFERENCES `Config`.`ConfigJob` (`ConfigJobID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`JobToDataProvider`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`JobToDataProvider` (
  `JobToDatasourceID` INT(11) NOT NULL AUTO_INCREMENT,
  `ConfigJobID` INT(11) NOT NULL,
  `DataProviderID` INT(11) NULL DEFAULT NULL,
  `IsActive` TINYINT(1) NOT NULL DEFAULT '0',
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
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`MappedAttribute`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`MappedAttribute` (
  `MappedAttributeID` INT(11) NOT NULL AUTO_INCREMENT,
  `AttributeID` INT(11) NOT NULL,
  `MappedFieldID` INT(11) NOT NULL,
  `Priority` INT(11) NOT NULL,
  `IsActive` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`MappedAttributeID`),
  INDEX `fk_attr_id_from_attribute_idx` (`AttributeID` ASC),
  CONSTRAINT `fk_attr_id_from_attribute`
    FOREIGN KEY (`AttributeID`)
    REFERENCES `Config`.`Attribute` (`AttributeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`MappedTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`MappedTable` (
  `MappedTableID` INT(11) NOT NULL AUTO_INCREMENT,
  `MappedTableName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MappedTableID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`MappedField`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`MappedField` (
  `MappedFieldID` INT(11) NOT NULL AUTO_INCREMENT,
  `MappedTableID` INT(11) NOT NULL,
  `MappedFieldName` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MappedFieldID`),
  INDEX `fk_mtid_from_mappedtable_idx` (`MappedTableID` ASC),
  CONSTRAINT `fk_mtid_from_mappedtable`
    FOREIGN KEY (`MappedTableID`)
    REFERENCES `Config`.`MappedTable` (`MappedTableID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Config`.`MappedTransform`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Config`.`MappedTransform` (
  `MappedTransformID` INT(11) NOT NULL AUTO_INCREMENT,
  `MappedAttributeID` INT(11) NOT NULL,
  `MappedFieldID` INT(11) NOT NULL,
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
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `documenter_test` ;

-- -----------------------------------------------------
-- Table `documenter_test`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `documenter_test`.`customer` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `forename` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NULL DEFAULT NULL,
  `comments` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `documenter_test` ;

-- -----------------------------------------------------
-- procedure CreateExtendedProperty
-- -----------------------------------------------------

DELIMITER $$
USE `documenter_test`$$
CREATE DEFINER=`root`@`%` PROCEDURE `CreateExtendedProperty`(in param_name varchar(30), in param_value text, in param_schema_name varchar(50), in param_table_name varchar(100), in param_column_name varchar(100))
BEGIN
	
    IF param_column_name = '' THEN
		IF EXISTS (SELECT * FROM configuration_live.extended_properties WHERE table_schema = param_schema_name AND table_name = param_table_name AND column_name IS NULL AND name = param_name) THEN
			UPDATE
				configuration_live.extended_properties
			SET
				value = param_value
			WHERE
				table_schema = param_schema_name AND
				table_name = param_table_name AND 
                column_name IS NULL AND
				name = param_name;
		ELSE
			INSERT INTO
				configuration_live.extended_properties(table_schema, table_name, name, value)
			VALUES
				(param_schema_name, param_table_name, param_name, param_value);
		END IF;
        
	ELSE
    
		IF EXISTS (SELECT * FROM configuration_live.extended_properties WHERE table_schema = param_schema_name AND table_name = param_table_name AND column_name = param_column_name AND name = param_name) THEN
			UPDATE
				configuration_live.extended_properties
			SET
				value = param_value
			WHERE
				table_schema = param_schema_name AND
				table_name = param_table_name AND 
				column_name = param_column_name AND 
				name = param_name;
		ELSE
			INSERT INTO
				configuration_live.extended_properties(table_schema, table_name, column_name, name, value)
			VALUES
				(param_schema_name, param_table_name, param_column_name, param_name, param_value);
		END IF;
        
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DropExtendedProperty
-- -----------------------------------------------------

DELIMITER $$
USE `documenter_test`$$
CREATE DEFINER=`root`@`%` PROCEDURE `DropExtendedProperty`(in param_name VARCHAR(30), in param_schema_name VARCHAR(50), in param_table_name VARCHAR(100), in param_column_name VARCHAR(100))
BEGIN

	IF param_column_name = '' THEN
		DELETE FROM
			configuration_live.extended_properties
		WHERE
			table_schema = param_schema_name AND
			table_name = param_table_name AND
			column_name IS NULL AND
			name = param_name;
	ELSE
		DELETE FROM
			configuration_live.extended_properties
		WHERE
			table_schema = param_schema_name AND
			table_name = param_table_name AND
			column_name = param_column_name AND
			name = param_name;
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetColumnDetailsForObject
-- -----------------------------------------------------

DELIMITER $$
USE `documenter_test`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetColumnDetailsForObject`(in param_schema_name VARCHAR(50), in param_object_name VARCHAR(100))
BEGIN

	SELECT 
		c.COLUMN_NAME AS 'Column Name',
		CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN CONCAT(UPPER(c.DATA_TYPE), '(', c.CHARACTER_MAXIMUM_LENGTH, ')')
			 WHEN c.DATA_TYPE IN ('numeric', 'decimal', 'float', 'double') THEN CONCAT(UPPER(c.DATA_TYPE), '(', c.NUMERIC_PRECISION, ',', c.NUMERIC_SCALE, ')')
			 ELSE UPPER(c.DATA_TYPE) END AS 'Data Type',
		c.IS_NULLABLE AS 'IsNullable?',
		CASE WHEN k.CONSTRAINT_NAME IS NULL THEN 'NO' ELSE 'YES' END AS 'Primary Key?',
		cd.Description,
		ed.ExpandedDescription
	FROM
		INFORMATION_SCHEMA.COLUMNS c
	LEFT JOIN
	(
		SELECT DISTINCT
			TC.TABLE_SCHEMA,
			TC.TABLE_NAME,
			KCU.CONSTRAINT_NAME,
			KCU.COLUMN_NAME
		FROM 
			INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
		INNER JOIN 
			INFORMATION_SCHEMA.KEY_COLUMN_USAGE As KCU
		ON 
			KCU.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
		WHERE
			TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
		) k
	ON
		k.table_schema = c.table_schema AND
		k.table_name = c.table_name AND
		k.column_name = c.column_name
	LEFT JOIN
	(
		SELECT
			table_schema,
			table_name,
			column_name,
			value AS Description
		FROM
			configuration_live.extended_properties
		WHERE
			name = 'Description'
	) cd
	ON
		c.table_schema = cd.table_schema AND
		c.table_name = cd.table_name AND
		c.column_name = cd.column_name
	LEFT JOIN
	(
		SELECT
			table_schema,
			table_name,
			column_name,
			value AS ExpandedDescription
		FROM
			configuration_live.extended_properties
		WHERE
			name = 'ExpandedDescription'
	) ed
	ON
		c.table_schema = ed.table_schema AND
		c.table_name = ed.table_name AND
		c.column_name = ed.column_name
	WHERE
		c.table_schema = param_schema_name AND
		c.table_name = param_object_name
	ORDER BY
		c.ORDINAL_POSITION;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetObjectListForDocumentation
-- -----------------------------------------------------

DELIMITER $$
USE `documenter_test`$$
CREATE DEFINER=`root`@`%` PROCEDURE `GetObjectListForDocumentation`(in param_schema_name VARCHAR(50), in param_object_name VARCHAR(100))
BEGIN

	SELECT
		ep_doc.table_schema,
		ep_doc.table_name,
		ep.value
	FROM
		(
			SELECT
				table_schema,
                table_name
			FROM
                configuration_live.extended_properties
			WHERE
				name = 'Document' AND
                value = 'Yes'
		) ep_doc
	LEFT JOIN
		configuration_live.extended_properties ep
	ON
		ep.table_schema = ep_doc.table_schema AND
		ep.table_name = ep_doc.table_name AND
		ep.column_name IS NULL AND
		ep.name = 'Description'
	WHERE
		(param_schema_name = '' OR 
		param_object_name = '') 
		OR
		(ep.table_schema = param_schema_name AND
		ep.table_name = param_object_name);
        
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
