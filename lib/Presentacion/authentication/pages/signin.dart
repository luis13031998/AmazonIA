import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:spotifymusic_app/Data/models/auth/signin_user_req.dart';
import 'package:spotifymusic_app/Dominio/usecases/auth/sigin.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signup.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/forgot_password.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/core/configs/assets/app_vector.dart';
import 'package:spotifymusic_app/screen/nav_bar_screen.dart';
import 'package:spotifymusic_app/service_locator.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + 20;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo decorativo
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(AppVector.topPattern, fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(AppVector.bottomPattern, fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(AppImages.authBG1, fit: BoxFit.cover),
          ),

          // Contenido principal
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 228, 131, 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Accede a los libros virtuales de tu institución',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Campos
                    _inputField(_email, 'Correo electrónico'),
                    const SizedBox(height: 20),
                    _inputField(_password, 'Contraseña', isPassword: true),
                    const SizedBox(height: 30),

                    // Botón principal
                    BasicAppButton(
                      onPressed: () async {
                        final result = await sl<SigninUseCase>().call(
                          params: SigninUserReq(
                            email: _email.text.trim(),
                            password: _password.text.trim(),
                          ),
                        );

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
                                content:
                                    Text('✅ Inicio de sesión exitoso'),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BottomNavBar()),
                                (route) => false,
                              );
                            });
                          },
                        );
                      },
                      title: 'Iniciar Sesión',
                    ),
                    const SizedBox(height: 10),

                    // Olvidó contraseña
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage()),
                        );
                      },
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),

                    const SizedBox(height: 25),
                    _divider(),
                    const SizedBox(height: 25),

                    // Botones sociales
                    _socialLoginButtons(context),
                    const SizedBox(height: 25),

                    // Texto para registrarse
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes una cuenta?',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupPage()),
                            );
                          },
                          child: const Text(
                            'Regístrate aquí',
                            style: TextStyle(
                              color: Color.fromARGB(255, 228, 131, 12),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // Botón de retroceso
          Positioned(
            top: topPadding,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Widgets Reutilizables ----------------

  Widget _inputField(TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _divider() => const Row(
        children: [
          Expanded(
              child: Divider(color: Colors.white54, thickness: 1, endIndent: 10)),
          Text("O",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
              child: Divider(color: Colors.white54, thickness: 1, indent: 10)),
        ],
      );

  Widget _socialLoginButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _socialButton(
            asset: 'assets/icons/google.png',
            onTap: () async => await _entrarConGoogle(context),
          ),
          const SizedBox(width: 30),
          if (Platform.isIOS)
            _socialButton(
              asset: 'assets/icons/apple.png',
              onTap: () async => await _entrarConApple(context),
            ),
        ],
      );

  Widget _socialButton({required String asset, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.25),
        ),
        child: Image.asset(asset, height: 30, width: 30),
      ),
    );
  }

  // ------------------- Google Login -------------------

  Future<UserCredential?> _entrarConGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavBar()),
          (route) => false,
        );
      }

      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al iniciar con Google: $e")),
      );
      return null;
    }
  }

  // ------------------- Apple Login -------------------

  Future<UserCredential?> _entrarConApple(BuildContext context) async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256toString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavBar()),
          (route) => false,
        );
      }

      return userCredential;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al iniciar con Apple: $e")),
      );
      return null;
    }
  }
}

// ------------------- Funciones auxiliares -------------------

String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(
    length,
    (_) => charset[random.nextInt(charset.length)],
  ).join();
}

String sha256toString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
