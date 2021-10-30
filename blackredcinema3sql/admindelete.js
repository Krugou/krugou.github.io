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
  var sql3 = "DELETE FROM bookings;";
  db.query(sql3, function (err, result) {
    if (err) throw err;
    console.log("Bookings deleted: " + result.affectedRows);
  });
  setTimeout((function() {
    return process.exit();
}), 50);
});