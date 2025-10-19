import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifymusic_app/Provider/favorite_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Detail/detail_screen.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/bloc/theme_cubit.dart';

class ProductCart extends StatelessWidget {
  final Producto producto;

  const ProductCart({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // 🎨 Colores dinámicos según el tema
        final cardColor = themeMode == ThemeMode.dark
            ? Colors.grey[850] // Fondo oscuro
            : kcontentColor; // Fondo claro original

        final textColor =
            themeMode == ThemeMode.dark ? Colors.white : Colors.black;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(producto: producto),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Center(
                      child: Hero(
                        // ✅ TAG ÚNICO para evitar colisiones
                        tag: '${producto.image}_${producto.title}',
                        child: Image.asset(
                          producto.image,
                          width: 150,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        producto.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "", // Aquí podrías poner precio si lo tienes
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            producto.colors.length,
                            (index) => Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: producto.colors[index],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ❤️ Ícono de favorito
              Positioned(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: kprimaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        provider.toggleFavorite(producto);
                      },
                      child: Icon(
                        provider.isExist(producto)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
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
