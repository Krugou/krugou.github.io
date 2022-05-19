var fs = require('fs');
var http = require('http');
http.createServer((req, res) => {
  fs.readFile('demo.html', (err, data) => {

  });

}).listen(3000);