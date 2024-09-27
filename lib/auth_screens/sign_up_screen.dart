import 'package:dietitian_cons/backend/auth_services.dart';
import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/components/social_button.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final _key = GlobalKey<FormState>();

  bool isLoading = false;

  String? myValidator(String? value) {
    if (value!.isEmpty) {
      return "Field required.";
    } else {
      return null;
    }
  }

  final AuthServices _authServices = AuthServices();
  final DbCloud _cloud = DbCloud();

  // sign up user
  void signUp() async {
    setState(() {
      isLoading = true;
    });
    dynamic user = await _authServices.signUp(
        _nameController.text, _emailController.text, _pwdController.text);

    if (user is String) {
      String message = user.toString();
      setState(() {
        isLoading = false;
      });
      // Logging error message if any
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
      _cloud.saveUser(user.email, user.uid, int.parse(_phoneNumberController.text));
      _cloud.consultationPaid(user.email, null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Check your email to verify your account"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushNamed(context, "home");
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
        _cloud.saveUser(response.email, response.uid, int.parse(response.phoneNumber));
        _cloud.consultationPaid(response.email, null);
        Navigator.pushNamed(context, "auth-gate");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sign in successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                    Text(
                      "Register now",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    // Slogan
                    Text(
                      "Sign up with your email and password.",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    // Form for input fields
                    Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Spacing
                          const SizedBox(
                            height: 15,
                          ),
                          MyInputField(
                            label: const Text("Username:"),
                            controller: _nameController,
                            obscureText: false,
                            hintText: "Your username",
                            validator: myValidator,
                          ),

                          // Spacing
                          const SizedBox(height: 10),

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
                            label: const Text("Phone:"),
                            controller: _phoneNumberController,
                            obscureText: false,
                            hintText: "Phone number",
                            validator: myValidator,
                            keyboardType: TextInputType.phone,
                          ),

                          // Spacing
                          const SizedBox(
                            height: 10,
                          ),

                          MyInputField(
                            label: const Text("Password:"),
                            controller: _pwdController,
                            obscureText: true,
                            hintText: "Your password",
                            validator: myValidator,
                          ),

                          // Spacing
                          const SizedBox(
                            height: 20,
                          ),

                          MyButton(
                            text: "Sign up",
                            color: Theme.of(context).colorScheme.primary,
                            textColor: Colors.white,
                            onTap: () {
                              if (_key.currentState?.validate() ?? false) {
                                signUp();
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
                      height: 30,
                    ),

                    // Social Providers
                    SocialButton(
                      imageUrl: "assets/icons/google.png",
                      providerName: "Google",
                      onTap: () {
                        googleSignIn();
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
                          "Already have an account?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "sign-in");
                          },
                          child: Text(
                            "Sign in",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        )
                      ],
                    ),

                    // Spacing
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
    );
  }
}
