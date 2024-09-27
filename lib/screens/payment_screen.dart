import "package:dietitian_cons/components/my_button.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.product});
  final String product;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double? progressIndicator;

  @override
  void initState(){
    super.initState();
    downloadProduct();
  }

  String getFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last.split('/').last;

    return fileName;
  }

  void downloadProduct() async {
    final tempDir = await getDownloadsDirectory();
    if(tempDir == null)return;
    // print(tempDir!.path);
    final fileName = getFileName(widget.product);
    final path = "${tempDir!.path}/$fileName";
    final response = await Dio().download(
      widget.product,
      path,
      onReceiveProgress: (received, total) {
        if (total <= 0) return;
        setState(() {
          progressIndicator = received / total * 100;
        });
        // print("Percentage: ${(received/total * 100).toStringAsFixed(0)}%");
      },
    );
    OpenFile.open(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Text(
              "Paid successfully now you can download the product.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (progressIndicator != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${progressIndicator!.toStringAsFixed(0)}%",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  MyButton(
                    text: "Download again",
                    color: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    onTap: downloadProduct,
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
