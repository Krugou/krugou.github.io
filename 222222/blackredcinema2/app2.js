require('dotenv').config()

const express = require('express');
const app = express();
const cookieParser = require('cookie-parser')
const Joi = require('joi');
Joi.objectId = require('joi-objectid')(Joi);
const mongoose = require('mongoose');
const users = require('./routes/users');
const flash = require('connect-flash');
const session = require('express-session');
const passport = require("passport");
// Google Auth
const {OAuth2Client} = require('google-auth-library');
const CLIENT_ID = '268617966419-h19b582mhou65qn4d1ns8s5i3ea5sf78.apps.googleusercontent.com'
const client = new OAuth2Client(CLIENT_ID);


const PORT = 4000;
const router = express.Router();

const expressEjsLayout = require('express-ejs-layouts')

//EJS
app.set('view engine','ejs');
app.use(expressEjsLayout);
//BodyParser
app.use(express.urlencoded({extended : false}));
//express session
app.use(session({
    secret : 'secret',
    resave : true,
    saveUninitialized : true
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
app.use('/',require('./routes/index'));
app.use('/users',require('./routes/users'));
// Middleware

app.set('view engine', 'ejs');
app.use(express.json());
app.use(cookieParser());
app.use(express.static('public'));

app.get('/', (req, res)=>{
    res.render('index')
})

app.get('/login', (req,res)=>{
    res.render('login');
})
app.get('/logout', (req,res)=>{
    res.render('logout2');
})
app.post('/login', (req,res)=>{
    let token = req.body.token;

    async function verify() {
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: CLIENT_ID,  // Specify the CLIENT_ID of the app that accesses the backend
        });
        const payload = ticket.getPayload();
        const userid = payload['sub'];
      }
      verify()
      .then(()=>{
          res.cookie('session-token', token);
          res.send('success')
      })
      .catch(console.error);

})

app.get('/profile', checkAuthenticated, (req, res)=>{
    let user = req.user;
    res.render('profile', {user});
})

app.get('/protectedRoute', checkAuthenticated, (req,res)=>{
    res.send('This route is protected')
})

app.get('/logout', (req, res)=>{
    res.clearCookie('session-token');
    res.redirect('/logout2')

})


function checkAuthenticated(req, res, next){

    let token = req.cookies['session-token'];

    let user = {};
    async function verify() {
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: CLIENT_ID,  // Specify the CLIENT_ID of the app that accesses the backend
        });
        const payload = ticket.getPayload();
        user.name = payload.name;
        user.email = payload.email;
        user.picture = payload.picture;
      }
      verify()
      .then(()=>{
          req.user = user;
          next();
      })
      .catch(err=>{
          res.redirect('/login')
      })

}

app.use(express.json());
app.use('/api/users', users);
mongoose.connect('mongodb://localhost/mongo-games')
    .then(() => console.log('Now connected to MongoDB!'))
    .catch(err => console.error('Something went wrong', err));


app.listen(PORT, ()=>{
    console.log(`Server running on port ${PORT}`);
})