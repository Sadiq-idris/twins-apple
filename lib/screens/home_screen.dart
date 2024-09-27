import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dietitian_cons/screens/nav_screens/article_nav.dart';
import 'package:dietitian_cons/screens/nav_screens/main_nav.dart';
import 'package:dietitian_cons/screens/nav_screens/recipe_nav.dart';
import 'package:dietitian_cons/components/my_nav_bar.dart';
import 'package:dietitian_cons/screens/no_internet_connection_screen.dart';
import 'package:dietitian_cons/screens/product_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _page = [
    const MainNav(),
    const ArticleNav(),
    const RecipeNav(),
    const ProductScreen(),
  ];

  Connectivity? connectivity;

  void onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: connectivity!.onConnectivityChanged,
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            final response = snapshots.data;
            if (response != null) {
              if (response.first == ConnectivityResult.wifi ||
                  response.first == ConnectivityResult.mobile) {
                return _page[_selectedIndex];
              } else {
                print("----------> something happen");
                return const NoInternetConnectionScreen();
              }
            }
          } else if (snapshots.hasError) {
            print("----------> something happen");
          } 

          return _page[_selectedIndex];
        },
      ),
      bottomNavigationBar: MyNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
