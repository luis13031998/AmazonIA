import 'package:flutter/material.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/screen/Cart/cart_screen.dart';
import 'package:spotifymusic_app/screen/ChatbotIA/chatIA.dart';
import 'package:spotifymusic_app/screen/Home/home_screen.dart';
import 'package:spotifymusic_app/screen/Profile/profile.dart';
import 'package:spotifymusic_app/screen/Favorite/favorite.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int cuttentIndex = 3;

  List screens = const [
    Scaffold(),
    ChatScreen(),
    Favorite(),
    HomeScreen(),
    CartScreen(),
    Profile(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor =
        isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
      onPressed: () {
      setState(() {
      cuttentIndex = 3;
    });
    },
  shape: const CircleBorder(),
  backgroundColor: isDarkMode 
      ? const Color.fromARGB(255, 65, 30, 191)
      : const Color.fromARGB(255, 255, 102, 14),
  child: const Icon(
    Icons.home,
    color: Colors.white,
    size: 35,
  ),
),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: backgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
  onPressed: () {
    setState(() {
      cuttentIndex = 1;
    });
  },
  icon: Icon(
    Icons.grid_view_outlined,
    size: 30,
    color: cuttentIndex == 1
        ? (isDarkMode ? const Color.fromARGB(255, 141, 117, 231) : const Color.fromARGB(255, 255, 102, 14))
        : inactiveColor,
  ),
),

            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 2;
                });
              },
              icon: Icon(
                Icons.favorite_border,
                size: 30,
                color: cuttentIndex == 2 
                 ? (isDarkMode ? const Color.fromARGB(255, 141, 117, 231) : const Color.fromARGB(255, 255, 102, 14))
                 : inactiveColor,
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 4;
                });
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 30,
                color: cuttentIndex == 4 
                 ? (isDarkMode ? const Color.fromARGB(255, 141, 117, 231) : const Color.fromARGB(255, 255, 102, 14))
                 : inactiveColor,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  cuttentIndex = 5;
                });
              },
              icon: Icon(
                Icons.person,
                size: 30,
                color: cuttentIndex == 5 
                 ? (isDarkMode ? const Color.fromARGB(255, 141, 117, 231) : const Color.fromARGB(255, 255, 102, 14))
                 : inactiveColor,
              ),
            ),
          ],
        ),
      ),
      body: screens[cuttentIndex],
    );
  }
}
