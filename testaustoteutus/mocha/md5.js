var crypto = require('crypto');

module.exports = function(string,callback){
    var withCallBack = typeof callback === 'function';

    try {

        var hash = crypto.createHash('md5').update(string).digest('hex');
    } catch (e) {
        if (withCallBack) callback(e);
        else throw e;
    }
}