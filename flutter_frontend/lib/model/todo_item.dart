class TodoItem {
  final int id;
  final String title;
  final bool completed;

  TodoItem({required this.id, required this.title, required this.completed});

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(id: json['id'], title: json['title'], completed: json['completed']);
  }
}
