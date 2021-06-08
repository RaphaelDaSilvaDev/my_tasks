import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todo_list/app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return simpleTaskWidget(index);
                      },
                    ),
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
        onTap: () {
          Navigator.pushNamed(context, "/addSimpleTask");
        },
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

  Widget simpleTaskWidget(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 24),
      child: Card(
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(
            "To Do Something",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.justify,
          ),
          trailing: Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
