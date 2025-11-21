import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/addto_cart.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/description.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/detail_app_bar.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/items_details.dart';

class DetailScreen extends StatefulWidget {
  final Producto producto;

  const DetailScreen({super.key, required this.producto});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentImage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : kcontentColor;
    final containerColor = isDark ? Colors.grey[900] : Colors.white;
    final activeDotColor = isDark ? Colors.white : Colors.black;
    final borderDotColor = isDark ? Colors.white70 : Colors.black;

    final String bookId = widget.producto.title.trim();

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: AddtoCart(producto: widget.producto),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailAppBAR(producto: widget.producto),

              /// IMAGEN PRINCIPAL
              Center(
                child: Hero(
                  tag: '${widget.producto.image}_${widget.producto.title}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.producto.image,
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// INDICADORES
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: currentImage == index ? 15 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentImage == index
                          ? activeDotColor
                          : Colors.transparent,
                      border: Border.all(color: borderDotColor),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemsDetails(producto: widget.producto),
                    const SizedBox(height: 20),

                    /// 🔥 STREAM PRINCIPAL (DOCUMENTO DEL LIBRO)
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('books')
                          .doc(bookId)
                          .snapshots(),
                      builder: (context, bookSnapshot) {
                        if (bookSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Description(
                            description: widget.producto.description,
                            dowlands: "Cargando...",
                            reviews: "Cargando...",
                          );
                        }

                        /// SI EL DOCUMENTO NO EXISTE
                        if (!bookSnapshot.hasData ||
                            !bookSnapshot.data!.exists) {
                          return Description(
                            description: widget.producto.description,
                            dowlands:
                                "Aún no hay datos registrados para este libro.",
                            reviews: "No hay descargas.",
                          );
                        }

                        final bookData =
                            bookSnapshot.data!.data() as Map<String, dynamic>;

                        final int totalDownloads =
                            bookData['totalDownloads'] is int
                                ? bookData['totalDownloads']
                                : 0;

                        /// SUBSTREAM – LISTA DE DESCARGAS
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('books')
                              .doc(bookId)
                              .collection("downloads")
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, usersSnapshot) {
                            if (!usersSnapshot.hasData) {
                              return Description(
                                description: widget.producto.description,
                                dowlands:
                                    "Este libro ha sido descargado $totalDownloads veces.",
                                reviews: "Cargando usuarios...",
                              );
                            }

                            final downloadsDocs = usersSnapshot.data!.docs;

                            String usersList = downloadsDocs.isEmpty
                                ? "Nadie ha descargado este libro aún."
                                : downloadsDocs.map((d) {
                                    final String uid =
                                        d['uid'] ?? 'Usuario desconocido';

                                    final timestamp = d['timestamp'];
                                    String timeText = "Sin fecha";

                                    if (timestamp is Timestamp) {
                                      final date =
                                          timestamp.toDate().toLocal();
                                      timeText =
                                          "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
                                    }

                                    return "• $uid — $timeText";
                                  }).join("\n");

                            return Description(
                              description: widget.producto.description,
                              dowlands:
                                  "Este libro ha sido descargado $totalDownloads veces.",
                              reviews: "Usuarios que descargaron:\n$usersList",
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
