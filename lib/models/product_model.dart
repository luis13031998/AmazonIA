import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';

/// 🔹 MODELO DE PRODUCTO (LIBRO)
class Producto {
  final String id; 
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
  int totalDownloads; // el id real del documento en Firestore
// 👈 Nuevo campo

  Producto({
    required this.id,
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
    this.totalDownloads = 0, // valor inicial
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
  // --- Ejemplo 2: Matemática ---
  String laTriseccion = await getPdfUrl('La_triseccion_del_angulo.pdf');
  all.add(
    Producto(
      id: "la_triseccion_del_angulo",
      title: "La triseccion del angulo",
      description:
          "El problema de la trisección del ángulo se aborda en varios libros de matemáticas, especialmente en el contexto de la imposibilidad de resolverlo usando solo regla y compás.",
      image: AppImages.latrisecion,
      colors: [Colors.yellow],
      seller: "Patricio del Rio",
      category: "Matematica",
      review: "(320 reviews)",
      rate: 3.8,
      quantity: 1,
      pdfUrl: laTriseccion,
    ),
  );

  // --- Ejemplo 2: Comunicación ---
  String americaPdf = await getPdfUrl('54634_LoQueAmericaLeDebeAEspana.pdf');
  all.add(
    Producto(
      id: "54634_LoQueAmericaLeDebeAEspana",
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
  // --- Libro Comunicación #2 ---
  String diccionariopdf = await getPdfUrl('2700_voces_que_hacen_falta_en_el_diccionario.pdf');
  all.add(
    Producto(
      id: "2700_voces_que_hacen_falta_en_el_diccionario",
      title: "2700 voces que hacen falta en el diccionario",
      description:
          "Su valor radica en el registro de la lengua coloquial, regional o emergente del siglo XIX/XX en el Perú y América Latina, lo que lo convierte en referencia para estudios de lingüística histórica o lexicografía americana.",
      image: AppImages.voces,
      colors: [Colors.yellow],
      seller: "Ricardo Palma",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: diccionariopdf,
    ),
  );
  // --- Libro Comunicación #3 ---
  String razonyFe = await getPdfUrl('De_la_razon_y_la_fe.pdf');
  all.add(
    Producto(
      id: "De_la_razon_y_la_fe",
      title: "De la razon y la fe",
      description:
          "La perfeccion de un ser consiste no solo en la exacta sujecion á las leyes de su naturaleza, sino tambien en la superioridad o elevacion de sus cualidades.",
      image: AppImages.razon,
      colors: [Colors.yellow],
      seller: "Justo David Salas",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: razonyFe,
    ),
  );
  // --- Libro Comunicación #4 ---
  String cachivaches = await getPdfUrl('Cachivaches.pdf');
  all.add(
    Producto(
      id: "cachivaches",
      title: "Cachivaches",
      description:
          "Un análisis de la influencia cultural y social de España en América Latina.",
      image: AppImages.cachivaches,
      colors: [Colors.yellow],
      seller: "Ricardo Palma",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: cachivaches,
    ),
  );
  // --- Libro Comunicación #5 ---
  String demonioAndes = await getPdfUrl('El_demonio_de_los_andes.pdf');
  all.add(
    Producto(
      id: "El_demonio_de_los_andes",
      title: "El demonio de los andes",
      description:
          "Un análisis de la influencia cultural y social de España en América Latina.",
      image: AppImages.demonioandes,
      colors: [Colors.yellow],
      seller: "Tariqul Islam",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: demonioAndes,
    ),
  );
  // --- Libro Comunicación #6 ---
  String hechicera = await getPdfUrl('La_hechicera.pdf');
  all.add(
    Producto(
      id: "La_hechicera",
      title: "La hechicera",
      description:
          "Un análisis de la influencia cultural y social de España en América Latina.",
      image: AppImages.hechicera,
      colors: [Colors.yellow],
      seller: "Tariqul Islam",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: hechicera,
    ),
  );
  // --- Libro Comunicación #7 ---
  String pinzonada = await getPdfUrl('La_pinzonada.pdf');
  all.add(
    Producto(
      id: "La_pinzonada",
      title: "La pinzonada",
      description:
          "Un análisis de la influencia cultural y social de España en América Latina.",
      image: AppImages.pinzonada,
      colors: [Colors.yellow],
      seller: "Tariqul Islam",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: pinzonada,
    ),
  );
  // --- Libro Comunicación #8 ---
  String recluta = await getPdfUrl('La_vuelta_del_recluta.pdf');
  all.add(
    Producto(
      id: "La_vuelta_del_recluta",
      title: "La vuelta del recluta",
      description:
          "Un análisis de la influencia cultural y social de España en América Latina.",
      image: AppImages.recluta,
      colors: [Colors.yellow],
      seller: "Tariqul Islam",
      category: "Comunicacion",
      review: "(220 reviews)",
      rate: 4.6,
      quantity: 1,
      pdfUrl: recluta,
    ),
  );
  // --- Ejemplo 1: Matemática ---
  String romeoPdf = await getPdfUrl('RomeoYJulieta.pdf');
  all.add(
    Producto(
      id: "RomeoYJulieta",
      title: "Romeo y Julieta",
      description:
          "El libro 'Romeo y Julieta' es una de las obras más famosas de William Shakespeare y trata sobre una trágica historia de amor entre dos jóvenes pertenecientes a familias rivales.",
      image: AppImages.romeo,
      colors: [Colors.yellow],
      seller: "Shakespeare",
      category: "Comunicacion",
      review: "(320 reviews)",
      rate: 4.8,
      quantity: 1,
      pdfUrl: romeoPdf,
    ),
  );

  // --- Ejemplo 3: Ciencia Sociales ---
  String economiaPdf =
      await getPdfUrl('Clavito-y-el-xilófono-mágico_compressed.pdf');
  all.add(
    Producto(
      id: "Clavito-y-el-xilófono-mágico_compressed",
      title: "Economia Digital",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.economiaa,
      colors: [Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: economiaPdf,
    ),
  );
  // --- Libro Ciencia #2 ---
  String anatomiapdf =
      await getPdfUrl('Anatomia_Nacional.pdf');
  all.add(
    Producto(
      id: "Anatomia_Nacional",
      title: "Anatomia Nacional",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.anatomia,
      colors: [Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: anatomiapdf,
    ),
  );
  // --- Libro Ciencia #3 ---
  String aneurismapdf =
      await getPdfUrl('Curacion_de_un_Aneurisma_Traumatico.pdf');
  all.add(
    Producto(
      id: "Curacion_de_un_Aneurisma_Traumatico",
      title: "Curación de un aneurisma traumatico",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.curacion,
      colors: [Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: aneurismapdf,
    ),
  );
  // --- Libro Ciencia #4 ---
  String navegacionpdf =
      await getPdfUrl('Estudios_Generales_sobre_la_navegacion_Aerea.pdf');
  all.add(
    Producto(
      id: "Estudios_Generales_sobre_la_navegacion_Aerea",
      title: "Estudios generales sobre la navegación aerea",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.estudios,
      colors: [Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: navegacionpdf,
    ),
  );
  // --- Libro Ciencia #5 ---
  String reflexionespdf =
      await getPdfUrl('Ligeras_Reflexiones_sobre_la_embriaguez.pdf');
  all.add(
    Producto(
      id: "Ligeras_Reflexiones_sobre_la_embriaguez",
      title: "Ligeras reflexiones sobre la embriaguez",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.embriago,
      colors: [Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: reflexionespdf,
    ),
  );
  // --- Libro Ciencia #6 ---
  String nitratepdf =
      await getPdfUrl('Nitrate_of_Soda.pdf');
  all.add(
    Producto(
      id: "Nitrate_of_Soda",
      title: "Nitrate of Soda",
      description:
          "Un libro que explica cómo la tecnología está transformando los modelos económicos tradicionales.",
      image: AppImages.nitrate,
      colors: [Colors.yellow],
      seller: "Carlos Mendoza",
      category: "Ciencia",
      review: "(150 reviews)",
      rate: 4.5,
      quantity: 1,
      pdfUrl: nitratepdf,
    ),
  );

  // --- Ejemplo 4: Historia ---
  String democraciaPdf = await getPdfUrl('cuentos-sobre-valores-salud.pdf');
  all.add(
    Producto(
      id: "cuentos-sobre-valores-salud",
      title: "Democracia Hoy",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.democracia,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: democraciaPdf,
    ),
  );
  // --- Libro Historia #2 ---
  String abusosPdf = await getPdfUrl('Abusos_que_se_observaron_en_la_Callana.pdf');
  all.add(
    Producto(
      id: "Abusos_que_se_observaron_en_la_Callana",
      title: "Abusos que se observaron en la callana",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.ciencia,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: abusosPdf,
    ),
  );
  // --- Libro Historia #3 ---
  String antiguoPdf = await getPdfUrl('Antiguo_Peru.pdf');
  all.add(
    Producto(
      id: "Antiguo_Peru",
      title: "Antiguo Perú",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.antiguo,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: antiguoPdf,
    ),
  );
  // --- Libro Historia #4 ---
  String antropologiaPdf = await getPdfUrl('Antropologia_y_Sociologia_de_las_Razas_Interandinas.pdf');
  all.add(
    Producto(
      id: "Antropologia_y_Sociologia_de_las_Razas_Interandinas",
      title: "Antropologia y Sociologia de las Razas Interandinas",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.antropologia,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: antropologiaPdf,
    ),
  );
  // --- Libro Historia #5 ---
  String comercioPdf = await getPdfUrl('Comercio_Especial_del_Peru.pdf');
  all.add(
    Producto(
      id: "Comercio_Especial_del_Peru",
      title: "Comercio especial del Perú",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.comercio,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: comercioPdf,
    ),
  );
  // --- Libro Historia #6 ---
  String alfabetizadorPdf = await getPdfUrl('El_alfabetizador_del_Indio.pdf');
  all.add(
    Producto(
      id: "El_alfabetizador_del_Indio",
      title: "El alfabetizador del indio",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.alfabetizador,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: alfabetizadorPdf,
    ),
  );
  // --- Libro Historia #6 ---
  String principioPdf = await getPdfUrl('El_principio_de_la_Conquista_en_America.pdf');
  all.add(
    Producto(
      id: "El_principio_de_la_Conquista_en_America",
      title: "El principio de la conquista en america",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.conquista,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: principioPdf,
    ),
  );
  // --- Libro Historia #7 ---
  String emancipaciondf = await getPdfUrl('emancipacion_del_Indio.pdf');
  all.add(
    Producto(
      id: "emancipacion_del_Indio",
      title: "Emancipación del indio",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.emancipacion,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: emancipaciondf,
    ),
  );
  // --- Libro Historia #8 ---
  String beneficienciapdf = await getPdfUrl('Estatuto_de_la_beneficiencia_China.pdf');
  all.add(
    Producto(
      id: "Estatuto_de_la_beneficiencia_China",
      title: "Estatuto de la beneficiencia china",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.estatuto,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: beneficienciapdf,
    ),
  );
  // --- Libro Historia #9 ---
  String inmigracionpdf = await getPdfUrl('inmigracion_de_Chinos.pdf');
  all.add(
    Producto(
      id: "inmigracion_de_Chinos",
      title: "Inmigración de chinos",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.inmigracion,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: inmigracionpdf,
    ),
  );
  // --- Libro Historia #10 ---
  String cosmografiapdf = await getPdfUrl('La_cosmografia_de_Pedro_Apiano.pdf');
  all.add(
    Producto(
      id: "La_cosmografia_de_Pedro_Apiano",
      title: "La cosmografia de Pedro Apiano",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.ecografia,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: cosmografiapdf,
    ),
  );
  // --- Libro Historia #11 ---
  String museopdf = await getPdfUrl('Museo_de_Historia_Nacional.pdf');
  all.add(
    Producto(
      id: "Museo_de_Historia_Nacional",
      title: "Museo de historia nacional",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.museo,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: museopdf,
    ),
  );
  // --- Libro Historia #12 ---
  String sistemapdf = await getPdfUrl('Nuevo_Sistema_de_Volar_Por_Los Aires.pdf');
  all.add(
    Producto(
      id: "Nuevo_Sistema_de_Volar_Por_Los Aires",
      title: "Nuevo sistema de volar por los aires",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.volaraires,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: sistemapdf,
    ),
  );
  // --- Libro Historia #13 ---
  String stpdf = await getPdfUrl('ST.pdf');
  all.add(
    Producto(
      id: "ST",
      title: "St",
      description:
          "Una reflexión sobre los retos y transformaciones de los sistemas democráticos actuales.",
      image: AppImages.librost,
      colors: [Colors.yellow],
      seller: "Laura Pérez",
      category: "Historia",
      review: "(175 reviews)",
      rate: 4.4,
      quantity: 1,
      pdfUrl: stpdf,
    ),
  );


  // --- Ejemplo 5: CTA ---
  String cienciaPdf = await getPdfUrl('la-psicologia-del-dinero-morgan-housel.pdf');
  all.add(
    Producto(
      id: "la-psicologia-del-dinero-morgan-housel",
      title: "Avances Ciencia Moderna",
      description:
          "Un recorrido por los descubrimientos más importantes de la ciencia en el siglo XXI.",
      image: AppImages.avances,
      colors: [Colors.yellow],
      seller: "Dr. Julio Navarro",
      category: "CTA",
      review: "(280 reviews)",
      rate: 4.9,
      quantity: 1,
      pdfUrl: cienciaPdf,
    ),
  );
  // --- Libro CTA 2 ---
  String antiguedadesPdf = await getPdfUrl('Antiguedades_peruanas.pdf');
  all.add(
    Producto(
      id: "Antiguedades_peruanas",
      title: "Antiguedades peruanas",
      description:
          "Un recorrido por los descubrimientos más importantes de la ciencia en el siglo XXI.",
      image: AppImages.antiguedades,
      colors: [Colors.yellow],
      seller: "Dr. Julio Navarro",
      category: "CTA",
      review: "(280 reviews)",
      rate: 4.9,
      quantity: 1,
      pdfUrl: antiguedadesPdf,
    ),
  );
  // --- Libro CTA 3 ---
  String filosofiaPdf = await getPdfUrl('Filosofia_y_arte.pdf');
  all.add(
    Producto(
      id: "Filosofia_y_arte",
      title: "Filosofia y arte",
      description:
          "Un recorrido por los descubrimientos más importantes de la ciencia en el siglo XXI.",
      image: AppImages.filosofia,
      colors: [Colors.yellow],
      seller: "Dr. Julio Navarro",
      category: "CTA",
      review: "(280 reviews)",
      rate: 4.9,
      quantity: 1,
      pdfUrl: filosofiaPdf,
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
