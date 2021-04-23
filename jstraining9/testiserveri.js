const http = require("http")
const server = http.createServer((req,res) => {
    res.write("moikka kaikille")
    res.end()
})
server.listen(8080)
console.log("connection found")