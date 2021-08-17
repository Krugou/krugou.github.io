const { getBalance} = require ('../bankaccount');

describe('BankAccount', () => {
    it('Should get the balance of the user',() => {
        expect(100).toBe(getBalance('Nokelainen'))
    });
});