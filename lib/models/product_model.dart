import 'package:flutter/material.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';

class Producto{
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

  Producto(
    {required this.title,
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
    }
  );
}

final List<Producto> all = [
  Producto(
    title: "Romeo y Julieta", 
    description: "El libro 'Romeo y Julieta' es una de las obras más famosas de William Shakespeare y trata sobre una trágica historia de amor entre dos jóvenes pertenecientes a familias rivales.", 
    image: AppImages.Romeo, 
    colors: [
      Colors.yellow,
      Colors.yellow,
      Colors.yellow,
    ], 
    seller: "Shakespare", 
    category: "Drama", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "https://drive.google.com/uc?export=download&id=1_JTGLVZ70p0hmgkdq_qSZhY7NkuAVmBW",
    ),

  Producto(
    title: "Lo que America debe a españa", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.america, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Historia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),

     Producto(
    title: "La psicologia del dinero", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.psico, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Economia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),

     Producto(
    title: "El dinero de la democracia", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.dinero, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Politica", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),

    Producto(
    title: "El principito", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.principito, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Drama", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),

    Producto(
    title: "Alas de onix", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.alasdeonix, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Rebecca Yarros", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Escalera interior", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.escalerainterior, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Almudena Grandes", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Bitacora experimental de viajes en el tiempo", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.bitacoraexperimental, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Kims Theory", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Clavito y el xilofono magico", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.clavito, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Andrea y Claudia paz", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Cuentos con valores", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.cuantosconvalores, 
    
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Rosa Maria Cifuentes", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Destroza este diario", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.destrozaestediario, 
    
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Keri Smith", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Cosas olvidadas", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.albumdelascosas, 
    
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Enrique Plamas", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "El mundo maquiavelo", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.mundomaquiavelico, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Alan Garcia", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "En el umbral de lo desconocido", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.humbraldelodesconocido, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Carmen Mc Evoy", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "El tunel", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.eltunel, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Ernesto Sabato", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Fabulas de esopo", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.fabulasdeesopo, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Planeta junior", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Kafka en la orilla", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.kafkaenlaorilla, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Haruki Murakami", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "La generacaión ansiosa", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.lageneracion, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Jonathan Haidt", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "La revolución que cambiara todo", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.larevolucion, 
   
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Inteligencia articial", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "La dictadura de la minoria", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.ladictadura, 
    
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Steven levitsky y Daniel ziblat", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "La isla de iros", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.laislasdeoro, 
   
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "L. M. Bracklow", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Memorias de un tremendo cañonazo", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.memoriadeuntremendo, 
    
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Rulito Pinasco", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Mi amigo capibara", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.miamigocapibara, 
     
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Capibara", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Culpa", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.culpa, 
    
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Olga Montero Rose", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Victoria", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.victoria, 
    
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Paloma Sanchez", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Perú: Pais sostenible", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.perupaissostenible, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Jesus Salazar Nishi", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Peruanos ejemplares del siglo xx", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.peruanosejemplares, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Pedro Cateriano Bellido", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Quien teme al genero?", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.quientemealgenero, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Judith Butler", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "RolexGate", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.rolexgate, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Ernesto Cabral", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Tea Shop", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.teashop, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Bruno Pinasco", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
    Producto(
    title: "Todos los lugares que mantuvimos en secreto", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.todosloslugares, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Inma Rubiales", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
];

final List<Producto> drama = [
  Producto(
    title: "Romeo y Julieta", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.Romeo, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Drama", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),

    Producto(
    title: "El principito", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.principito, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Drama", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
];

final List<Producto> historia = [

  Producto(
    title: "Lo que America debe a españa", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.america, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Historia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
];

final List<Producto> economia = [

     Producto(
    title: "La psicologia del dinero", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.psico, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Economia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
];

final List<Producto> politica = [
  
     Producto(
    title: "El dinero de la democracia", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.dinero, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Politica", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
];

final List<Producto> ciencia = [
  
    Producto(
    title: "Inteligencia artificial", 
    description: "Lorem ipsum dolor sir amet, consecturkaadakda, kjae,asdas, temasld", 
    image: AppImages.inteligenciaIA, 
    colors: [
      Colors.black,
      Colors.blue,
      Colors.orange,
    ], 
    seller: "Tariqul isalm", 
    category: "Ciencia", 
    review: "(320 reviews)",
    rate: 4.8, 
    quantity: 1,
    pdfUrl: "",
    ),
];