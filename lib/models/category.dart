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
    title: "Matematica",
    image: AppImages.drama,
  ),
  Category(
    title: "Comunicacion",
    image: AppImages.historia,
  ),
  Category(
    title: "Ciencia",
    image: AppImages.politica,
  ),
  Category(
    title: "Historia",
    image: AppImages.economia,
  ),
  Category(
    title: "CTA",
    image: AppImages.ciencia,
  ),
];