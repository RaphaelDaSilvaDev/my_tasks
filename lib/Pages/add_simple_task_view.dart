import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import '../app_controller.dart';

class AddSimpleTask extends StatelessWidget {
  String actualDate = formatDate(DateTime.now(), [d, '-', M, '-', yy]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: Icon(AppController.instance.isDarkTheme
                              ? Icons.arrow_back_ios
                              : Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Simple Task",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: "Your Task",
                            hintStyle: TextStyle(fontSize: 18),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                        SizedBox(
                          height: 300,
                        ),
                        Text(
                          actualDate,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 46,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            // Add your onPressed code here!
                          },
                          child: const Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            // Add your onPressed code here!
                          },
                          child: const Icon(Icons.add),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
