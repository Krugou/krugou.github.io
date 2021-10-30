const express = require('express');
const router  = express.Router();
const {ensureAuthenticated} = require('../config/auth') 
//login page
router.get('/', (req,res)=>{
    res.render('welcome');
})
//register page
router.get('/register', (req,res)=>{
    res.render('register');
})
router.get('/reservations',ensureAuthenticated,(req,res)=>{
    res.render('reservations',{
        user: req.user
    });
})
router.get('/admin',ensureAuthenticated,(req,res)=>{
    res.render('admin',{
        user: req.user
    });
})
router.get('/mainsite2',ensureAuthenticated,(req,res)=>{
    res.render('mainsite2',{
        user: req.user
    });
})


module.exports = router; 