const {greet} = require('../util');
describe('Greet Feature', () => {
  it('Should get the greet message', () => {
    const results = greet('Jane');
    expect(results).toBe('Hello Jane');
  });
});