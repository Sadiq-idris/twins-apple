import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/user_tile.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/chat_gate_way.dart';
import 'package:flutter/material.dart';
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
    final adminEmail = Provider.of<MyAuthProvider>(context).adminEmail;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: StreamBuilder(
            stream: cloud.getAdmins(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                final data = snapshots.data.docs;
                for (var admin in data) {
                  if (user!.email == admin["email"] || user.email == adminEmail) {
                    return displayingUsers(cloud);
                  } else {
                    return ChatGateWay(
                        email: user.email!,
                        name: user.displayName!,
                        uid: user.uid);
                  }
                }
              }
        
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  StreamBuilder<List<Map<String, dynamic>>> displayingUsers(DbCloud cloud) {
    return StreamBuilder(
      stream: cloud.getUsers(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          final data = snapshots.data;
          if (data != null) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index){
                final saveUser = data[index];

                return UserTile(user: saveUser, isAdmin: false,);
              }
            );
          }
        }

        return const Text("Loadding....");
      },
    );
  }
}
