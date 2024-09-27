import 'package:flutter/material.dart';

class AnimatedDotted extends StatelessWidget {
  const AnimatedDotted({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(left: 10),
      duration: const Duration(milliseconds: 500),
      padding: isActive ? const EdgeInsets.all(7):const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
