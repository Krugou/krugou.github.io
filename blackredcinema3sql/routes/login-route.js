var express = require('express');
var router = express.Router();
var db=require('../database');
/* GET users listing. */
router.get('/login', function(req, res, next) {
  res.render('login');
});
router.post('/login', function(req, res){
    var emailAddress = req.body.email;
    var seating = req.body.seating;
    var movie = req.body.movie;
    var password = req.body.password;
    var sql="SELECT * FROM bookings WHERE email =? AND password =? ";
    db.query(sql, [emailAddress, password], function (err, data, fields) {
        if(err) throw err
        if(data.length>0){
            req.session.loggedinUser= true;
            req.session.emailAddress= emailAddress;
            req.session.seating= seating;
            req.session.movie= movie;
            
            console.log("success at login")
            res.redirect('/reservations');
        }else{
            res.render('login',{alertMsg:"Your Email Address or password is wrong"});
            console.log("email or password is WRONG!!")
        }
    })
})
module.exports = router;