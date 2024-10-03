import 'package:dietitian_cons/backend/auth_services.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/components/social_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  String? myValidator(String? value) {
    if (value!.isEmpty) {
      return "Field required.";
    } else {
      return null;
    }
  }

  final _key = GlobalKey<FormState>();

  bool isLoading = false;

  final AuthServices _authServices = AuthServices();
  final DbCloud _cloud = DbCloud();

  // sign in user
  void signIn() async {
    setState(() {
      isLoading = true;
    });
    dynamic user =
        await _authServices.signIn(_emailController.text, _pwdController.text);

    if (user != null) {
      if (user is String) {
        setState(() {
          isLoading = false;
        });
        String message = user.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, "home");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign in successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

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
        setState(() {
          isLoading = false;
        });
        // final user = await _cloud.getSingleUser(response.email);
        _cloud.saveUser(response.email, response.uid, null);
        final formattedDate =
            DateFormat("yyy-MM-dd").format(response.metadata.creationTime);

        final dateTime = DateFormat("yyy-MM-dd").format(DateTime.now());

        if (formattedDate == dateTime) {
          _cloud.consultationPaid(response.email, null);
        }
        _cloud.addNotification(response.email, false, false);
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
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: const Text("Sign In"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spacing
                    // const SizedBox(
                    //   height: 20,
                    // ),

                    Text(
                      "Welcome back",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    // Slogan
                    Text(
                      "Sign in with your email and password.",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    // Spacing
                    const SizedBox(
                      height: 15,
                    ),

                    // Form for input fields
                    Form(
                      key: _key,
                      // autovalidateMode: isSubmitting? AutovalidateMode.always: AutovalidateMode.disabled,
                      // onChanged: (){
                      //   print("submitted");
                      // },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyInputField(
                            label: const Text("Email:"),
                            controller: _emailController,
                            obscureText: false,
                            hintText: "Email Address",
                            validator: myValidator,
                          ),
                          // Spacing
                          const SizedBox(height: 10),

                          MyInputField(
                            label: const Text("Password:"),
                            controller: _pwdController,
                            obscureText: true,
                            hintText: "Your password",
                            validator: myValidator,
                          ),

                          // Spacing
                          const SizedBox(
                            height: 10,
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "reset-password");
                            },
                            child: Text(
                              "Forgot password?",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),

                          // Spacing
                          const SizedBox(
                            height: 15,
                          ),

                          MyButton(
                            text: "Sign in",
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                            onTap: () {
                              if (_key.currentState?.validate() ?? false) {
                                signIn();
                              } else {
                                debugPrint("Error");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // End of form widget -------------------------

                    // Spacing
                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          "Continue in with",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),

                    // Spacing
                    const SizedBox(
                      height: 40,
                    ),

                    // Social Providers
                    SocialButton(
                      imageUrl: "assets/icons/google.png",
                      providerName: "Google",
                      onTap: () {
                        googleSignIn();
                        debugPrint("Sign in");
                      },
                    ),

                    // Spacing
                    const SizedBox(
                      height: 20,
                    ),

                    SocialButton(
                      imageUrl: "assets/icons/facebook.png",
                      providerName: "Facebook",
                      onTap: () {},
                    ),

                    // Spacing
                    const SizedBox(
                      height: 10,
                    ),

                    // Sign up if dont have account
                    Row(
                      children: [
                        Text(
                          "Dont have an account?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "sign-up");
                          },
                          child: Text(
                            "Sign up",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
