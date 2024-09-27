import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderInfo extends StatefulWidget {
  const OrderInfo({super.key});

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  final DbCloud _cloud = DbCloud();
  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<MyAuthProvider>(context).user!.email;
    final adminEmail = Provider.of<MyAuthProvider>(context).adminEmail;

    return adminEmail == userEmail
        ? Scaffold(
            appBar: AppBar(
              title: const Text("Orders to process"),
            ),
            body: StreamBuilder(
              stream: _cloud.getAllOrder(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  final response = snapshots.data;
                  if (response != null) {
                    
                    return ListView.builder(
                      itemCount: response.length,
                      itemBuilder: (context, index) {
                        final order = response[index].data();
                        final docId = response[index].id;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Orders(
                                  cloud: _cloud,
                                  userEmail: order["userEmail"],
                                  docId: docId,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: const Icon(Icons.delivery_dining_outlined),
                            title: Text(order["userEmail"]),
                          ),
                        );
                      },
                    );
                  }
                } else if (snapshots.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return const Center(child: Text("Not orders"));
              },
            ),
          )
        : Orders(cloud: _cloud, userEmail: userEmail!);
  }
}
