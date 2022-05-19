const {isEven, isOdd} = require('../totuusarvot');
describe('Even/odd', () => {
  it('Paluuarvo on TRUE, jos luku on parillinen', () => {
    const results = isEven(2);
    expect(results).toBeTruthy();
    expect(results).not.toBeFalsy();
    expect(isEven(3)).not.toBeTruthy();
  });
});
describe('Even/odd', () => {
  it('Paluuarvo on TRUE, jos luku on pariton', () => {
    const results = isOdd(3);
    expect(results).toBeTruthy();
    expect(results).not.toBeFalsy();
    expect(isOdd(4)).not.toBeTruthy();
  });
});