var mysql = require('mysql');
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'blackredcinemabookings'
  });
  
  connection.connect((err) => {
    if (err) throw err;
    console.log('yhteydessä MySQL Server!');
  });
  module.exports = connection;