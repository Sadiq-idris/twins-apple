import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_search_field.dart';
import 'package:dietitian_cons/components/recipe_tile.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class RecipeNav extends StatefulWidget {
  const RecipeNav({super.key, this.isFirstTime});
  final bool? isFirstTime;

  @override
  State<RecipeNav> createState() => _RecipeNavState();
}

class _RecipeNavState extends State<RecipeNav> {
  final DbCloud _cloud = DbCloud();
  final TextEditingController searchController = TextEditingController();

  void search() {
    if (searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(
            searchText: searchController.text,
            stream: _cloud.searchRecipe(searchController.text),
            isArticleSearch: false,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyAuthProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
        automaticallyImplyLeading: widget.isFirstTime ?? false,
        actions: [
          IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.favorite_outline))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            // Search field
            MySearchField(
              searchController: searchController,
              onTap: search,
              hintText: "Search for recipes",
            ),
            const SizedBox(
              height: 20,
            ),
            // Displaying recipes
            StreamBuilder(
              stream: _cloud.getRecipes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  final data = docs;
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final recipe = data[index].data();
                        final docId = data[index].id;
                        // print(recipe);

                        return RecipeTile(recipe: recipe, docId: docId);
                      },
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      floatingActionButton:
          user!.email == Provider.of<MyAuthProvider>(context).adminEmail
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "new-recipe");
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
