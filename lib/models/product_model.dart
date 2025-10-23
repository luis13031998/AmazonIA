import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';

/// 🔹 MODELO DE PRODUCTO (LIBRO)
class Producto {
  final String title;
  final String description;
  final String image;
  final String review;
  final String seller;
  final List<Color> colors;
  final String category;
  final double rate;
  int quantity;
  bool isPurchased;
  final String pdfUrl;
  int downloads; // 👈 Nuevo campo

  Producto({
    required this.title,
    required this.review,
    required this.description,
    required this.image,
    required this.colors,
    required this.seller,
    required this.category,
    required this.rate,
    required this.quantity,
    this.isPurchased = false,
    required this.pdfUrl,
    this.downloads = 0, // valor inicial
  });
}

/// 🔹 FUNCIÓN PARA MOSTRAR ESTRELLAS SEGÚN EL RATING
Widget buildStarRating(double rating) {
  int filledStars = rating.floor(); // número entero de estrellas llenas
  bool hasHalfStar = (rating - filledStars) >= 0.5;
  int emptyStars = 5 - filledStars - (hasHalfStar ? 1 : 0);

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (int i = 0; i < filledStars; i++)
        const Icon(Icons.star, color: Colors.yellow, size: 20),
      if (hasHalfStar)
        const Icon(Icons.star_half, color: Colors.yellow, size: 20),
      for (int i = 0; i < emptyStars; i++)
        const Icon(Icons.star_border, color: Colors.yellow, size: 20),
    ],
  );
}

/// 🔹 FUNCIÓN PARA OBTENER URL DE ARCHIVO PDF DESDE FIREBASE STORAGE
Future<String> getPdfUrl(String fileName) async {
  try {
    final ref = FirebaseStorage.instance.ref().child('books/$fileName');
    return await ref.getDownloadURL();
  } catch (e) {
    print('⚠️ Error obteniendo PDF $fileName: $e');
    return '';
  }
}

/// 🔹 FUNCIÓN PARA INCREMENTAR DESCARGAS EN FIRESTORE
Future<void> incrementarDescargas(String tituloLibro) async {
  try {
    final docRef =
        FirebaseFirestore.instance.collection('books').doc(tituloLibro);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        transaction.set(docRef, {'downloads': 1});
      } else {
        final currentDownloads = snapshot.get('downloads') ?? 0;
        transaction.update(docRef, {'downloads': currentDownloads + 1});
      }
    });

    print("✅ Descarga incrementada para $tituloLibro");
  } catch (e) {
    print('⚠️ Error al incrementar descargas: $e');
  }
}

/// 🔹 FUNCIÓN PARA OBTENER NÚMERO DE DESCARGAS DESDE FIRESTORE
Future<int> obtenerDescargas(String tituloLibro) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('books').doc(tituloLibro).get();

    if (snapshot.exists) {
      return snapshot.get('downloads') ?? 0;
    } else {
      return 0;
    }
  } catch (e) {
    print('⚠️ Error obteniendo descargas de $tituloLibro: $e');
    return 0;
  }
}

/// 🔹 LISTA GLOBAL DE TODOS LOS PRODUCTOS
final List<Producto> all = [];

/// 🔹 MAPA DE CATEGORÍAS → (Ejemplo: "Drama" : [Producto, Producto...])
Map<String, List<Producto>> categorias = {};

/// 🔹 CARGAR PRODUCTOS DESDE FIREBASE Y AGRUPARLOS
Future<void> loadProducts() async {
  all.clear();

  // --- Ejemplo 1: Matemática ---
  String romeoPdf = await getPdfUrl('RomeoYJulieta.pdf');
  all.add(
    Producto(
      title: "Romeo y Julieta",
      description:
          "El libro 'Romeo y Julieta' es una de las obras más famosas de William Shakespeare y trata sobre una trágica historia de amor entre dos jóvenes pertenecientes a familias rivales.",
      image: AppImages.Romeo,
      colors: [Colors.yellow],
      seller: "Shakespeare",
      category: "Matematica",
      review: "(320 reviews)",
      rate: 4.8,
      quantity: 1,
      pdfUrl: romeoPdf,
    ),
  );

  // --- Ejemplo 2: Comunicación ---
  String americaPdf = await getPdfUrl('54634_LoQueAmericaLeDebeAEspana.pdf');
  all.add(
    Producto(
      title: "America debe a Espana",
      description:
          "Un análisis de la influencia cultural y social de España en América Latina.",
      image: AppImages.america,
      colors: [Colors.yellow],
      seller: "Tariqul Islam",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: americaPdf,
    ),
  );

  // --- Ejemplo 3: Ciencia Sociales ---
  String economiaPdf =
      await getPdfUrl('Clavito-y-el-xilófono-mágico_compressed.pdf');
  all.add(
    Producto(
      title: "Economia Digital",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.economia,
      colors: [Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: economiaPdf,
    ),
  );

  // --- Ejemplo 4: Historia ---
  String democraciaPdf = await getPdfUrl('cuentos-sobre-valores-salud.pdf');
  all.add(
    Producto(
      title: "Democracia Hoy",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.ciencia,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: democraciaPdf,
    ),
  );

  // --- Ejemplo 5: CTA ---
  String cienciaPdf = await getPdfUrl('la-psicologia-del-dinero-morgan-housel.pdf');
  all.add(
    Producto(
      title: "Avances Ciencia Moderna",
      description:
          "Un recorrido por los descubrimientos más importantes de la ciencia en el siglo XXI.",
      image: AppImages.ciencia,
      colors: [Colors.yellow],
      seller: "Dr. Julio Navarro",
      category: "CTA",
      review: "(280 reviews)",
      rate: 4.9,
      quantity: 1,
      pdfUrl: cienciaPdf,
    ),
  );

  // 🔹 Agrupar los productos
  agruparPorCategoria();
}

/// 🔹 AGRUPAR AUTOMÁTICAMENTE LOS PRODUCTOS POR CATEGORÍA
void agruparPorCategoria() {
  categorias.clear();

  for (var producto in all) {
    categorias.putIfAbsent(producto.category, () => []);
    categorias[producto.category]!.add(producto);
  }

  // 🔹 Agregar categoría "All" con todos los productos
  categorias["All"] = List.from(all);
}

/// 🔹 MODELO DE CATEGORÍA VISUAL
class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

/// 🔹 LISTA DE CATEGORÍAS VISIBLES EN LA UI
final List<Category> categoriasList = [
  Category(title: "All", image: AppImages.all),
  Category(title: "Matematica", image: AppImages.drama),
  Category(title: "Comunicacion", image: AppImages.historia),
  Category(title: "Ciencia", image: AppImages.politica),
  Category(title: "Historia", image: AppImages.economia),
  Category(title: "CTA", image: AppImages.ciencia),
];
