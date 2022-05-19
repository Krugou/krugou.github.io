const {uppercase2} = require('../uppercase2');
test(`Uppercase 'test' to equal 'TEST' .then`, () => {
  return uppercase2('test').then(str => {
    expect(str).toBe('TEST');
  });
});
test(`Uppercase 'test' to equal 'TEST' .catch`, () => {
  return uppercase2('test').catch(e => {
    expect(e).toMatch('Empty string');
  });
});

test(`Uppercase 'test' to equal 'TEST' .catch async()`, async () => {
  const str = await uppercase2('test');
  {
    expect(str).toBe('TEST');
  }
)
  ;
  test(`Uppercase 'test' to equal 'TEST' .catch async()`, async () => {
    await uppercase2('').catch(e => {
      expect(e).toMatch('Empty string');
    });
  });