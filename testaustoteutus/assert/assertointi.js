function merkkijono(teksti) {
    if (!teksti) {
        throw new Error("Ei merkkijonoa");
    }
    else {
        return null;
    }
}
module.exports = { merkkijono }