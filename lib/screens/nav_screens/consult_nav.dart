import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/user_tile.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/chat_gate_way.dart';
import 'package:dietitian_cons/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class ConsultNav extends StatefulWidget {
  const ConsultNav({super.key});

  @override
  State<ConsultNav> createState() => _ConsultNavState();
}

class _ConsultNavState extends State<ConsultNav> {
  @override
  Widget build(BuildContext context) {
    final myAuthProvider = Provider.of<MyAuthProvider>(context);
    final DbCloud cloud = DbCloud();

    final user = myAuthProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: user!.email == Provider.of<MyAuthProvider>(context).adminEmail
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: StreamBuilder(
                stream: cloud.getUsers(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    final data = snapshots.data;
                    if (data != null) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return UserTile(user: data[index]);
                        },
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          : ChatGateWay(
              email: user.email!,
              name: user.displayName!,
              uid: user.uid,
            ),
    );
  }
}
