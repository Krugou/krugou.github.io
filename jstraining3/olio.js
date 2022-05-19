var lemmikki = {
  petspecies: 'cat',
  petname: 'Capri',
  petownerfirstName: 'Jesper',
  petownersecondName: 'Hogstad',
  petcolor: 'white and black',
  petbreed: 'Norwegian Forest cat',
  petheight: '60',
  petweight: '10',
  id: 0022,
  fullName: function() {
    return this.petownerfirstName + ' ' + this.petownersecondName;
  },
  petdetails: function() {
    return this.petspecies + ' ' + this.petname + ' ' + this.petspecies + ' ' +
        this.petcolor + ' ' + this.petbreed;
  },
};
console.log(lemmikki.fullName());
console.log(lemmikki.petdetails());