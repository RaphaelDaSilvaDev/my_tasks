import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:todo_list/app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        backgroundColor: Theme.of(context).primaryColor,
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor:
            AppController.instance.isDarkTheme ? Colors.black : Colors.white,
        overlayOpacity: 0.6,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.task,
            ),
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            label: "Simple Task",
            labelStyle: TextStyle(fontSize: 18),
            labelBackgroundColor: AppController.instance.isDarkTheme
                ? Colors.grey[800]
                : Colors.white,
            onTap: () {
              Navigator.pushNamed(context, '/addSimpleTask');
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.list_alt_rounded),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            label: "List Task",
            labelStyle: TextStyle(fontSize: 18),
            labelBackgroundColor: AppController.instance.isDarkTheme
                ? Colors.grey[800]
                : Colors.white,
            onTap: () {
              Navigator.pushNamed(context, '/addListTask');
            },
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Text(
                      "My ToDo List",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: IconButton(
                      icon: Icon(AppController.instance.isDarkTheme
                          ? Icons.light_mode
                          : Icons.dark_mode),
                      onPressed: () {
                        AppController.instance.changeTheme();
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return toDoSimple(index);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget toDoSimple(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ListTile(
          title: Text(
            "To Do Something",
            textAlign: TextAlign.justify,
          ),
          subtitle: Text("24 maio, 2021"),
          trailing: Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onChanged: (value) {
              print(value);
            },
            activeColor: Theme.of(context).primaryColor,
            value: true,
          ),
        ),
      ),
    );
  }

  Widget toDoList(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
