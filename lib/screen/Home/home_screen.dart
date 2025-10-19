import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/bloc/theme_cubit.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/models/book_detail_page.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Home/Widget/home_app_bar.dart';
import 'package:spotifymusic_app/screen/Home/Widget/image_slider.dart';
import 'package:spotifymusic_app/screen/Home/Widget/product_cart.dart';
import 'package:spotifymusic_app/screen/Home/Widget/search_bar.dart';

/// 🔹 Mapa de imágenes por categoría
final Map<String, String> categoryImages = {
  "All": AppImages.all,
  "Matematica": AppImages.drama,
  "Comunicacion": AppImages.historia,
  "Ciencia Sociales": AppImages.politica,
  "Historia": AppImages.economia,
  "CTA": AppImages.ciencia,
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  int selectedIndex = 0;
  bool isLoading = true;
  List<String> categoryNames = [];

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  /// 🔹 Cargar productos desde Firebase Storage
  Future<void> _loadAllProducts() async {
    await loadProducts();
    setState(() {
      categoryNames = ["All", ...categorias.keys.toList()];
      isLoading = false;
    });
  }

  /// 🔹 Obtener lista de productos según categoría
List<Producto> _getProductsByCategory(String category) {
  if (category == "All") {
    // ✅ Devuelve directamente la lista 'all' sin duplicados
    return all;
  }
  return categorias[category] ?? [];
}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final backgroundColor =
            themeMode == ThemeMode.dark ? Colors.black : Colors.white;
        final textColor =
            themeMode == ThemeMode.dark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 233, 191, 64)),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),
                        const CustomAppBar(),
                        const SizedBox(height: 20),
                        const MySearchBAR(),
                        const SizedBox(height: 20),

                        /// 🔹 SLIDER DE IMÁGENES
                        ImageSlider(
                          currentSlide: currentSlider,
                          onChange: (value) {
                            setState(() => currentSlider = value);
                          },
                        ),
                        const SizedBox(height: 20),

                        /// 🔹 LISTA DE CATEGORÍAS
                        SizedBox(
                          height: 120,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  List.generate(categoryNames.length, (index) {
                                final category = categoryNames[index];
                                final image =
                                    categoryImages[category] ?? AppImages.all;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    padding: const EdgeInsets.all(8),
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: selectedIndex == index
                                          ? const Color.fromARGB(
                                              255, 228, 131, 12)
                                          : Colors.transparent,
                                      boxShadow: selectedIndex == index
                                          ? [
                                              BoxShadow(
                                                color: Colors.greenAccent
                                                    .withOpacity(0.4),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: selectedIndex == index
                                                  ? Colors.white
                                                  : Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            image: DecorationImage(
                                              image: AssetImage(image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          category,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        /// 🔹 TÍTULO DE SECCIÓN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Libros de ${categoryNames[selectedIndex]}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            Text(
                              "Ver todo",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: themeMode == ThemeMode.dark
                                    ? Colors.grey[300]
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        /// 🔹 GRID DE PRODUCTOS
                        Builder(
                          builder: (context) {
                            final selectedCategory =
                                categoryNames[selectedIndex];
                            final productos =
                                _getProductsByCategory(selectedCategory);

                            if (productos.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "No hay libros disponibles en esta categoría.",
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }

                            return GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.78,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                final producto = productos[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (producto.pdfUrl.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "El PDF no está disponible.")));
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BookDetailPage(libro: producto),
                                      ),
                                    );
                                  },
                                  child: ProductCart(producto: producto),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
