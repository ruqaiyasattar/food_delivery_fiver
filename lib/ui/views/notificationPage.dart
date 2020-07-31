import 'package:flutter/material.dart';
import '../widgets/titleAppBar.dart';
import '../shared/text_styles.dart' as style;

class NotificationPage extends StatelessWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: TitleAppBar(title: "Notification"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              NotificationCard(
                message: "You have a new message from the Restaurant",
                color: Colors.lightBlue,
                icon: Icons.mail,
              ),
              NotificationCard(
                message: "Your password sems to be incorrect",
                color: Colors.red,
                icon: Icons.highlight_off,
              ),
              NotificationCard(
                message: "Congratulations! Your action has succeded!",
                color: Colors.green,
                icon: Icons.done,
              ),
              NotificationCard(
                message: "You have a new message from the Restaurant",
                color: Colors.orangeAccent,
                icon: Icons.error_outline,
              ),
              NotificationCard(
                message: "Your Uber has now arrived at your location",
                color: Colors.grey,
                icon: Icons.send,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  IconData icon;

  Color color;

  String message;

  NotificationCard({this.icon, this.color, this.message});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Card(
          elevation: 10,
          child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  ),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(300),),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      "You have a new message from the Restaurant",
                      maxLines: 3,
                      style: style.subHeaderStyle,
                      softWrap: true,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
