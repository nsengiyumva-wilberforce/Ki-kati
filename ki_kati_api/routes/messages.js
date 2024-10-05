const express = require("express");
const auth = require("../middleware/auth"); // Your auth middleware
const Message = require("../models/Message");

const router = express.Router();

module.exports = (io) => {
    // Send a message
    router.post("/send", auth, async (req, res) => {
        const { recipient, content } = req.body;

        try {
            const message = new Message({
                sender: req.user.id,
                recipient,
                content,
            });

            await message.save();

            // Emit the message to all connected clients
            io.emit("messageReceived", {
                sender: req.user.id,
                recipient,
                content,
            });

            res.status(201).json({ message: "Message sent successfully" });
        } catch (error) {
            console.log(error);
            res.status(500).json({ message: "Server error" });
        }
    });

    return router; // Return the router
};
