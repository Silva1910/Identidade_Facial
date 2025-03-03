/*
  Warnings:

  - The primary key for the `colaborador` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - A unique constraint covering the columns `[Matricula]` on the table `colaborador` will be added. If there are existing duplicate values, this will fail.
*/

-- Remover foreign keys antes da alteração
ALTER TABLE `registroponto` DROP FOREIGN KEY `registroponto_Matricula_fkey`;
ALTER TABLE `colaborador` DROP FOREIGN KEY `colaborador_CNPJ_fkey`;

-- Alterar chave primária
ALTER TABLE `colaborador` DROP PRIMARY KEY,
    ADD PRIMARY KEY (`CNPJ`, `Matricula`);

-- Criar índice único para `Matricula`
CREATE UNIQUE INDEX `colaborador_Matricula_key` ON `colaborador`(`Matricula`);

-- Recriar foreign keys após a alteração
ALTER TABLE `registroponto` ADD CONSTRAINT `registroponto_Matricula_fkey` FOREIGN KEY (`Matricula`) REFERENCES `colaborador`(`Matricula`);
ALTER TABLE `colaborador` ADD CONSTRAINT `colaborador_CNPJ_fkey` FOREIGN KEY (`CNPJ`) REFERENCES `Empresa`(`CNPJ`);
