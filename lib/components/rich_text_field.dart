import "package:flutter/material.dart";
import "package:flutter_quill/flutter_quill.dart";

class RichTextField extends StatefulWidget {
  const RichTextField(
      {super.key, required this.controller, this.value, this.label});

  final QuillController controller;
  final Document? value;
  final String? label;

  @override
  State<RichTextField> createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    // widget.controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // check if there is default value to input in the quill editor
    if (widget.value != null) {
      widget.controller.document = widget.value!;
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label ?? "",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      QuillToolbar.simple(
        controller: widget.controller,
        configurations: const QuillSimpleToolbarConfigurations(),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: QuillEditor.basic(
          focusNode: _focusNode,
          controller: widget.controller,
          configurations: const QuillEditorConfigurations(
            disableClipboard: false,
            minHeight: 500,
          ),
        ),
      )
    ]);
  }
}
