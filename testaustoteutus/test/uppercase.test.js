const {uppercase} = require('../uppercase');

test(`Uppercase 'test' to equal 'TEST'`, (done) => {
  uppercase('test', (str) => {
    expect(str).toBe('TEST');
    done();
  });

});