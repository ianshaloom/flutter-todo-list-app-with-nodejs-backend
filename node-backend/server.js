const express = require("express");

// app config
const app = express();

const port = 3001;

// middleware config

app.use(express.json());

// api routes
app.get("/api/v1/todolist", (req, res) => res.json(todos));
app.post("/api/v1/todolist", (req, res) => {
  let todo = {
    id: todos.length + 1,
    title: req.body.title,
    completed: false,
  };

  todos.push(todo);
  res.status(201).json(todo);
});

app.put("/api/v1/todolist/:id", (req, res) => {
  let todoId = req.params.id;
  let updatedTodo = todos.find((todo) => todo.id == todoId);

  if (!updatedTodo) {
    res.status(404).send("Todo not found");
  } else {
    updatedTodo.title = req.body.title;
    updatedTodo.completed = req.body.completed;
    res.status(200).json(updatedTodo);
  }
});
app.delete("/api/v1/todolist/:id", (req, res) => {
  let todoId = req.params.id;
  let todoIndex = todos.findIndex((todo) => todo.id == todoId);

  if (todoIndex === -1) {
    res.status(404).send("Todo not found");
  } else {
    todos.splice(todoIndex, 1);
    res.status(200).send("Todo deleted");
  }
});

// define a list of todos
const todos = [
  { id: 1, title: "Learn Node.js", completed: false },
  { id: 2, title: "Learn Express.js", completed: false },
  { id: 3, title: "Learn MongoDB", completed: false },
  { id: 4, title: "Learn React", completed: false },
  { id: 5, title: "Learn Redux", completed: false },
  { id: 6, title: "Learn GraphQL", completed: false },
  { id: 7, title: "Learn Apollo", completed: false },
  { id: 8, title: "Learn Mongoose", completed: false },
  { id: 9, title: "Learn PostgreSQL", completed: false },
  { id: 10, title: "Learn MySQL", completed: false },
  { id: 11, title: "Learn HTML", completed: false },
  { id: 12, title: "Learn CSS", completed: false },
  { id: 13, title: "Learn JavaScript", completed: false },
  { id: 14, title: "Learn TypeScript", completed: false },
  { id: 15, title: "Learn Python", completed: false },
  { id: 16, title: "Learn Java", completed: false },
  { id: 17, title: "Learn C#", completed: false },
  { id: 18, title: "Learn C++", completed: false },
  { id: 19, title: "Learn PHP", completed: false },
  { id: 20, title: "Learn Ruby", completed: false },
];

// listeners
app.listen(port, () => console.log(`listening on localhost: ${port}`));
