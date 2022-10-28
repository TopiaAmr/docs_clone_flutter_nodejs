require('dotenv').config()
const express = require("express")
const mongoose = require("mongoose");
const cors = require('cors');
const authRouter = require("./routes/auth");

const PORT = process.env.PORT | 3001
const DB = process.env.mongoDB;

const app = express()
app.use(cors())
app.use(express.json())
app.use(authRouter)

mongoose.connect(DB)
    .then(() => console.log("DB Connected!"))
    .catch((err) => console.log(err))



app.listen(PORT, '0.0.0.0', () => console.log("Server running on ", PORT))