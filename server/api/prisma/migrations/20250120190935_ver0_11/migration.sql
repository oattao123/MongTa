/*
  Warnings:

  - Added the required column `status` to the `chat` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "chat" ADD COLUMN     "status" VARCHAR(9) NOT NULL;
