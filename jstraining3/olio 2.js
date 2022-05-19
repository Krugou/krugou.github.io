function Lemmikki(nimi, rotu, ika, paino) {
  this.nimi = nimi;
  this.rotu = rotu;
  this.ika = ika;
  this.paino = paino;
}

var asiakas101 = new Lemmikki('Fio', 'Shiba Inu', 3, 3);
var asiakas102 = new Lemmikki('Way', 'Akita', 4, 5);
var asiakas103 = new Lemmikki('Ved', 'Chow Chow', 6, 10);
console.log(
    'Päivän ensimmäinen asiakas on ' + asiakas101.nimi + ' ' + asiakas101.ika +
    'v');
console.log(asiakas103.nimi + ' ' + asiakas103.ika);
console.log(asiakas102.nimi + ' ' + asiakas102.ika);