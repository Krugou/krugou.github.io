var express = require('express');
var router = express.Router();

const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: 'database.sqlite'
});

const User = sequelize.define('User', {
  // Model attributes are defined here
  firstName: { type: DataTypes.STRING, allowNull: false },
  lastName:  { type: DataTypes.STRING                   }  // allowNull defaults to true
}, {
  // Other model options go here
});

(async () => {
  await User.sync({ force: true });
  await User.create({ firstName: 'Christian', lastName: 'Finnberg' });
})();



/* GET home page. */
router.get('/', async function(req, res, next) {
  const users = await User.findAll();
  const firstuser = users[0].dataValues;
  console.log(firstuser);
  res.render('index', { title: 'Express', firstName: firstuser.firstName,lastName: firstuser.lastName });
});

module.exports = router;
