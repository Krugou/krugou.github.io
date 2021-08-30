let mongoose = require('mongoose');
let Schema = mongoose.Schema;

let UserSchema = new Schema(
  {
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    emailAddress: { type: String, required: true },
    username: { type: String, required: true},
    password: { type: String, required: true },    
  },
  {
    versionKey: false
  }
);

module.exports = mongoose.model('user', UserSchema);