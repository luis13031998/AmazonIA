import 'package:flutter/material.dart';
import 'package:spotifymusic_app/models/product_model.dart';
// Importa librerías Stripe según tu implementación

class ProductDetailsPage extends StatefulWidget {
  final Producto producto;
  const ProductDetailsPage({required this.producto, Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isProcessingPayment = false;

  // Simulación: Aquí pondrías la lógica real de Stripe
  Future<bool> processStripePayment(double amount) async {
    setState(() {
      isProcessingPayment = true;
    });

    // Simula el pago: en la práctica, llama a Stripe y espera la confirmación
    await Future.delayed(Duration(seconds: 3));
    
    setState(() {
      isProcessingPayment = false;
    });

    // Retorna true si pago exitoso
    return true;
  }

  

  void openPdf() {
    if (widget.producto.isPurchased) {
      // Abre el PDF (puede ser un archivo local o remoto)
      // Ejemplo con url_launcher o cualquier visor PDF que uses
      print("Abriendo PDF...");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes comprar el libro para poder abrirlo.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.producto.title)),
      body: Padding(
        padding: EdgeInsets.all(16),
        
      ),
    );
  }
}
