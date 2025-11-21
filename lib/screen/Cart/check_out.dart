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
    final provider = CartProvider.of(context, listen: true);

    final cantidad = provider.cart.length;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final background = isDarkMode ? Colors.grey[900] : Colors.white;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Cantidad libros a descargar:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[300] : Colors.grey,
              )),
          const SizedBox(height: 8),
          Text(
            "$cantidad",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
  if (provider.cart.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No tienes libros en el carrito.")),
    );
    return;
  }

  final libro = provider.cart.first;
  if (libro.pdfUrl.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("❌ Este libro no tiene PDF.")),
    );
    return;
  }
  
  String makeDocId(String title) {
  return title.trim()
    .toLowerCase()
    .replaceAll(RegExp(r'\s+'), '_')  // espacios -> _
    .replaceAll(RegExp(r'[^a-z0-9_áéíóúñü]'), ''); // quitar chars raros (ajusta si quieres)
}


  // abrir pdf (puedes abrir primero o después según prefieras)
  await _abrirPdf(libro.pdfUrl, context);

  final user = FirebaseAuth.instance.currentUser;
  final bookId = makeDocId(libro.title);
  final bookRef = FirebaseFirestore.instance.collection("books").doc(bookId);

  try {
    // 1) Transaction seguro para incrementar o crear el doc si no existe
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(bookRef);
      if (!snapshot.exists) {
        transaction.set(bookRef, {
          "title": libro.title,
          "totalDownloads": 1,
          // puedes añadir otros campos iniciales si quieres
        });
      } else {
        transaction.update(bookRef, {
          "totalDownloads": FieldValue.increment(1),
        });
      }
    });

    // 2) Añadir registro en subcolección 'downloads' con timestamp y uid
    await bookRef.collection("downloads").add({
      "uid": user?.uid ?? "invitado",
      "timestamp": Timestamp.now(), // nombre 'timestamp' (coincide con DetailScreen)
    });

    // 3) Notificar y limpiar carrito (asegúrate clearCart haga notifyListeners)
    provider.addNotification("Se descargó el libro ${libro.title}");
    provider.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("📥 Se descargó '${libro.title}' exitosamente.")),
    );
  } catch (e) {
    print("⚠️ Error actualizando descargas: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al registrar la descarga.")),
    );
  }
},

            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              minimumSize: const Size(double.infinity, 55),
            ),
            child: const Text(
              "Descargar libro PDF ⏏️",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
