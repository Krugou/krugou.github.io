var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'BlackRed Cinema' ,nameofplace: 'Cinema hall 123, 00001, Minsk',hall1: 'Seating 101',hall2: 'seating 111',currentcapacity: '50' });
});


module.exports = router;
