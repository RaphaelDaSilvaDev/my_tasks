import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:my_tasks/DataBase/database_helper.dart';
import 'package:my_tasks/Models/task_model.dart';
import 'package:my_tasks/Models/todo_model.dart';
import 'package:my_tasks/Pages/add_simple_task_view.dart';
import 'package:my_tasks/app_controller.dart';

import '../app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Task>> _taskList;
  late Future<List<Todo>> _todoList;

  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  _updateTodoList(taskId) {
    setState(() {
      _todoList = DatabaseHelper.instance.getTodoList(taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header(),
                  Expanded(
                    child: FutureBuilder(
                        initialData: [],
                        future: _taskList,
                        builder: (context, AsyncSnapshot<List> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(
                              "No Tasks",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ));
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return showTask(snapshot.data?[index]);
                              },
                            );
                          }
                        }),
                  )
                ],
              ),
              floatingButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "My Tasks",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(AppController.instance.isDarkTheme
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              AppController.instance.changeTheme();
            },
          )
        ],
      ),
    );
  }

  Widget floatingButton() {
    return Positioned(
      bottom: 24,
      right: 28,
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSimpleTask(updateTaskList: _updateTaskList),
            )),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16)),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget showTask(Task task) {
    _todoList = DatabaseHelper.instance.getTodoList(task.id);

    return Expanded(
      child: FutureBuilder(
          initialData: [],
          future: _todoList,
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }

            if (snapshot.data!.isEmpty) {
              return simpleTaskWidget(task);
            } else {
              return todoTaskWidget(task, snapshot);
            }
          }),
    );
  }

  Widget simpleTaskWidget(Task task) {
    return task.isDone == 0
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
            child: Card(
              elevation: 0.2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              color: AppController.instance.isDarkTheme
                  ? task.isDone == 1
                      ? Colors.grey[600]
                      : null
                  : task.isDone == 1
                      ? Colors.grey[100]
                      : null,
              child: ListTile(
                  enabled: task.isDone == 1 ? false : true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  title: Text(
                    task.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.justify,
                  ),
                  subtitle: Text(
                    task.date,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.justify,
                  ),
                  trailing: Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    onChanged: (value) {
                      if (value != null) {
                        task.isDone = value ? 1 : 0;
                      }
                      DatabaseHelper.instance.updateTask(task);
                      _updateTaskList();
                    },
                    activeColor: Theme.of(context).primaryColor,
                    value: task.isDone == 1 ? true : false,
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddSimpleTask(
                            task: task, updateTaskList: _updateTaskList),
                      ))),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
            child: Dismissible(
              onDismissed: (direction) {
                DatabaseHelper.instance.deleteTask(task);
                _updateTaskList();
              },
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  )),
              child: Card(
                elevation: 0.2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                color: AppController.instance.isDarkTheme
                    ? task.isDone == 1
                        ? Colors.grey[600]
                        : null
                    : task.isDone == 1
                        ? Colors.grey[100]
                        : null,
                child: ListTile(
                    enabled: task.isDone == 1 ? false : true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    title: Text(
                      task.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.justify,
                    ),
                    subtitle: Text(
                      task.date,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.justify,
                    ),
                    trailing: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      onChanged: (value) {
                        if (value != null) {
                          task.isDone = value ? 1 : 0;
                        }
                        DatabaseHelper.instance.updateTask(task);
                        _updateTaskList();
                      },
                      activeColor: Theme.of(context).primaryColor,
                      value: task.isDone == 1 ? true : false,
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddSimpleTask(
                              task: task, updateTaskList: _updateTaskList),
                        ))),
              ),
            ),
          );
  }

  Widget todoTaskWidget(Task task, AsyncSnapshot<List> snapshot) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
      child: Card(
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: AppController.instance.isDarkTheme
            ? task.isDone == 1
                ? Colors.grey[600]
                : null
            : task.isDone == 1
                ? Colors.grey[100]
                : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              enabled: task.isDone == 1 ? false : true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              title: Text(
                task.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                textAlign: TextAlign.justify,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddSimpleTask(
                      task: task, updateTaskList: _updateTaskList),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 310),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return toDoList(task, snapshot.data?[index]);
                },
              ),
            ),
            ListTile(
              dense: true,
              title: Text(
                task.date,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget toDoList(Task task, Todo todo) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          onChanged: (value) {
            if (value != null) {
              todo.isDone = value ? 1 : 0;
              DatabaseHelper.instance.updateTodo(todo);
              _updateTodoList(task.id);
            }
          },
          activeColor: Colors.green,
          value: todo.isDone == 1 ? true : false,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              todo.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}
