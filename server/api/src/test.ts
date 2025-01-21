import { Response, Request } from "express";
import { prismadb } from "./lib/db";

export const sendchat = async (req: Request, res: Response): Promise<void> => {
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

        const send = await prismadb.chat.create({
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

    } catch (error) {
        console.error("Send chat error:", error);
        res.status(500).json({
            success: false,
            message: "An error occurred while sending the message."
        });
    }
};