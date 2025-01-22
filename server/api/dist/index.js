"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.io = void 0;
const express_1 = __importDefault(require("express"));
const socket_io_1 = require("socket.io");
const chat_1 = require("./chat");
const app = (0, express_1.default)();
const PORT = process.env.PORT || 3000;
const appServer = app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
app.use(express_1.default.json());
app.post("/api/createchat", chat_1.createchat);
app.post("/api/sendchat", chat_1.sendchat);
app.get("/api/chat/:id/:user_id", chat_1.chatlog);
app.get("/api/chathistory/:id", chat_1.chathistory);
exports.io = new socket_io_1.Server(appServer, {
    cors: {
        origin: "http://localhost:3000"
    }
});
exports.io.on('connection', (socket) => {
    socket.on('join', (conversation_id, user_id) => {
        socket.join(conversation_id);
        console.log(`${user_id} joined room: ${conversation_id}`);
        socket.to(conversation_id).emit('User joined', { user_id });
        socket.on('sendMessage', (messageData) => {
            socket.to(conversation_id).emit('newMessage', messageData);
        });
    });
});
app.get("/", (req, res) => {
    res.send("Welco to the Node.js dsa");
});
