const {default: ModuleNotFoundError} = require(
    'jest-resolve/build/ModuleNotFoundError');

function greet(name) {
  return `Hello ${name}`;
}

module.exports = {greet};