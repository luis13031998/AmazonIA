import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:spotifymusic_app/Presentacion/authentication/pages/signup_or_signin.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/bloc/theme_cubit.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
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
  bool loadingUser = true;

  String userName = "";
  String userPhotoUrl = ""; // ✅ NECESARIO PARA MOSTRAR LA FOTO

  // ======================================================
  // 🔥 Cargar nombre + foto del usuario desde Firestore
  // ======================================================
  Future<void> _loadUserName() async {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (!mounted) return; // ←🔥 Evita el error

      if (doc.exists) {
        setState(() {
          userName = doc["fullName"] ?? "Usuario";
          userPhotoUrl = doc["photoUrl"] ?? "";
        });
      }
    }
  } catch (e) {
    print("Error cargando usuario: $e");
  }

  if (!mounted) return; // ←🔥 También aquí
  setState(() => loadingUser = false);
}


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

    _loadUserName(); // <-- carga nombre y foto

    _loadCategoriesAndProducts();

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
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
      displayedProducts.clear();
    });

    final selectedCategory = categoryNames[index];
    final products = _getProductsByCategory(selectedCategory);

    _categoryAnimController.reset();
    _gridAnimController.reset();
    _categoryAnimController.forward();

    for (var i = 0; i < products.length; i += 6) {
      await Future.delayed(const Duration(milliseconds: 80));
      setState(() {
        displayedProducts.addAll(products.skip(i).take(6));
      });
    }

    _gridAnimController.forward();
    setState(() => isLoading = false);
  }

  // ======================================================
  // 🔥 Cerrar Sesión
  // ======================================================
  void _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cerrar sesión"),
          content: const Text("¿Estás seguro que deseas cerrar sesión?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 65, 30, 191)
                    : const Color.fromARGB(255, 240, 127, 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Salir"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignupOrSigninPage()),
        (route) => false,
      );
    }
  }

  void _showNotifications(BuildContext context) {
  final provider = CartProvider.of(context, listen: false);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ==> Barra superior estilo iOS
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),

                // ==> Título elegante
                const Text(
                  "Notificaciones 🔔",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, provider, _) {
                      if (provider.notifications.isEmpty) {
                        return const Center(
                          child: Text(
                            "No tienes notificaciones",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: provider.notifications.length,
                        itemBuilder: (context, index) {
                          final mensaje = provider.notifications[index];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey[900]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Avatar ícono
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.deepPurple
                                        : Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.notifications_active,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Texto del mensaje
                                Expanded(
                                  child: Text(
                                    mensaje,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 5),

                                // Botón eliminar
                                GestureDetector(
                                  onTap: () =>
                                      provider.removeNotificationAt(index),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.redAccent,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  // ======================================================
  // 🔥 UI
  // ======================================================
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final backgroundColor = themeMode == ThemeMode.dark
            ? Colors.black
            : const Color.fromARGB(255, 223, 218, 218);

        final textColor =
            themeMode == ThemeMode.dark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: AnimatedScale(
            scale: _showFloatingButton ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: FloatingActionButton(
              heroTag: "scrollToTopFAB",
              onPressed: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              ),
              backgroundColor: themeMode == ThemeMode.dark
                  ? const Color.fromARGB(255, 65, 30, 191)
                  : Colors.orange,
              child: const Icon(Icons.arrow_upward),
            ),
          ),
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: _appBarElevation,
                expandedHeight: 160,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: loadingUser
                      ? const Text("Cargando...",
                          style: TextStyle(color: Colors.white))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: userPhotoUrl.isNotEmpty
                                  ? NetworkImage(userPhotoUrl)
                                  : const AssetImage("assets/images/perfilnino.png")
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Bienvenido\n$userName",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageSlider(
                        currentSlide: currentSlider,
                        onChange: (value) =>
                            setState(() => currentSlider = value),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: themeMode == ThemeMode.dark
                                ? [
                                    const Color.fromARGB(255, 65, 30, 191),
                                    Colors.transparent
                                  ]
                                : [
                                    const Color.fromARGB(0, 229, 156, 55),
                                    Colors.transparent
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Consumer<CartProvider>(
                    builder: (context, provider, _) {
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications,
                                color: Colors.white),
                            onPressed: () => _showNotifications(context),
                          ),
                          if (provider.notifications.isNotEmpty)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                                child: Text(
                                  '${provider.notifications.length}',
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _cerrarSesion,
                  ),
                  Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (_) =>
                        context.read<ThemeCubit>().toggleTheme(),
                  ),
                ],
              ),

              // ======================================================
              // 🔥 CONTENIDO PRINCIPAL
              // ======================================================

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MySearchBAR(),
                      const SizedBox(height: 20),
                      Text(
                        "Explora tus libros favoritos 📚",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ---- CATEGORÍAS ----
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryNames.length,
                          itemBuilder: (context, index) {
                            final category = categoryNames[index];
                            final image =
                                categoryImages[category] ?? AppImages.all;

                            return GestureDetector(
                              onTap: () => _onCategorySelected(index),
                              child: AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 200),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: 95,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: selectedIndex == index
                                      ? (themeMode == ThemeMode.dark
                                          ? const Color.fromARGB(
                                              255, 81, 51, 189)
                                          : Colors.orange)
                                      : (themeMode == ThemeMode.dark
                                          ? Colors.grey[800]
                                          : const Color.fromARGB(
                                              255, 205, 202, 202)),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage: AssetImage(image),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      category,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.78,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                              ),
                              itemCount: displayedProducts.length,
                              itemBuilder: (context, index) {
                                final producto = displayedProducts[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookDetailPage(libro: producto),
                                    ),
                                  ),
                                  child:
                                      ProductCart(producto: producto),
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
