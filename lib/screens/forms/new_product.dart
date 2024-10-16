import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/components/image_picker_field.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:flutter/material.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockNoController = TextEditingController();
  final Storage _storage = Storage();
  final DbCloud _cloud = DbCloud();
  List images = [];
  List<String> downloadUrlImages = [];
  bool isLoading = false;

  void selectImages() async {
    final response = await _storage.pickImage();
    if (response != null) {
      setState(() {
        images.add(response);
      });
    }
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

  void addProduct() async {
    setState(() {
      isLoading = true;
    });
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _stockNoController.text.isNotEmpty &&
        images.isNotEmpty) {
      // uploading product images
      for (var image in images) {
        final response =
            await _storage.uploadImage("product_images/${image[1]}", image[0]);
        if (response != null) {
          downloadUrlImages.add(response);
        }
      }

      final product = ProductModel(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text.replaceAll(",", "")),
        images: downloadUrlImages,
        stockNo: int.parse(_stockNoController.text),
        createAt: Timestamp.now(),
      );

      _cloud.newProduct(product);

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Added successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("All fields are required!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New product"),
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
                      height: 15,
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
                      hintText: "Name of the product",
                      label: const Text("Name"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyInputField(
                      controller: _descriptionController,
                      obscureText: false,
                      hintText: "Description of the product",
                      label: const Text("Description"),
                      maxLines: 4,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyInputField(
                      controller: _priceController,
                      obscureText: false,
                      hintText: "Price of the product",
                      label: const Text("Price"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyInputField(
                      controller: _stockNoController,
                      obscureText: false,
                      hintText: "How many of the product is in stock",
                      label: const Text("Stock number"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyButton(
                      text: "Add",
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      onTap: addProduct,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
