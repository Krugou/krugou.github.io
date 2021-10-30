const mongoose = require('mongoose');
const UserSchema  = new mongoose.Schema({
  name :{
      type  : String,
      required : true
  } ,
  email :{
    type  : String,
    required : true
} ,
password :{
    type  : String,
    required : true
} ,
date :{
    type : Date,
    default : Date.now
} ,
seating :{
    type : String,
    
} ,
movie :{
    type : String,
    
} ,

});
const User= mongoose.model('User',UserSchema);

module.exports = User;