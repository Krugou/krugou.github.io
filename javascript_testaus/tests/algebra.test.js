const {test} = require('@jest/globals');
const {sum, mul, sub, div} = require('../algebra');
describe('Algebran testaus...', () => {

  test('Lasketaan yhteen 1 + 1=2', () => {
    expect(sum(1, 1)).toBe(2);

  });

  test(' Kerrotaan 1 * 1=1', () => {
    expect(mul(1, 1)).toBe(1);

  });

  test('Miinustetaan 1-1 = 0', () => {
    expect(sub(1, 1)).toBe(0);

  });

  test('Jaetaan 1/1 = 1', () => {
    expect(div(1, 1)).toBe(1);

  });
});