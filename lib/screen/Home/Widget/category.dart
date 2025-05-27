import 'package:flutter/material.dart';
import 'package:spotifymusic_app/models/category.dart';

class Categorias extends StatefulWidget {
  const Categorias ({super.key});

  @override
  State<Categorias> createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    fit: BoxFit.cover
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                categoriasList[index].title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
            ),
            
          ),
          );
        },
      ),
    );
  }
}