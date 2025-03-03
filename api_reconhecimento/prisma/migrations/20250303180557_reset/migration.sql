-- DropForeignKey
ALTER TABLE `colaborador` DROP FOREIGN KEY `colaborador_CNPJ_fkey`;

-- DropForeignKey
ALTER TABLE `registroponto` DROP FOREIGN KEY `registroponto_Matricula_fkey`;

-- DropIndex
DROP INDEX `registroponto_Matricula_fkey` ON `registroponto`;

-- AddForeignKey
ALTER TABLE `colaborador` ADD CONSTRAINT `colaborador_CNPJ_fkey` FOREIGN KEY (`CNPJ`) REFERENCES `Empresa`(`CNPJ`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `registroponto` ADD CONSTRAINT `registroponto_Matricula_fkey` FOREIGN KEY (`Matricula`) REFERENCES `colaborador`(`Matricula`) ON DELETE RESTRICT ON UPDATE CASCADE;
