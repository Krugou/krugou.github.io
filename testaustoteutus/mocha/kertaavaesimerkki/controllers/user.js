let mongoose = require('mongoose');
let User = require('../models/user');

function createUser(req, res) {
var newUser = new User(req.body);
newUser.save((err,user) => {
if(err) {
res.send(err);
}
else {
res.json({message: "User successfully created", user });
}
});
}

function getUsers(req, res) {
let query = User.find({});
query.exec((err, users) => {
if(err) res.send(err);
res.json(users);
});
}

function updateUser(req, res) {
User.findById({_id: req.params.id}, (err, user) => {
if(err) res.send(err);
Object.assign(user, req.body).save((err, user) => {
if(err) res.send(err);
res.json({ message: 'User updated', user });
});
});
}

function deleteUser(req, res) {
User.remove({_id : req.params.id}, (err, result) => {
res.json({ message: "User deleted", result });
});
}

module.exports = { getUsers, createUser, deleteUser, updateUser };