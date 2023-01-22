const jwt = require ("jsonwebtoken")


module.exports = function (req,res,next) {
    const token= req.header("x-auth-token")
    if (!token) {
        return res.status(401).send("access denied !! ")
    }
    try {
        const decodeToken = jwt.verify(token,"privateKey")
        req.user=decodeToken
        next()
    } catch (e) {
        res.status(400).send("token invalid !")
    }
}