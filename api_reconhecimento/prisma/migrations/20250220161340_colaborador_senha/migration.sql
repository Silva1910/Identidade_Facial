/*
  Warnings:

  - Added the required column `Senha` to the `colaborador` table without a default value. This is not possible if the table is not empty.
  - Added the required column `Senha` to the `Empresa` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `colaborador` ADD COLUMN `Senha` VARCHAR(50) NOT NULL;

-- AlterTable
ALTER TABLE `empresa` ADD COLUMN `Senha` VARCHAR(50) NOT NULL;
