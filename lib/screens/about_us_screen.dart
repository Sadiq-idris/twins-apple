import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final List services = [
    "Weight management",
    "Chronic disease management (e.g., diabetes, hypertension, cholesterol)",
    "Prenatal and postnatal nutrition"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About us"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                  "Twins Apple  food court and Nutritional services Ltd is a dedicated collective of dietitians and nutritionists focused on improving health and well-being through personalized meal planning and expert consultation. Our mission is to provide individuals with customized meal plans designed around their specific dietary needs, nutritional goals, and health conditions. By tailoring nutrition strategies, we help clients achieve optimal health, manage chronic conditions, and improve their overall lifestyle through balanced and nutrient-rich diets."),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  "Twins Apple is a professional health consultancy specializing in dietetics and nutrition. Our team of experienced dietitians works closely with clients to create personalized nutrition plans aimed at improving health outcomes and fostering long-term wellness. We cater to individuals with diverse health needs, offering solutions for:"),
              Column(
                children: List.generate(services.length, (index) {
                  return ListTile(
                    leading: Text("${index + 1}"),
                    title: Text(services[index]),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
