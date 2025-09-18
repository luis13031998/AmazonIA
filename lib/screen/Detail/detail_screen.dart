import 'package:flutter/material.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/models/product_model.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/addto_cart.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/description.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/detail_app_bar.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/image_slider.dart';
import 'package:spotifymusic_app/screen/Detail/Widget/items_details.dart';

class DetailScreen extends StatefulWidget {
  final Producto producto;
  const DetailScreen({super.key, required this.producto});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>{
  int currentImage = 0;
  int currentColor = 1;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      //Para agregar al carrito, icono y cantidad
      floatingActionButton: AddtoCart(producto: widget.producto),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Boton para retrocedes, compartir y favorito
            DetailAppBAR(producto: widget.producto),
            //Para detalle de imagen slider
           MyImageSlider(image: widget.producto.image, onChange: (index){
            setState(() {
              currentImage = index;
            });
           },
           ),
           const SizedBox(height: 10),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => AnimatedContainer(
                duration: const Duration(microseconds: 300),
                width: currentImage == index ? 15 : 8,
                height: 8,
                margin: const EdgeInsets.only(right: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                color: currentImage == index
                ? Colors.black
                : Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                )
                ),
                ),
                ),
           ),
           const SizedBox(height: 20),
           Container(
            width: double.infinity,
            decoration: const  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Para nombre producto, precio,calificación, vendedor
                 ItemsDetails(producto: widget.producto),
    
                 

                 
                  const SizedBox(height: 20),
                  // para describir el producto
                  Description(description: widget.producto.description)
              ],
            ),
           )
          ],
        ),
        )),
    );
  }
}