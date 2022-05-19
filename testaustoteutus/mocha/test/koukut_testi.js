var should = require('should');
it('lintujenpitäisi lentää', function() {
});
describe('galaksi', function() {
  describe('maa', function() {
    describe('helsinki', function() {
      it('lintujen pitäisi lentää', function() { /**... */});
    });
  });
});
describe('helsinki', function() {
  it('lintujen pitäisi lentää', function() { /**... */});
  it('hevosten pitäisi laukata', function() { /**... */});
});
describe('helsinki', function() {
  before(function() {
    console.log('näetkö...tämä functio ajetaan vain kerran');
  });
  it('bird should fly', function() { /**... */});
  it('horses should gallop', function() { /**... */});
});
describe('helsinki', function() {
  beforeEach(function() {
    console.log('näetkö...tämä functio ajetaan joka kerta');
  });
  it('lintujen pitäisi lentää', function() { /**... */});
  it('hevosten pitäsi laukata', function() { /**... */});
});
describe('maa', function() {
  describe('helsinki', function() {
    it('lintujen pitäisi lentää', function() { /**... */});
  });
  describe('ruotsi', function() {
    it('lintujen pitäisi rynnätä', function() { /**... */});
  });
});
describe('earth', function() {
  before(function() {
    console.log(
        'näetkö...tämä functio ajetaan kerran,ennen ensimmäistä describeä()');
  });
  describe('helsinki', function() {
    it('lintujen pitäisi lentää', function() { /**... */});
  });
  describe('ruotsi', function() {
    it('lintujen pitäisi rynnätä', function() { /**... */});
  });
});
describe('maa',
    function() {
      beforeEach(function() {
        console.log(
            'näetkö...tämä functio ajetaan joka kerta, ennen describeä()');
      });
      describe('helsinki', function() {
        it('lintujen pitäisi lentää', function() { /**... */});
      });
      describe('ruotsi', function() {
        it('lintujen pitäisi rynnätä', function() { /**... */});
      });
    });