var mysql = require('mysql');

var con = mysql.createConnection({
  host: 'tietokantayhteydet.mysql.database.azure.com',
  user: 'kissa',
  password: 'Katti123!',
});

con.connect(function(err) {
  if (err) throw err;
  console.log('Connected!');
  con.query('CREATE DATABASE aleksinokelainen', function(err, result) {
    if (err) throw err;
    console.log('Database created');
  });
});