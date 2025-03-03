/*
  Warnings:

  - Added the required column `IsAdm` to the `colaborador` table without a default value. This is not possible if the table is not empty.
  - Added the required column `login` to the `colaborador` table without a default value. This is not possible if the table is not empty.
  - Added the required column `IsAdm` to the `Empresa` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `colaborador` ADD COLUMN `IsAdm` BOOLEAN NOT NULL,
    ADD COLUMN `login` VARCHAR(40) NOT NULL;

-- AlterTable
ALTER TABLE `empresa` ADD COLUMN `IsAdm` BOOLEAN NOT NULL;
