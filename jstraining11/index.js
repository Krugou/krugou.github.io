var mongoose = require('mongoose');
var env = require('dotenv').config();   //Use the .env file to load the variables

mongoose.connect(
    'mongodb://' + process.env.COSMOSDB_HOST + ':' + process.env.COSMOSDB_PORT +
    '/' + process.env.COSMOSDB_DBNAME + '?ssl=true&replicaSet=globaldb', {
      auth: {
        user: process.env.COSMOSDB_USER,
        password: process.env.COSMOSDB_PASSWORD,
      },
      useNewUrlParser: true,
      useUnifiedTopology: true,
      retryWrites: false,
    }).
    then(() => console.log('Connection to CosmosDB successful')).
    catch((err) => console.error(err));

const Familyaleksinokelainen = mongoose.model('Familyaleksinokelainen',
    new mongoose.Schema({
      lastName: String,
      parents: [
        {
          familyName: String,
          firstName: String,
          gender: String,
        }],
      children: [
        {
          familyName: String,
          firstName: String,
          gender: String,
          grade: Number,
        }],
      pets: [
        {
          givenName: String,
        }],
      address: {
        country: String,
        state: String,
        city: String,
      },
    }));
const familyaleksinokelainen = new Familyaleksinokelainen({
  lastName: 'Volum',
  parents: [
    {firstName: 'Thomas'},
    {firstName: 'Mary Kay'},
  ],
  children: [
    {firstName: 'Ryan', gender: 'male', grade: 8},
    {firstName: 'Patrick', gender: 'male', grade: 7},
  ],
  pets: [
    {givenName: 'Buddy'},
  ],
  address: {country: 'USA', state: 'WA', city: 'Seattle'},
});
familyaleksinokelainen.save((err, saveFamily) => {
  console.log(JSON.stringify(saveFamily));
});