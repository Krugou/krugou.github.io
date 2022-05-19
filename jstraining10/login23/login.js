var mysql = require('mysql');
var express = require('express');
var session = require('express-session');
var path = require('path');

var con = mysql.createConnection({
  host: 'localhost',
  user: 'admin',
  password: 'mypassword89',
  database: 'kirjautuminen',
});
con.connect(function(err) {
  if (err) throw err;
  console.log('Yhdistetty...');
});
var app = express();

app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true,
}));

app.use(express.urlencoded({extended: true}));
app.use(express.json());

app.get('/', function(request, response) {
  response.sendFile(path.join(__dirname + '/login.html'));
});