import 'package:dietitian_cons/backend/db_cloud.dart';
import 'package:dietitian_cons/components/my_button.dart';
import 'package:dietitian_cons/components/my_input_field.dart';
import 'package:dietitian_cons/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DbCloud _cloud = DbCloud();
  final TextEditingController _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyAuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (user!.photoURL != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  user.photoURL!,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            if (user.photoURL == null)
              const Icon(
                Icons.person,
                size: 200,
              ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: Text("${user.displayName}"),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(user.email!),
            ),
            FutureBuilder(
              future: _cloud.getSingleUser(user.email!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data.docs[0].data();

                  return ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("+234${data["phoneNumber"]}"),
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Update phone number"),
                                content: SizedBox(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      MyInputField(
                                        controller: _phoneNumberController,
                                        obscureText: false,
                                        hintText: "Phone number",
                                        label: const Text("Phone"),
                                        keyboardType: TextInputType.phone,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MyButton(
                                        text: "Update",
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        textColor: Colors.white,
                                        onTap: () {
                                          if (_phoneNumberController
                                              .text.isNotEmpty) {
                                            _cloud.saveUser(
                                                user.email!,
                                                user.uid,
                                                int.parse(_phoneNumberController
                                                    .text));
                                            Navigator.pop(context);
                                            _phoneNumberController.clear();
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Icons.edit),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
