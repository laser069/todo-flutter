const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
require('dotenv').config();

const todoRoutes = require('./routes/todoRoutes');

const PORT = process.env.PORT || 3000;
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Database connection
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.DB_URI);
    console.log('✅ MongoDB connected successfully');
  } catch (error) {
    console.error('❌ MongoDB connection error:', error.message);
    process.exit(1);
  }
};

connectDB();

// Routes
app.use('/api/todos', todoRoutes);

// Health check endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'Todo API is running',
    version: '1.0.0',
    endpoints: {
      getAll: 'GET /api/todos/all',
      getById: 'GET /api/todos/:id',
      create: 'POST /api/todos/create',
      update: 'PUT /api/todos/update/:id',
      delete: 'DELETE /api/todos/delete/:id',
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ message: 'Route not found' });
});

// Error handler
app.use((err, req, res, next) => {
  console.error('Server error:', err);
  res.status(500).json({ message: 'Internal Server Error' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});

