var mysql = require('mysql');
const { exit } = require('process');
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'blackredcinemabookings'
  });
  

db.connect(function(err) {
  if (err) throw err;
  var sql3 = "DELETE FROM TABLE bookings WHERE EMAIL = 'g'";
  db.query(sql3, function (err, result) {
    if (err) throw err;
    console.log("Number of records deleted: " + result.affectedRows);
  });
  setTimeout((function() {
    return process.exit();
}), 50);
});