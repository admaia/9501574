import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_app/screens/core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final String email = "adama@gmail.com";
  final String mdp = "motdepasse";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connexion",
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 99, 146, 184),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                border: UnderlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Mot de passe",
                border: UnderlineInputBorder(),
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String motdepasse = passwordController.text;

                if (email == email && motdepasse == mdp) {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  await sp.setBool('isLogin', true);
                  await sp.setString('email', email);
                  await sp.setString('mot de passe', motdepasse);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CorePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email ou mot de passe incorrect'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 99, 146, 184),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Connexion',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
