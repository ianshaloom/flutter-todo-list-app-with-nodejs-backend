// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'model/todo_item.dart';
import 'service/todo_repo.dart';
import 'service/todo_repo_impl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Node Backend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoRepo todoRepo = TodoRepoImpl();
  List<TodoItem> todoses = [];

  Future<TodoItem> _completeTodo(bool value, int id) async {
    try {
      final TodoItem todo = await todoRepo
          .updateTodo(
            id,
            todoses[id].title,
            value,
          )
          .whenComplete(() => showSnackBar(
                context: context,
                message: 'Todo ${value ? 'completed' : 'uncompleted'}',
              ));
      return todo;
    } on Exception catch (e) {
      showSnackBar(context: context, message: 'Error: $e');
      return todoses[id];
    }
  }

  // Function to delete a todo
  Future<void> _deleteTodo(
    int id,
  ) async {
    try {
      await todoRepo
          .deleteTodo(
            id,
          )
          .whenComplete(() => showSnackBar(
                context: context,
                message: 'Todo deleted',
              ));
    } on Exception catch (e) {
      showSnackBar(context: context, message: 'Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // todoRepo.getTodos().then((value) => setState(() => todos = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text('Todo List'),
            centerTitle: true,
            floating: true,
            pinned: true,
            snap: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: FutureBuilder(
                future: todoRepo.getTodos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverFillRemaining(
                      child: Center(
                        child: SizedBox(
                          height: 75,
                          width: 75,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text('Error fetching todos'),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final List<TodoItem> todos =
                        snapshot.data as List<TodoItem>;
                    todoses = todos;

                    return SliverList.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Checkbox(
                          value: todos[index].completed,
                          onChanged: (value) {
                            _completeTodo(
                              value!,
                              todos[index].id,
                            ).then((value) =>
                                setState(() => todos[index] = value));
                          },
                        ),
                        minVerticalPadding: 16,
                        title: Text(todos[index].title),
                        trailing: IconButton(
                          onPressed: () {
                            _deleteTodo(
                              todos[index].id,
                            ).then((value) =>
                                setState(() => todos.removeAt(index)));
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  } else {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text('No todos'),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 1,
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: const Duration(milliseconds: 1500),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 15, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

class TodoListStream extends StatelessWidget {
  TodoListStream({super.key});

  final TodoRepo todoRepo = TodoRepoImpl();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: todoRepo.getTodosStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching todos'),
          );
        } else if (snapshot.hasData) {
          final List<TodoItem> todos = snapshot.data as List<TodoItem>;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) => ListTile(
              leading: Checkbox(
                value: todos[index].completed,
                onChanged: (value) {},
              ),
              minVerticalPadding: 16,
              title: Text(todos[index].title),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text('No todos'),
          );
        }
      },
    );
  }
}
