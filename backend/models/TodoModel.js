const mongoose = require('mongoose');

/**
 * Todo Schema
 * Represents a task in the todo application
 */
const todoSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Title is required'],
    trim: true,
  },
  priority: {
    type: String,
    enum: ['High', 'Medium', 'Low'],
    default: 'Medium',
  },
  completed: {
    type: Boolean,
    default: false,
  },
  dueDate: {
    type: Date,
    default: null,
  },
}, {
  timestamps: true, // Adds createdAt and updatedAt fields
});

const Todo = mongoose.model('Todo', todoSchema);

module.exports = Todo;


