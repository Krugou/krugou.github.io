var express = require('express');
var router = express.Router();
const { User } = require('../models')

/* GET users listing. */
router.get('/', async function(req, res, next) {
  const users = await User.findAll();
  const firstuser = users[0].dataValues;
  console.log(users);
  res.render('listUsers', { title: 'Express', users1:users });
  // res.send('respond with a resource');
});

module.exports = router;

