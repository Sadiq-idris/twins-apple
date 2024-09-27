import 'package:flutter/material.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          ),
          Text(
            "It looks like you're offline",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Text("Check your connection and try again",)
        ],
      ),
    );
  }
}
