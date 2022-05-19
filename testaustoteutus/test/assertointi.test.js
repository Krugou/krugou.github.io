const assert = require('assert');
const {merkkijono} = require('../assert/assertointi');
describe('Assert-kirjasto', () => {
  it('assert() demo', () => {
    assert(100 > 70,
        'Oletettu arvo ei ole suurempi kuin vastaanotettu arvo --> TRUE');
  });
  //Jos kaksi objektia, tai niiden lapsiobjektit eivät ole yhtäsuuria, tulee virhe 
  it('deepStrictEqual() demo', () => {
    let x = {a: {n: 0}};
    let y = {a: {n: 0}};
    let z = {a: {n: 0}};
    assert.deepStrictEqual(x, y);
    assert.deepStrictEqual(x, z);
  });
  //Jos kaksi objektia, tai niiden lapsiobjektit eivät ole yhtäsuuria, tulee virhe 
  it('equal() demo', () => {
    assert.equal(50, 50);
    assert.equal(50, '50');
    assert.equal(50, 50);
  });
  //Jos kaksi objektia, tai niiden lapsiobjektit eivät ole yhtäsuuria, tulee virhe
  it('equal() demo', () => {
    assert.notEqual(51, 50);
    assert.notEqual(51, '50');
    assert.notEqual(51, 50);
    assert.ifError(merkkijono('Testi'), 'Ei merkkijonoa');
  });
  it('ifError demo', () => {
    assert.ifError(merkkijono('testi'));
    assert(typeof 3 == 'number');
  });
});