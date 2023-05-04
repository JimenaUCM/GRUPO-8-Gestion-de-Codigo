CREATE SCHEMA `bd-ucmrails` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `bd-ucmrails`;

CREATE TABLE `bd-ucmrails`.`estacion` (
  `nombre` VARCHAR(40) NOT NULL,
  `localidad` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`nombre`, `localidad`)
);

CREATE TABLE `bd-ucmrails`.`ruta` (
  `nombre` VARCHAR(50) NOT NULL,
  `precio` INT NOT NULL,
  `estacionorigen` VARCHAR(40) NOT NULL,
  `estaciondestino` VARCHAR(40) NOT NULL,
  `localidadorigen` VARCHAR(40) NOT NULL,
  `localidaddestino` VARCHAR(40) NOT NULL,
  `duracionminutos` INT NOT NULL,
  PRIMARY KEY (`nombre`),
  INDEX `EstacionOrigen_idx` (`estacionorigen` ASC) VISIBLE,
  INDEX `EstacionDestino_idx` (`estaciondestino` ASC) VISIBLE,
  CONSTRAINT `EstacionOrigen`
    FOREIGN KEY (`estacionorigen`, `localidadorigen`)
    REFERENCES `bd-ucmrails`.`estacion` (`nombre`, `localidad`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `EstacionDestino`
    FOREIGN KEY (`estaciondestino`, `localidaddestino`)
    REFERENCES `bd-ucmrails`.`estacion` (`nombre`, `localidad`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE `bd-ucmrails`.`tren` (
  `id` VARCHAR(15) NOT NULL,
  `tipotren` INT NULL,
  `horasalida` DATETIME NOT NULL,
  `ruta` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `ruta`
    FOREIGN KEY (`ruta`)
    REFERENCES `bd-ucmrails`.`ruta` (`nombre`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE `bd-ucmrails`.`usuario` (
  `dni` varchar(9) NOT NULL,
  `nombre` varchar(15) NOT NULL,
  `apellidos` varchar(40) NOT NULL,
  `contraseña` varchar(40) NOT NULL,
  PRIMARY KEY (`dni`)
);

CREATE TABLE `bd-ucmrails`.`cliente` (
  `dni` VARCHAR(9) NOT NULL,
  `saldo` INT NOT NULL,
  PRIMARY KEY (`dni`),
  CONSTRAINT `DNI_CLIENTE`
    FOREIGN KEY (`dni`)
    REFERENCES `bd-ucmrails`.`usuario` (`dni`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE `bd-ucmrails`.`administradores` (
  `dni` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`dni`),
  CONSTRAINT `DNI_ADMIN`
    FOREIGN KEY (`dni`)
    REFERENCES `bd-ucmrails`.`usuario` (`dni`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE `bd-ucmrails`.`billete` (
  `numeroasiento` INT NOT NULL,
  `idtren` VARCHAR(15) NOT NULL,
  `fecha` DATE NOT NULL,
  `valoracion` INT NULL,
  `idcliente` VARCHAR(9) NULL,
  `estadisponible` TINYINT NOT NULL,
  PRIMARY KEY (`numeroasiento`, `idtren`),
  INDEX `id_idx` (`idtren` ASC) VISIBLE,
  CONSTRAINT `idtren`
    FOREIGN KEY (`idtren`)
    REFERENCES `bd-ucmrails`.`tren` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `DNI_Cliente_Billete`
    FOREIGN KEY (`idcliente`)
    REFERENCES `bd-ucmrails`.`cliente` (`dni`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE `bd-ucmrails`.`servicios` (
  `nombre` VARCHAR(25) NOT NULL,
  `precio` INT NOT NULL,
  PRIMARY KEY (`nombre`)
);

CREATE TABLE `bd-ucmrails`.`servicios-billetes` (
  `nombre-servicio` VARCHAR(25) NOT NULL,
  `numeroasiento` INT NOT NULL,
  `idtren` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`nombre-servicio`, `idtren`, `numeroasiento`),
  INDEX `billete_idx` (`numeroasiento` ASC, `idtren` ASC) VISIBLE,
  CONSTRAINT `billete`
    FOREIGN KEY (`numeroasiento` , `idtren`)
    REFERENCES `bd-ucmrails`.`billete` (`numeroasiento` , `idtren`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `servicio`
    FOREIGN KEY (`nombre-servicio`)
    REFERENCES `bd-ucmrails`.`servicios` (`nombre`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO `bd-ucmrails`.`estacion` (`nombre`, `localidad`) VALUES ('Atocha', 'Madrid');
INSERT INTO `bd-ucmrails`.`estacion` (`nombre`, `localidad`) VALUES ('Principe Pio', 'Madrid');
INSERT INTO `bd-ucmrails`.`estacion` (`nombre`, `localidad`) VALUES ('Sants', 'Barcelona');
INSERT INTO `bd-ucmrails`.`estacion` (`nombre`, `localidad`) VALUES ('Joaquin Sorolla', 'Valencia');

INSERT INTO `bd-ucmrails`.`ruta` (`nombre`, `precio`, `estacionorigen`, `estaciondestino`, `localidadorigen`, `localidaddestino`, `duracionminutos`) 
						VALUES ('Atocha-PrincipePio', 5, 'Atocha', 'Principe Pio' ,'Madrid' ,'Madrid' , 10);
INSERT INTO `bd-ucmrails`.`ruta` (`nombre`, `precio`, `estacionorigen`, `estaciondestino`, `localidadorigen`, `localidaddestino`, `duracionminutos`) 
						VALUES ('Atocha-Sants', 50, 'Atocha', 'Sants' ,'Madrid' ,'Barcelona' , 90);
INSERT INTO `bd-ucmrails`.`ruta` (`nombre`, `precio`, `estacionorigen`, `estaciondestino`, `localidadorigen`, `localidaddestino`, `duracionminutos`) 
						VALUES ('Sants-PrincipePio', 60, 'Sants', 'Principe Pio' ,'Barcelona' ,'Madrid' , 85);
INSERT INTO `bd-ucmrails`.`ruta` (`nombre`, `precio`, `estacionorigen`, `estaciondestino`, `localidadorigen`, `localidaddestino`, `duracionminutos`) 
						VALUES ('Sants-JoaquinSorolla', 25, 'Sants', 'Joaquin Sorolla' ,'Barcelona' ,'Valencia' , 30);
INSERT INTO `bd-ucmrails`.`ruta` (`nombre`, `precio`, `estacionorigen`, `estaciondestino`, `localidadorigen`, `localidaddestino`, `duracionminutos`) 
						VALUES ('JoaquinSorolla-Atocha', 40, 'Joaquin Sorolla', 'Atocha' ,'Valencia' ,'Madrid' , 75);

INSERT INTO `bd-ucmrails`.`tren` VALUES ('Tren1', 0, '2023-04-17 16:30:00', 'Atocha-PrincipePio');
INSERT INTO `bd-ucmrails`.`tren` VALUES ('Tren2', 0, '2023-07-15 20:37:00', 'Sants-JoaquinSorolla');
INSERT INTO `bd-ucmrails`.`tren` VALUES ('Tren3', 0, '2024-08-17 09:00:00', 'Atocha-Sants');

INSERT INTO `bd-ucmrails`.`billete` VALUES (1, 'Tren1', '2023-04-17', null, null, true);
INSERT INTO `bd-ucmrails`.`billete` VALUES (2, 'Tren1', '2023-04-17', null, null, false);
INSERT INTO `bd-ucmrails`.`billete` VALUES (3, 'Tren1', '2023-04-17', null, null, true);
INSERT INTO `bd-ucmrails`.`billete` VALUES (4, 'Tren1', '2023-04-17', null, null, true);
INSERT INTO `bd-ucmrails`.`billete` VALUES (5, 'Tren1', '2023-04-17', null, null, false);
INSERT INTO `bd-ucmrails`.`billete` VALUES (6, 'Tren1', '2023-04-17', null, null, true);

INSERT INTO `bd-ucmrails`.`billete` VALUES (1, 'Tren2', '2023-07-15', null, null, true);
INSERT INTO `bd-ucmrails`.`billete` VALUES (2, 'Tren2', '2023-07-15', null, null, true);
INSERT INTO `bd-ucmrails`.`billete` VALUES (3, 'Tren2', '2023-07-15', null, null, true);
INSERT INTO `bd-ucmrails`.`billete` VALUES (4, 'Tren2', '2023-07-15', null, null, true);

INSERT INTO `bd-ucmrails`.`billete` VALUES (1, 'Tren3', '2024-08-17', null, null, true);

INSERT INTO `bd-ucmrails`.`servicios` VALUES ('Comida', 1000);
INSERT INTO `bd-ucmrails`.`servicios` VALUES ('Cama', 3500);