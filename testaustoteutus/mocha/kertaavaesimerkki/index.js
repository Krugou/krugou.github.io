let express = require('express');
let app = express();
let mongoose = require('mongoose');
let morgan = require('morgan');
let bodyParser = require('body-parser');
let port = 5000;
let user = require('./controllers/user');
     
mongoose.connect("127.0.0.1:27017");
                                     
app.use(bodyParser.json());                                    
app.use(bodyParser.urlencoded({extended: true}));              
app.use(bodyParser.text());                                    
app.use(bodyParser.json({ type: 'application/json'}));  

app.get("/", (req, res) => res.json({message: "User management app"}));

app.route("/user")
.get(user.getUsers)
.post(user.createUser);
app.route("/user/:id")
.delete(user.deleteUser)
.put(user.updateUser);
app.listen(port);
module.exports = app;