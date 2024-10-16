import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/product_tile.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/forms/new_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, this.isFirstTime});
  final bool? isFirstTime;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final DbCloud _cloud = DbCloud();
  @override
  Widget build(BuildContext context) {
    final adminEmail = Provider.of<MyAuthProvider>(context).adminEmail;
    final userEmail = Provider.of<MyAuthProvider>(context).user!.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        automaticallyImplyLeading: widget.isFirstTime ?? false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delivery_dining),
            onPressed: () {
              Navigator.pushNamed(context, "order-info");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: StreamBuilder(
            stream: _cloud.getProducts(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                final data = snapshots.data;
                if (data != null) {
                  return GridView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 250,
                    ),
                    itemBuilder: (context, index) {
                      final product = ProductModel.fromJson(data[index].data());
                      final docId = data[index].id;
                      return ProductTile(
                        product: product,
                        docId: docId,
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Icon(Icons.hourglass_empty_rounded));
                }
              } else if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.not_interested_rounded,
                      size: 100,
                    ),
                    Text("No products for sell."),
                  ],
                ),
              );
            }),
      ),
      floatingActionButton: adminEmail == userEmail
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewProduct()),
                );
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox(),
    );
  }
}
