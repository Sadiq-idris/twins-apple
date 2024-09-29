import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:flutter/material.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final DbCloud _cloud = DbCloud();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin users"),
      ),
      body: StreamBuilder(
        stream: _cloud.getAdmins(),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            final data = snapshots.data.docs;
            if (data != null) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final adminUser = data[index].data();
                  final docId = data[index].id;
                  return ListTile(
                    title: Text(adminUser["email"]),
                    trailing: IconButton(
                      onPressed: () {
                        _cloud.deleteAdmin(docId);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectAdminUser();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget? selectAdminUser() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: Column(
            children: [
              Text(
                "Choose new admin user",
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _cloud.getUsers(),
                  builder: (context, snapshots) {
                    if (snapshots.hasData) {
                      final data = snapshots.data;
                      if (data != null) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final user = data[index];
                            return InkWell(
                              onTap: () {
                                _cloud.addAdmin(user["email"], user["uid"]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Admin added successfully."),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: ListTile(
                                title: Text(user["email"]),
                              ),
                            );
                          },
                        );
                      }
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
