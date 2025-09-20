import 'dart:io'; // 👈 necesario para exit(0)
import 'package:flutter/material.dart';
import '../../../constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Detecta si está en Dark Mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[850] : kcontentColor,
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () {
            // Mostramos alerta de confirmación al salir
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "¿Salir de la aplicación?",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "¿Seguro que quieres cerrar la aplicación?",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el diálogo
                      },
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 243, 104, 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        exit(0); // 👈 Cierra la aplicación
                      },
                      child: const Text(
                        "Salir",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.exit_to_app,
            color: isDarkMode ? Colors.grey[300] : Colors.white,
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[850] : kcontentColor,
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () {},
          iconSize: 30,
          icon: Icon(
            Icons.notifications_outlined,
            color: isDarkMode ? Colors.grey[300] : Colors.white,
          ),
        ),
      ],
    );
  }
}
