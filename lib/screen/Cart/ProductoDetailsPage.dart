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

  void handleBuy() async {
    bool success = await processStripePayment(widget.producto.price);
    if (success) {
      setState(() {
        widget.producto.isPurchased = true;  // Actualizamos el estado
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pago completado con éxito. Ya puedes descargar el libro.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El pago falló. Inténtalo nuevamente.")),
      );
    }
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
        child: Column(
          children: [
            Image.asset(widget.producto.image),
            SizedBox(height: 16),
            Text(widget.producto.description),
            SizedBox(height: 16),
            Text("Precio: \$${widget.producto.price.toStringAsFixed(2)}"),
            SizedBox(height: 16),

            if (!widget.producto.isPurchased)
              ElevatedButton(
                onPressed: isProcessingPayment ? null : handleBuy,
                child: isProcessingPayment
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Comprar"),
              )
            else
              ElevatedButton(
                onPressed: openPdf,
                child: Text("Abrir libro"),
              ),
          ],
        ),
      ),
    );
  }
}
