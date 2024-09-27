import "package:dietitian_cons/backend/db_cloud.dart";
import "package:dietitian_cons/components/order_tile.dart";
import "package:flutter/material.dart";

class Orders extends StatefulWidget {
  const Orders({
    super.key,
    required DbCloud cloud,
    required this.userEmail,
    this.docId,
  }) : _cloud = cloud;

  final DbCloud _cloud;
  final String userEmail;
  final String? docId;

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders - ${widget.userEmail}"),
      ),
      body: StreamBuilder(
        stream: widget._cloud.getUserOrder(widget.userEmail),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            final data = snapshots.data;

            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                final order = data[index].data();
                final docId = data[index].id;
                return OrderTile(order: order, docId: docId,);
              },
            );
          } else if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return const Center(
            child: Text("You have no orders"),
          );
        },
      ),
    );
  }
}
