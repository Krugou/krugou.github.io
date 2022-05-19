var banaani = {hinta: 1};
var mango = {hinta: 2};
var ananas = {hinta: 5};
var omena = {hinta: 4};
var kiwi = {hinta: 9};

var fruitbasket = [];
fruitbasket.push(banaani);
fruitbasket.push(omena);
fruitbasket.push(kiwi);

function laskeHinta() {
  var tulos = 0;
  for (var i = 0; i < fruitbasket.length; i++) {
    tulos = tulos + fruitbasket[i].hinta;
  }
  return 'Hedelmäkorin hinta on ' + tulos + ' euroa';
}

console.log(laskeHinta());


