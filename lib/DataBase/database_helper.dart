import 'dart:io';

import 'package:my_tasks/Models/todo_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_tasks/Models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String taskTable = "task_table";
  String todoTable = "todo_table";
  String id = "id";
  String taskId = "taskId";
  String title = "title";
  String date = "date";
  String isDone = "isDone";

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "task_list.db";
    final taskListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return taskListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $taskTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $date TEXT, $isDone INTEGER)',
    );

    await db.execute(
      'CREATE TABLE $todoTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $taskId INTEGER, $title TEXT, $isDone INTEGER)',
    );
  }

  //Task
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(taskTable);
    return result;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }

  Future<int> insetTask(Task task) async {
    int taskId = 0;
    Database? db = await this.db;
    final int result = await db!.insert(taskTable, task.toMap()).then((value) {
      taskId = value;
      return taskId;
    });

    return result;
  }

  Future<int> updateTask(Task task) async {
    Database? db = await this.db;
    final int result = await db!.update(
      taskTable,
      task.toMap(),
      where: '$id = ?',
      whereArgs: [task.id],
    );

    return result;
  }

  Future<int> deleteTask(Task? task) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      taskTable,
      where: '$id = ?',
      whereArgs: [task!.id],
    );

    return result;
  }

  //Todo

  Future<List<Map<String, dynamic>>> getTodoMapList(int? taskIdInt) async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!
        .query(todoTable, where: '$taskId = ?', whereArgs: [taskIdInt]);
    return result;
  }

  Future<List<Todo>> getTodoList(int? taskIdInt) async {
    final List<Map<String, dynamic>> todoMapList =
        await getTodoMapList(taskIdInt);
    final List<Todo> todoList = [];
    todoMapList.forEach((todoMap) {
      todoList.add(Todo.fromMap(todoMap));
    });

    return todoList;
  }

  Future<int> insetTodo(Todo todo) async {
    Database? db = await this.db;
    final int result = await db!.insert(todoTable, todo.toMap());

    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database? db = await this.db;
    final int result = await db!.update(
      todoTable,
      todo.toMap(),
      where: '$id = ?',
      whereArgs: [todo.id],
    );

    return result;
  }

  Future<int> deleteTodo(Todo? todo) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      todoTable,
      where: '$id = ?',
      whereArgs: [todo!.id],
    );

    return result;
  }
}
