const express = require('express');
const User = require('../models/user_model');

const authRouter = express.Router();
authRouter.post('/api/signup', async (req, res) => {
    try {
        const { name, email, profilePic } = req.body;
        if (!name | !email | !profilePic) {
            res.json({error: "Body is missing"})
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
            res.status = 200
            res.json({ user })
        } else {
            res.status = 500
            res.json({error: "User already exists"})
        }
    } catch (e) {

    }
})

module.exports = authRouter