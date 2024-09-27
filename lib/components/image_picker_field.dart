import 'package:flutter/material.dart';

class ImagePickerField extends StatefulWidget {
  const ImagePickerField(
      {super.key, required this.onTap, required this.fileName, required this.label});

  final void Function()? onTap;
  final String fileName;
  final String label;

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: Text(
                "select",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
        widget.fileName.isNotEmpty ? Text(
          widget.fileName 
        ) : const SizedBox(),
      ]),
    );
  }
}
