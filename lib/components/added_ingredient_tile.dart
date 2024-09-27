import 'package:flutter/material.dart';

class AddedIngredientTile extends StatelessWidget {
  const AddedIngredientTile({
    super.key,
    required this.ingredient,
    required this.ingredientKey,
    required this.onDismissed,
  });

  final Map ingredient;
  final Key ingredientKey;
  final void Function(DismissDirection) onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ingredientKey,
      background: Container(
        color: Colors.red,
        child: const Text(
          "Deleted",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onDismissed: onDismissed,
      child: ingredient.isNotEmpty? Column(children: [
        ListTile(
          leading: Icon(
            Icons.local_grocery_store_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
          title: Text(ingredient["name"]),
          trailing:  Text(
            ingredient["amount"],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const Divider(
          height: 0,
        ),
      ]): const SizedBox(),
    );
  }
}
