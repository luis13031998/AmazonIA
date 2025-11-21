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
    // Detectar colores según el tema actual
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final selectedColor = Colors.orange;

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabButton("Descripción", 'descripcion', isDark, textColor, selectedColor),
                const SizedBox(width: 8),
                _buildTabButton("N° de Descargas", 'descargas', isDark, textColor, selectedColor),
                const SizedBox(width: 8),
                _buildTabButton("Reseñas", 'reseñas', isDark, textColor, selectedColor),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              key: ValueKey<String>(selectedTab),
              textToShow,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔸 Botón de pestaña reutilizable con tema dinámico
  Widget _buildTabButton(
    String text,
    String tabKey,
    bool isDark,
    Color textColor,
    Color selectedColor,
  ) {
    final bool isSelected = selectedTab == tabKey;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = tabKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : (isDark ? Colors.white24 : Colors.black26),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : textColor,
          ),
        ),
      ),
    );
  }
}
