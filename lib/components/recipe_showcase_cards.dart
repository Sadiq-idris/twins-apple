import 'package:cached_network_image/cached_network_image.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/screens/detail_recipe_screen.dart';
import 'package:flutter/material.dart';

class RecipeShowcaseCards extends StatefulWidget {
  const RecipeShowcaseCards({
    super.key,
  });

  @override
  State<RecipeShowcaseCards> createState() => _RecipeShowcaseCardsState();
}

class _RecipeShowcaseCardsState extends State<RecipeShowcaseCards> {
  final DbCloud _cloud = DbCloud();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cloud.getRecipes(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          if (snapshots.data!.docs.length >= 3) {
            final response = snapshots.data!.docs.getRange(0, 3).toList();
            return Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: response.length,
                itemBuilder: (context, index) {
                  final recipe = response[index].data();
                  final docId = response[index].id;
                  return recipeTile(context, recipe, docId);
                },
              ),
            );
          }
        }

        return const Loader();
      },
    );
  }

  Widget recipeTile(BuildContext context, Map recipe, String docId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRecipeScreen(recipe: recipe),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 10),
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.softLight,
            ),
            image: CachedNetworkImageProvider(
              recipe["images"][0],
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Text(
          recipe["name"],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 100,
      child: ListView(
        primary: false,
        scrollDirection: Axis.horizontal,
        children: List.generate(3, (index) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
            ),
          );
        }),
      ),
    );
  }
}
