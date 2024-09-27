import 'dart:convert';

import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/components/image_picker_field.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/components/rich_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class UpdateArticleScreen extends StatefulWidget {
  const UpdateArticleScreen(
      {super.key, required this.article, required this.docId});

  final Map<String, dynamic> article;
  final String docId;

  @override
  State<UpdateArticleScreen> createState() => _UpdateArticleScreenState();
}

class _UpdateArticleScreenState extends State<UpdateArticleScreen> {
  // initializing controllers
  final TextEditingController _titleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  final Storage _storage = Storage();
  final DbCloud _cloud = DbCloud();

  List<dynamic>? file;
  String? fileName;
  String? imageUrl;

  // getting the filename of thumbnail url
  String getFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last.split("/").last;
    return fileName;
  }

  bool isLoading = false;

  // picking image from galllery
  void pickImage() async {
    // getting the filename

    file = await _storage.pickImage();

    if (file != null) {
      setState(() {
        fileName = file![1];
      });
    }
  }

  // Updating the data
  void update() async {
    setState(() {
      isLoading = true;
    });
    if (file != null) {
      // if user change the thumbnail delete the old one
      await _storage
          .delete('thumbnail/${getFileName(widget.article['thumbnailUrl'])}');

      // adding new one
      imageUrl = await _storage.uploadImage('thumbnail/${file![0]}', file![0]);
    }
    // then update firebase store
    _cloud.update(widget.docId, {
      "title": _titleController.text,
      "thumbnailUrl": imageUrl ?? widget.article['thumbnailUrl'],
      "content": jsonEncode(_quillController.document.toDelta()),
      // "createAt": widget.,
    });

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Updated successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // extracting the content to document
  Document defaultQuillValue() {
    final jsonData = jsonDecode(widget.article["content"]);
    final value = Document.fromJson(jsonData);

    return value;
  }

  // initial state of the widget
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.article["title"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                      fileName: file != null
                          ? fileName!
                          : getFileName(widget.article["thumbnailUrl"]),
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
                      value: defaultQuillValue(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyButton(
                      text: "update",
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onTap: () {
                        update();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
