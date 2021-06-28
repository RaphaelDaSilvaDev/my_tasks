import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:my_tasks/DataBase/database_helper.dart';
import 'package:my_tasks/Models/task_model.dart';
import 'package:my_tasks/Models/todo_model.dart';

class AddSimpleTask extends StatefulWidget {
  final Function updateTaskList;
  final Task? task;

  AddSimpleTask({this.task, required this.updateTaskList});

  @override
  _AddSimpleTaskState createState() => _AddSimpleTaskState();
}

class _AddSimpleTaskState extends State<AddSimpleTask> {
  late Future<List<Todo>> _todoList;
  String _title = "";
  String _date = formatDate(DateTime.now(), ['dd', " - ", "M", " - ", "yyyy"]);
  int? _taskId = 0;

  FocusNode? _todoFocus;

  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _date = widget.task!.date;
      _taskId = widget.task?.id;
      _todoFocus = FocusNode();
    }
    _updateTodoList();
  }

  _updateTodoList() {
    setState(() {
      _todoList = DatabaseHelper.instance.getTodoList(_taskId);
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
                            return Center(
                                child: Text(
                              "No Todos",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ));
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return todoWidget(snapshot.data?[index]);
                              },
                            );
                          }
                        }),
                  ),
                  _taskId != 0 ? newTodoWidget() : Container()
                ],
              ),
              floatingButton(),
              date(),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.only(top: 24, left: 18, right: 24, bottom: 24),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (widget.updateTaskList != null) {
                widget.updateTaskList();
              }
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: widget.task?.title ?? "Task Name",
                  border: InputBorder.none),
              onSubmitted: (value) async {
                if (value != "") {
                  _title = value;
                  Task task = Task(date: _date, isDone: 0, title: _title);
                  if (widget.task == null) {
                    task.isDone = 0;
                    _taskId = await DatabaseHelper.instance.insetTask(task);
                  } else {
                    task.id = _taskId;
                    task.isDone = widget.task!.isDone;
                    DatabaseHelper.instance.updateTask(task);
                  }
                  setState(() {});
                  widget.updateTaskList();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget newTodoWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 96.0),
        child: Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onChanged: (value) {},
              activeColor: Colors.green,
              value: false,
            ),
            Expanded(
              child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  focusNode: _todoFocus,
                  controller: TextEditingController()..clear(),
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                      hintText: "Enter Todo Item", border: InputBorder.none),
                  textAlign: TextAlign.justify,
                  onSubmitted: (value) async {
                    if (value != "") {
                      Todo todo =
                          Todo(taskId: _taskId, isDone: 0, title: value);
                      DatabaseHelper.instance.insetTodo(todo);
                      _updateTodoList();
                      _todoFocus?.requestFocus();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget todoWidget(Todo todo) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      child: Row(
        children: [
          Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onChanged: (value) {
              if (value != null) {
                todo.isDone = value ? 1 : 0;
                DatabaseHelper.instance.updateTodo(todo);
                _updateTodoList();
              }
            },
            activeColor: Colors.green,
            value: todo.isDone == 1 ? true : false,
          ),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              decoration: InputDecoration(
                  hintText: todo.title,
                  border: InputBorder.none,
                  hintMaxLines: 10),
              textAlign: TextAlign.justify,
              onSubmitted: (value) async {
                if (value != "") {
                  Todo todoWithId = Todo.withId(
                      id: todo.id,
                      taskId: _taskId,
                      isDone: widget.task!.isDone,
                      title: value);
                  DatabaseHelper.instance.updateTodo(todoWithId);
                  _updateTodoList();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget floatingButton() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: GestureDetector(
        onTap: () {
          print(widget.task!.id);
          DatabaseHelper.instance.deleteTask(widget.task);
          widget.updateTaskList();
          Navigator.pop(context);
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(16)),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget date() {
    return Positioned(
      bottom: 108,
      right: 24,
      child: Text(
        '$_date',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w100, color: Colors.grey),
      ),
    );
  }
}
