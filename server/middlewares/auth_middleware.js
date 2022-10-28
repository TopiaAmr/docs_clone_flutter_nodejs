const jwt = required("jsonwebtoken")

const auth = async (req, res, next) => {
    try {
        const token = req.header("auth-token")
        if (!token) {
            return res.status(401).json({ error: "Not authoized! Token is missing." })
        }
        const verified = jwt.verify(token, process.env.passwordKey)
        if (!verified) {
            return res.status(401).json({ error: "Verification failed! Request Denied!" })
        }
        req.user = verified.id
        req.token = token
        next()
    } catch (e) {
        res.status(500).json({ error: "Internal Server Error" })
    }
}

module.exports = auth