import '../model/todo_item.dart';

abstract class TodoRepo {
  Future<List<TodoItem>> getTodos();
  Stream<List<TodoItem>> getTodosStream();
  Future<TodoItem> addTodo(String todoTitle, bool completed);
  Future<TodoItem> updateTodo(int id,String todoTitle, bool completed);
  Future<void> deleteTodo(int id);
}