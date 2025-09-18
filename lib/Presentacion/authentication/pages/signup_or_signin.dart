import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signin.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signup.dart';
import 'package:spotifymusic_app/common/helpers/is_dark.dart';
import 'package:spotifymusic_app/common/widgets/appbar/app_bar.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/core/configs/assets/app_vector.dart';


class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
            const BasicAppbar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              AppVector.topPattern,
              fit: BoxFit.cover, // Ajuste opcional
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              AppVector.bottomPattern,
              fit: BoxFit.cover, // Ajuste opcional
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset( // Se cambió SvgPicture.asset por Image.asset
              AppImages.authBG,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 
                  const SizedBox(
                    height: 55,
                  ),
                  const Text(
                    'colegio IE  “Albert Einstein”',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 235, 180, 53)
                    ),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  const Text(
                    'Para poder acceder a nuestro libros virtuales escolar primero debes registrarte y poder pertenecer a los libros virtuales.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color.fromARGB(255, 249, 249, 248)
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
              
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: BasicAppButton(
                          onPressed: (){
                            Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (BuildContext context) => SignupPage()
                            )
                            );
                          },
                          title: 'Registrar',
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 1,
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (BuildContext context) => SigninPage()
                            )
                          );
                        }, 
                        child: Text(
                          'Iniciar Sesion',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode ? Colors.white : const Color.fromARGB(255, 250, 249, 249),
                            fontSize: 16,
                          ),
                        )
                        )
                      )
                    ]
                  )
                ]
              ),
            )
          ),
        ],
      ),
    );
  }
}
