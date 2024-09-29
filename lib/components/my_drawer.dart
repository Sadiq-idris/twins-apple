import 'package:dietitian_cons/backend/auth_services.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/profile_screen.dart';
import 'package:dietitian_cons/screens/report_screen.dart';
import 'package:dietitian_cons/screens/admin_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final AuthServices _authServices = AuthServices();

  void signOut() async {
    await _authServices.signOut();
    Navigator.pushNamed(context, "sign-in");
  }

  @override
  Widget build(BuildContext context) {
    final adminEmail = Provider.of<MyAuthProvider>(context).adminEmail;
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(child: Image.asset("assets/images/logo.png")),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                },
                child: const ListTile(
                    leading: Icon(Icons.person), title: Text("Profile")),
              ),
              if (_authServices.getCurrentuser()!.email == adminEmail)
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminUsersScreen()));
                  },
                  child: const ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Admin users")),
                ),
              if (_authServices.getCurrentuser()!.email == adminEmail)
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportScreen()));
                  },
                  child: const ListTile(
                      leading: Icon(Icons.report), title: Text("Reports")),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sign Out"),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: signOut,
              ),
            ],
          )
        ],
      ),
    );
  }
}
