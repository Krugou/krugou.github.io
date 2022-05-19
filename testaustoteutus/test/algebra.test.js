const {
  sum, mul, sub, div, speci...käyttäjältä janne.salonen

  janne.salonen10.58
  const {sum, mul, sub, div, special} = require('../algebra')



  describe
('Algebran testaus...', () => {

  test('Lasketaan yhteen 1 + 1 = 2', () => {

    expect(sum(1, 1)).toBe(2);

  });

  test('Kerrotaan 1 * 1 = 1', () => {

    expect(mul(1, 1)).not.toBe(0);

  });

  test('Miinustetaan 1-1 = 0', () => {

    expect(sub(1, 1)).toBe(0);

  });

  test('Testataan, että arvo on suurempi kuin 4', () => {

    expect(sub(5, 0)).toBeGreaterThanOrEqual(5);

  });

  test('Jaetaan 1/1 = 1', () => {

    expect(div(1, 1)).toBe(1);

  });

  test('Jaetaan 1/0 = Ääretön', () => {

    expect(div(1, 0)).toBe(Infinity);

  });

  test('Special palauttaa null', () => {

    expect(special()).toBeNull();

  });

});