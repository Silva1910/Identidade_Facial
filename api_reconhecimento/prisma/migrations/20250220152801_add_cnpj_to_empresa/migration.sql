-- CreateTable
CREATE TABLE `Empresa` (
    `CNPJ` VARCHAR(14) NOT NULL,
    `NomeFantasia` VARCHAR(100) NOT NULL,
    `CEP` VARCHAR(8) NOT NULL,
    `EstadoCidade` VARCHAR(100) NOT NULL,
    `Bairro` VARCHAR(50) NOT NULL,
    `RuaAvenida` VARCHAR(100) NOT NULL,
    `Numero` VARCHAR(10) NOT NULL,
    `Complemento` VARCHAR(50) NULL,
    `Responsavel` VARCHAR(100) NOT NULL,
    `DataCriacao` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`CNPJ`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `colaborador` (
    `Matricula` VARCHAR(36) NOT NULL,
    `Nome` VARCHAR(100) NOT NULL,
    `CPF` VARCHAR(11) NOT NULL,
    `RG` VARCHAR(15) NOT NULL,
    `DataNascimento` DATE NOT NULL,
    `DataAdmissao` DATE NOT NULL,
    `NIS` VARCHAR(11) NOT NULL,
    `CTPS` VARCHAR(20) NOT NULL,
    `CargaHoraria` INTEGER NOT NULL,
    `Cargo` VARCHAR(40) NOT NULL,
    `CNPJ` VARCHAR(14) NOT NULL,
    `imagem` BLOB NULL,

    PRIMARY KEY (`Matricula`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `registroponto` (
    `Dia` DATETIME(3) NOT NULL,
    `Matricula` VARCHAR(36) NOT NULL,
    `Registro` JSON NOT NULL,

    PRIMARY KEY (`Dia`, `Matricula`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `colaborador` ADD CONSTRAINT `colaborador_CNPJ_fkey` FOREIGN KEY (`CNPJ`) REFERENCES `Empresa`(`CNPJ`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `registroponto` ADD CONSTRAINT `registroponto_Matricula_fkey` FOREIGN KEY (`Matricula`) REFERENCES `colaborador`(`Matricula`) ON DELETE RESTRICT ON UPDATE CASCADE;
