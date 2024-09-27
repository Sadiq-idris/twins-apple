import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:flutter/material.dart';

class MySearchField extends StatelessWidget {
  const MySearchField({
    super.key,
    required this.searchController,
    required this.onTap,
    required this.hintText,
  });

  final TextEditingController searchController;
  final void Function() onTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MyInputField(
            controller: searchController,
            obscureText: false,
            hintText: hintText,
            label: const Text("Search"),
          ),
        ),
        const SizedBox(width: 10,),
        GestureDetector(
          onTap: onTap,
          child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 25,
              )),
        ),
      ],
    );
  }
}
