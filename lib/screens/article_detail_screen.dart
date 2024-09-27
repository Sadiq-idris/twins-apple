import 'dart:convert';

import 'package:dietitian_cons/myAds/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.createAt,
    required this.content,
  });

  final ImageProvider imageUrl;
  final String title;
  final String createAt;
  final String content;

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final QuillController _quillController = QuillController.basic();

  // banner ads
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print("Failed to load a banner ad: ${error.message}");
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    // quill editor read only
    _quillController.readOnly = true;
    // add the content data to quill editor
    final deltaData = jsonDecode(widget.content);
    _quillController.document = Document.fromJson(deltaData);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 15,
              ),
              Hero(
                tag: "hero-${widget.title}",
                child: Image(
                  image: widget.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.createAt,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              QuillEditor.basic(
                controller: _quillController,
                configurations: QuillEditorConfigurations(
                    showCursor: false,
                    customStyles: DefaultStyles(
                      sizeLarge: Theme.of(context).textTheme.headlineMedium,
                      sizeSmall: Theme.of(context).textTheme.bodySmall,
                    )),
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
        ),
      ),
    );
  }
}
