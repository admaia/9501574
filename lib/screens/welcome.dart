import 'package:flutter/material.dart';
import 'package:spending_app/screens/login.dart';

class MyWelcomePage extends StatefulWidget {
  const MyWelcomePage({super.key});

  @override
  State<MyWelcomePage> createState() => _MyWelcomePageState();
}

class _MyWelcomePageState extends State<MyWelcomePage> {
  String title = "Welcome to Benko !";
  bool isLoading = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: const Color.fromARGB(255, 35, 116, 181),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Votre app favorite pour gérer vos dépenses !",
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 35, 116, 181),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset("images/banklogo.png", width: 200, height: 200),
            const SizedBox(height: 20),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(
                  const Color.fromARGB(255, 35, 116, 181),
                ),
                minimumSize: WidgetStateProperty.all(Size(100, 70)),
              ),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                // Navigate after a delay
                Future.delayed(const Duration(seconds: 5), () {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                });
              },
              child: Text(
                'Commencer',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 35, 116, 181),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 127, 114, 148),
              ),
          ],
        ),
      ),
    );
  }
}
