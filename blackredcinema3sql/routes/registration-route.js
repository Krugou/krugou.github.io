var express = require('express');
var router = express.Router();
var db=require('../database');
// näyttää rekisteröintilomakkeen
router.get('/register', function(req, res, next) {
  res.render('registerform');
});
// tallentaa käyttäjän syöttämät tiedot post pyynnöstä
router.post('/register', function(req, res, next) {
    inputpassword ={
        password2: req.body.password2
    }
    inputData ={
        name: req.body.name,
        email: req.body.email,
        password: req.body.password,
        seating: req.body.seating,
        movie: req.body.movie,
    }
// tarkistaa ettei sähköposti ole käytössä
var sql="SELECT * FROM bookings WHERE email =?";
db.query(sql, [inputData.email] ,function (err, data, fields) {
 if(err) throw err
 if(data.length>1){
     var msg = inputData.email+ "was already exist";
     console.log("already exist")
 }else if(inputpassword.password2 != inputData.password){
    var msg ="Password & Confirm Password is not Matched";
    console.log("password failed")
 }else{
     
    // tallentaa db:hen tiedot
    var sql2 = "INSERT INTO bookings SET ?";
   db.query(sql2, inputData, function (err, data) {
      if (err) throw err;
           });
           console.log("1 record inserted");
           res.render('login',{alertMsg:msg});
  var msg ="Your are successfully registered";
 }
 
 
})
     
});
module.exports = router;