const express = require('express');
const router = express.Router();
const User = require("../models/user");
const bcrypt = require('bcrypt');
const passport = require('passport');
//login handle
router.get('/login',(req,res)=>{
    res.render('login');
})
router.get('/register',(req,res)=>{
    res.render('register')
    })
//Register handle
router.post('/login',(req,res,next)=>{
passport.authenticate('local',{
    successRedirect : '/reservations',
    failureRedirect: '/users/login',
    failureFlash : true
})(req,res,next)
})

  //register post handle
  router.post('/register', async(req,res)=>{
    
   
    const {name,email, password, password2,seating,movie} = req.body;
    let errors = [];
    console.log(' Name ' + name+ ' email :' + email+ ' pass:' + password+' seating:' + seating + ' movie:'+ movie);
    if(!name || !email || !password || !password2 || !seating ) {
        errors.push({msg : "Please fill in all fields"})
    }
    //onko salasanat samat
    if(password !== password2) {
        errors.push({msg : "passwords dont match"});
    }
    
   if(seating.length > 2 ) {
         errors.push({msg : 'seating two many values'})
            }
            
   
    //onko salasana enemmän kuin 6 kirjainta
    if(password.length < 6 ) {
        errors.push({msg : 'password atleast 6 characters'})
    }
     if(errors.length > 0 ) {
    res.render('register', {
        errors : errors,
        name : name,
        email : email,
        password : password,
        password2 : password2,
        seating : seating,
        movie : movie
        })
    }  else {
       User.findOne({$or:[{email:email},{seating:seating},]}).exec((err,user)=>{
        console.log(user);   
        if(user) {
            errors.push({msg: 'email already registered or seating is taken'});
            res.render('register',{errors,name,email,password,password2,seating,movie})  
           } else {
            const newUser = new User({
                name : name,
                email : email,
                password : password,
                seating : seating,
                movie : movie
            });
    
            //hash password
            bcrypt.genSalt(10,(err,salt)=> 
            bcrypt.hash(newUser.password,salt,
                (err,hash)=> {
                    if(err) throw err;
                        //save pass to hash
                        newUser.password = hash;
                    //save user
                    newUser.save()
                    .then((value)=>{
                        console.log(value)
                        req.flash('success_msg','You have now registered!');
                        res.redirect('/users/login');
                    })
                    .catch(value=> console.log(value));
                      
           }));
             }
       })
    }
    })
//logout
router.get('/logout',(req,res)=>{
req.logout();
req.flash('success_msg','Now logged out');
res.redirect('/users/login'); 
})
module.exports  = router;