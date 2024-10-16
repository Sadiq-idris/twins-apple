import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/detail_product_screen.dart';
import 'package:dietitian_cons/screens/forms/update_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({super.key, required this.product, required this.docId});
  final ProductModel product;
  final String docId;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  final DbCloud _cloud = DbCloud();
  final Storage _storage = Storage();

  String getFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last.split('/').last;

    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    final adminEmail =
        Provider.of<MyAuthProvider>(context, listen: false).adminEmail;
    final userEmail =
        Provider.of<MyAuthProvider>(context, listen: false).user!.email;
    return SizedBox(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailProductScreen(product: widget.product),
            ),
          );
        },
        onLongPress: () {
          if (adminEmail == userEmail) {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 200,
                    width: double.infinity,
                    // decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProduct(
                                    product: widget.product,
                                    docId: widget.docId),
                              ),
                            );
                          },
                          child: const ListTile(
                            leading: Icon(Icons.update),
                            title: Text("Update"),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            for (var image in widget.product.images) {
                              final fileName = getFileName(image);
                              final path = "product_images/$fileName";
                              _storage.delete(path);
                              print("Delete Product image");
                            }

                            _cloud.deleteProduct(widget.docId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("product Deleted successfully"),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const ListTile(
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: widget.product.images[0],
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    // borderRadius: BorderRadius.circular()
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              "₦${widget.product.price.toString()}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: '',
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "${widget.product.stockNo} in stock",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
