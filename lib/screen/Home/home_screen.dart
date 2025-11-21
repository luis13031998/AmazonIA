import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/bloc/theme_cubit.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/models/book_detail_page.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Home/Widget/image_slider.dart';
import 'package:spotifymusic_app/screen/Home/Widget/product_cart.dart';
import 'package:spotifymusic_app/screen/Home/Widget/search_bar.dart';

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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentSlider = 0;
  int selectedIndex = 0;
  bool isLoading = true;

  List<String> categoryNames = [];
  List<Producto> displayedProducts = [];

  final ScrollController _scrollController = ScrollController();
  double _appBarElevation = 0;
  bool _showFloatingButton = false;

  late AnimationController _categoryAnimController;
  late AnimationController _gridAnimController;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndProducts();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      setState(() {
        _appBarElevation = offset > 5 ? 5 : offset;
        _showFloatingButton = offset > 300;
      });
    });

    _categoryAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _gridAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _categoryAnimController.dispose();
    _gridAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadCategoriesAndProducts() async {
    await loadProducts();
    setState(() {
      categoryNames = ["All", ...categorias.keys.toList()];
      displayedProducts = all.take(10).toList();
      isLoading = false;
    });

    _categoryAnimController.forward();
    _gridAnimController.forward();
  }

  List<Producto> _getProductsByCategory(String category) {
    if (category == "All") return all;
    return categorias[category] ?? [];
  }

  Future<void> _onCategorySelected(int index) async {
    setState(() {
      selectedIndex = index;
      isLoading = true;
      displayedProducts = [];
    });

    final selectedCategory = categoryNames[index];
    final products = _getProductsByCategory(selectedCategory);

    _categoryAnimController.reset();
    _gridAnimController.reset();
    _categoryAnimController.forward();

    for (var i = 0; i < products.length; i += 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        displayedProducts.addAll(products.skip(i).take(10));
      });
    }

    _gridAnimController.forward();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final backgroundColor = themeMode == ThemeMode.dark
            ? Colors.black
            : const Color.fromARGB(255, 223, 218, 218);
        final textColor = themeMode == ThemeMode.dark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: AnimatedScale(
            scale: _showFloatingButton ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: FloatingActionButton(
              heroTag: "scrollToTopFAB", // ✅ tag único para evitar errores
              onPressed: () => _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut),
              backgroundColor: Colors.orange,
              child: const Icon(Icons.arrow_upward),
            ),
          ),
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: _appBarElevation,
                backgroundColor: Colors.transparent,
                expandedHeight: 160,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 10),
                  title: Text(
                    "IEE ROSA DE SANTA MARIA",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                        )
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageSlider(
                        currentSlide: currentSlider,
                        onChange: (value) => setState(() => currentSlider = value),
                      ),
                      Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: themeMode == ThemeMode.dark
          ? [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.1)]
          : [Colors.orange.withOpacity(0.3), Colors.orange.withOpacity(0.1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: const BorderRadius.vertical(
      bottom: Radius.circular(25),
    ),
  ),
),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(color: Colors.black.withOpacity(0.05)),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {},
                  ),
                  Switch(
                    value: themeMode == ThemeMode.dark,
                    activeColor: Colors.yellow,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.white54,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                  IconButton(
  icon: const Icon(Icons.logout, color: Colors.white, size: 28),
  tooltip: 'Cerrar sesión',
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: false, // Para que no se cierre tocando fuera
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: const [
            Icon(Icons.exit_to_app, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Salir de la aplicación"),
          ],
        ),
        content: const Text(
          "¿Estás seguro que deseas salir de Rosa-IA?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => exit(0),
            child: const Text("Salir"),
          ),
        ],
      ),
    );
  },
),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MySearchBAR(),
                      const SizedBox(height: 20),
                      Text(
                        "Explora tus libros favoritos 📚",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Selecciona una categoría para comenzar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: themeMode == ThemeMode.dark
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Categorías
                      SizedBox(
                        height: 120,
                        child: AnimatedBuilder(
                          animation: _categoryAnimController,
                          builder: (context, child) => Opacity(
                            opacity: _categoryAnimController.value,
                            child: Transform.translate(
                              offset: Offset(0, 50 * (1 - _categoryAnimController.value)),
                              child: child,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryNames.length,
                                itemBuilder: (context, index) {
                                  final category = categoryNames[index];
                                  final image = categoryImages[category] ?? AppImages.all;

                                  return GestureDetector(
                                    onTap: () => _onCategorySelected(index),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(horizontal: 8),
                                      padding: const EdgeInsets.all(8),
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: selectedIndex == index
                                            ? Colors.orange.withOpacity(0.9)
                                            : Colors.white.withOpacity(0.2),
                                        boxShadow: selectedIndex == index
                                            ? [
                                                BoxShadow(
                                                  color: Colors.orange.withOpacity(0.4),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      Text(
                        "Libros de ${categoryNames.isNotEmpty ? categoryNames[selectedIndex] : ''}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Explora los mejores títulos en esta categoría",
                        style: TextStyle(
                          fontSize: 15,
                          color: themeMode == ThemeMode.dark
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Grid de productos
                      isLoading && displayedProducts.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 233, 191, 64),
                              ),
                            )
                          : displayedProducts.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "No hay libros disponibles en esta categoría.",
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.78,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: displayedProducts.length,
                                  itemBuilder: (context, index) {
                                    final producto = displayedProducts[index];

                                    return AnimatedBuilder(
                                      animation: _gridAnimController,
                                      builder: (context, child) {
                                        double animationValue =
                                            (_gridAnimController.value - index * 0.0)
                                                .clamp(0.0, 1.0);

                                        return Opacity(
                                          opacity: animationValue,
                                          child: Transform.translate(
                                            offset: Offset(0, 50 * (1 - animationValue)),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          if (producto.pdfUrl.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text("El PDF no está disponible."),
                                            ));
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
                                      ),
                                    );
                                  },
                                ),
                    ],
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
