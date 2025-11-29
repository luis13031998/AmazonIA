import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/models/product_model.dart';

class AddtoCart extends StatelessWidget {
  final Producto producto;
  const AddtoCart({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isDark ? Colors.white10 : Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            provider.addToCart(producto);
            provider.addNotification("Reservaste: ${producto.title}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: isDark ? Colors.grey[900] : Colors.black87,
                duration: const Duration(seconds: 1),
                content: const Text(
                  "📚 Libro reservado correctamente",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 100),
            decoration: BoxDecoration(
             color: isDark ? const Color.fromARGB(255, 65, 30, 191) : const Color.fromARGB(255, 240, 127, 14),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: const Text(
              "Reservar libro",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
