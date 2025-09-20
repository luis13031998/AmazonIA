import 'package:flutter/material.dart';
import 'package:spotifymusic_app/models/product_model.dart';

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

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    final librosEncontrados = _buscarLibrosLocales(query);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Libros encontrados"),
        content: SizedBox(
          height: 200,
          width: 300,
          child: librosEncontrados.isNotEmpty
              ? ListView.builder(
                  itemCount: librosEncontrados.length,
                  itemBuilder: (context, index) {
                    final libro = librosEncontrados[index];
                    return ListTile(
                      leading: Image.asset(libro.image, width: 40),
                      title: Text(libro.title),
                      subtitle: Text(libro.seller),
                    );
                  },
                )
              : const Center(
                  child: Text("No se encontraron libros."),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );

    setState(() => _isLoading = false);
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
              border: Border.all(
                width: 1,
                color: Colors.transparent,
              ),
              gradient: null,
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
      color: isDarkMode ? Colors.white : Colors.grey.shade800,
    ),
    onSubmitted: (_) => _search(),
    decoration: InputDecoration(
      hintText: "Buscar libros...",
      hintStyle: TextStyle(
        color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
        fontWeight: FontWeight.w600,
      ),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 15), // 🔥 centra verticalmente
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
