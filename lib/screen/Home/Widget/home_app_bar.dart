import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import '../../../constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final provider = CartProvider.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón de salida
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.grey[850] : kcontentColor,
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: theme.dialogBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "¿Salir de la aplicación?",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "¿Seguro que quieres cerrar la aplicación?",
                    style: theme.textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[300] : Colors.black87,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 241, 114, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => exit(0),
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
            color: isDarkMode
                ? Colors.grey[300]
                : const Color.fromARGB(255, 42, 30, 30),
          ),
        ),

        // Logo en el centro
        Expanded(
          child: Center(
            child: Image.asset(
              "assets/images/logosanta.png",
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Botón de notificaciones con badge
        Stack(
          children: [
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[850] : kcontentColor,
                padding: const EdgeInsets.all(20),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Notificaciones"),
                    content: provider.notifications.isEmpty
                        ? const Text("No tienes notificaciones todavía.")
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: provider.notifications
                                .map((msg) => ListTile(
                                      leading: const Icon(Icons.book),
                                      title: Text(msg),
                                    ))
                                .toList(),
                          ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          provider.clearNotifications(); // 👉 limpia todas
                          Navigator.pop(context);
                        },
                        child: const Text("Limpiar"),
                      ),
                    ],
                  ),
                );
              },
              iconSize: 30,
              icon: Icon(
                Icons.notifications_outlined,
                color: isDarkMode
                    ? Colors.grey[300]
                    : const Color.fromRGBO(24, 20, 20, 1),
              ),
            ),

            // 🔴 Badge con contador
            if (provider.notifications.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    "${provider.notifications.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
