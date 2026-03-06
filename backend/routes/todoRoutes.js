const express = require('express');
const router = express.Router();

const {
  getAllTodos,
  createTodo,
  updateTodo,
  deleteTodo,
  getTodoById,
} = require('../controller/todoController');

// Route definitions
router.get('/all', getAllTodos);          // GET /api/todos/all - Get all todos
router.get('/:id', getTodoById);          // GET /api/todos/:id - Get single todo
router.post('/create', createTodo);       // POST /api/todos/create - Create new todo
router.put('/update/:id', updateTodo);    // PUT /api/todos/update/:id - Update todo
router.delete('/delete/:id', deleteTodo); // DELETE /api/todos/delete/:id - Delete todo

module.exports = router;