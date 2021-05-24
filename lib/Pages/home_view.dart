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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {},
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
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return buildTask(index);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTask(int index) {
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
}
