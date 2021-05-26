import 'package:flutter/material.dart';
import 'package:todo_list/Pages/add_list_task_view.dart';
import 'package:todo_list/Pages/add_simple_task_view.dart';
import 'package:todo_list/app_controller.dart';
import 'Pages/home_view.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My ToDo List',
            theme: ThemeData(
              brightness: AppController.instance.isDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
              primaryColor: Colors.green,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => HomePage(),
              '/addSimpleTask': (context) => AddSimpleTask(),
              '/addListTask': (context) => AddListTask()
            },
          );
        });
  }
}
