const mysql = require('mysql2');
const dbConnection = mysql.createPool({
  host: 'localhost', // MYSQL HOST NAME
  user: 'admin', // MYSQL USERNAME
  password: 'mypassword89', // MYSQL PASSWORD
  database: 'mydb', // MYSQL DB NAME
}).promise();
module.exports = dbConnection;