class Task {
  int? id;
  String title;
  String date;
  int isDone;

  Task({
    required this.date,
    required this.isDone,
    required this.title,
  });

  Task.withId({
    required this.date,
    required this.isDone,
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['date'] = date;
    map['isDone'] = isDone;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      isDone: map['isDone'],
    );
  }
}
