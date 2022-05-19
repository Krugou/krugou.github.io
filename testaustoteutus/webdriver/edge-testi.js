const edge = require('@microsoft/edge-selenium-tools');

// launch microsoft edge (chromium)
let options = new edge.Options().setEdgeChromium(true);
let driver = edge.driver.createSession(options);
driver.get('http://www.webdriverjs.com');
driver.findElement(by.css('.search-field.form-control')).
    sendKeys('WebdriverJs');
driver.findElement(by.css('button.search-submit i')).click();
driver.wait(untilelementTextIs(driver.findElement(By.css('.vl-main-header>h1')),
    'Search Results for: WebdriverJs'), 10000);
driver.quit();