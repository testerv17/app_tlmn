import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_menu/pages/home_page.dart';
import 'package:test_menu/util/colors.dart';

class LoginvTwo extends StatelessWidget {
  const LoginvTwo({super.key});

  Future<void> _signIn(
      String email, String password, BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      // Authenticate user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Determine role based on email
      String role = "admin"; // Default to admin
      if (email.toLowerCase().startsWith("cuadrilla")) {
        role = "cuadrilla";
      }

      // Close loading indicator
      if (Navigator.canPop(context)) Navigator.pop(context);

      // Navigate to HomePage with the user's role
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(user: userCredential.user!, role: role),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      if (Navigator.canPop(context)) Navigator.pop(context);

      // Handle specific Firebase authentication errors
      String errorMessage = "An unexpected error occurred.";
      if (e.code == 'user-not-found') {
        errorMessage = "El correo electrónico no está registrado.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "La contraseña ingresada es incorrecta.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Close loading indicator
      if (Navigator.canPop(context)) Navigator.pop(context);

      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error inesperado: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [backgroundColor5, backgroundColor4, backgroundColor1],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20),
            children: [
              Image.asset("lib/images/teclumnsSlogan.png",
                  width: 40, height: 60),
              SizedBox(height: size.height * 0.15),
              myTextField(
                "Correo electrónico",
                Colors.white,
                (value) => email = value,
              ),
              myTextField(
                "Contraseña",
                Colors.black26,
                (value) => password = value,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Ingresa tus credenciales para acceder",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: textcolor2,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () => _signIn(email, password, context),
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Entrar",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container myTextField(String hint, Color color, Function(String) onChanged,
      {bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextField(
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45, fontSize: 19),
          suffixIcon: Icon(Icons.visibility_off_outlined, color: color),
        ),
      ),
    );
  }
}
