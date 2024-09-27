import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message, required this.sender});

  final String message;
  final bool sender;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: sender?MainAxisAlignment.end:MainAxisAlignment.start, children: [
      Flexible(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: sender?Theme.of(context).colorScheme.primary : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            softWrap: true,
            maxLines: 10,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    ]);
  }
}
