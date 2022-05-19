const {Sequelize, DataTypes} = require('sequelize');
const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: 'database.sqlite',
});

const User = sequelize.define('User', {
  // Model attributes are defined here
  firstName: {type: DataTypes.STRING, allowNull: false},
  lastName: {type: DataTypes.STRING},  // allowNull defaults to true
}, {
  // Other model options go here
});

(async () => {
  await User.sync({force: true});
  await User.create({firstName: 'Christian', lastName: 'Finnberg'});
  await User.create({firstName: 'Aleksi', lastName: 'Nokelainen'});
})();

module.exports = {User};