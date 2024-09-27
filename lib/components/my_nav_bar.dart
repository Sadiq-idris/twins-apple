import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyNavBar extends StatelessWidget {
  const MyNavBar(
      {super.key,
      required this.selectedIndex,
      required this.onDestinationSelected});

  final void Function(int) onDestinationSelected;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
            icon: SvgPicture.asset(
              "assets/icons/house-solid.svg",
              width: 25,
              colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
            ),
            label: "Home",
            selectedIcon: SvgPicture.asset(
              "assets/icons/house-solid.svg",
              width: 20,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            )),
        NavigationDestination(
          icon: SvgPicture.asset(
            "assets/icons/newspaper-regular.svg",
            width: 25,
            colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
          ),
          label: "Article",
          selectedIcon: SvgPicture.asset(
            "assets/icons/newspaper-regular.svg",
            width: 20,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        NavigationDestination(
          icon: SvgPicture.asset(
            "assets/icons/bowl-food-solid.svg",
            width: 25,
            colorFilter:  ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
          ),
          label: "Recipes",
          selectedIcon: SvgPicture.asset(
            "assets/icons/bowl-food-solid.svg",
            width: 20,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        NavigationDestination(
          icon: SvgPicture.asset(
            "assets/icons/cart-shopping-solid.svg",
            width: 25,
            colorFilter: ColorFilter.mode(Colors.grey[700]!, BlendMode.srcIn),
          ),
          label: "Products",
          selectedIcon: SvgPicture.asset(
            "assets/icons/cart-shopping-solid.svg",
            width: 20,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}
