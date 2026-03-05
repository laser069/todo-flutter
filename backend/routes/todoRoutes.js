const express = require('express');

const router = express.Router();

const {getAllTodos,createTodo,updateTodo,deleteTodo,getTodoById} = require('../controller/todoController');

router.get('/all',getAllTodos);
router.get('/:id',getTodoById)
router.post('/create',createTodo);
router.put('/update/:id',updateTodo)
router.delete('/delete/:id',deleteTodo)

module.exports = router;