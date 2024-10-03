import "package:flutter/material.dart";
import "package:url_launcher/url_launcher_string.dart";


class ContactUsScreen extends StatefulWidget{
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreen();
}


class _ContactUsScreen extends State<ContactUsScreen>{

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: const Text("Contact us")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10.0),
        child: Column(
          children: [
            InkWell(
              onTap: (){
                launchUrlString("tel:+2348036099274");
              },
              child: const ListTile(
                title: Text("Phone 1"),
                trailing: Icon(Icons.phone),
              ),
            ),
            InkWell(
              onTap: (){
                launchUrlString("tel:+2349112644215");
              },
              child: const ListTile(
                title: Text("Phone 2"),
                trailing: Icon(Icons.phone),
              ),
            ),
            InkWell(
              onTap: (){
                launchUrlString("mailto:twinsapple094@gmail.com");
              },
              child: const ListTile(
                title: Text("Email"),
                trailing: Icon(Icons.email),
              ),
            ),
            const ListTile(
              title: Text("Address"),
              trailing: Text("Darmanawa No.2 A Magaji street"),
            ),
          ],
        ),
      ),
    );
  }
}