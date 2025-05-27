import 'package:flutter/material.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/screen/Cart/check_out.dart';
import 'package:spotifymusic_app/screen/nav_bar_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);
    final finalList = provider.cart;

    //por cantidad
    productoQuantity(IconData icon, int index) {
      return GestureDetector(onTap: () {
        setState(() {
          icon == Icons.add 
          ? provider.incrementoQtn(index) 
          : provider.decrementoQtn(index);
        });
      },
      child: Icon(icon, size: 20),
      );
    }

    return Scaffold(
      //para total y pago
      bottomSheet: CheckOutBox(),
      backgroundColor: kcontentColor,
      body: SafeArea(
        child: Column(
          children: [
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
                        builder: (context) => const BottomNavBar(),
                        ),
                        );
          }, 
          style: IconButton.styleFrom(
                      backgroundColor: Colors.white, 
                     padding: EdgeInsets.all(15),
                    ),
          icon:const Icon(Icons.arrow_back_ios),
            ),
            const Text(
              "Mi carrito",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(),
              ],
              ),
              ),
              Expanded(
                child: ListView.builder(
                shrinkWrap: true,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: kcontentColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  cartItems.image
                                  ),
                              ),
                             const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItems.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    cartItems.category,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "S/${cartItems.price}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        ),
                        Positioned(
                          top: 35,
                          right: 35,
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
                                  size: 22,
                                ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: kcontentColor,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      productoQuantity(Icons.add, index),
                                      const SizedBox(width: 10),
                                      Text(
                                        cartItems.quantity.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      productoQuantity(Icons.remove, index),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                )
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
        ),
    );
  }
}