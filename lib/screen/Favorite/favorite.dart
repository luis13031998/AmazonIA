import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/favorite_provider.dart';
import 'package:spotifymusic_app/constants.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final finalList = provider.favorites;
    return Scaffold(
     backgroundColor: kcontentColor,
     appBar: AppBar(
      backgroundColor: kcontentColor,
      title: const Text(
        "Favorite",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
     ),
     body: Column(
      children: [
       Expanded(
                child: ListView.builder(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                height: 85,
                                width: 85,
                                decoration: BoxDecoration(
                                  color: kcontentColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  favoritItems.image,
                                  ),
                              ),
                             const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favoritItems.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    favoritItems.category,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "S/${favoritItems.price}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        ),
                        Positioned(
                          top: 50,
                          right: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  finalList.removeAt(index);
                                  setState(() {});
                                }, 
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                ),                             
                            ],
                          ),
                          )
                    ],
                  );
                },
                ),
                ),
     ],
     ),
    );
  }
}