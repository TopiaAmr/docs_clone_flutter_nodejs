const express = require('express');
const User = require('../models/user_model');
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth_middleware');

const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {
    try {
        const { name, email, profilePic } = req.body;
        if (!name | !email | !profilePic) {
            res.json({ error: "Body is missing" })
            return
        }
        let user = await User.findOne({ email: email })
        if (!user) {
            user = new User({
                name,
                email,
                profilePic
            })
            user = await user.save()
        }

        const token = jwt.sign({ id: user._id }, process.env.passwordKey)
        res.status(200).json({ user, token })
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
})

authRouter.get('/api/profile', auth, async (req, res) => {
    const user = await User.findById(req.user)
    const token = req.token
    res.json({ user, token })
})

module.exports = authRouter