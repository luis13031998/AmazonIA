import 'package:flutter/material.dart';
import 'package:spotifymusic_app/constants.dart';

class Description extends StatelessWidget {
  final String description;
  const Description({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: kprimaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: const Text(
            "Descripción",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16
            ),
          ),
        ),
        const Text(
            "Especificación",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16
            ),
          ),
          const Text(
            "Reseñas",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16
            ),
          ),
      ],
       ),
       SizedBox(height: 20),
       Text(
        description,
       style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
       ),
       ),
      ],
    );
  }
}