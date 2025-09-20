import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/favorite_provider.dart';
import 'package:spotifymusic_app/constants.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final finalList = provider.favorites;

    // Detectar si está en modo oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colores dinámicos según tema
    final backgroundColor = isDarkMode ? Colors.black : kcontentColor;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final descriptionColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Lista de libros favoritos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.grey[300] : Colors.white, // color dinámico
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              thickness: 6,
              radius: const Radius.circular(10),
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: finalList.length,
                itemBuilder: (context, index) {
                  final favoritItems = finalList[index];
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              if (!isDarkMode)
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Imagen
                              Container(
                                height: 125,
                                width: 85,
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(favoritItems.image),
                              ),
                              const SizedBox(width: 10),

                              // Texto
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      favoritItems.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: titleColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      favoritItems.description,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: descriptionColor,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Botón de eliminar
                      Positioned(
                        top: 110,
                        right: 20,
                        child: IconButton(
                          onPressed: () {
                            finalList.removeAt(index);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red.shade400,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
