import express, { Request, Response } from "express";
import { Server } from "socket.io";
import { chathistory, chatlog, createchat, sendchat } from "./chat";

const app = express();
const PORT = process.env.PORT || 3000;

const appServer = app.listen(PORT , () => {
  console.log(`Server is running on port ${PORT}`);
})

app.use(express.json());

app.post("/api/createchat", createchat)
app.post("/api/sendchat", sendchat)
app.get("/api/chat/:id/:user_id", chatlog)
app.get("/api/chathistory/:id", chathistory)

const io = new Server(appServer, {
  cors: {
      origin: "http://localhost:3000"
  }
})

io.on("connection", (socket) => {
  
  socket.on("join", (conversationid: string, userid: string) => {
    socket.join(conversationid)
    console.log(`${userid} joined room: ${conversationid}`);

    socket.to(conversationid).emit("userJoined", { userid });

    socket.on("sendMessage", (messageData: { senderId: string, message: string }) => {
      
      socket.to(conversationid).emit("newMessage", messageData);
    })
  })
})


app.get("/", (req: Request, res: Response) => {
  res.send("Welco to the Node.js dsa");
});
