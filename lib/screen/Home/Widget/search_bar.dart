import 'package:flutter/material.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Detail/detail_screen.dart';

class MySearchBAR extends StatefulWidget {
  const MySearchBAR({super.key});

  @override
  State<MySearchBAR> createState() => _MySearchBARState();
}

class _MySearchBARState extends State<MySearchBAR>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// 🔎 Busca libros en la lista local `all`
  List<Producto> _buscarLibrosLocales(String query) {
    return all
        .where((producto) =>
            producto.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// 🔹 Función de búsqueda y mostrar resultados
  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    final librosEncontrados = _buscarLibrosLocales(query);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔸 Título
                Row(
                  children: [
                    const Icon(Icons.menu_book_rounded,
                        color: Color(0xFFF1720A), size: 28),
                    const SizedBox(width: 8),
                    Text(
                      "Resultados de búsqueda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF222222),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close_rounded),
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 📚 Resultados
                librosEncontrados.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            const Icon(Icons.search_off_rounded,
                                size: 60, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text(
                              "No se encontraron libros.",
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: librosEncontrados.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 220,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final libro = librosEncontrados[index];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[850]
                                    : const Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.pop(dialogContext);
                                  _navigateToDetail(context, libro);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                      child: Image.asset(
                                        libro.image,
                                        height: 130,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            libro.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            libro.seller,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isDarkMode
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded,
                                                  size: 16,
                                                  color: Color(0xFFF1720A)),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${libro.rate}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: isDarkMode
                                                      ? Colors.grey[300]
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );

    setState(() => _isLoading = false);
  }

  /// 🔹 Navegación a pantalla de detalle con animación fade + slide
  void _navigateToDetail(BuildContext context, Producto libro) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailScreen(producto: libro),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );

          final fade = Tween<double>(begin: 0, end: 1).animate(animation);

          return SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: isDarkMode ? Colors.black : Colors.white,
              border: Border.all(width: 1, color: Colors.transparent),
            ),
            child: CustomPaint(
              painter: _ModernRGBBorderPainter(
                animationValue: _animationController.value,
                borderRadius: 30,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color:
                            isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                    const SizedBox(width: 22),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode
                              ? Colors.white
                              : Colors.grey.shade800,
                        ),
                        onSubmitted: (_) => _search(),
                        decoration: InputDecoration(
                          hintText: "Buscar libros...",
                          hintStyle: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[500]
                                : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 20,
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                            onPressed: _search,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 🎨 Borde RGB moderno animado
class _ModernRGBBorderPainter extends CustomPainter {
  final double animationValue;
  final double borderRadius;

  _ModernRGBBorderPainter({
    required this.animationValue,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 6.28319,
      transform: GradientRotation(animationValue * 6.28319),
      colors: const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.cyan,
        Colors.blue,
        Colors.purple,
        Colors.red,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rrect = RRect.fromRectAndRadius(
      rect.deflate(1.5),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _ModernRGBBorderPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
