import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/article_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleShowcaseCards extends StatefulWidget {
  const ArticleShowcaseCards({super.key});

  @override
  State<ArticleShowcaseCards> createState() => _ArticleShowcaseCardsState();
}

class _ArticleShowcaseCardsState extends State<ArticleShowcaseCards> {
  final DbCloud _cloud = DbCloud();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cloud.read(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final documents = snapshot.data!.docs.getRange(0, 3).toList();

          return ListView.builder(
              primary: false,
              shrinkWrap: true,
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
              });
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Text("Something is wrong");
      },
    );
  }
}
