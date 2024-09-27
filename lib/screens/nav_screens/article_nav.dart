import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/article_tile.dart';
import 'package:dietitian_cons/components/my_search_field.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ArticleNav extends StatefulWidget {
  const ArticleNav({super.key, this.isFirstTime});
  final bool? isFirstTime;

  @override
  State<ArticleNav> createState() => _ArticleNavState();
}

class _ArticleNavState extends State<ArticleNav> {
  final DbCloud _cloud = DbCloud();
  final TextEditingController searchController = TextEditingController();

  void search() {
    if (searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(
            searchText: searchController.text,
            stream: _cloud.searchArticle(searchController.text),
            isArticleSearch: true,
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
    print(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles"),
        automaticallyImplyLeading: widget.isFirstTime ?? false,
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
              hintText: "Search for articles",
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: _cloud.read(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final documents = snapshot.data!.docs;

                  return Expanded(
                    child: ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          // getting the data
                          final data = documents[index].data();
                          Map<String, dynamic> article = data;

                          // getting the id for each document
                          String docId = documents[index].id;

                          // converting timestamp to datetime
                          DateTime dateTime = article["createAt"].toDate();

                          // formatting the datetime
                          String formattedDate =
                              DateFormat("yMMMMEEEEd").format(dateTime);

                          return ArticleTile(
                            title: article["title"],
                            imageUrl: article["thumbnailUrl"],
                            createAt: formattedDate,
                            docId: docId,
                            content: article["content"],
                          );
                        }),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Text("Something is wrong");
              },
            ),
          ],
        ),
      ),
      floatingActionButton:
          user!.email == Provider.of<MyAuthProvider>(context).adminEmail
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "new-article");
                  },
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}
