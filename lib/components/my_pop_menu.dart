import 'package:flutter/material.dart';

class MyPopMenu extends StatelessWidget {
  const MyPopMenu({
    super.key,
    required this.delete,
    required this.update,
  });

  final void Function() delete;
  final void Function() update;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: delete,
          child: const ListTile(
              leading: Icon(Icons.delete), title: Text("Delete")),
        ),
        InkWell(
          onTap: update,
          child: const ListTile(
              leading: Icon(Icons.update), title: Text("Update")),
        ),
      ],
    );
  }
}
