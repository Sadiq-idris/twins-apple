import 'package:dietitian_cons/backend/auth_services.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  AuthServices _authServices = AuthServices();

  void resetPassword() async {
    await _authServices.resetPassword(_emailController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Check your inbox forder instructions."),
        backgroundColor: Colors.green,
      ),
    );
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            // Spacing
            const SizedBox(
              height: 20,
            ),

            Text(
              "Reset password",
              style: Theme.of(context).textTheme.headlineLarge,
            ),

            // Slogan
            Text(
              "Enter your email, and we'll send you instrutions for creating new password.",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Spacing
            const SizedBox(
              height: 15,
            ),

            // Form for input fields
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyInputField(
                    label: const Text("Email:"),
                    controller: _emailController,
                    obscureText: false,
                    hintText: "Email Address",
                  ),

                  // Spacing
                  const SizedBox(
                    height: 15,
                  ),

                  MyButton(
                    text: "Reset password",
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Colors.white,
                    onTap: () {
                      resetPassword();
                    },
                  ),
                ],
              ),
            ),
            // End of form widget -------------------------
          ],
        ),
      ),
    );
  }
}
