import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:flutter/material.dart';

class RecipeAlertDialog extends StatelessWidget {
  const RecipeAlertDialog({
    super.key,
    required this.ingredientNameController,
    required this.amountController,
    required this.onPressed,
  });

  final TextEditingController ingredientNameController;
  final TextEditingController amountController;
  final void Function() onPressed;
  

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add ingredient"),
      content: SizedBox(
        height: 130,
        child: Column(
          children: [
            MyInputField(
              controller: ingredientNameController,
              obscureText: false,
              hintText: "name of the ingredient",
              label: const Text("Ingredient Name"),
            ),
            const SizedBox(height: 15,),
            MyInputField(
              controller: amountController,
              obscureText: false,
              hintText: "Amount to add",
              label: const Text("Amount"),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("add"),
        ),
      ],
    );
  }
}
