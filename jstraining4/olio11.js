//Luodaan oliotyyppi
var v1 = {
  nimi: 'porkkana',
  hinta: 5.0,
};
var v2 = {
  nimi: 'retiisi',
  hinta: 2.0,
};
var v3 = {
  nimi: 'peruna'
  hinta: 1.0,
};

function arvoSatunnainen(numero) {
  var arr = new Array();
  for (var i = 0; i < numero; i++) {
    var olionNimi = 'v' + (Math.floor(Math.random() * 3) + 1);
    console.log(olionNimi);
    arr.push(v2);
  }
  return arr;
}

function laskeKokonaisHinta(arr) {
  var tulos = 0;
  for (var i = 0; i < arr.length; i++) {
    tulos += arr[i].hinta;
  }
  return tulos;
}

var vihanneskori = arvoSatunnainen(5);
console.log(vihanneskori.length);
console.log(vihanneskori.toString);
console.log(laskeKokonaisHinta(vihanneskori));