import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:my_tasks/DataBase/database_helper.dart';
import 'package:my_tasks/Models/task_model.dart';
import 'package:my_tasks/Pages/add_simple_task_view.dart';
import 'package:my_tasks/app_controller.dart';

import '../app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Task>> _taskList;

  void initState() {
    super.initState();
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
                                return simpleTaskWidget(snapshot.data?[index]);
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
      right: 24,
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
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
              onDismissed: (direction) =>
                  {DatabaseHelper.instance.deleteTask(task), _updateTaskList()},
              key: Key(task.id.toString()),
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
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
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

  Widget toDoList(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12, left: 12),
              child: Text(
                "Task Name",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                "Firts task",
                textAlign: TextAlign.justify,
              ),
              subtitle: Text("24 maio, 2021"),
              trailing: Checkbox(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onChanged: (value) {
                  print(value);
                },
                activeColor: Theme.of(context).primaryColor,
                value: true,
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
