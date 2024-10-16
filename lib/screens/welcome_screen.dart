import 'package:dietitian_cons/backend/auth_services.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false;
  final DbCloud _cloud = DbCloud();

  AuthServices _authServices = AuthServices();

  // sign in user with google
  void googleSignIn() async {
    setState(() {
      isLoading = true;
    });

    dynamic response = await _authServices.signInWithGoogle();

    if (response != null) {
      if (response is String) {
        setState(() {
          isLoading = false;
        });
        String message = response.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // setState(() {
        //   isLoading = false;
        // });
        _cloud.saveUser(response.email, response.uid, null);
        final formattedDate =
            DateFormat("yyy-MM-dd").format(response.metadata.creationTime);

        final dateTime = DateFormat("yyy-MM-dd").format(DateTime.now());

        if (formattedDate == dateTime) {
          _cloud.consultationPaid(response.email, null);
        }
        Navigator.pushNamed(context, "auth-gate");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign in successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Center(
                  child: Column(
                    children: [
                      // Spacing
                      const Spacer(),
                      // Logo
                      Image.asset("assets/images/logo.png"),

                      // Spacing
                      const Spacer(),

                      // Company name
                      Text(
                        "Twins Apple",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),

                      // Slogan
                      Text(
                        "Food court & nutritional services \n where the taste meets wellness",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      // Spacing
                      const Spacer(),

                      // Button
                      MyButton(
                        text: "Sign in",
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.pushNamed(context, "sign-in");
                        },
                      ),

                      // Spacing
                      const SizedBox(
                        height: 10,
                      ),

                      MyButton(
                        text: "Sign up",
                        color: Theme.of(context).colorScheme.secondary,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        onTap: () {
                          Navigator.pushNamed(context, "sign-up");
                        },
                      ),

                      // Spacing
                      const Spacer(),

                      // OR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                              endIndent: 20,
                            ),
                          ),
                          Text(
                            "Log in with",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                              indent: 20,
                            ),
                          ),
                        ],
                      ),

                      // Spacing
                      const Spacer(),

                      // Social media login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyIconButton(
                            onTap: () {
                              googleSignIn();
                            },
                            imageUrl: "assets/icons/google.png",
                          ),
                        ],
                      ),

                      // Spacing
                      const Spacer(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
