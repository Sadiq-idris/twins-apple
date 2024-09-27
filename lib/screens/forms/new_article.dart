import 'dart:convert';

import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/components/image_picker_field.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/components/rich_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

class NewArticle extends StatefulWidget {
  const NewArticle({super.key});

  @override
  State<NewArticle> createState() => _NewArticleState();
}

class _NewArticleState extends State<NewArticle> {
  final TextEditingController _titleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  bool isLoading = false;

  final Storage _storage = Storage();
  final DbCloud _cloud = DbCloud();

  List? file;
  String fileName = '';
  String? downloadUrl;

  void pickImage() async {
    file = await _storage.pickImage();
    if (file != null) {
      setState(() {
        fileName = file![1];
      });
    }
  }

  void add() async {
    setState(() {
      isLoading = true;
    });

    // get the data from the quill editor
    Delta data = _quillController.document.toDelta();
    final jsonData = jsonEncode(data);

    if (file != null) {
      // uploading image thumbnail and get the download url
      downloadUrl =
          await _storage.uploadImage("thumbnail/${file![1]}", file![0]);
    }

    // final content = data.toJson();

    // create new article
    if (downloadUrl != null &&
        data.isNotEmpty &&
        _titleController.text.isNotEmpty) {
      // Add to firebase store
      _cloud.add(
        _titleController.text,
        downloadUrl!,
        jsonData,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Created successfully."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All field are required"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New article"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ImagePickerField(
                      label: "Thumbnail",
                      onTap: pickImage,
                      fileName: fileName,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyInputField(
                      controller: _titleController,
                      obscureText: false,
                      hintText: "Title of the article",
                      label: const Text("Title"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichTextField(
                      controller: _quillController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyButton(
                      text: "Add",
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onTap: () {
                        add();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
