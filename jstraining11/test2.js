var mysql = require('mysql');

var con = mysql.createConnection({
  host: "tietokantayhteydet.mysql.database.azure.com",
  user: "kissa",
  password: "Katti123!",
  database: "aleksinokelainen"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
  var sql = "CREATE TABLE Clients (ID INT AUTO_INCREMENT PRIMARY KEY, ClientName VARCHAR(255) NOT NULL)";
  con.query(sql, function (err, result) {
    if (err) throw err;
    console.log("Table created");
  });
});