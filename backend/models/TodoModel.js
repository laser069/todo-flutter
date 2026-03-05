const mongoose = require('mongoose');

const todoSchema = new mongoose.Schema({
    title:{type:String,required:true},
    priority:{type:String,enum:['High','Medium','Low'],default:'Medium',required:true},
    completed:{type:Boolean,default:false},
    dueDate:{type:Date,default:null},
    },{timestamps:true}
)

const todo = mongoose.model('Todo',todoSchema);
module.exports = todo;







