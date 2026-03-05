const express = require('express');
const todo = require('../models/TodoModel')

const createTodo = async (req,res)=>{
    try{
        const {title,priority,completed,dueDate} = req.body;
        const newTodo  = new todo({
            title:title,
            priority:priority,
            completed:completed,
            dueDate:dueDate
        })
        await newTodo.save();
        res.status(201).json({message:'Todo created successfully',todo:newTodo})

    }catch(e){
        console.log(e);
        res.status(500).json({message:'Internal Server Error'})
    }
}

const getAllTodos = async (req,res)=>{
    try{    
        const todos = await todo.find();
        res.status(200).json({todos:todos})
    }catch(e){
        console.log(e);
        res.status(500).json({message:'Internal Server Error'})
    }
}


const updateTodo = async (req,res)=>{
    try{
        const {id} = req.params;
        const {title,priority,completed,dueDate} = req.body;

        const updatedTodo  =await todo.findByIdAndUpdate(id,{
            title:title,
            priority:priority,
            completed:completed,
            dueDate:dueDate
        },{new:true})
        
        res.status(200).json({message:'Todo updated',todo:updatedTodo})
    }catch(e){
        console.log(e);
        res.status(500).json({message:'Internal Server Error'})

    }
}

const deleteTodo = async (req,res)=>{
    try{
        const {id} = req.params;
        await todo.findByIdAndDelete(id);
        res.status(200).json({message:'todo deleted'})
    }catch(e){
        console.log(e);
        res.status(500).json({message:'Internal Server Error'})
    }
}


const getTodoById = async (req,res)=>{
    try{
        const {id} = req.params;
        const foundTodo = await todo.findById(id);
        if(foundTodo){
            res.status(200).json({todo:foundTodo})

        }else{
            res.status(404).json({message:'todo not found'})
        }
        
    }catch(e){
        console.log(e);
        res.status(500).json({message:'Internal Server Error'})
    }
}

module.exports = {
    getAllTodos,
    createTodo,
    updateTodo,
    deleteTodo,
    getTodoById,
}


