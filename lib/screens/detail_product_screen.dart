import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietitian_cons/components/animated_dotted.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:dietitian_cons/screens/check_out_screen.dart';
import 'package:flutter/material.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final PageController _pageController = PageController();
  int pageInView = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    pageInView = index;
                  });
                },
                children: List.generate(
                  widget.product.images.length,
                  (index) {
                    return CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: widget.product.images[index],
                      placeholder: (context, url) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            // borderRadius: BorderRadius.circular()
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.images.length,
                (index) {
                  return AnimatedDotted(isActive: pageInView == index);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "₦ ${widget.product.price.toString()}",
                        style: TextStyle(
                          fontFamily: '',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${widget.product.stockNo} in stock",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(widget.product.description),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    text: widget.product.category == "Physical product"
                        ? "Order now"
                        : "Pay to download",
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckOutScreen(
                            isPhysicalProduct:
                                widget.product.category == "Physical product",
                            product: widget.product,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
