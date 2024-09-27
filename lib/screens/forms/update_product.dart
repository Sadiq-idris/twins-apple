import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:flutter/material.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({
    super.key,
    required this.product,
    required this.docId,
  });
  final ProductModel product;
  final String docId;

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockNoController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool isLoading = false;
  String? selectedCategory;
  final DbCloud _cloud = DbCloud();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _stockNoController.text = widget.product.stockNo.toString();
    _categoryController.text = widget.product.category;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockNoController.dispose();
    _categoryController.dispose();
  }

  void updateProduct(context) {
    ProductModel product = widget.product;
    final newProduct = ProductModel(
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      images: product.images,
      stockNo: int.parse(_stockNoController.text),
      createAt: Timestamp.now(),
      category: _categoryController.text,
    );
    _cloud.updateProduct(widget.docId, newProduct);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product updated successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update product"),
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
                    DropdownMenu(
                      label: const Text("Categories"),
                      controller: _categoryController,
                      initialSelection: widget.product.category,
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                            value: "physical product",
                            label: "Physical product"),
                        DropdownMenuEntry(
                            value: "digital product", label: "Digital product"),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyButton(
                      text: "Update",
                      color: Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      onTap: (){
                        updateProduct(context);
                      },
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
