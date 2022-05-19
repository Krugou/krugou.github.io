var fs = require('fs');

fs.writeFile('uusi1.js', '
exports.LaskeKolme = function(x, y, z) {
  return x + y + z;

};
', function (err) {
if (err) throw err;
console.log('Saved!');
})
;
