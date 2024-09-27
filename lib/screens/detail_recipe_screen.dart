import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietitian_cons/components/animated_dotted.dart';
import 'package:dietitian_cons/myAds/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DetailRecipeScreen extends StatefulWidget {
  const DetailRecipeScreen({super.key, required this.recipe});

  final Map recipe;

  @override
  State<DetailRecipeScreen> createState() => _DetailRecipeScreenState();
}

class _DetailRecipeScreenState extends State<DetailRecipeScreen> {
  final PageController _controller = PageController();
  final QuillController _quillController = QuillController.basic();
  BannerAd? _bannerAd;

  int pageInView = 0;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _bannerAd = ad as BannerAd;
        });
      }, onAdFailedToLoad: (ad, error) {
        print("Failed to load banner ad: ${error.message}");
        ad.dispose();
      }),
    ).load();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredient = jsonDecode(widget.recipe["ingredients"]);
    // getting the description and decode it
    final descriptionData = jsonDecode(widget.recipe["description"]);
    final value = Document.fromJson(descriptionData);

    // displaying the data from the document of description in quill editor
    _quillController.document = value;
    _quillController.readOnly = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe["name"],
        ),
        actions: [
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Added to favorite"),
                  ),
                );
              },
              icon: const Icon(Icons.favorite_outline))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying recipes images
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (int index) {
                      setState(() {
                        pageInView = index;
                      });
                    },
                    children:
                        List.generate(widget.recipe["images"].length, (index) {
                      return CachedNetworkImage(
                        imageUrl: widget.recipe["images"][index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            // borderRadius: BorderRadius.circular()
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error),
                        ),
                      );
                    }),
                  ),
                  Positioned(
                    bottom: 5,
                    left: MediaQuery.of(context).size.width / 2 - 20,
                    child: Row(
                        children: List.generate(widget.recipe["images"].length,
                            (index) {
                      return AnimatedDotted(
                        isActive: pageInView == index,
                      );
                    })),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Ingredients:",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: List.generate(ingredient.length, (index) {
                      return ListTile(
                        minTileHeight: 10,
                        leading: const Icon(Icons.circle_outlined),
                        title: Text(ingredient[index]["name"]),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Directions",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  QuillEditor.basic(
                    controller: _quillController,
                    configurations: QuillEditorConfigurations(
                      showCursor: false,
                      customStyles: DefaultStyles(
                        sizeLarge: Theme.of(context).textTheme.bodyMedium,
                        sizeSmall: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_bannerAd != null)
                    SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(
                        ad: _bannerAd!,
                      ),
                    ),
                  const SizedBox(
                    height: 10,
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
