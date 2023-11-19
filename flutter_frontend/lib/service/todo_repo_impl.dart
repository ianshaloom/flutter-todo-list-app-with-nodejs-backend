import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../model/todo_item.dart';
import 'todo_repo.dart';

class TodoRepoImpl extends TodoRepo {
  // get todos stream
  @override
  Stream<List<TodoItem>> getTodosStream() async* {
    final response = await http.get(Uri.parse('$serverUrl/api/v1/todolist'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      final List<TodoItem> todos =
          body.map((dynamic item) => TodoItem.fromJson(item)).toList();
      yield todos;
    } else {
      throw Exception('Failed to load todos');
    }
  }
  
  // get todos
  @override
  Future<List<TodoItem>> getTodos() async {
    final response = await http.get(Uri.parse('$serverUrl/api/v1/todolist'));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      final List<TodoItem> todos =
          body.map((dynamic item) => TodoItem.fromJson(item)).toList();
      return todos;
    } else {
      throw Exception('Failed to load todos');
    }
  }

  // add todo
  @override
  Future<TodoItem> addTodo(String todoTitle, bool completed) async {
    completed = false;
    final response = await http.post(
      Uri.parse('$serverUrl/api/v1/todolist'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': todoTitle,
        'completed': completed,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final TodoItem todo = TodoItem.fromJson(body);
      return todo;
    } else {
      throw Exception('Failed to add todo');
    }
  }

  // update todo
  @override
  Future<TodoItem> updateTodo(int id,String todoTitle, bool completed) async {
    final response = await http.put(
      Uri.parse('$serverUrl/api/v1/todolist/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': todoTitle,
        'completed': completed,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final TodoItem todo = TodoItem.fromJson(body);
      return todo;
    } else {
      throw Exception('Failed to update todo');
    }
  }

  // delete todo
  @override
  Future<void> deleteTodo(int id) async {
    final response = await http.delete(
      Uri.parse('$serverUrl/api/v1/todolist/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    } 
  }
}
