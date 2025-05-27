import 'package:flutter/material.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/models/product_model.dart';

class ItemsDetails extends StatelessWidget {
  final Producto producto;
  const ItemsDetails({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          producto.title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 25,
             ),
        ),
      
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                "S/${producto.price}",
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
               const SizedBox(height: 10),
               //para calificacion
               Row(
                children: [
                Container(
                  width: 55,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kprimaryColor,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                      size: 15,
                      color: Colors.white,
                      ),
                      const SizedBox(width: 3,),
                      Text(
                        producto.rate.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  producto.review,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                )
               ],)
            ],
            ),
            const Spacer(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Seller: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: producto.seller,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                      ),
                  ),
                ],
            ),
            ),
          ],
        )
      ],
    );
  }
}