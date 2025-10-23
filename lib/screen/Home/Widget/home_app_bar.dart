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
        // 🔸 Botón de salida
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
                        backgroundColor: const Color(0xFFF1720A),
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

        // 🔹 Logo centrado
        Expanded(
          child: Center(
            child: Image.asset(
              "assets/images/logosanta.png",
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // 🔔 Botón de notificaciones moderno
        Stack(
          children: [
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[850] : kcontentColor,
                padding: const EdgeInsets.all(20),
              ),
              onPressed: () {
                // ⬇️ Bottom Sheet moderno
                showModalBottomSheet(
                  context: context,
                  backgroundColor:
                      isDarkMode ? Colors.grey[900] : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔸 Título
                          Row(
                            children: [
                              const Icon(Icons.notifications_active,
                                  color: Color(0xFFF1720A), size: 28),
                              const SizedBox(width: 8),
                              Text(
                                "Notificaciones",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              if (provider.notifications.isNotEmpty)
                                IconButton(
                                  onPressed: () {
                                    provider.clearNotifications();
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.redAccent),
                                  tooltip: "Borrar todas",
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 📨 Contenido
                          provider.notifications.isEmpty
                              ? Center(
                                  child: Column(
                                    children: const [
                                      Icon(Icons.notifications_off_outlined,
                                          color: Colors.grey, size: 60),
                                      SizedBox(height: 10),
                                      Text(
                                        "No tienes notificaciones todavía.",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: provider.notifications.length,
                                  itemBuilder: (context, index) {
                                    final msg = provider.notifications[index];
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: Card(
                                        color: isDarkMode
                                            ? Colors.grey[850]
                                            : const Color(0xFFF9F9F9),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.notifications,
                                            color: Color(0xFFF1720A),
                                          ),
                                          title: Text(
                                            msg,
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.grey),
                                            onPressed: () {
                                              provider.removeNotificationAt(
                                                  index);
                                              Navigator.pop(context);
                                              // vuelve a abrir actualizado
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 100),
                                                () => showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: isDarkMode
                                                      ? Colors.grey[900]
                                                      : Colors.white,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(25),
                                                    ),
                                                  ),
                                                  builder: (_) =>
                                                      const SizedBox(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
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
