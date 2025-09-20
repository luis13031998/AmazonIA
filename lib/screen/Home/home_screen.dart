import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/bloc/theme_cubit.dart';
import 'package:spotifymusic_app/models/category.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Home/Widget/home_app_bar.dart';
import 'package:spotifymusic_app/screen/Home/Widget/image_slider.dart';
import 'package:spotifymusic_app/screen/Home/Widget/product_cart.dart';
import 'package:spotifymusic_app/screen/Home/Widget/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<List<Producto>> selectedCategories = [
      all,
      drama,
      historia,
      economia,
      politica,
      ciencia,
    ];

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // Colores dinámicos según el modo
        final backgroundColor =
            themeMode == ThemeMode.dark ? Colors.black : Colors.white;
        final textColor =
            themeMode == ThemeMode.dark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  // Barra personalizada
                  CustomAppBar(),
                  const SizedBox(height: 20),
                  // Barra de búsqueda
                  const MySearchBAR(),
                  const SizedBox(height: 20),
                  // Slider de imágenes
                  ImageSlider(
                    currentSlide: currentSlider,
                    onChange: (value) {
                      setState(() {
                        currentSlider = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Categorías
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      itemCount: categoriasList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: selectedIndex == index
                                  ? Colors.blue[200]
                                  : Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 65,
                                  width: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          categoriasList[index].image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  categoriasList[index].title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Título y enlace
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Especial para ti",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Ver todo",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: themeMode == ThemeMode.dark
                              ? Colors.grey[300]
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Productos en cuadrícula
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: selectedCategories[selectedIndex].length,
                    itemBuilder: (context, index) {
                      return ProductCart(
                        producto: selectedCategories[selectedIndex][index],
                        // Si quieres también podrías pasar el themeMode a ProductCart
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
