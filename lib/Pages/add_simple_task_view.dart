import 'package:flutter/material.dart';

class AddSimpleTask extends StatelessWidget {
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
                  Container(
                    margin: EdgeInsets.only(
                        top: 24, left: 18, right: 24, bottom: 24),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                hintText: "Task Name",
                                border: InputBorder.none),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 14, right: 24),
                    child: Column(
                      children: [
                        todoWidget("Do someting", true),
                        todoWidget("My other task", true),
                        todoWidget("This is for test", false),
                        todoWidget(
                            "This is a big task for test the break line is work or not in this case... hahaha",
                            false),
                      ],
                    ),
                  )
                ],
              ),
              floatingButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget todoWidget(title, isDone) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onChanged: (value) {},
            activeColor: Colors.green,
            value: isDone,
          ),
          Expanded(
            child: Text(
              title ?? "Unnamed Task",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDone ? Colors.grey : null),
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
        onTap: () {},
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
}
