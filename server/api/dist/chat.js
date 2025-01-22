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
exports.chathistory = exports.chatlog = exports.sendchat = exports.createchat = void 0;
const db_1 = require("./lib/db");
const index_1 = require("../src/index");
const createchat = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { user_id, ophthaid } = req.body;
        if (!user_id || !ophthaid) {
            res.status(400).json({
                success: false,
                message: "Missing required inputs."
            });
            return;
        }
        const check_user = yield db_1.prismadb.user.findUnique({
            where: {
                id: user_id
            },
            select: {
                is_opthamologist: true
            }
        });
        if ((check_user === null || check_user === void 0 ? void 0 : check_user.is_opthamologist) == true) {
            res.status(409).send({
                success: false,
                message: "Ophthamologist cannot create chat."
            });
            return;
        }
        const check_ophtha = yield db_1.prismadb.user.findUnique({
            where: {
                id: ophthaid
            },
            select: {
                is_opthamologist: true
            }
        });
        if ((check_ophtha === null || check_ophtha === void 0 ? void 0 : check_ophtha.is_opthamologist) == false) {
            res.status(409).send({
                success: false,
                message: "Cannot create chat with user that is not opthamologist."
            });
            return;
        }
        const check_chat = yield db_1.prismadb.conversation.findMany({
            where: {
                user_id: user_id,
                ophthalmologist_id: ophthaid
            }
        });
        if (check_chat.length > 0) {
            res.status(409).send({
                success: false,
                message: "Chat already created."
            });
            return;
        }
        const create = yield db_1.prismadb.conversation.create({
            data: {
                user_id,
                ophthalmologist_id: ophthaid
            }
        });
        index_1.io.emit('newChat', { user_id, ophthaid, conversation_id: create.id });
        res.status(201).send({
            create,
            message: "Chat created successfully"
        });
    }
    catch (error) {
        console.log(error);
        res.status(500).json({
            error,
            success: false,
            message: "An error occurred while creating the chat."
        });
    }
});
exports.createchat = createchat;
const sendchat = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { conversation_id, sender_id, message } = req.body;
        if (!conversation_id || !sender_id || !message) {
            res.status(400).json({
                success: false,
                message: "Missing required inputs."
            });
            return;
        }
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
        index_1.io.to(conversation_id).emit('newMessage', {
            sender_id,
            message,
            timestamp,
        });
        res.status(201).send({
            send,
            message: "Message sent successfully."
        });
    }
    catch (error) {
        console.log(error);
        res.status(500).json({
            error,
            success: false,
            message: "An error occurred while sending the message."
        });
    }
});
exports.sendchat = sendchat;
const chatlog = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id, user_id } = req.params;
        const chatlog = yield db_1.prismadb.chat.findMany({
            where: {
                conversation_id: parseInt(id)
            },
            select: {
                id: true,
                chat: true,
                timestamp: true,
                status: true,
                sender_id: true,
                conversation_id: true
            },
            orderBy: {
                timestamp: 'desc'
            }
        });
        if (chatlog.length <= 0) {
            res.status(404).json({
                success: false,
                message: "Chat did not exist."
            });
            return;
        }
        // await prismadb.chat.updateMany({
        //     where: {
        //         AND: [
        //             { conversation_id: parseInt(id) },
        //             { sender_id: parseInt() },
        //             {
        //                 id: {
        //                 not: send.id
        //             }
        //         }
        //         ]
        //     },
        //     data: {
        //         status: 'read'
        //     }
        // })
        res.status(200).send({
            chatlog,
            success: true,
            message: "Chat log sent sucessfully."
        });
    }
    catch (error) {
        console.log(error);
        res.status(400).json({
            error,
            success: false,
            message: "An unexpected error occurred while fetching the chat log."
        });
    }
});
exports.chatlog = chatlog;
const chathistory = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { id } = req.params;
        const user = yield db_1.prismadb.user.findFirst({
            where: {
                id: parseInt(id)
            },
            select: {
                first_name: true,
                last_name: true,
                profile_picture: true,
                is_opthamologist: true
            }
        });
        if (user === null || user === void 0 ? void 0 : user.is_opthamologist) {
            const conversation = yield db_1.prismadb.conversation.findMany({
                where: {
                    ophthalmologist_id: parseInt(id)
                },
                select: {
                    id: true
                }
            });
            const chatid = conversation.map((conversation) => conversation.id);
            const chathistory = yield db_1.prismadb.chat.findMany({
                where: {
                    conversation_id: {
                        in: chatid
                    }
                },
                select: {
                    chat: true,
                    conversation_id: true,
                    timestamp: true,
                    status: true,
                    sender_id: true,
                    conversation: {
                        select: {
                            User_conversation_user_idToUser: {
                                select: {
                                    first_name: true,
                                    last_name: true,
                                    profile_picture: true,
                                }
                            }
                        }
                    }
                },
                orderBy: {
                    timestamp: 'desc'
                }
            });
            if (chathistory.length === 0) {
                res.status(200).send({
                    success: true,
                    message: "Not have any Chat history yet."
                });
                return;
            }
            const latest_chat = Object.values(chathistory.reduce((acc, chat) => {
                if (!acc[chat.conversation_id] || acc[chat.conversation_id].timestamp < chat.timestamp) {
                    acc[chat.conversation_id] = chat;
                }
                return acc;
            }, {}));
            const chat_check = latest_chat.map((latestchat) => {
                const chat_count = chathistory.filter((chat) => chat.conversation_id === latestchat.conversation_id &&
                    chat.status === "delivered" &&
                    chat.sender_id !== parseInt(id)).length;
                return Object.assign(Object.assign({}, latestchat), { chat_notread: chat_count });
            });
            chat_check.sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime());
            res.status(200).send({
                latest_chat: chat_check,
                success: true,
                message: "Chat history sent successfully.",
            });
        }
        else {
            const conversation = yield db_1.prismadb.conversation.findMany({
                where: {
                    user_id: parseInt(id)
                },
                select: {
                    id: true
                }
            });
            const chatid = conversation.map((conversation) => conversation.id);
            const chathistory = yield db_1.prismadb.chat.findMany({
                where: {
                    conversation_id: {
                        in: chatid
                    }
                },
                select: {
                    chat: true,
                    conversation_id: true,
                    timestamp: true,
                    status: true,
                    sender_id: true,
                    conversation: {
                        select: {
                            User_conversation_ophthalmologist_idToUser: {
                                select: {
                                    first_name: true,
                                    last_name: true,
                                    profile_picture: true,
                                }
                            }
                        }
                    }
                },
                orderBy: {
                    timestamp: 'desc'
                }
            });
            const latest_chat = Object.values(chathistory.reduce((acc, chat) => {
                if (!acc[chat.conversation_id] || acc[chat.conversation_id].timestamp < chat.timestamp) {
                    acc[chat.conversation_id] = chat;
                }
                return acc;
            }, {}));
            const chat_check = latest_chat.map((latestchat) => {
                const chat_count = chathistory.filter((chat) => chat.conversation_id === latestchat.conversation_id &&
                    chat.status === "delivered" &&
                    chat.sender_id !== parseInt(id)).length;
                return Object.assign(Object.assign({}, latestchat), { chat_notread: chat_count });
            });
            chat_check.sort((a, b) => new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime());
            res.status(200).send({
                latest_chat: chat_check,
                success: true,
                message: "Chat history sent successfully.",
            });
        }
    }
    catch (error) {
        console.log(error);
        res.status(400).json({
            error,
            success: false,
            message: "An unexpected error occurred while fetching the chat history."
        });
    }
});
exports.chathistory = chathistory;
