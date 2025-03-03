/*
  Warnings:

  - Added the required column `DataCriacao` to the `Empresa` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `empresa` ADD COLUMN `DataCriacao` DATETIME(3) NOT NULL;
