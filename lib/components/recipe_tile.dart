import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/backend/storage.dart';
import 'package:dietitian_cons/components/my_pop_menu.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/detail_recipe_screen.dart';
// import 'package:dietitian_cons/screens/forms/update_recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class RecipeTile extends StatefulWidget {
  const RecipeTile({
    super.key,
    required this.recipe,
    required this.docId,
  });

  final Map recipe;
  final String docId;

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  final DbCloud _cloud = DbCloud();
  final Storage _storage = Storage();

  String getFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last.split('/').last;

    return fileName;
  }

  // Delete article
  void deleteRecipe() {
    // file name path
    for (var image in widget.recipe["images"]) {
      String filePath = 'recipe_images/${getFileName(image)}';
      print(filePath);
      // Deleting the thumbnail image from firebase Storage
      _storage.delete(filePath);
    }
    // Deleting the document from firebase store
    _cloud.deleteRecipe(widget.docId);

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
    final user = Provider.of<MyAuthProvider>(context).user;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailRecipeScreen(recipe: widget.recipe)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: widget.recipe["images"][0],
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    // borderRadius: BorderRadius.circular()
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error),
                ),
              ),
            ),
            user!.email == Provider.of<MyAuthProvider>(context).adminEmail
                ? Positioned(
                  right: 10,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 5, left: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showPopover(
                              context: context,
                              width: 200,
                              height: 140,
                              direction: PopoverDirection.bottom,
                              bodyBuilder: (context) => MyPopMenu(
                                    delete: deleteRecipe,
                                    update: () {},
                                  ));
                        },
                        child: const Icon(Icons.more_horiz_rounded),
                      ),
                    ),
                )
                : Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 5, left: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.favorite_outline),
                  )
          ]),
          const SizedBox(
            height: 3,
          ),
          SizedBox(
            width: 200,
            child: Text(
              widget.recipe["name"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
