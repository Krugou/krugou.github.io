const uppercase2 = (str) => {
    return new Promise((resolve,reject) =>{
        if(!str){
            reject ('Empty string')
            return
        }
        resolve(str.toUpperCase())
    })
}
module.exports = { uppercase2}