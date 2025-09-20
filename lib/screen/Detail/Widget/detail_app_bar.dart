import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/favorite_provider.dart';
import 'package:spotifymusic_app/models/product_model.dart';

class DetailAppBAR extends StatelessWidget {
  final Producto producto;
  const DetailAppBAR({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    // Detecta si el tema actual es oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: isDarkMode
                  ? Colors.grey.shade800
                  : Colors.white, // Fondo dinámico
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDarkMode ? Colors.white : Colors.black, // Ícono dinámico
            ),
          ),
          const Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: isDarkMode
                  ? Colors.grey.shade800
                  : Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {},
            icon: Icon(
              Icons.share_outlined,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: isDarkMode
                  ? Colors.grey.shade800
                  : Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              provider.toggleFavorite(producto);
            },
            icon: Icon(
              provider.isExist(producto)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: provider.isExist(producto)
                  ? Colors.red // Corazón rojo en ambos modos
                  : (isDarkMode ? Colors.white : Colors.black),
              size: 25,
            ),
          ),
        ],
      ),
    );
  }
}
