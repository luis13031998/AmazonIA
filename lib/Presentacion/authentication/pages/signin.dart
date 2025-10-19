import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:spotifymusic_app/Data/models/auth/signin_user_req.dart';
import 'package:spotifymusic_app/Dominio/usecases/auth/sigin.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signup.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/forgot_password.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/screen/nav_bar_screen.dart';
import 'package:spotifymusic_app/service_locator.dart';

class SigninPage extends StatelessWidget {
   SigninPage({super.key}); // ✅ se usa const

  // controladores (no pueden ser const)
  final TextEditingController _email =  TextEditingController();
  final TextEditingController _password =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: _signupText(context),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Image.asset(AppImages.authBG, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _titleText(),
                  const SizedBox(height: 50),
                  _emailField(context),
                  const SizedBox(height: 20),
                  _passwordField(context),
                  const SizedBox(height: 20),

                  // Botón iniciar sesión
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
                              content: Text('✅ Inicio de sesión exitoso'),
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

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _orDivider(),
                  const SizedBox(height: 20),

                  _socialLoginButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------- Widgets UI -------------------

  Widget _titleText() => const Text(
        'Iniciar Sesión',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      );

  Widget _emailField(BuildContext context) => TextField(
        controller: _email,
        decoration: InputDecoration(
          hintText: 'Ingresa tu correo',
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding: const EdgeInsets.all(30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        style: const TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
      );

  Widget _passwordField(BuildContext context) => TextField(
        controller: _password,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          contentPadding: const EdgeInsets.all(30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        style: const TextStyle(color: Colors.white),
      );

  Widget _orDivider() => const Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.white70,
              thickness: 1,
              endIndent: 10,
            ),
          ),
          Text(
            "O",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white70,
              thickness: 1,
              indent: 10,
            ),
          ),
        ],
      );

  Widget _signupText(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¿No eres miembro?',
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
                  MaterialPageRoute(builder: (_) => const SignupPage()),
                );
              },
              child: const Text(
                'Regístrate ahora',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color.fromARGB(255, 237, 231, 39),
                ),
              ),
            ),
          ],
        ),
      );

  // ------------------- Social Login -------------------

  Widget _socialLoginButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Google
          GestureDetector(
            onTap: () async => await _entrarConGoogle(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Image.asset(
                'assets/icons/google.png',
                height: 30,
                width: 30,
              ),
            ),
          ),
          const SizedBox(width: 30),

          // Apple (solo visible en iOS)
          Offstage(
            offstage: !Platform.isIOS,
            child: GestureDetector(
              onTap: () async => await _entrarConApple(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Image.asset(
                  'assets/icons/apple.png',
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ],
      );

  // ------------------- Google Login -------------------

  Future<UserCredential?> _entrarConGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

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
