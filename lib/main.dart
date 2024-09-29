// import 'package:dietitian_cons/backend/my_cloud_message.dart';
import 'package:dietitian_cons/firebase_options.dart';
import 'package:dietitian_cons/myAds/ad_helper.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:dietitian_cons/screens/auth_gate_screen.dart';
import 'package:dietitian_cons/auth_screens/reset_password_screen.dart';
import 'package:dietitian_cons/auth_screens/sign_in_screen.dart';
import 'package:dietitian_cons/auth_screens/sign_up_screen.dart';
import 'package:dietitian_cons/screens/forms/new_article.dart';
import 'package:dietitian_cons/screens/forms/new_recipe.dart';
import 'package:dietitian_cons/screens/home_screen.dart';
import 'package:dietitian_cons/screens/nav_screens/consult_nav.dart';
import 'package:dietitian_cons/screens/nav_screens/order_info.dart';
import 'package:dietitian_cons/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initializing mobile ad sdk
  await AdHelper().initAd();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAuthProvider(),
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Dietitian consultation",
          theme: lightMode,
          home: const AuthGateScreen(),
          routes: {
            "sign-in": (context) => const SignInScreen(),
            "sign-up": (context) => const SignUpScreen(),
            "reset-password": (context) => const ResetPasswordScreen(),
            "home": (context) => const HomeScreen(),
            "auth-gate": (context) => const AuthGateScreen(),
            "new-article": (context) => const NewArticle(),
            "new-recipe": (context) => const NewRecipe(),
            "chat-room": (context) => const ConsultNav(),
            "order-info": (context) => const OrderInfo(),
          },
        ),
      ),
    );
  }
}
