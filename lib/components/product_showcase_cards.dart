import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/product_tile.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductShowcaseCards extends StatefulWidget {
  const ProductShowcaseCards({super.key});

  @override
  State<ProductShowcaseCards> createState() => _ProductShowcaseCardsState();
}

class _ProductShowcaseCardsState extends State<ProductShowcaseCards> {
  final DbCloud _cloud = DbCloud();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cloud.getProducts(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          final data = snapshots.data;
          if (data != null) {
            final responses = data.length >= 3 ?data.getRange(0, 3).toList():data;
            return SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                primary: false,
                itemCount: responses.length,
                itemBuilder: (context, index) {
                  final product = ProductModel.fromJson(responses[index].data());
                  final docId = responses[index].id;
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 15),
                    child: ProductTile(product: product, docId: docId),
                  );
                },
              ),
            );
          } else{
            return const Icon(Icons.hourglass_empty_rounded);
          }
        } else if (snapshots.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
