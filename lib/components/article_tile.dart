import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/components/my_pop_menu.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/article_detail_screen.dart';
import 'package:dietitian_cons/screens/forms/update_article_screen.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class ArticleTile extends StatefulWidget {
  const ArticleTile({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.createAt,
    required this.docId,
    required this.content,
  });

  final String imageUrl;
  final String title;
  final String createAt;
  final String docId;
  final String content;

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  final DbCloud _cloud = DbCloud();
  final Storage _storage = Storage();
  final TextEditingController _aboutReportController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  ImageProvider<Object>? imageCache;

  void onTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
                  title: widget.title,
                  imageUrl: imageCache!,
                  createAt: widget.createAt,
                  content: widget.content,
                )));
  }

  String getFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last.split('/').last;

    return fileName;
  }

  // updating article redirect
  void updateArticle() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateArticleScreen(
                  article: {
                    "title": widget.title,
                    "thumbnailUrl": widget.imageUrl,
                    "content": widget.content,
                    "createAt": widget.createAt,
                  },
                  docId: widget.docId,
                )));
  }

  // Delete article
  void deleteArticle() {
    // file name path
    String filePath = 'thumbnail/${getFileName(widget.imageUrl)}';
    // Deleting the thumbnail image from firebase Storage
    _storage.delete(filePath);
    // Deleting the document from firebase store
    _cloud.delete(widget.docId);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Deleted successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // get user info from provider
    final user = Provider.of<MyAuthProvider>(context).user;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: "hero-${widget.title}",
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      imageBuilder: (context, imageProvider) {
                        imageCache = imageProvider;
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 100,
                          width: 120,
                        );
                      },
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 170,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Text(
                      widget.createAt,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ],
            ),
          ),
          user!.email == "sadiqidris888@gmail.com"
              ? GestureDetector(
                  child: const Icon(Icons.more_vert),
                  onTap: () {
                    showPopover(
                        context: context,
                        width: 200,
                        height: 140,
                        bodyBuilder: (context) => MyPopMenu(
                              delete: deleteArticle,
                              update: updateArticle,
                            ),
                        direction: PopoverDirection.bottom);
                  },
                )
              : GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 200,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print("clicked");
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
                                              const SizedBox(height: 10,),
                                              MyButton(
                                                text: "Report",
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                textColor: Colors.white,
                                                onTap: () {
                                                  if (
                                                      _reportController
                                                          .text.isNotEmpty) {
                                                      _cloud.addReport(
                                                        "Article report - ${widget.title}",
                                                        _reportController.text,
                                                      );
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text("Article report successfull"))
                                                      );
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
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.more_vert),
                ),
        ],
      ),
    );
  }
}
