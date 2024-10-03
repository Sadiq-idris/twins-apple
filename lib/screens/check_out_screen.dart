import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/models/order_model.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({
    super.key,
    required this.isPhysicalProduct,
    required this.product,
  });
  final bool isPhysicalProduct;
  final ProductModel product;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final TextEditingController _howManyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _cloud = DbCloud();

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
    int howMany = _howManyController.text.isNotEmpty
        ? int.parse(_howManyController.text)
        : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check out"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isPhysicalProduct)
              MyInputField(
                controller: _howManyController,
                obscureText: false,
                hintText: "How many do you want to buy.",
                label: const Text("How many."),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    howMany = _howManyController.text.isNotEmpty
                        ? int.parse(_howManyController.text)
                        : 1;
                  });
                },
              ),
            const SizedBox(
              height: 10,
            ),
            if (widget.isPhysicalProduct)
              MyInputField(
                controller: _addressController,
                obscureText: false,
                hintText: "Your address",
                label: const Text("Address"),
              ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "₦ ${widget.product.price * howMany}",
              style: const TextStyle(
                fontFamily: "",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyButton(
              text: widget.product.category == "Physical product"
                  ? "Order now"
                  : "Pay to download",
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              onTap: () async {
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
                  paymentReference:
                      "${Timestamp.now()}-payment-${widget.product.name}",
                  paymentDescription: "Payment of ${widget.product.name}",
                );
                try {
                  final response =
                      monnify?.initializePayment(transaction: transaction);

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
                          address: _addressController.text,
                        );
                        _cloud.newOrder(order);
                        Navigator.pushNamed(context, "order-info");
                      }
                    }
                  });
                } catch (error) {
                  print("Error while try to initialize payment: $error");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
