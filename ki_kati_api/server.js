const express = require("express");
const http = require("http");
const mongoose = require("mongoose");
const cors = require("cors");
require("dotenv").config();
const socketIo = require("socket.io");

const authRoutes = require("./routes/auth");
const messageRoutes = require("./routes/messages");
const groupRoutes = require("./routes/groups");

const app = express();
const server = http.createServer(app);

const io = socketIo(server, {
  cors: {
    origin: "*", // Update to your frontend URL in production
    methods: ["GET", "POST", "PUT", "DELETE"],
  },
});

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));

// Store active users and their last active time
const activeUsers = new Map(); // Map to store username and timestamp of last active
const onlineUsers = new Set(); // Set to track currently online users

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/messages", messageRoutes(io));
app.use("/api/groups", groupRoutes(io));

// Socket.IO Events
io.on("connection", (socket) => {
  console.log("New client connected");

  // When a user connects, register them as online
  socket.on("registerUser", (username) => {
    onlineUsers.add(username);
    io.emit("activeUsers", Array.from(onlineUsers).map(user => ({
      username: user,
      lastActive: activeUsers.get(user) || null, // Include last active time if exists
    }))); // Emit active users with timestamps to all clients
  });

  // When a user disconnects, update their last active time
  socket.on("disconnect", () => {
    const username = [...onlineUsers].find(user => user === socket.username); // Get the username
    if (username) {
      onlineUsers.delete(username); // Remove from online users
      activeUsers.set(username, new Date()); // Update last active time
      io.emit("activeUsers", Array.from(onlineUsers).map(user => ({
        username: user,
        lastActive: activeUsers.get(user) || null,
      }))); // Emit updated list to all clients
    }
    console.log("Client disconnected");
  });
});

const PORT = process.env.PORT || 5000;

server.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
