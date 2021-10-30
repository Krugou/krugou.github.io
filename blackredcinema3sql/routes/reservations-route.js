var express = require('express');
var router = express.Router();
var db=require('../database');
/* hakee käyttäjän tietoja */

router.get('/reservations', function(req, res, next) {
   
    if(req.session.loggedinUser){     
        res.render('reservations',{email:req.session.emailAddress,})
    }else{
        res.redirect('/login');
    }
});
module.exports = router;
