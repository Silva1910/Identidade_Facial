-- Criando Base de Dados
CREATE DATABASE IF NOT EXISTS `Registro_Database`;

-- Usando Base de Dados
USE `Registro_Database`;

-- Criando Tabela - EMPRESA
CREATE TABLE IF NOT EXISTS `EMPRESA` (
    `CNPJ` CHAR(14) NOT NULL,
    `NOMEFANTASIA` VARCHAR(35) NOT NULL,
    `CEP` INTEGER(8) NOT NULL,
    `UF` CHAR(2) NOT NULL,
    `CIDADE` VARCHAR(35) NOT NULL,
    `BAIRRO` VARCHAR(35) NOT NULL,
    `LOGRADOURO` VARCHAR(100) NOT NULL,
    `NUMERO` INTEGER(10) NOT NULL,
    `COMPLEMENTO` VARCHAR(50),
    `DATACRIACAO` DATE NOT NULL
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Criando Chave Primária
ALTER TABLE `EMPRESA` ADD CONSTRAINT `PK_EMPRESA_CNPJ` PRIMARY KEY (`CNPJ`);

-- Criando Tabela - COLABORADOR
CREATE TABLE IF NOT EXISTS `COLABORADOR` (
    `MATRICULA` VARCHAR(36) NOT NULL,
    `CNPJ_EMPRESA` CHAR(14) NOT NULL,
    `NOME` VARCHAR(100) NOT NULL,
    `CPF` CHAR(11) NOT NULL,
    `RG` CHAR(9) NOT NULL,
    `DATA_NASCIMENTO` DATE NOT NULL,
    `DATA_ADMISSAO` DATE NOT NULL,
    `NIS` CHAR(11) NOT NULL,
    `CTPS` CHAR(11) NOT NULL,
    `CARGA_HORARIA` TIME NOT NULL,
    `CARGO` VARCHAR(40) NOT NULL,
    `IMAGEM` BLOB NULL,
    `BANCO_DE_HORAS` TIME NOT NULL
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Criando Chave Primária
ALTER TABLE `COLABORADOR` ADD CONSTRAINT `PK_COLABORADOR_MATRICULA_CNPJ` PRIMARY KEY (`MATRICULA`, `CNPJ_EMPRESA`);

-- Criando Chave Estrangeira
ALTER TABLE `COLABORADOR` ADD CONSTRAINT `FK_COLABORADOR_CNPJ_EMPRESA` FOREIGN KEY (`CNPJ_EMPRESA`) REFERENCES `EMPRESA`(`CNPJ`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Criando Tabela - USUARIO
CREATE TABLE IF NOT EXISTS `USUARIO` (
    `MATRICULA_COLABORADOR` VARCHAR(36) NOT NULL,
    `CNPJ_EMPRESA` CHAR(14) NOT NULL,
    `SENHA` VARCHAR(100) NOT NULL,
    `ADMIN` BOOLEAN NOT NULL
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Criando Chave Primária
ALTER TABLE `USUARIO` ADD CONSTRAINT `PK_USUARIO_CNPJ_MATRICULA` PRIMARY KEY (`MATRICULA_COLABORADOR`, `CNPJ_EMPRESA`);

-- Criando Chaves Estrangeiras
ALTER TABLE `USUARIO` ADD CONSTRAINT `FK_USUARIO_MATRICULA_COLABORADOR` FOREIGN KEY (`MATRICULA_COLABORADOR`) REFERENCES `COLABORADOR`(`MATRICULA`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `USUARIO` ADD CONSTRAINT `FK_USUARIO_CNPJ_EMPRESA` FOREIGN KEY (`CNPJ_EMPRESA`) REFERENCES `EMPRESA`(`CNPJ`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Criando Tabela - REGISTRO_PONTO
CREATE TABLE IF NOT EXISTS `REGISTRO_PONTO` (
    `MATRICULA_COLABORADOR` VARCHAR(36) NOT NULL,
    `CNPJ_EMPRESA` CHAR(14) NOT NULL,
    `DATA` DATETIME NOT NULL
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Criando Chave Primária
ALTER TABLE `REGISTRO_PONTO` ADD CONSTRAINT `PK_REGISTRO_PONTO` PRIMARY KEY (`MATRICULA_COLABORADOR`, `CNPJ_EMPRESA`, `DATA`);

-- Criando Chaves Estrangeiras
ALTER TABLE `REGISTRO_PONTO` ADD CONSTRAINT `FK_REGISTRO_PONTO_MATRICULA_COLABORADOR` FOREIGN KEY (`MATRICULA_COLABORADOR`) REFERENCES `COLABORADOR`(`MATRICULA`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `REGISTRO_PONTO` ADD CONSTRAINT `FK_REGISTRO_PONTO_CNPJ_EMPRESA` FOREIGN KEY (`CNPJ_EMPRESA`) REFERENCES `EMPRESA`(`CNPJ`) ON DELETE RESTRICT ON UPDATE CASCADE;