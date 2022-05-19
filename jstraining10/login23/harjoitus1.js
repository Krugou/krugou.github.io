var mysql = require('mysql');
var con = mysql.createConnection({
  host: 'localhost',
  user: 'admin',
  password: 'mypassword89',
  database: 'db_henkilöstö',
});
con.connect(function(err) {
  if (err) throw err;
  console.log('Yhdistyi');
});
var sql = 'delete from projekti where nimi=\'Teekutsut\'';
con.query(sql, function(err, result, fields) {
  if (err) throw err;
  console.log(result);
});
con.end();