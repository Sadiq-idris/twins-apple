import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietitian_cons/components/article_tile.dart';
import 'package:dietitian_cons/components/not_found.dart';
import 'package:dietitian_cons/components/recipe_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.searchText,
    required this.stream,
    required this.isArticleSearch,
  });

  final String searchText;
  final Stream<List<List<Object>>>? stream;
  final bool isArticleSearch;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search - ${widget.searchText}")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder(
          stream: widget.stream,
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              final data = snapshots.data;
              print(data);
              if (data!.isNotEmpty) {
                // check if it is article search or not
                if (widget.isArticleSearch) {
                  final response = data[0][0] as Map<String, dynamic>;
                  String docId = data[0][1] as String;
                  Timestamp timestamp = response["createAt"] as Timestamp;
                  DateTime dateTime = timestamp.toDate();
                  String formattedDate =
                      DateFormat("yMMMMEEEEd").format(dateTime);
                  return ArticleTile(
                    title: response["title"],
                    imageUrl: response["thumbnailUrl"],
                    createAt: formattedDate,
                    docId: docId,
                    content: response["content"],
                  );
                } else {
                  final recipe = data[0][0] as Map<String, dynamic>;
                  String docId = data[0][1] as String;
                  
                  return SizedBox(width: 180, child: RecipeTile(recipe: recipe, docId: docId));
                }
              }
            } else if (snapshots.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const NotFound();
          },
        ),
      ),
    );
  }
}
