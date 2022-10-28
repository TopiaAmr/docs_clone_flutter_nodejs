const express = require("express")
const Document = require("../models/document_model")
const docRouter = express.Router()

const authed = require('../middlewares/auth_middleware')

docRouter.post('/doc/create', authed, async (req, res) => {
    try {
        const { createdAt } = req.body;
        let doc = new Document({
            uid: req.user,
            title: 'Untitled Document',
            createdAt,
        })

        doc = await doc.save()
        res.json(doc)
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
})

docRouter.get('/doc', authed, async (req, res) => {
    try {
        let docs = await Document.find({ uid: req.user })
        res.json(docs)
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
})

module.exports = docRouter

