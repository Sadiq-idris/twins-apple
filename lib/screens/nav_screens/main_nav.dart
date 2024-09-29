import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/article_showcase_cards.dart';
import 'package:dietitian_cons/components/my_drawer.dart';
import 'package:dietitian_cons/components/product_showcase_cards.dart';
import 'package:dietitian_cons/components/recipe_showcase_cards.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/nav_screens/article_nav.dart';
import 'package:dietitian_cons/screens/nav_screens/recipe_nav.dart';
import 'package:dietitian_cons/screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  final DbCloud _cloud = DbCloud();


  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<MyAuthProvider>(context, listen:false).user!.email;
    
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "chat-room");
            },
            child: FutureBuilder(
              future: _cloud.getNotification(userEmail!),
              builder: (context, snapshot) {

                return Stack(
                  fit: StackFit.loose,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SvgPicture.asset(
                        "assets/icons/comments-solid.svg",
                        width: 30,
                      ),
                    ),
                    if(snapshot.hasData)
                      if(snapshot.data!.data()?["receive"]?? false)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal:5, vertical:0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              "!",
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                  ],
                );
              }
            ),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView(
            primary: true,
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Twins apple",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "Food court & nutritional services",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const RecipeShowcaseCards(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecipeNav(
                            isFirstTime: true,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                "Products",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const ProductShowcaseCards(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductScreen(
                            isFirstTime: true,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Articles",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ArticleShowcaseCards(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ArticleNav(
                                    isFirstTime: true,
                                  )));
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
