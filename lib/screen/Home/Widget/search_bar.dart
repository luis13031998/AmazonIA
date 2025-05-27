import 'package:flutter/material.dart';
import 'package:spotifymusic_app/IAllamaService.dart';
import 'package:spotifymusic_app/models/product_model.dart'; // Assuming `all` and `Producto` are defined here

// Assuming 'kcontentColor' is defined in a 'constants.dart' file
// If not, you might need to define it or replace it with a direct color like Colors.grey[200]
// import 'package:spotifymusic_app/constants.dart';


class MySearchBAR extends StatefulWidget {
  const MySearchBAR({super.key});

  @override
  State<MySearchBAR> createState() => _MySearchBARState();
}

class _MySearchBARState extends State<MySearchBAR> with SingleTickerProviderStateMixin { // <--- ADD SingleTickerProviderStateMixin
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animationController; // <--- ADD AnimationController

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Duration of one full cycle
    )..repeat(); // Makes the animation repeat indefinitely
  }

  @override
  void dispose() {
    _animationController.dispose(); // <--- Dispose the controller
    _controller.dispose();
    super.dispose();
  }

  List<Producto> _buscarLibrosLocales(String query) {
    // Assuming 'all' is a global or accessible list of Producto objects
    return all.where((producto) =>
      producto.title.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void _searchWithAI() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    // Reset current state and show loading
    setState(() {
      _isLoading = true;
    });

    // --- LOCAL BOOK SEARCH ---
    final librosEncontrados = _buscarLibrosLocales(query);

    if (librosEncontrados.isNotEmpty) {
      if (!mounted) return; // Check if widget is still in tree before showing dialog
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog( // Use dialogContext to avoid conflicts
          title: const Text("Libros encontrados"),
          content: SizedBox(
            height: 200, // Adjust height as needed
            width: 300,  // Adjust width as needed
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

    // --- AI RECOMMENDATION ---
    try {
      final result = await LlamaService().generateText(
        "Recomiéndame un libro similar a: $query"
      );

      if (!mounted) return; // Check if widget is still in tree before showing dialog
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog( // Use dialogContext
          title: const Text("Recomendación de Libro IA"),
          content: Text(result), // This is where the UTF-8 fix in LlamaService is crucial
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
      // Ensure loading state is false regardless of success or error
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8), // Padding around the entire search bar
      child: AnimatedBuilder( // <--- This widget rebuilds for animation
        animation: _animationController,
        builder: (context, child) {
          return CustomPaint( // <--- This draws the animated border
            painter: _RainbowBorderPainter(animationValue: _animationController.value),
            child: Container( // This is your actual search bar content
              height: 55,
              // No margin here, CustomPaint handles the border space
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), // Match the RRect in painter
                color: Colors.white, // Background color of the search bar
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  // Search Icon (if you want the inner white circle)
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // This is inside the search bar, adjust as needed
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      onSubmitted: (_) => _searchWithAI(),
                      decoration: const InputDecoration(
                        hintText: "¿Qué libro te gustó?",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none, // No border for the TextField itself
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container( // The vertical separator
                    height: 25,
                    width: 1.5,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(width: 10),
                  _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.tune, color: Colors.grey), // Or Icons.search
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


// Your _RainbowBorderPainter, it remains the same and is crucial for the animation
class _RainbowBorderPainter extends CustomPainter {
  final double animationValue;

  _RainbowBorderPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 6.28319, // 2π radians
      tileMode: TileMode.repeated,
      transform: GradientRotation(animationValue * 6.28319), // This makes it animate!
      colors: const [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
        Colors.red, // For a smooth transition back to the start
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect) // Use createShader here
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4; // Border width

    // Adjust the radius for the border to match the search bar's shape
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(2), // Inset the rectangle to leave space for the border
      const Radius.circular(30), // Match your search bar's borderRadius
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _RainbowBorderPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}