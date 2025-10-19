import 'package:flutter/material.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/addto_cart.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/description.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/detail_app_bar.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/items_details.dart';

class DetailScreen extends StatefulWidget {
  final Producto producto;
  const DetailScreen({super.key, required this.producto});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentImage = 0;
  int currentColor = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : kcontentColor;
    final containerColor = isDark ? Colors.grey[900] : Colors.white;
    final activeDotColor = isDark ? Colors.white : Colors.black;
    final borderDotColor = isDark ? Colors.white70 : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,

      // 🛒 FAB para agregar al carrito
      floatingActionButton: AddtoCart(producto: widget.producto),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 AppBar con botón atrás, compartir y favorito
              DetailAppBAR(producto: widget.producto),

              // 🖼️ Imagen principal con animación Hero
              Center(
                child: Hero(
                  // ✅ TAG único y consistente con ProductCart
                  tag: '${widget.producto.image}_${widget.producto.title}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.producto.image,
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // 🔘 Indicadores (puedes mantener el efecto)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: currentImage == index ? 15 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentImage == index
                          ? activeDotColor
                          : Colors.transparent,
                      border: Border.all(color: borderDotColor),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📦 Contenedor con detalles del libro
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🏷️ Detalles (nombre, autor, etc.)
                    ItemsDetails(producto: widget.producto),

                    const SizedBox(height: 20),

                    // 📝 Descripción
                    Description(description: widget.producto.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
