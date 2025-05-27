import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotifymusic_app/Data/models/auth/create_user_req.dart';
import 'package:spotifymusic_app/Dominio/usecases/auth/signup.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signin.dart';
import 'package:spotifymusic_app/common/widgets/appbar/app_bar.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart';
import 'package:spotifymusic_app/core/configs/assets/app_vector.dart';
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
      bottomNavigationBar: _siginText(context),
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVector.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           _registerText(),
           const SizedBox(height: 50,),
           _fullNameField(context),
           const SizedBox(height: 20,),
           _emailField(context),
           const SizedBox(height: 20,),
           _passwordField(context),
           const SizedBox(height: 20,),
           BasicAppButton(
            onPressed: () async {
              var result = await sl<SignupUseCase>().call(
                params: CreateUserReq(
                  fullName: _fullName.text.toString(), 
                  email: _email.text.toString(), 
                  password: _password.text.toString()
                  )
              );
              result.fold(
                (l){
                  var snackbar = SnackBar(content: Text(l));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }, 
                (r){
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (BuildContext context) => const BottomNavBar()),
                    (route) => false
                    );
                }
              );
            },
            title: 'Crear cuenta',
           )
          ],
        ),
      ),
    );
  }

  Widget _registerText(){
    return const Text(
      'Registro', 
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context){
    return TextField(
        controller: _fullName,
        decoration: InputDecoration(
        hintText: 'Nombre Completo',
        contentPadding: const EdgeInsets.all(30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30)
        )
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _emailField(BuildContext context){
    return TextField(
        controller: _email,
        decoration: InputDecoration(
        hintText: 'Ingresar Correo',
        contentPadding: const EdgeInsets.all(30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30)
        )
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _passwordField(BuildContext context){
    return TextField(
        controller: _password,
        decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: const EdgeInsets.all(30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30)
        )
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _siginText(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿Tienes una cuenta?',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                 builder: (BuildContext context) => SigninPage()
               )
             );
            },
            child: Text(
             'Iniciar sesión'
            )
          )
        ],
      ),
    );
  }
}