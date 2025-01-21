"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendchat = void 0;
const db_1 = require("./lib/db");
const sendchat = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { conversation_id, sender_id, message } = req.body;
        // if (!conversation_id || !sender_id || !message) {
        //     res.status(400).json({
        //         success: false,
        //         message: "Missing required fields"
        //     });
        //     return;  // Add return here to prevent further execution
        // }
        const now = new Date();
        const timeZoneOffset = 7 * 60;
        const timestamp = new Date(now.getTime() + timeZoneOffset * 60000);
        const send = yield db_1.prismadb.chat.create({
            data: {
                sender_id,
                conversation_id,
                chat: message,
                timestamp,
                status: 'delivered'
            }
        });
        res.status(201).json({
            success: true,
            data: send,
            message: "Message sent successfully."
        });
    }
    catch (error) {
        console.error("Send chat error:", error);
        res.status(500).json({
            success: false,
            message: "An error occurred while sending the message."
        });
    }
});
exports.sendchat = sendchat;
