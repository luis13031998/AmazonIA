import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Dominio/usecases/auth/signup.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signin.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/service_locator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_fullName.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await sl<SignupUseCase>().call(
      params: CreateUserReq(
        fullName: _fullName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
      ),
    );

    setState(() => _isLoading = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Usuario creado correctamente'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) =>  SigninPage()),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + 20;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: _signinText(context),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Image.asset(AppImages.authBG1, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),

          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _registerText(),
                  const SizedBox(height: 50),
                  _fullNameField(context),
                  const SizedBox(height: 20),
                  _emailField(context),
                  const SizedBox(height: 20),
                  _passwordField(context),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : BasicAppButton(
                          onPressed: _handleSignup,
                          title: 'Crear cuenta',
                        ),
                ],
              ),
            ),
          ),

          // 🔹 Botón circular de retroceso (igual al de SigninPage)
          Positioned(
            top: topPadding,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ WIDGETS ------------------

  Widget _registerText() => const Text(
        'Registro',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      );

  Widget _fullNameField(BuildContext context) => TextField(
        controller: _fullName,
        textInputAction: TextInputAction.next,
        decoration: _inputDecoration(context, 'Nombre completo'),
        style: const TextStyle(color: Colors.white),
      );

  Widget _emailField(BuildContext context) => TextField(
        controller: _email,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: _inputDecoration(context, 'Correo electrónico'),
        style: const TextStyle(color: Colors.white),
      );

  Widget _passwordField(BuildContext context) => TextField(
        controller: _password,
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: _inputDecoration(context, 'Contraseña'),
        style: const TextStyle(color: Colors.white),
      );

  InputDecoration _inputDecoration(BuildContext context, String hint) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color.fromARGB(255, 228, 131, 12), width: 2),
        ),
      );

  Widget _signinText(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿Tienes una cuenta?',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>  SigninPage()),
                );
              },
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color.fromARGB(255, 228, 131, 12),
                ),
              ),
            ),
          ],
        ),
      );
}
