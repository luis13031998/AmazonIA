import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Dominio/usecases/auth/signup.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signin.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/screen/nav_bar_screen.dart';
import 'package:spotifymusic_app/service_locator.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: _siginText(context),
      ),
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            Image.asset(
              AppImages.authBG,
              fit: BoxFit.cover,
            ),

            // Capa semi-transparente
            Container(
              color: Colors.black.withOpacity(0.3),
            ),

            // Contenido principal
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
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
                      const SizedBox(height: 20),
                      BasicAppButton(
                        onPressed: () async {
                          var result = await sl<SignupUseCase>().call(
                            params: CreateUserReq(
                              fullName: _fullName.text,
                              email: _email.text,
                              password: _password.text,
                            ),
                          );
                          result.fold(
                            (l) {
                              var snackbar = SnackBar(content: Text(l));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            },
                            (r) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const BottomNavBar(),
                                ),
                                (route) => false,
                              );
                            },
                          );
                        },
                        title: 'Crear cuenta',
                      ),
                      const SizedBox(height: 20),
                      _orDivider(),
                      const SizedBox(height: 20),
                      _socialLoginButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Registro',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: InputDecoration(
        hintText: 'Nombre Completo',
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
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        hintText: 'Ingresar Correo',
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
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
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
  }

  Widget _orDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.white70,
            thickness: 1,
            endIndent: 10,
          ),
        ),
        const Text(
          "O",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.white70,
            thickness: 1,
            indent: 10,
          ),
        ),
      ],
    );
  }

  Widget _socialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // TODO: lógica login con Google
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Image.asset(
              'assets/icons/google.png', // Asegúrate de agregar en pubspec.yaml
              height: 30,
              width: 30,
            ),
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () {
            // TODO: lógica login con Apple
          },
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
      ],
    );
  }

  Widget _siginText(BuildContext context) {
    return Padding(
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
                MaterialPageRoute(builder: (BuildContext context) => SigninPage()),
              );
            },
            child: const Text(
              'Iniciar sesión',
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
  }
}
