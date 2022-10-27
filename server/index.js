const express = require("express")
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");

const PORT = process.env.PORT | 3001
const PASSWORD = process.env.MONGO_PASSWORD
const DB = `mongodb+srv://topia:${PASSWORD}@cluster0.bcnqe9q.mongodb.net`;

const app = express()
app.use(express.json())
app.use(authRouter)

mongoose.connect(DB)
    .then(() => console.log("DB Connected!"))
    .catch((err) => console.log(err))



app.listen(PORT, '0.0.0.0', () => console.log("Server running on ", PORT))