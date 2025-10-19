import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  });
}

/// 🔹 FUNCIÓN PARA OBTENER URL DE ARCHIVO PDF DESDE FIREBASE STORAGE
Future<String> getPdfUrl(String fileName) async {
  try {
    final ref = FirebaseStorage.instance.ref().child('libros/$fileName');
    return await ref.getDownloadURL();
  } catch (e) {
    print('⚠️ Error obteniendo PDF $fileName: $e');
    return ''; // Devuelve vacío si hay error
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
      colors: [Colors.yellow, Colors.yellow, Colors.yellow],
      seller: "Shakespeare",
      category: "Matematica",
      review: "(320 reviews)",
      rate: 4.8,
      quantity: 1,
      pdfUrl: romeoPdf,
    ),
  );

  // --- Ejemplo 2: Comunicación ---
  String americaPdf = await getPdfUrl('AmericaDebeAEspana.pdf');
  all.add(
    Producto(
      title: "Lo que América debe a España",
      description:
          "Un análisis de la influencia cultural y social de España en América Latina.",
      image: AppImages.america,
      colors: [Colors.yellow, Colors.yellow, Colors.yellow],
      seller: "Tariqul Islam",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: americaPdf,
    ),
  );

  // --- Ejemplo 3: Ciencia Sociales ---
  String economiaPdf = await getPdfUrl('EconomiaDigital.pdf');
  all.add(
    Producto(
      title: "Economía Digital",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.economia,
      colors: [Colors.yellow, Colors.yellow, Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: economiaPdf,
    ),
  );

  // --- Ejemplo 4: Historia ---
  String democraciaPdf = await getPdfUrl('DemocraciaHoy.pdf');
  all.add(
    Producto(
      title: "Democracia Hoy",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.ciencia,
      colors: [Colors.yellow, Colors.yellow, Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: democraciaPdf,
    ),
  );

  // --- Ejemplo 5: CTA ---
  String cienciaPdf = await getPdfUrl('AvancesCiencia.pdf');
  all.add(
    Producto(
      title: "Avances de la Ciencia Moderna",
      description:
          "Un recorrido por los descubrimientos más importantes de la ciencia en el siglo XXI.",
      image: AppImages.ciencia,
      colors: [Colors.yellow, Colors.yellow, Colors.yellow],
      seller: "Dr. Julio Navarro",
      category: "CTA",
      review: "(280 reviews)",
      rate: 4.9,
      quantity: 1,
      pdfUrl: cienciaPdf,
    ),
  );

  // 🔹 Llamar a la función de agrupamiento después de cargar
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
