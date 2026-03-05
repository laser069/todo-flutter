const express = require("express")
const cors = require("cors")
const mongoose = require("mongoose")

require('dotenv').config()
const todoRoutes = require('./routes/todoRoutes')

const PORT = 3000;
const app = express()

mongoose.connect(process.env.DB_URI).then(()=>{
    console.log("connected!")
}).catch((e)=>{
    console.log(e);
})

app.use(cors())
app.use(express.json())
app.use('/api/todos',todoRoutes)

app.get("/",(req,res)=>{
    return res.json({message:"Hello"})
})


app.listen(PORT,()=>{
    console.log(`Server runnin at ${PORT}`)
})



