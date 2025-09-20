import 'package:flutter/material.dart';
import 'package:spotifymusic_app/constants.dart';

class Description extends StatelessWidget {
  final String description;
  const Description({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado con 3 secciones
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón "Descripción" (seleccionado)
            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: kprimaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Descripción",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            // Texto "Especificación"
            Text(
              "Especificación",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.grey[300] : Colors.black,
              ),
            ),

            // Texto "Reseñas"
            Text(
              "Reseñas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.grey[300] : Colors.black,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Texto de descripción
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.grey[400] : Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
