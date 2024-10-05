const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();
const socketIo = require("socket.io");

const authRoutes = require("./routes/auth");
const messageRoutes = require("./routes/messages");

const app = express();
const server = http.createServer(app); // Create HTTP server

const io = socketIo(server, {
  cors: {
      origin: "*", // You can specify your frontend URL here
      methods: ["GET", "POST"]
  }
});

const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

//connect to mongodb
mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/messages", messageRoutes(io));

// Socket.IO Events
io.on("connection", (socket) => {
  console.log("New client connected");

  // Listen for messages
  socket.on("sendMessage", (data) => {
    // Emit the message to all connected clients
    io.emit("messageReceived", data);
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected");
  });
});

server.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
