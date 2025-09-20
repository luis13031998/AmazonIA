import 'package:flutter/material.dart';
import 'package:spotifymusic_app/IAllamaService.dart';
import 'package:spotifymusic_app/models/product_model.dart'; // Assuming `all` and `Producto` are defined here

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
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<Producto> _buscarLibrosLocales(String query) {
    return all
        .where((producto) =>
            producto.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _searchWithAI() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final librosEncontrados = _buscarLibrosLocales(query);

    if (librosEncontrados.isNotEmpty) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Libros encontrados"),
          content: SizedBox(
            height: 200,
            width: 300,
            child: ListView.builder(
              itemCount: librosEncontrados.length,
              itemBuilder: (context, index) {
                final libro = librosEncontrados[index];
                return ListTile(
                  leading: Image.asset(libro.image, width: 40),
                  title: Text(libro.title),
                  subtitle: Text(libro.seller),
                );
              },
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
    }

    try {
      final result = await LlamaService()
          .generateText("Recomiéndame un libro similar a: $query");

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Recomendación de Libro IA"),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error con IA: $e");
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Error"),
          content: Text("No se pudo obtener la recomendación de IA: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema es oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint(
            painter: _RainbowBorderPainter(
              animationValue: _animationController.value,
            ),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isDarkMode ? Colors.grey[900] : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850] : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      onSubmitted: (_) => _searchWithAI(),
                      decoration: InputDecoration(
                        hintText: "¿Qué libro te gustó?",
                        hintStyle: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[500] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 25,
                    width: 1.5,
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  ),
                  const SizedBox(width: 10),
                  _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.tune,
                            color:
                                isDarkMode ? Colors.grey[400] : Colors.grey[700],
                          ),
                          onPressed: _searchWithAI,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RainbowBorderPainter extends CustomPainter {
  final double animationValue;

  _RainbowBorderPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 6.28319,
      tileMode: TileMode.repeated,
      transform: GradientRotation(animationValue * 6.28319),
      colors: const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
        Colors.red,
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final rrect = RRect.fromRectAndRadius(
      rect.deflate(2),
      const Radius.circular(30),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _RainbowBorderPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
