import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/screen/Cart/check_out.dart';
import 'package:spotifymusic_app/screen/nav_bar_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : kcontentColor;
    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final iconColor = isDarkMode ? Colors.grey[300] : Colors.black;
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.grey[400] : Colors.grey;

    return Scaffold(
      bottomSheet: const CheckOutBox(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar()),
                      );
                    },
                    style: IconButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.grey[850] : Colors.white,
                      padding: const EdgeInsets.all(15),
                    ),
                    icon: Icon(Icons.arrow_back_ios, color: iconColor),
                  ),
                  Text(
                    "Libros a descargar",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // LISTA CONSUMER — AHORA SI SE ACTUALIZA 😎🔥
            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  final finalList = provider.cart;

                  if (finalList.isEmpty) {
                    return Center(
                      child: Text(
                        "No tienes libros para descargar",
                        style: TextStyle(color: titleColor, fontSize: 18),
                      ),
                    );
                  }

                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 6,
                    radius: const Radius.circular(8),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: finalList.length,
                      itemBuilder: (context, index) {
                        final cartItems = finalList[index];

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
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Imagen
                                    Container(
                                      height: 100,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(cartItems.image),
                                    ),
                                    const SizedBox(width: 10),

                                    // Información
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItems.title,
                                            style: TextStyle(
                                              color: titleColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            cartItems.category,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: subtitleColor,
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              top: 100,
                              right: 15,
                              child: IconButton(
                                onPressed: () {
                                  provider.removeFromCart(index);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade400,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
