import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spotifymusic_app/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<Producto> _cart = [];
  final List<String> _notifications = [];

  List<Producto> get cart => _cart;
  List<String> get notifications => _notifications;

  /// 👉 AGREGA UN PRODUCTO SIN DUPLICAR
  void addToCart(Producto producto) {
    final index = _cart.indexWhere((p) => p.title == producto.title);

    if (index == -1) {
      _cart.add(producto);
    } else {
      _cart[index].quantity++;
    }

    notifyListeners();
  }

  /// 👉 ELIMINA NOTIFICACIÓN POR ÍNDICE
  void removeNotificationAt(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  void incrementoQtn(int index) {
    _cart[index].quantity++;
    notifyListeners();
  }

  void decrementoQtn(int index) {
    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    }
    notifyListeners();
  }

  void clearCart() {
  for (var p in _cart) {
    p.quantity = 1;             // Reinicia cada cantidad
  }
  _cart.clear();                // Vacía el carrito
  notifyListeners();            // Notifica a la UI
}

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  Producto? getFirstProduct() {
    if (_cart.isNotEmpty) return _cart.first;
    return null;
  }

  /// 👉 AÑADIR NOTIFICACIÓN
  void addNotification(String message) {
    _notifications.add(message);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  static CartProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<CartProvider>(context, listen: listen);
  }
}
