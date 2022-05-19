var nimi = 'Onni';
var salasana = 'Onni2';
var nimiTK = 'Onni';
var salasanaTK = 'Onni2';
if (nimi == nimiTK && salasana == salasanaTK) {
  console.log('Olet käyttäjä ' + nimi + ' tervetuloa!');
} else if (salasana !== salasanaTK) {
  console.log('Salasana väärin');
} else if (nimi !== nimiTK) {
  console.log('Tunnus väärin');
} else {
  console.log('Kaikki meni väärin');
}