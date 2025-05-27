import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/favorite_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Detail/detail_screen.dart';

class ProductCart extends StatelessWidget {
  final Producto producto;
  const ProductCart({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
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
              color: kcontentColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Center(
                  child: Hero(
                    tag: producto.image,
                    child: Image.asset(
                    producto.image,
                    width: 150,
                    height: 130,
                    fit: BoxFit.cover,
                    ),
                  ),
                  ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    producto.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "S/${producto.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                        )
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // icono fvorite
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
              child: GestureDetector(onTap: () {
                provider.toggleFavorite(producto);
              },
              child: Icon(
                provider.isExist(producto)?
                Icons.favorite:
                Icons.favorite_border,
                color: Colors.white,
                size: 22,
              ),
              ),
             ), 
            )
          ),
        ],
      ),
    );
  }
}