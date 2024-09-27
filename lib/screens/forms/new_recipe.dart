import 'dart:convert';

import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/components/added_ingredient_tile.dart';
import 'package:dietitian_cons/components/image_picker_field.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/components/recipe_alert_dialog.dart';
import 'package:dietitian_cons/components/rich_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NewRecipe extends StatefulWidget {
  const NewRecipe({super.key});

  @override
  State<NewRecipe> createState() => _NewRecipeState();
}

class _NewRecipeState extends State<NewRecipe> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientNameController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  final Storage _storage = Storage();
  final DbCloud _cloud = DbCloud();

  final List images = [];
  final List<Map<String, String>> ingredients = [];

  bool isLoading = false;

  // pick images
  void selectImages() async {
    final respond = await _storage.pickImage();

    setState(() {
      images.add(respond);
    });
  }

  // show lists of images selected
  List<Widget> showingListImagesSelected() {
    List<Widget> selected = [];
    if (images.isEmpty) {
      return const [SizedBox()];
    } else {
      for (var item in images) {
        if (item != null) {
          selected.add(Text(item[1]));
        }
      }

      return selected;
    }
  }

  // show dialog for adding new ingredient
  void addIngredient() {
    showDialog(
      context: context,
      builder: (context) => RecipeAlertDialog(
        ingredientNameController: _ingredientNameController,
        amountController: _amountController,
        onPressed: () {
          if (_ingredientNameController.text.isNotEmpty &
              _amountController.text.isNotEmpty) {
            setState(() {
              ingredients.add({
                "name": _ingredientNameController.text,
                "amount": _amountController.text
              });
            });
            _ingredientNameController.clear();
            _amountController.clear();
          } else {
            print("required all fields");
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  // Add to firebase store | storage
  void add() async {
    setState(() {
      isLoading = true;
    });
    final List<String> imageDownloadUrl = [];
    // converting the quill delta data to json
    final deltaData = _quillController.document.toDelta();
    final description = jsonEncode(deltaData);
    if (images.isNotEmpty &
        _nameController.text.isNotEmpty &
        ingredients.isNotEmpty &
        description.isNotEmpty) {
      // first upload the images to firebase storage
      for (var image in images) {
        if (image != null) {
          final response =
              await _storage.uploadImage("recipe_images/${image[1]}", image[0]);
          imageDownloadUrl.add(response!);
        }
      }

      // adding to firestore
      _cloud.addRecipe(
        _nameController.text,
        imageDownloadUrl,
        ingredients,
        description,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("New recipe added Successfully"),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required."),
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
    _nameController.dispose();
    _quillController.dispose();
    _amountController.dispose();
    _ingredientNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New recipe"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ImagePickerField(
                      label: "Images",
                      onTap: selectImages,
                      fileName: "",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: showingListImagesSelected(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyInputField(
                      controller: _nameController,
                      obscureText: false,
                      hintText: "Name of the food",
                      label: const Text("Name"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Ingredients:"),
                          GestureDetector(
                            onTap: addIngredient,
                            child: Text("Select",
                                style: Theme.of(context).textTheme.labelMedium),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        for (var ingredient in ingredients)
                          AddedIngredientTile(
                            ingredient: ingredient,
                            ingredientKey: Key("item-${ingredient}"),
                            onDismissed: (DismissDirection direction) {
                              ingredients.remove(ingredient);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichTextField(
                      label: "Description:",
                      controller: _quillController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyButton(
                      text: "Add",
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onTap: add,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
