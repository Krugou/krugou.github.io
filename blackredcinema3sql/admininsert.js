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
  var sql3 = "CREATE TABLE `bookings` (`id` int(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT, `name` varchar(30) DEFAULT NULL,`email` varchar(30) DEFAULT NULL,`password` varchar(10) DEFAULT NULL, `seating` varchar(50) DEFAULT NULL,   `movie` varchar(20) DEFAULT NULL, `created_at` datetime NOT NULL  ) ENGINE=InnoDB DEFAULT CHARSET=latin1;";
  db.query(sql3, function (err, result) {
    if (err) throw err;
    
  });
  
  setTimeout((function() {
    return process.exit();
}), 50);
console.log("CREATE TABLE done");
});