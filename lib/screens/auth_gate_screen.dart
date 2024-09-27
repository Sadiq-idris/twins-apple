import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'welcome_screen.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {


  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<MyAuthProvider>(context);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
          if(snapshot.hasData){

            User? user = snapshot.data;

              authProvider.user = user;  
           

            return const HomeScreen();
          }

          return const WelcomeScreen();
      },
    );
  }
}
