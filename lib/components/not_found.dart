import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 70, color: Theme.of(context).colorScheme.tertiary,),
          const Text("Search not found", style: TextStyle(fontSize: 18),),
        ],
      ),
    );
  }
}
