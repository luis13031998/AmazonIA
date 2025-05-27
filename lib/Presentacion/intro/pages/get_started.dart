import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/pages/choose_mode.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/core/configs/assets/app_vector.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  AppImages.introBG,
                )
              )
            ), 
          ),
          Container(
            color:  Colors.black.withOpacity(0.15),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40
            ),
            child: Column(
               children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    AppVector.logo,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Disfruta leyendo los mejores libros',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 242, 196, 15)
                  ),
                ),
                const SizedBox(height: 21,),
                const Text(
                  'Somos una tienda virtual de libros para todo tipo de acceso en información, podras visualizar, comprar y vender libros de tu necesidad.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20,),
                BasicAppButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context) => const ChooseModePage()
                    )
                    );
                  }, 
                  title: 'Empezar'
                )
              ],
             ),
          ),
        ],
      ),
    );
  }
}
