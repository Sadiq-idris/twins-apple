import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTile extends StatefulWidget {
  const UserTile({super.key, required this.user});

  final Map user;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final DbCloud _cloud = DbCloud();
  @override
  Widget build(BuildContext context) {
    // final userEmail = Provider.of<MyAuthProvider>(context).user!.email;
    return FutureBuilder(
      future: _cloud.getNotification(widget.user["email"]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.data();

          return data != null
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(widget.user["email"]),
                        ),
                        body: ChatScreen(
                            email: widget.user["email"],
                            uid: widget.user["uid"]),
                      );
                    }));
                  },
                  child: widget.user["email"] !=
                          Provider.of<MyAuthProvider>(context).adminEmail
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(widget.user["email"]),
                            trailing: data["send"]
                                ? const Icon(
                                    Icons.notification_add,
                                    color: Colors.green,
                                  )
                                : const Icon(Icons.notifications),
                          ),
                        )
                      : const SizedBox(),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(widget.user["email"]),
                        ),
                        body: ChatScreen(
                            email: widget.user["email"],
                            uid: widget.user["uid"]),
                      );
                    }));
                  },
                  child: widget.user["email"] !=
                          Provider.of<MyAuthProvider>(context).adminEmail
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(widget.user["email"]),
                            trailing: const Icon(Icons.notifications),
                          ),
                        )
                      : const SizedBox());
        }

        return Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }
}
