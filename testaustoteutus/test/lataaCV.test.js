const { isValidURL } = require ('../isValidURL')
describe('isValidURL-funktion testaus', () => {
    test('http://www.example.com', () => {
        expect(isValidURL('http://www.example.com')).toBeTruthy();
    })
    test('https://www.example.com', () => {
        expect(isValidURL('https://www.example.com')).toBeTruthy();
    })
    test('www.example.com', () => {
        expect(isValidURL('www.example.com')).toBeTruthy();
    })
    test('example.com', () => {
        expect(isValidURL('example.com')).toBeTruthy();
    })
    test('example.io', () => {
        expect(isValidURL('example.io')).toBeTruthy();
    })
    test('https://localhost:80', () => {
        expect(isValidURL('https://localhost:80')).not.toBeTruthy();
    })
    test('http://en.wikipedia.org/wiki/Procter_&_Gamble', () => {
        expect(isValidURL('http://en.wikipedia.org/wiki/Procter_&_Gamble')).toBeTruthy();
    })
    test('http://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&docid=nIv5rk2GyP3hXM&tbnid=isiOkMe3nCtexM:&ved=0CAUQjRw&url=http%3A%2F%2Fanimalcrossing.wikia.com%2Fwiki%2FLion&ei=ygZXU_2fGKbMsQTf4YLgAQ&bvm=bv.65177938,d.aWc&psig=AFQjCNEpBfKnal9kU7Zu4n7RnEt2nerN4g&ust=1398298682009707',() => {
        expect(isValidURL('http://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&docid=nIv5rk2GyP3hXM&tbnid=isiOkMe3nCtexM:&ved=0CAUQjRw&url=http%3A%2F%2Fanimalcrossing.wikia.com%2Fwiki%2FLion&ei=ygZXU_2fGKbMsQTf4YLgAQ&bvm=bv.65177938,d.aWc&psig=AFQjCNEpBfKnal9kU7Zu4n7RnEt2nerN4g&ust=1398298682009707')).toBeTruthy()
    })
    test('https://sdfasd', () => {
        expect(isValidURL('https://sdfasd')).not.toBeTruthy();
    })
    test('dfdsfdsfdfdsfsdfs', () => {
        expect(isValidURL('dfdsfdsfdfdsfsdfs')).not.toBeTruthy();
    })
    test('https://sdfasd', () => {
        expect(isValidURL('https://sdfasd')).not.toBeTruthy();
    })
    test('magnet:?xt=urn:btih:123', () => {
        expect(isValidURL('magnet:?xt=urn:btih:123')).not.toBeTruthy();
    })
    test('https://stackoverflow.com/', () => {
        expect(isValidURL('https://stackoverflow.com/')).toBeTruthy();
    })
    test('https://w', () => {
        expect(isValidURL('https://w')).not.toBeTruthy();
    })