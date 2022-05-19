var mysql = require('mysql');
var con = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'db_henkilöstö',
});
con.connect(function(err) {
  if (err) throw err;
  console.log('Yhdistetty...');
});
var sql = 'select * from osasto';
con.query(sql, function(err, result, fields) {
  if (err) throw err;
  console.log(result);
});
con.end();