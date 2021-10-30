const express = require('express');
var mysql = require('mysql');
const mongoose = require('mongoose');
const router = express.Router();
const app = express();
const expressEjsLayout = require('express-ejs-layouts')
const flash = require('connect-flash');
const session = require('express-session');
const passport = require("passport");
const PORT = 3000;


//EJS
app.set('view engine','ejs');
app.use(expressEjsLayout);
//BodyParser
app.use(express.urlencoded({extended : false}));
//express session
app.use(session({
    secret : 'secret',
    resave: false,
    saveUninitialized: true,
    cookie: { maxAge: 60000 }
}));
app.use(passport.initialize());
app.use(passport.session());
app.use(flash());
app.use((req,res,next)=> {
    res.locals.success_msg = req.flash('success_msg');
    res.locals.error_msg = req.flash('error_msg');
    res.locals.error  = req.flash('error');
    next();
    })
    
//Routes
var registrationRouter = require('./routes/registration-route');
var loginRouter = require('./routes/login-route');
var reservationsRouter = require('./routes/reservations-Route');
var logoutRouter = require('./routes/logout-route');
var index = require('./routes/index');
app.use('/', index);
app.use('/', registrationRouter);
app.use('/', loginRouter);
app.use('/', reservationsRouter);
app.use('/', logoutRouter);
app.use(express.static('public'));


app.listen(PORT, ()=>{
    console.log(`Serveri käynnissä portilla: ${PORT}`);
})
