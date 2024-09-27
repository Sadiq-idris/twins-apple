import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/models/order_model.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderTile extends StatefulWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.docId,
  });
  final Map order;
  final String docId;
  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool selected = false;
  final DbCloud _cloud = DbCloud();
  final TextEditingController _reportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final adminEmail =
        Provider.of<MyAuthProvider>(context, listen: false).adminEmail;
    final userEmail =
        Provider.of<MyAuthProvider>(context, listen: false).user!.email;
    final ProductModel product = ProductModel.fromJson(widget.order["product"]);
    final OrderModel orderModel = OrderModel.fromJson(widget.order);
    return InkWell(
      onLongPress: () {
        if (adminEmail == userEmail) {
          updateOrder(context, widget.order);
        } else {
          orderUserInfo(context, orderModel);
        }
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: product.images[0],
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        title:
            Text(product.name, style: Theme.of(context).textTheme.bodyMedium),
        subtitle: Text(
          "Paid ${orderModel.howMany} pieces",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Column(
          children: [
            Text(
              "₦${(product.price * orderModel.howMany)}",
              style: TextStyle(fontFamily: ""),
            ),
            Text(
              orderModel.isDelivered ? "Delivered" : "Pending..",
              style: TextStyle(
                color: orderModel.isDelivered
                    ? Colors.green[800]
                    : Colors.yellow[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> orderUserInfo(BuildContext context, OrderModel orderModel) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderModel.product["name"],
                style: Theme.of(context).textTheme.labelLarge,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Report"),
                        content: SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              MyInputField(
                                controller: _reportController,
                                obscureText: false,
                                hintText: "About the report",
                                label: const Text("Report"),
                                maxLines: 2,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyButton(
                                text: "Report",
                                color: Theme.of(context).colorScheme.primary,
                                textColor: Colors.white,
                                onTap: () {
                                  if (_reportController.text.isNotEmpty) {
                                    _cloud.addReport(
                                      "Product report - ${orderModel.product["name"]}",
                                      _reportController.text,
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Order report successfull")));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.report),
                  title: Text("Report"),
                ),
              ),
              if (orderModel.isDelivered)
                InkWell(
                  onTap: () {
                    _cloud.deleteOrder(widget.docId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Deleted successfully."),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.delete),
                    title: Text("Delete"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void updateOrder(BuildContext context, Map order) {
    final saveUser = _cloud.getSingleUser(order["userEmail"]);
    saveUser.then((res) {
      final phoneNumber = res.docs[0].data()["phoneNumber"];
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order["userEmail"],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    order["product"]["name"],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownMenu(
                    label: const Text("Shipping order"),
                    onSelected: (newSelected) {
                      setState(() {
                        selected = newSelected!;
                      });
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: false, label: "Not delivered"),
                      DropdownMenuEntry(value: true, label: "Is delilvered"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyButton(
                    text: "Save changes",
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onTap: () {
                      final newOrder = OrderModel(
                        userId: order["userId"],
                        userEmail: order["userEmail"],
                        product: order["product"],
                        isDelivered: selected,
                        howMany: order["howMany"],
                      );
                      _cloud.updateOrder(
                        widget.docId,
                        newOrder,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Changes save successfully."),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text("Or"),
                  Row(
                    children: [
                      const Text("Delete"),
                      IconButton(
                        onPressed: () {
                          _cloud.deleteOrder(widget.docId);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Order deleted successfully."),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: (){
                      launchUrlString("tel:+234$phoneNumber");
                    },
                    child: ListTile(
                      title: Text("+234$phoneNumber"),
                      trailing: const Icon(Icons.call),
                    ),
                  )
                ],
              ),
            );
          });
    });
  }
}
