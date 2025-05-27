import 'package:spotifymusic_app/core/configs/assets/app_images.dart';

class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

final List<Category> categoriasList = [
  Category(
    title: "All",
    image: AppImages.all,
  ),
  Category(
    title: "Drama",
    image: AppImages.drama,
  ),
  Category(
    title: "Historia",
    image: AppImages.historia,
  ),
  Category(
    title: "Politica",
    image: AppImages.politica,
  ),
  Category(
    title: "Economia",
    image: AppImages.economia,
  ),
  Category(
    title: "Ciencia",
    image: AppImages.ciencia,
  ),
];