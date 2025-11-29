import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final provider = CartProvider.of(context); // <- escucha cambios del carrito

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final background = isDarkMode ? Colors.grey[900] : Colors.white;

    return AnimatedBuilder(
      animation: provider, // 🔥 Se reconstruye cuando cambia el carrito
      builder: (context, _) {
        final cantidad = provider.cart.length;

        return Container(
          height: 220,
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Cantidad de libros a descargar:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$cantidad",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const Spacer(),

              // ===========================
              // ======== BOTÓN ==============
              // ===========================
              ElevatedButton(
                onPressed: () async {
                  if (provider.cart.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No tienes libros en el carrito.")),
                    );
                    return;
                  }

                  final user = FirebaseAuth.instance.currentUser;

                  for (var libro in provider.cart) {
                    if (libro.pdfUrl.isEmpty) continue;

                    final bookId = libro.id;
                    final bookRef = FirebaseFirestore.instance
                        .collection("books")
                        .doc(bookId);

                    try {
                      // 📌 Verificar descargas previas
                      final existingDownload = await bookRef
                          .collection("downloads")
                          .where("uid", isEqualTo: user?.uid ?? "invitado")
                          .limit(1)
                          .get();

                      if (existingDownload.docs.isNotEmpty) {
                        provider.addNotification(
                            "ℹ️ Ya habías descargado ${libro.title}");
                        continue;
                      }

                      // 🔥 Abrir PDF
                      await _abrirPdf(libro.pdfUrl, context);

                      // 📌 Incrementar contador global
                      await FirebaseFirestore.instance.runTransaction((transaction) async {
                        final snapshot = await transaction.get(bookRef);
                        if (!snapshot.exists) {
                          transaction.set(bookRef, {
                            "title": libro.title,
                            "totalDownloads": 1,
                          });
                        } else {
                          transaction.update(bookRef, {
                            "totalDownloads": FieldValue.increment(1),
                          });
                        }
                      });

                      // 📌 Guardar descarga por usuario
                      await bookRef.collection("downloads").add({
                        "uid": user?.uid ?? "invitado",
                        "bookTitle": libro.title,
                        "timestamp": Timestamp.now(),
                      });

                      provider.addNotification("📚 Descargaste el libro: ${libro.title}");
                    } catch (e) {
                      debugPrint("⚠️ Error descargando ${libro.title}: $e");
                    }
                  }

                  // 🔥 Vaciar carrito y actualizar contador
                  provider.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("✅ Descargas procesadas correctamente."),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color.fromARGB(255, 65, 30, 191)
                      : const Color.fromARGB(255, 240, 127, 14),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Descargar libros PDF ⏏️",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
