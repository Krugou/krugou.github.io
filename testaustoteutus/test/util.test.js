const {greet} = require('../util');

describe('Testataan merkkijonoja...', () => {

  test('Tulostaa tervehdys viestin', () => {

    const results = greet('Jasmin');

    expect(results).toBe('Terve Jasmin');

  });

});