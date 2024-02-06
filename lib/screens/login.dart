import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/screens/register_screen.dart'; // Importa la pantalla de registro
import 'package:movies/main.dart'; // Reemplaza 'MainScreen' con el nombre de tu pantalla principal

class LoginScreen extends StatefulWidget {
  final ThemeData? themeData;

  LoginScreen({this.themeData});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.themeData!.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: widget.themeData!.colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Log In',
          style: widget.themeData!.textTheme.headlineSmall,
        ),
      ),
      body: Container(
        color: widget.themeData!.primaryColor,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();

                try {
                  await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Navigate to the main screen (or any other desired screen) after successful login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),  // Reemplaza MainScreen con el nombre de tu pantalla principal
                    ),
                  );
                } catch (e) {
                  print('Error: $e');
                  // Handle login error
                }
              },
              child: Text('Log In'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to the registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: Text(
                'Don\'t have an account? Register here.',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
