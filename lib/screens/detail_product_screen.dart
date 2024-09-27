import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/animated_dotted.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/models/order_model.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  const DetailProductScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _howManyController = TextEditingController();
  final _cloud = DbCloud();
  int pageInView = 0;
  late Monnify? monnify;
  String apiKey = "MK_TEST_0LG8BY5ANH";
  String contractCode = "6110587178";
  // Apikey - LJKHE0QFSMGCSHQDJTC3GXLTJTAU9T3H
  // TEST API - MK_TEST_OLG8BY5ANH
  // CONTRACT CODE 6110587178

  @override
  void initState() {
    super.initState();
    initialMonnify();
  }

  void initialMonnify() async {
    monnify = await Monnify.initialize(
      applicationMode: ApplicationMode.TEST,
      apiKey: apiKey,
      contractCode: contractCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        Provider.of<MyAuthProvider>(context, listen: false).user!.uid;
    final userEmail =
        Provider.of<MyAuthProvider>(context, listen: false).user!.email;
    int howMany = _howManyController.text.isNotEmpty?int.parse(_howManyController.text):1;
    final dateTime = widget.product.createAt.toDate();
    final formattedDate = DateFormat("yMMMMEEEEd").format(dateTime);
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
                  if (widget.product.category == "Physical product")
                    MyInputField(
                      controller: _howManyController,
                      obscureText: false,
                      hintText: "How many to do want to buy.",
                      label: const Text("How many to do want to buy."),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10,),
                  MyButton(
                    text: widget.product.category == "Physical product"
                        ? "Order now"
                        : "Pay to download",
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    onTap: () async {
                      // resetting the howmany 
                      setState(() {
                        howMany = _howManyController.text.isNotEmpty?int.parse(_howManyController.text):1;
                      });
                      final amount = widget.product.price * howMany;
                      final transaction = TransactionDetails().copyWith(
                        amount: amount,
                        currencyCode: "NGN",
                        customerName:
                            Provider.of<MyAuthProvider>(context, listen: false)
                                .user!
                                .displayName,
                        customerEmail:
                            Provider.of<MyAuthProvider>(context, listen: false)
                                .user!
                                .email,
                        paymentReference: "${Timestamp.now()}-payment-${widget.product.name}",
                        paymentDescription: "Payment of ${widget.product.name}",
                      );
                      try {
                        final response = monnify?.initializePayment(
                            transaction: transaction);

                        response?.then((value) {
                          if (value?.transactionStatus == "PAID") {
                            if (widget.product.category == "Digital product") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                    product: widget.product.product!,
                                  ),
                                ),
                              );
                            } else {
                              final order = OrderModel(
                                userId: userId,
                                userEmail: userEmail!,
                                product: widget.product.toJson(),
                                isDelivered: false,
                                howMany: howMany,
                              );
                              _cloud.newOrder(order);
                              Navigator.pushNamed(context, "order-info");
                              print(
                                  "Paid successfully. your order is in query");
                            }
                          }
                        });
                      } catch (error) {
                        print("Error while try to initialize payment: $error");
                      }
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
