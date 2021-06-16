class Todo {
  int? id;
  int? taskId;
  String title;
  int isDone;

  Todo({
    required this.title,
    required this.isDone,
    required this.taskId,
  });
  Todo.withId({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['isDone'] = isDone;
    map['taskId'] = taskId;
    return map;
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo.withId(
      id: map['id'],
      taskId: map['taskId'],
      title: map['title'],
      isDone: map['isDone'],
    );
  }
}
