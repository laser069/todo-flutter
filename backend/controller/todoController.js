const Todo = require('../models/TodoModel');

/**
 * Create a new todo
 * POST /api/todos/create
 */
const createTodo = async (req, res) => {
  try {
    const { title, priority, completed, dueDate } = req.body;

    // Validate required fields
    if (!title || title.trim() === '') {
      return res.status(400).json({ message: 'Title is required' });
    }

    const newTodo = new Todo({
      title: title.trim(),
      priority: priority || 'Medium',
      completed: completed || false,
      dueDate: dueDate || null,
    });

    await newTodo.save();
    res.status(201).json({ message: 'Todo created successfully', todo: newTodo });
  } catch (error) {
    console.error('Error creating todo:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

/**
 * Get all todos
 * GET /api/todos/all
 */
const getAllTodos = async (req, res) => {
  try {
    const todos = await Todo.find().sort({ createdAt: -1 });
    res.status(200).json({ todos });
  } catch (error) {
    console.error('Error fetching todos:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

/**
 * Update a todo
 * PUT /api/todos/update/:id
 */
const updateTodo = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, priority, completed, dueDate } = req.body;

    // Check if todo exists
    const existingTodo = await Todo.findById(id);
    if (!existingTodo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    const updatedTodo = await Todo.findByIdAndUpdate(
      id,
      {
        title: title?.trim() || existingTodo.title,
        priority: priority || existingTodo.priority,
        completed: completed !== undefined ? completed : existingTodo.completed,
        dueDate: dueDate !== undefined ? dueDate : existingTodo.dueDate,
      },
      { new: true, runValidators: true }
    );

    res.status(200).json({ message: 'Todo updated successfully', todo: updatedTodo });
  } catch (error) {
    console.error('Error updating todo:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

/**
 * Delete a todo
 * DELETE /api/todos/delete/:id
 */
const deleteTodo = async (req, res) => {
  try {
    const { id } = req.params;

    const deletedTodo = await Todo.findByIdAndDelete(id);
    if (!deletedTodo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    res.status(200).json({ message: 'Todo deleted successfully' });
  } catch (error) {
    console.error('Error deleting todo:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

/**
 * Get a single todo by ID
 * GET /api/todos/:id
 */
const getTodoById = async (req, res) => {
  try {
    const { id } = req.params;

    const todo = await Todo.findById(id);
    if (!todo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    res.status(200).json({ todo });
  } catch (error) {
    console.error('Error fetching todo:', error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
};

module.exports = {
  getAllTodos,
  createTodo,
  updateTodo,
  deleteTodo,
  getTodoById,
};


