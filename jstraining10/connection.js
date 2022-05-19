var mysql = require('mysql');
var conn = mysql.createConnection({
  host: 'localhost',
  user: 'admin',
  password: 'mypassword89',
  database: 'mydb',
});
conn.connect(function(err) {
  if (err) throw err;
  console.log('Yhdistyi');

});
