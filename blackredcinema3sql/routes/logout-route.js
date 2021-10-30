
const express = require('express')
var router = express.Router();
/* lopettaa session */
router.get('/logout', function(req, res) {  
  req.session.destroy();
  res.redirect('/login');
});
module.exports = router;