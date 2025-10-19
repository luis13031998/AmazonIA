import 'package:flutter/material.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailPage extends StatelessWidget {
  final Producto libro;

  const BookDetailPage({super.key, required this.libro});

  Future<void> _abrirPdf(BuildContext context) async {
    final Uri uri = Uri.parse(libro.pdfUrl);
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(libro.title,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                libro.image,
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  color: Colors.white30,
                  size: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              libro.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              "Autor: ${libro.seller}",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              libro.description,
              style:
                  const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _abrirPdf(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
              label: const Text(
                "Abrir PDF",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
