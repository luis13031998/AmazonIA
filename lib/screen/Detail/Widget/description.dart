import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  final String description;
  final String dowlands;
  final String reviews;

  const Description({
    Key? key,
    required this.description,
    required this.dowlands,
    required this.reviews,
  }) : super(key: key);

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  String selectedTab = 'descripcion';

  @override
  Widget build(BuildContext context) {
    String textToShow = '';
    if (selectedTab == 'descripcion') {
      textToShow = widget.description;
    } else if (selectedTab == 'descargas') {
      textToShow = widget.dowlands;
    } else if (selectedTab == 'reseñas') {
      textToShow = widget.reviews;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔸 Fila con desplazamiento horizontal para evitar overflow
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabButton("Descripción", 'descripcion'),
                const SizedBox(width: 8),
                _buildTabButton("N° de Descargas", 'descargas'),
                const SizedBox(width: 8),
                _buildTabButton("Reseñas", 'reseñas'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔸 Contenido dinámico
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey<String>(selectedTab),
              textToShow,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 Botón de pestaña reutilizable
  Widget _buildTabButton(String text, String tabKey) {
    final bool isSelected = selectedTab == tabKey;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tabKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.white24,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
