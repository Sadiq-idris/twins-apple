import 'dart:convert';

import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/components/added_ingredient_tile.dart';
import 'package:dietitian_cons/components/image_picker_field.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/components/recipe_alert_dialog.dart';
import 'package:dietitian_cons/components/rich_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class UpdateRecipe extends StatefulWidget {
  const UpdateRecipe({
    super.key,
    required this.recipe,
  });
  final Map recipe;

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> {
  final Storage _storage = Storage();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientNameController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  bool isLoading = false;

  List<dynamic>? images;
  List<Map<String, String>>? ingredients;

  // pick images
  void selectImages() async {
    // picking image from the gallery
    final respond = await _storage.pickImage();

    setState(() {
      images!.add(respond!);
    });
  }

  // show lists of images selected
  List<Widget> showingListImagesSelected() {
    // decoding the previuous value of images
    final prevImages = widget.recipe["images"];
    images = prevImages;
    print(images);
    List<Widget> selected = [];
    if (images == null) {
      return const [SizedBox()];
    } else {
      for (var item in images!) {
        if (item.isNotEmpty) {
          selected.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item[1]),
              IconButton(
                  onPressed: () {
                    setState(() {
                      images!.remove(item);
                    });
                  },
                  icon: const Icon(Icons.remove))
            ],
          ));
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
              ingredients!.add({
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

  void update() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("update recipe"),),
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
                    children: ingredients != null
                        ? List.generate(ingredients!.length, (index) {
                            // getting the previuous values of the ingredients
                            ingredients =
                                jsonDecode(widget.recipe["ingredients"]);
                            return AddedIngredientTile(
                              ingredient: ingredients![index],
                              ingredientKey:
                                  Key("item-${ingredients![index]["name"]}"),
                              onDismissed: (DismissDirection direction) {
                                ingredients!.remove(ingredients![index]);
                              },
                            );
                          })
                        : [],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RichTextField(
                    label: "Description:",
                    controller: _quillController,
                    value: Document.fromJson(
                        jsonDecode(widget.recipe["description"])),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyButton(
                    text: "update",
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onTap: update,
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
