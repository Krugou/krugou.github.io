
const { Triangle} = require ('../triangle');

describe('Triangle',() => {
    test ('Should correctly create a triangle object with three lengths', ()=>{
        const triangle = new Triangle(2,4,5);
        expect (triangle.side1).toEqual(2);
        expect (triangle.side2).toEqual(4);
        expect (triangle.side3).toEqual(5);
    });
});
describe('Should correctly determine whether three lengths are not a triangle',() => {
    const notTriangle = new Triangle(3,9,22);
    expect(notTriangle.checkType()).toEqual('Not a triangle');
});
describe('Tarkistetaan, onko epäsäännöllinen kolmio',() => {
    const notTriangle = new Triangle(4,5,7);
    expect(notTriangle.checkType()).toEqual('epäsäännöllinen kolmio');
});