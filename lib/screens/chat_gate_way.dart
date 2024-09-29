
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';

class ChatGateWay extends StatefulWidget {
  const ChatGateWay({
    super.key,
    required this.email,
    required this.name,
    required this.uid,
  });
  final String email;
  final String name;
  final String uid;

  @override
  State<ChatGateWay> createState() => _ChatGateWayState();
}

class _ChatGateWayState extends State<ChatGateWay> {
  final DbCloud _cloud = DbCloud();

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

  double price = 2000;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cloud.getConsultationPaid(widget.email),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          final data = snapshots.data.data();
          if (data["paid"] != null) {
            return ChatScreen(
              email: widget.email,
              uid: widget.uid,
              isAdmin: false,
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Consultation",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text(
                      "paid to have a consultation with a professional dietitian"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "₦$price",
                    style: TextStyle(
                      fontFamily: "",
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    text: "Pay",
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    onTap: () async {
                      final transaction = TransactionDetails().copyWith(
                          amount: price,
                          currencyCode: "NGN",
                          customerName: widget.name,
                          customerEmail: widget.email,
                          paymentReference:
                              "${Timestamp.now()}-payment-${widget.email}",
                          paymentDescription:
                              "Consultation payment by ${widget.email}");
                      try {
                        final response = monnify?.initializePayment(
                            transaction: transaction);
                        response?.then((res) {
                          if (res?.transactionStatus == "PAID") {
                            _cloud.consultationPaid(widget.email, true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Paid successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() {});
                          }
                        });
                      } catch (error) {
                        print("ERROR -----> $error");
                      }
                    },
                  ),
                ],
              ),
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
