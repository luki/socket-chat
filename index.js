var app = require("express")();
var http = require("http").createServer(app);
var io = require("socket.io")(http);

app.get("/", (req, res) => {
    res.send("<h1>Hello</h1>");
});

io.on("connection", (socket) => {
    console.log("User connected")

    socket.on("disconnect", () => {
      console.log("User disconnected")
    })

    // Receives a message
    socket.on("message", (content) => {
      console.log("Got a message, now sending it on!")
      socket.broadcast.emit("message", content);
    })
});

http.listen(3000, () => {
    console.log("Hi");
});
