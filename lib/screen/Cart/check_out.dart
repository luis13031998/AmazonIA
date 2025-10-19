import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckOutBox extends StatelessWidget {
  const CheckOutBox({super.key});

  Future<void> _abrirPdf(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir el PDF.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    final cantidad = provider.cart.length;

    // Detecta si está en Dark Mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.grey[300] : Colors.grey;
    final cantidadColor = isDarkMode ? Colors.white : Colors.black;
    final dividerColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cantidad libros a descargar: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 1),
          Divider(color: dividerColor),
          const SizedBox(height: 2),

          // Cantidad centrada
          Center(
            child: Text(
              "$cantidad",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: cantidadColor,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Botón de descarga
          ElevatedButton(
            onPressed: () async {
              if (provider.cart.isNotEmpty) {
                final primerLibro = provider.cart.first;

                if (primerLibro.pdfUrl.isNotEmpty) {
                  await _abrirPdf(primerLibro.pdfUrl, context);

                  // 🔹 Agregamos una notificación con el título del libro
                  provider.addNotification(
                    "Se ha descargado el libro ${primerLibro.title}",
                  );

                  provider.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Se descargó el libro '${primerLibro.title}' y se vació el carrito."),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("❌ Este libro no tiene PDF disponible.")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No tienes libros en el carrito.")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Descargar libro pdf ⏏️",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
