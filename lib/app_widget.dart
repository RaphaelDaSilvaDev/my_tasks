import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Pages/home_view.dart';
import 'app_controller.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Tasks',
            theme: ThemeData(
              brightness: AppController.instance.isDarkTheme
                  ? Brightness.dark
                  : Brightness.light,
              primaryColor: Colors.green,
              textTheme: AppController.instance.isDarkTheme
                  ? GoogleFonts.quicksandTextTheme(
                      Theme.of(context).primaryTextTheme)
                  : GoogleFonts.quicksandTextTheme(Theme.of(context).textTheme),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => HomePage(),
            },
          );
        });
  }
}
