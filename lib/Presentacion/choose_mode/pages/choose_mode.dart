import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:spotifymusic_app/Presentacion/authentication/pages/signup_or_signin.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/bloc/theme_cubit.dart';
import 'package:spotifymusic_app/common/widgets/button/basic_app_button.dart' show BasicAppButton;
import 'package:spotifymusic_app/core/configs/assets/app_images.dart' show AppImages;
import 'package:spotifymusic_app/core/configs/assets/app_vector.dart' show AppVector;
import 'package:spotifymusic_app/core/configs/theme/app_colors.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          // Cambiar opacidad dependiendo del tema
          final overlayOpacity = themeMode == ThemeMode.dark ? 0.5 : 0.15;

          return Stack(
            children: [
              // Imagen de fondo
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppImages.chooseModeBG),
                  ),
                ),
              ),

              // Capa negra con opacidad dinámica
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: Colors.black.withOpacity(overlayOpacity),
              ),

              // Botón de retroceso (más bajo y adaptado al notch)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10, // se adapta al notch
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Contenido principal
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                child: Column(
                  children: [
                    const Spacer(),
                    const Text(
                      'Elegir Modo',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 21),

                    Column(
                      children: [
                        // Modo Oscuro
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: themeMode == ThemeMode.dark
                                          ? Colors.orangeAccent.withOpacity(0.6)
                                          : const Color(0xff30393C).withOpacity(0.5),
                                      shape: BoxShape.circle,
                                      boxShadow: themeMode == ThemeMode.dark
                                          ? [
                                              BoxShadow(
                                                color: Colors.orangeAccent.withOpacity(0.6),
                                                blurRadius: 15,
                                                spreadRadius: 3,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: SvgPicture.asset(
                                      AppVector.moon,
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              'Modo Oscuro',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Modo Claro
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                              },
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: themeMode == ThemeMode.light
                                          ? const Color.fromARGB(255, 205, 205, 3).withOpacity(0.6)
                                          : const Color(0xff30393C).withOpacity(0.5),
                                      shape: BoxShape.circle,
                                      boxShadow: themeMode == ThemeMode.light
                                          ? [
                                              BoxShadow(
                                                color: const Color.fromARGB(255, 232, 206, 14)
                                                    .withOpacity(0.6),
                                                blurRadius: 15,
                                                spreadRadius: 3,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: SvgPicture.asset(
                                      AppVector.sun,
                                      fit: BoxFit.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              'Modo Claro',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                    BasicAppButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const SignupOrSigninPage(),
                          ),
                        );
                      },
                      title: 'Continuar',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
