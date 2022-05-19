const express = require('express');

const app = express();

const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello Express2!');
});
app.get('/home', (req, res) => {
  res.send('Welcome to our page');
});

app.get('/about', (req, res) => {
  res.send('About us...');
});
/*app.get("/home/user/:firstname/:lastname", (req, res) => {
  res.send(`Welcome ${req.params.firstname} ${req.params.lastname}`);
})*/
app.get('/home/user/', (req, res) => {
  res.json({username: 'John'});
});
app.get('/home/user/:firstname/:age', (req, res) => {
  if (req.params.age > 17) {

    return res.send(
        `Welcome ${req.params.firstname}, you're ${req.params.age} years old`);
  } else {
    return res.send(`Welcome ${req.params.firstname}, you're too young`);
  }
  ;
});
app.listen(port, () => {
  console.log(`Server is running on port ${port}.`);
});
