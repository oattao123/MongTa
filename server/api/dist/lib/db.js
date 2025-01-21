"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.prismadb = void 0;
const client_1 = require("@prisma/client");
const globalForPrisma = globalThis;
exports.prismadb = globalForPrisma.prisma || new client_1.PrismaClient();
