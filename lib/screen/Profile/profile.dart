import 'package:flutter/material.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode
        ? Colors.amberAccent // resalta en dark mode
        : const Color.fromARGB(221, 251, 167, 21);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Fondo
          Image.asset(
            AppImages.introBG,
            fit: BoxFit.cover,
            height: size.height,
            width: size.width,
          ),

          // Card con información del perfil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  height: size.height * 0.4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Column(
                    children: [
                      // Parte superior con foto y botones
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileHeader(context),
                            const SizedBox(height: 10),

                            // Nombre y descripción
                            Text(
                              "Pepito Juanito",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 35,
                                color: textColor,
                              ),
                            ),
                            Text(
                              "Alumno de 5to de primaria",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: subtitleColor,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Biografía
                            Text(
                              "Me encanta leer libros en mis ratos libre acompañado de mis amigos es uno de mis hobbies.",
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Divider(
                        color: isDarkMode ? Colors.white12 : Colors.black12,
                      ),

                      // Sección inferior (estadísticas)
                      SizedBox(
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _FriendAndMore(
                              title: "AMIGOS",
                              number: "24",
                              textColor: textColor,
                              subtitleColor: isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                            ),
                            _FriendAndMore(
                              title: "SIGUIENDO",
                              number: "28",
                              textColor: textColor,
                              subtitleColor: isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                            ),
                            _FriendAndMore(
                              title: "SEGUIDORES",
                              number: "134",
                              textColor: textColor,
                              subtitleColor: isDarkMode
                                  ? Colors.white54
                                  : Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la cabecera con la imagen de perfil y los botones de acción.
  Widget _buildProfileHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Foto de perfil con check verde
        Stack(
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundImage: AssetImage(AppImages.perfilNino),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 25,
                width: 25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 95, 225, 99),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),

        // Botones: Agregar amigo y seguir
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.redAccent.withOpacity(0.6)
                      : const Color.fromARGB(136, 244, 6, 6),
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
              child: Text(
                "AGREGAR AMIGO",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.pink,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
              child: const Text(
                "Seguir",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Widget reutilizable para mostrar amigos/seguidores/siguiendo.
class _FriendAndMore extends StatelessWidget {
  final String title;
  final String number;
  final Color textColor;
  final Color subtitleColor;

  const _FriendAndMore({
    required this.title,
    required this.number,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: subtitleColor,
            ),
          ),
          Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
