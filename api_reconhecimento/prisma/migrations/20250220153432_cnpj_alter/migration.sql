/*
  Warnings:

  - The primary key for the `empresa` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- AlterTable
ALTER TABLE `empresa` DROP PRIMARY KEY,
    MODIFY `CNPJ` VARCHAR(20) NOT NULL,
    ADD PRIMARY KEY (`CNPJ`);
