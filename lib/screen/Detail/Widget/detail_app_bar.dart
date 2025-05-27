import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/favorite_provider.dart';
import 'package:spotifymusic_app/models/product_model.dart';


class DetailAppBAR extends StatelessWidget {
  final Producto producto;
  const DetailAppBAR({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white, 
            padding: EdgeInsets.all(15),
            ),
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon:const Icon(Icons.arrow_back_ios),
            ),
            const Spacer(),
            IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white, 
            padding: EdgeInsets.all(15),
            ),
          onPressed: () {}, 
          icon:const Icon(Icons.share_outlined),
            ),
            const SizedBox(width: 10),
            IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white, 
            padding: EdgeInsets.all(15),
            ),
          onPressed: () {
            provider.toggleFavorite(producto);
          }, 
          icon: Icon(
            provider.isExist(producto)
            ? Icons.favorite
            : Icons.favorite_border,
            color : Colors.black,
            size: 25,
            ),
            ),
        ],
      ),
    );
  }
}