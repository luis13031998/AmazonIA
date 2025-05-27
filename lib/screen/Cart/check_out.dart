import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckOutBox extends StatefulWidget {
  const CheckOutBox({super.key});

  @override
  State<CheckOutBox> createState() => _CheckOutBoxState();
}

class _CheckOutBoxState extends State<CheckOutBox> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    final provider = CartProvider.of(context);

    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              filled: true,
              fillColor: kcontentColor,
              hintText: "Ingrese código de descuento",
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              suffixIcon: TextButton(
                onPressed: () {
                  // Aquí puedes manejar lógica de cupones
                },
                child: const Text(
                  "Aplicar",
                  style: TextStyle(
                    color: kprimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SubTotal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                "S/${provider.totalPrice()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "S/${provider.totalPrice()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await makePayment(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kprimaryColor,
              minimumSize: const Size(double.infinity, 55),
            ),
            child: const Text(
              "Verificar",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> makePayment(BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent('100', 'EUR');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Ikay',
        ),
      );

      await displayPaymentSheet(context);
    } catch (err) {
      print("Error en makePayment: $err");
      showErrorDialog(context, "Ocurrió un error al iniciar el pago.");
    }
  }

  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // ✅ Obtener el producto comprado
      final producto = CartProvider.of(context, listen: false).getFirstProduct();

      // ✅ Abrir el PDF automáticamente si existe
      if (producto != null && producto.pdfUrl.isNotEmpty) {
        await _abrirPdf(producto.pdfUrl);
      }

      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100.0),
              SizedBox(height: 10.0),
              Text("¡Pago exitoso!"),
            ],
          ),
        ),
      );

      paymentIntent = null;
    } on StripeException catch (e) {
      print('Error de Stripe: $e');
      showErrorDialog(context, "El pago fue cancelado.");
    } catch (e) {
      print("Error general: $e");
      showErrorDialog(context, "Error inesperado.");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretkey', // ⚠️ Backend en producción
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      throw Exception('Error al crear PaymentIntent: $err');
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  Future<void> _abrirPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showErrorDialog(context, "No se pudo abrir el PDF.");
    }
  }
}
